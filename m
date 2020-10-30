Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DA62A09DE
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgJ3P3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgJ3P3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:29:15 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54E4C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:29:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g25so6249661edm.6
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DNxhZBm7y9kuUgCZkBcBi+SCJDz8hhSGbmLkoj4ek34=;
        b=smRs/rDHzRojHutfm2Z2cvD/VE6VX4LLtJuZvDk0DjG4Vcf/IAq7ZNoYhpeHUNo0Ts
         BmcbaZvMHE7rn0iijXYJ4Qj9xBtlWfiKCzNa+JqKpUqPbMCzrmG4FJKBkIGTeUrcgMlM
         Pt5jF8nt5rpiIQEMlfmNgQ0+Wz7l4Xg1OBDrYhMivgR8tkJSMj5jhQLILPeF6bqvm3nh
         5/+k96mjP2x+nHSpj0vdH1E9vRVclJ0+kvAt8wfVR8SV4uFxvmChWuUoQftvpvPvSXvM
         6w6jGFqBN/f94eO1HQirQUeDLk3d+ZxmfH0PmXWgh5oTuJF5CjAyD1kRLF8LFoZay8wS
         aEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DNxhZBm7y9kuUgCZkBcBi+SCJDz8hhSGbmLkoj4ek34=;
        b=DwggqvTxTkZHG/kJPbs3xsqrU7TseSnMMBTMfM6Av0y8HBK5qnUdTT2zj9ujeWyiqE
         Sqfpo10VAYOeNbTNgpbzuaJhAQkfaZ+ntcC70n2JY8FEmPz9uvFTEcFehktTCoVeGVwP
         XH4pjYOqw7ddL0JOIrJqR6L9Tl5DNxSi5IWoR6MPbzIS5fagm2YAmdPh2havnKTJy4Vq
         +ALnqQGWu/TIl1w8fqLcQIV1gFgZbqrhJR1W1t4T8wCJmes5rgCToU6Ygs/FkL+QaA5V
         TACjDROuN0t5aq3vIP6W5wyB+RECnIX/BwLYEgtztvS7Osi8OWZRC0dw3bXPoMtWa5Ht
         lFSg==
X-Gm-Message-State: AOAM531dg22Gmy2/iBQNZM1zkdmCJE4mqhhYwCMj6i0ZqpePmepL5Z3n
        deKrnGeOFxqMlnavPVqtjOH6TF2Ne34=
X-Google-Smtp-Source: ABdhPJxFUSSyJrnfONyPvbMeBslIuTIplsZAVWziVjwMkG1W61KPk7ntMqo+QstkvH6mT3llhaatZQ==
X-Received: by 2002:a50:e686:: with SMTP id z6mr2970772edm.188.1604071752525;
        Fri, 30 Oct 2020 08:29:12 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id ok21sm3075360ejb.96.2020.10.30.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:29:11 -0700 (PDT)
Date:   Fri, 30 Oct 2020 17:29:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 0/5] Support for RollBall 10G copper SFP
 modules
Message-ID: <20201030152910.zmtecfzyxw4nuwud@skbuf>
References: <20201029222509.27201-1-kabel@kernel.org>
 <20201030150138.GB1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201030150138.GB1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 03:01:38PM +0000, Russell King - ARM Linux admin wrote:
> https://blog.thedigitalgroup.com/to-vs-cc-vs-bcc-how-to-use-them-correctly

I have to disagree about some of the information provided in this link:

------------------------------[cut here]------------------------------
Using the BCC Field:

BCC is for Blind Carbon Copy. It sends copies of the email to multiple
recipients, the only difference being that none of the recipients are
made aware of who else has received the email.

The BCC field is used when you want to send an email to multiple
recipients but do not want any of them to know about the other people
you have sent them to. There can be many scenarios where the BCC field
might be used, and the purpose might be a desire to keep the names of
the recipients a secret to one another and also protect the privacy of
recipients.

The most common application is for sending an email to a long list of
people who do not know each other, such as mailing lists. This protects
the privacy of the recipients as they are not able to view each other’s
email addresses.
------------------------------[cut here]------------------------------

It's plain stupid to put a mailing list in Bcc. I have filters that move
inbound emails from Inbox to separate folders based on the mailing list
from To: or CC:, except for emails where my address is also in To: or Cc:.
But when the mailing list is in Bcc, that email evades the filter and
arrives directly in my inbox, regardless of whether I'm even an intended
recipient or not.

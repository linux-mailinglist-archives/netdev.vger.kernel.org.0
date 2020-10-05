Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B822835D8
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 14:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgJEMeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 08:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJEMeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 08:34:23 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FD9C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 05:34:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id u21so11681060eja.2
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 05:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qxIM+Azyb1VsZswOjCvZT3l2JIQin8UOK8Z87bzS0Ns=;
        b=pX5Kw3rnlsFhLsDrONJzmC+gBdE27p8XbCk8deOQ/mJJqevznkAKMBxB90xglPdl31
         FTmK2JtNtGJQsv1jOtleg8URST0MmH8OqdDPuW2SQ0rA3XcSmgTzObvt24dQZ0AkCRcj
         5KRdaw3cjy1tIV/XZ7qZTzOrGqu/5AH0fGJ6tvJfC15EfkklOv1y9jpfI/174mrSejwL
         lAWB9LacClVhY1AZX2O8GB0z3s9ITgOfUkR7yrEElHH//9ysu5ERGZNtoaMSFmuKV2Y9
         dw/55M17h9NHUjwJDM+PbVBtVPsgElQjrq5qwf3waNeCg819ljmjccMBCSgLbzROfQH4
         SaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qxIM+Azyb1VsZswOjCvZT3l2JIQin8UOK8Z87bzS0Ns=;
        b=LuOKfhlBGGJYZBJ5rK5LELZ3H1lhuM/7yYkTZFEUcHab+OkiHyN63QquMeigYuVE6T
         l62my1iM+ldfXRCBvWhq0M89LEIyJc4BSBAMsHrfZ8Pymbo1MzkbXijxaPjZogpNpJLZ
         827ks6M9ct7d4PqOW528Z/ItQemAoOkLBLy5eWzbateYkUcX2raNnL5J0Nq7PSCQxqLB
         3iObkFCLKYYU9yV/77auxTCSMIUTP8AM/WlKfEjZyPl6liG3kt9e+siL6tj3WgzIgrmp
         telSLSX1fFRq3jLe+IgNbIhfuNop0LFlkE/eqsyq29G1LRrp4EJLvhjYVj8HuZhxEHAd
         KLQQ==
X-Gm-Message-State: AOAM530S5TfeGOmEQSBOyWHj6gwX0+1j46RHos6nyHMhIT5ahhj/TEh+
        pC4yVCa6GBDsH7sLYoOC7y8=
X-Google-Smtp-Source: ABdhPJwF7wMmfbLy6r80Up7pYFzzVLldE7pRPeHqo5QpFPyqJHtB2xAWYTfbq6QrPvB/voNwXNiq5g==
X-Received: by 2002:a17:906:c007:: with SMTP id e7mr15241603ejz.55.1601901261722;
        Mon, 05 Oct 2020 05:34:21 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id r11sm3483251edi.91.2020.10.05.05.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 05:34:21 -0700 (PDT)
Date:   Mon, 5 Oct 2020 15:34:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20201005123419.goprl5sirpt7g3gf@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <87y2lkshhn.fsf@kurt>
 <20200908102956.ked67svjhhkxu4ku@skbuf>
 <87o8llrr0b.fsf@kurt>
 <20201002081527.d635bjrvr6hhdrns@skbuf>
 <20201003075229.gxlndx7eh3vggxl7@skbuf>
 <87zh537idk.fsf@kurt>
 <20201004105617.5cclmtmrfrerpg7w@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004105617.5cclmtmrfrerpg7w@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 01:56:17PM +0300, Vladimir Oltean wrote:
> On Sat, Oct 03, 2020 at 11:45:27AM +0200, Kurt Kanzenbach wrote:
> > Maybe next week.
> 
> The merge window opens next week. This means you can still resend as
> RFC, but it can only be accepted in net-next after ~2 weeks.

False alarm, looks like we have an rc8. I guess that means you can
resend some time this week.

Thanks,
-Vladimir

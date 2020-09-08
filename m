Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EAE260FF5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgIHKdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbgIHKdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 06:33:15 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72983C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 03:33:14 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i22so21748833eja.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 03:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yen+UkpGMwjbV/4ZvWWGCTFtyU/qsgs4/bX+ZkxHae0=;
        b=LXgHFRKlFS2q3LV2Ls2BUhdhmUSuKxXYaTDpiasFffMzvmG3qiXo4PLBYcaJpOBhAL
         JshG7adkv2ZStcdaO9be8YpRe6jT6fYGAbVIcgp/pLP7gkJiWwVD4e0BNmsmGeyPFLp6
         pVkKzGcrQbWwp9rC822La/AYCrNHSaPGBYoKuVeMtC1f7D2FgXhdWxUYbAqG9wZSuCBG
         WdDt16LzMm2kkbtOyTAvmh7bDxyvY3MnBNaw/I/0JDcXftZMxEUbwIYBqYhUHmMddMW0
         K9W+LY81rg1hyT62RhhtGsnmHFhu0PHuGBHUXP6T+85HTj7xD/MEv+xCyJbfkM15Npvi
         RW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yen+UkpGMwjbV/4ZvWWGCTFtyU/qsgs4/bX+ZkxHae0=;
        b=i9B3cnDIr/R4mqlhPGmE7rG+0Z5cUWPjxemXXa0wcD6HGXhFLwQL9kN4q1N3Wu7OiV
         tdPgz4BORjT6ERwk62WJSfpa5Td+O0jNAUHpFi0XkTcGNJ0n/jvEeBJ3idIBuYpt+en8
         BZ17GG0ihfNzNh9butbKvcR7Jl7fvSanejvapgwwIeog3z+VwAf3Q94zjLcxkzZNBLWD
         imCoY8AxUw8+OhB/7pcawC4IpzcCxNb6OG7S3KcccIPVr1LRcFXX/8uBszv8hd7v2SQK
         JFE0w+gEiYXzEp/YjN1I0GkWIdDyhgZX1IhFWlU7keNXli+/jpTtJTt3FY/+637mHtyI
         O6jA==
X-Gm-Message-State: AOAM532sp4jpRMjUFK18EJboenWztDF1ChD9ZsolXv/6SrI30BvKrfTZ
        K4V6cdzHlZ+/whL71Ho1HNWLCxeldcM=
X-Google-Smtp-Source: ABdhPJw5XmLdtsQnvCKJ+/baq0Gudk8/fsOnI+Z95ouicOeXK1UkV7V/v9Rv1xZhBiq4uNF0V7NNmg==
X-Received: by 2002:a17:906:fb8c:: with SMTP id lr12mr26608239ejb.9.1599561193094;
        Tue, 08 Sep 2020 03:33:13 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id g11sm17191083edt.88.2020.09.08.03.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 03:33:12 -0700 (PDT)
Date:   Tue, 8 Sep 2020 13:33:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20200908103310.ttqh56cr2jyugblw@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 09:07:34PM -0700, Florian Fainelli wrote:
> You should be able to make b53 and bcm_sf2 also use
> configure_vlan_while_not_filtering to true (or rather not specify it), give
> me until tomorrow to run various tests if you don't mind.

Ok, but I would prefer not doing that in this patch.

Note that, given a choice, I try to avoid introducing functional changes
in drivers where I don't have the hardware to test, or somebody to
confirm that it works, at the very least.

For that reason, mv88e6xxx doesn't even have this flag set, even though
Russell had sent a patch for it with the old name:
https://lore.kernel.org/netdev/E1ij6pq-00084C-47@rmk-PC.armlinux.org.uk/

Somebody with a Marvell switch should probably pick that up and resend.

Thanks,
-Vladimir

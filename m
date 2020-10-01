Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30F427FA62
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgJAHjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAHjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:39:41 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E528C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:39:41 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e2so1926204wme.1
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 00:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ltX+FDktctt1JdtWXszU3zsClhbgBLFy/fcjHq1ZgnE=;
        b=L1MlyzHuEVE33Don9V31688wPPFY51uSPT1YRPfxN2KPhmcy9xk1mfU3sHCsdNPBl3
         kGNt+ZaBWb6a98g1HxFTFsMRj8fx2aWypRDVS95GiSMEeBkD3u0kesM0ckxWKHxom84Y
         ilaip0arDrkX0nQuEO+oMITZNLCUApb0BJZE0jGY5bnFGaS25hxTg7ZehqWIE7DYc7lp
         Ms5EjYzEIE15WK6Nv/R5b5og+jjHfQ+K6g/efhD5KswM2Mh+rDtn6IpEX9/+fo+Tzpzz
         sJvkUrDIFgf7n4wMAfgmZC+0nV2lTptkz53HR7RArULPBf8id9mp8LNyeGVY4IZmvKdc
         LAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ltX+FDktctt1JdtWXszU3zsClhbgBLFy/fcjHq1ZgnE=;
        b=LDyRFbI6zjQjKpnHuUE/RKjRI4F6P2NMtNqM1o8nzSpZWuxyMAgWh9jjNY9x/cG6sF
         jITjoZ/jqyi5+wcyiuqCFM49IcxrtwMqyrdIZ8aIzWpfDYRhNs6OMSTUZYWsHzJlsiG+
         HjFJ7FC4OJvmgRsnvjwGDgyGfipXvfIdVW+LbrPjlRr1e3mHXiVUkEOwx/1z/rlSieiM
         n0WV4QhVYxBvLV5iZVFOrzZXPSqg5FtbcKNHulf4qTIOHJtcuS4gi+x2eQz4OxWj5qy7
         8AQ16T76iJGFScovZaPKV7TQFJlgOWiGaqJcg4VjSmGGJMluFpeQ5Tk/UGkC+PzF62pU
         TFlg==
X-Gm-Message-State: AOAM5321YQSNRS3FpsZ+nn5/TobkwfbjGe67rPE4+DCeogVxX4qum43W
        5LarkVOgWlX7eh9RaguOHc1r8Q==
X-Google-Smtp-Source: ABdhPJyZ019cVJxosJuz4QbRPAsFjq8KxTKCysibdV0CcVLNuoAbdXHP+QJHm5yiv/dWHKV7SE6Ilg==
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr6967868wmj.130.1601537979809;
        Thu, 01 Oct 2020 00:39:39 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i9sm6972752wma.47.2020.10.01.00.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 00:39:39 -0700 (PDT)
Date:   Thu, 1 Oct 2020 09:39:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20201001073937.GL8264@nanopsycho>
References: <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
 <20200929130758.GF8264@nanopsycho>
 <20200929135700.GG3950513@lunn.ch>
 <20200930065604.GI8264@nanopsycho>
 <20200930135725.GH3996795@lunn.ch>
 <20200930143452.GJ8264@nanopsycho>
 <20200930145357.GM3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930145357.GM3996795@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 30, 2020 at 04:53:57PM CEST, andrew@lunn.ch wrote:
>> What do you mean by "regions"? Devlink regions? They are per-device, not
>> per-port. I have to be missing something.
>
>The rest of the patch series, which add regions per port! This came

Okay. Sorry about that. netdev ml kicked me out so I didn't receive
emails from it for couple of days :/


>out of the discussion from the first version of this patchset, and
>Jakub said it would make sense to add per port regions, rather than
>have regions which embedded a port number in there name.

For sure. If something is per-port, should be per-port. I agree.

>
>     Andrew
> 

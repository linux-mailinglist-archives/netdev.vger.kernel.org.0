Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6827D23C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbgI2PMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbgI2PMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:12:25 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F50C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:12:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e11so6852067wme.0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FGq75qUur3guPtN1jN9Cob7Ohj9YZYaRRzAKuw1dbWY=;
        b=UpOqoVDdveX2joIMaS3Bm10xXYWpHHOp7V9an6w5pCvz74gxdIZWdd6cTBt/VqZrTU
         L4iueI+uLIcuB62va87o2z/SqyVn7k4nGnEbotkxoSw1uOo/6ZaqektQYZgbxVOZwNWA
         kjh+d8fiocBNSNKS3IVJ1em5VRn/Gtj9CCXJXC91YFpuwM9h1xc02dv32PcyKWCJfccR
         HzeeM9KIAJwutrxQ20q8W9rSst7DYzDuOf54vTMI2dTVedx4tsMmpS9+ZW9jJZqsRb5m
         a/Gx0O4PYZBPX/8p/eHni83dCcW2jj7i6pcTmRgIFX7ONC2TcN0/SXz3UdCnyVUSvTni
         m+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FGq75qUur3guPtN1jN9Cob7Ohj9YZYaRRzAKuw1dbWY=;
        b=WaiCcP2SvCNefkyEKIYavo7b7YZkM6skAm4bk/57ZYPFaRHxH5MMAkFT6+uhUCbAtW
         X6JP6xhM2LlmXhqn+iZpcdaZQ8aWOlU0a/fKxa7NajNlaZUzWS+4XKw5LHTXALlSKFjB
         FpGtOnC9jSx/UzNbbWMclsdjcYmlDpvQyV1AocLzoFTgxHEvpV5Mpy9OVt7yKqvbzA+S
         gLMpsHG0CBUILwkeWsfLFvo7qFNYwxBEAdjL8gDFi7mggmLcGftUy/ZElVbTB4UKzaYB
         el1UkXeTTiUFLC2c/PdCFw5JgcM2o783nSqI7KbjeL0lC9P/8DbfUA2nRPBRUN/99Dio
         5bqA==
X-Gm-Message-State: AOAM530j9ylTsJVFJlwb+9ZSxjxPc2Wxn7TRr55+18uqMvqFujwgye/I
        oX9ZsFxI8wFnzFXmbnzd0z9rDg==
X-Google-Smtp-Source: ABdhPJwEQ+f0mdH2Ebj897BMB7BG1nwVtr5W8q5vyKE8vFkRobkdRnBMlIILIFaDlDmFVccuWnYobg==
X-Received: by 2002:a7b:cb17:: with SMTP id u23mr4969095wmj.166.1601392342306;
        Tue, 29 Sep 2020 08:12:22 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r14sm6356332wrn.56.2020.09.29.08.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 08:12:21 -0700 (PDT)
Date:   Tue, 29 Sep 2020 17:12:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200929151220.GG8264@nanopsycho>
References: <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf>
 <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
 <20200929130758.GF8264@nanopsycho>
 <20200929134855.5vqrvdrtjxdzb23t@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929134855.5vqrvdrtjxdzb23t@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 29, 2020 at 03:48:56PM CEST, vladimir.oltean@nxp.com wrote:
>On Tue, Sep 29, 2020 at 03:07:58PM +0200, Jiri Pirko wrote:
>> Tue, Sep 29, 2020 at 01:03:56PM CEST, vladimir.oltean@nxp.com wrote:
>> >On Mon, Sep 28, 2020 at 06:46:14PM -0700, Florian Fainelli wrote:
>> >> That makes sense to me as it would be confusing to suddenly show unused port
>> >> flavors after this patch series land. Andrew, Vladimir, does that work for
>> >> you as well?
>> >
>> >I have nothing to object against somebody adding a '--all' argument to
>> >devlink port commands.
>> 
>> How "unused" is a "flavour"? It seems to me more like a separate
>> attribute as port of any "flavour" may be potentially "unused". I don't
>> think we should mix these 2.
>> 
>
>I guess it's you who suggested it might make sense to add an "unused"
>port flavour?

Maybe, but that was just an idea. 2 years later, I don't think it is a
good idea.

>
>> Okay. That looks fine. I wonder if it would make sense to have another
>> flavour for "unused" ports.
>
>https://patchwork.ozlabs.org/project/netdev/cover/20180322105522.8186-1-jiri@resnulli.us/
>
>Thanks,
>-Vladimir

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3F224F3C2
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 10:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHXIQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 04:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgHXIQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 04:16:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E3AC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 01:16:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a5so7737921wrm.6
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 01:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WIZAf3x2BneXQTTKPWzLh7lCftlSclIRyCF/Mlb3EW4=;
        b=UHKFH64eK+dJNPTMUEG2GKmEf2QnNltVe6HCRpFWZspvwFb52ZYmQiiZ4kCn7gaF2n
         SXWHdJsGJdH3VASepqgugyFAniRVIf2/X+rV8wETDho6CtJwZxWFMEqRrP7qLqT0XnBu
         YeX+uSKhRk43xBqG+pNd/UgX22Fejf0PMRAWhlTDfbe4xvd6zuPGst55lUXGpU5bGOSi
         JJc8XAbBvVpdlaTys1EakKWsoJfhau+xKzZ49CNCDNf/Xm8fye7qn+8sIvjmFYZmYqDK
         51Pg1dKN8+2RkirYUoo7Y6SGAHGMfsl7fyD6/Xi2nyGomPK46Dz9HxN0fIKyv90Y7jg8
         ho2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WIZAf3x2BneXQTTKPWzLh7lCftlSclIRyCF/Mlb3EW4=;
        b=rs/6Y1kKBThTOvHfODtaQA9qlVD85nYWlbclD1+QxrXqSPTZp+K3lemTJfRbu0TBcH
         EtGaNm7acjlPBV0uqQHOpFcrfdMseUR5MoVYEJsRTIQgeGrxUiIbGH7VxiMydMaoa3wh
         VXZOQX1zhdh1AJm6epu3jdZnHc7XWTja5lAdHS32s0ZhGv4DdSjAMgJmsPrz0R+yfb86
         /bqJpcHUqizRW+YombPfvVNMFNfaI6w76swlQstYOuNyYwngulN0dJYVgmqJz8HPduQ+
         ufcP/iFaXVbFIXlkWqTB0T+gUN7/ZsFL3Y0WZ+M2aPX7GIdkLdvmj+NM236/hBQJ0L1b
         AKJA==
X-Gm-Message-State: AOAM530YR5jVr7Fd+0d9DiMhXRKz2k5XeeI+CVvqFyMI/a8GAffGTMs2
        eP8xQoioGEz+aBqzUDzshtvD9g==
X-Google-Smtp-Source: ABdhPJyQ1dfhud31uvmhWjcNOV9nz6EpZ3fFDfyZlE0Rpp4BVPYFIT8QORlNPZLa72KkbDqugJRCWA==
X-Received: by 2002:a05:6000:1211:: with SMTP id e17mr4734550wrx.263.1598256984974;
        Mon, 24 Aug 2020 01:16:24 -0700 (PDT)
Received: from dell ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id w1sm22294675wmc.18.2020.08.24.01.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 01:16:24 -0700 (PDT)
Date:   Mon, 24 Aug 2020 09:16:22 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/32] Set 2: Rid W=1 warnings in Wireless
Message-ID: <20200824081622.GI3248864@dell>
References: <20200821071644.109970-1-lee.jones@linaro.org>
 <a3915e15-0583-413f-1fcf-7cb9933ec0bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3915e15-0583-413f-1fcf-7cb9933ec0bf@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Aug 2020, Christian Lamparter wrote:

> On 2020-08-21 09:16, Lee Jones wrote:
> > This set is part of a larger effort attempting to clean-up W=1
> > kernel builds, which are currently overwhelmingly riddled with
> > niggly little warnings.
> > 
> I see that after our discussion about the carl9170 change in this
> thread following your patch: <https://lkml.org/lkml/2020/8/14/291>
> 
> you decided the best way to address our requirements, was to "drop"
> your patch from the series, instead of just implementing the requested
> changes. :(

No, this is "set 2", not "v2".

The patch you refer to is in the first set.

Looks like I am waiting for your reply [0]:

[0] https://lkml.org/lkml/2020/8/18/334

> > There are quite a few W=1 warnings in the Wireless.  My plan
> > is to work through all of them over the next few weeks.
> > Hopefully it won't be too long before drivers/net/wireless
> > builds clean with W=1 enabled.
> 
> Just a parting note for your consideration:
> 
> Since 5.7 [0], it has become rather easy to also compile the linux kernel
> with clang and the LLVM Utilities.
> <https://www.kernel.org/doc/html/latest/kbuild/llvm.html>
> 
> I hope this information can help you to see beyond that one-unamed
> "compiler" bias there... I wish you the best of luck in your endeavors.

Never used them.

GCC has always worked well for me.  What are their benefits over GCC?

I already build for 5 architectures locally and a great deal more
(arch * defconfigs) using remote testing infrastructures.  Multiplying
them without very good reason sounds like a *potential* waste of
already limited computation resources.

> Christian
> 
> [0] <https://www.phoronix.com/scan.php?page=news_item&px=Linux-5.7-Kbuild-Easier-LLVM>

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

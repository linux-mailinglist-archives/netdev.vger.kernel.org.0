Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457AE2A5EB5
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 08:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgKDH2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 02:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDH2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 02:28:35 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7132C061A4D
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 23:28:34 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id w14so20875023wrs.9
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 23:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wLEXV0pXYo3fgedAIDk4DzbNdcsQTd/XNKAap/2HYcc=;
        b=oCaaMmweyhhj6XXvSe2s7Sis2BaWG66BfxypLRIj+WM1b9mIvQQE1K3IYD/nwihYfY
         clUZOu7Mxt5CJI87BHPBo9rKoLdlsu8kZTQLopWa0ppSkemO0Q/6AOXixGvFhcCIvt+2
         isnYdmzagvtkz1v0tP45gxGTk+NhDm1HulwBiHgynWgcRMdf7Tjvs+uN8MLRrwxjzbtl
         enIdPXepqR/nOk8jHyYR53EqbG/psVMpi/IPjEHQXS0O3n5BmuMcdF3ByYaTnwqH8rlI
         7RlpowENlWKlhnqdkrrtbaDLLAIIVzE5pavbXKAsUWS32QK9G1bWyMQabEEu+hzlPaXB
         zL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wLEXV0pXYo3fgedAIDk4DzbNdcsQTd/XNKAap/2HYcc=;
        b=XCQUDBRQ+EpicG+tORPpNn/TtXYq44UT7m60LSGNDsC7xp/6jAa3WrVD/uhF8KsWtR
         kEnbrdCdFiDSdfS9YlRnhT3+9eSbbTIyQtjbkyGUqKZfdrbOe9pGooCCifbj+R9Rl54o
         0wAkEezyA0LHB1nn84ZNLQAHxxvGfm5tWBz591l7Ct1CBUjpfshfuLWERKNzV1L/dWmT
         XVw8GF6EC649D/jwO+V+aWHMibi2TK/gWn1BD3Na7344BUVRc9RF7ajdik2imXKJ/R/S
         8ujRTh2ap/l0ytb2ZN+T/4cY4FdLoV0yEnsBoc+AkuFzNvJdc03YWIJKXTslhHIHJ8JG
         hLNg==
X-Gm-Message-State: AOAM531kfNZ6JU8Pa9DmusAVoWPNe9wx24BA+pUTmjNmrLh9KWv30Bec
        b+yzFAoUR5Zp73TcgFI90+7WKw==
X-Google-Smtp-Source: ABdhPJwF1ggFJCrMvOcflb/7vBIIieWYv/iSuCk2b96wcd8ZmgAhpbQBvQhyYTE5gmGKJfkrHU8mgw==
X-Received: by 2002:a5d:67ca:: with SMTP id n10mr29926841wrw.209.1604474913582;
        Tue, 03 Nov 2020 23:28:33 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id c8sm1284855wrv.26.2020.11.03.23.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 23:28:32 -0800 (PST)
Date:   Wed, 4 Nov 2020 07:28:31 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 01/30] net: fddi: skfp: ecm: Protect 'if' when AIX_EVENT
 is not defined
Message-ID: <20201104072831.GP4488@dell>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
 <20201102114512.1062724-2-lee.jones@linaro.org>
 <20201103164610.249af38c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103164610.249af38c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Nov 2020, Jakub Kicinski wrote:

> On Mon,  2 Nov 2020 11:44:43 +0000 Lee Jones wrote:
> > When AIX_EVENT is not defined, the 'if' body will be empty, which
> > makes GCC complain.  Place bracketing around the invocation to protect
> > it.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/fddi/skfp/ecm.c: In function ‘ecm_fsm’:
> >  drivers/net/fddi/skfp/ecm.c:153:29: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> > 
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Okay, I applied most of these,

Thank you.

> but please don't post series larger than 15 patches in the future.

No problem.

> Also each patch series should have a cover letter.

https://lore.kernel.org/lkml/20200817081630.GR4354@dell/

> I did not apply:
> 
>  - wimax - it should go to staging
>  - tulip - does not apply
>  - lan79xx - has checkpatch warnings
>  - smsc - I'm expecting a patch from Andew there

I'll look into these.

Thanks again Jakub.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

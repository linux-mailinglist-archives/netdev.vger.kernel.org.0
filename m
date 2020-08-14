Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A59244CE5
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgHNQn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgHNQn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:43:26 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555CDC061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 09:43:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c80so7999031wme.0
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bw1Tir57DBh//uKbJmgY59q5qNNSVFGXpIBJzyrS4Lw=;
        b=qHm26J+IwYUn5IJa2ysdzXpsHxc1KAt6rMFUFONUIDMIASRMSgivr98FjRGVhasvPQ
         WOuffJNjFYuiO6PKizYbOKXKKNTHX5MrodACxfE93iH8gBsWtSvbMOKl16t3ArUkHyLT
         mRKQgeWXiL1b0FE+8ST0nanOd9slb1k0HMgBryQWBktVC8lHcWezaXAyAZfE2ZRaph4Z
         LPRj51ijyosSxSA7AAO8QZGKG7/oJyUchYsshMvm96tI0sVntS5LDM9bhfKAwsK7gbCA
         CUa+Vw9/IPMPePnJKd6rzUbQSEXow1zb2E9HUKZrTSagHrfeUU2nhE2CiCP7CjLZ1GcI
         fasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bw1Tir57DBh//uKbJmgY59q5qNNSVFGXpIBJzyrS4Lw=;
        b=LVZ5vCnq/WPvf3nRV+16y2MIljSlPDw+/rtxdeZkRcHS472BpDPSlnUVHn7It6ypW4
         CNG9QxfTXyDEQZvpVK4dmNXSjWkC1lW1ywXEaXkUYGkpIoiXsDzurQrKS26sWx/UOSbv
         Fuszyv1xxjjboFA905ZPJGRtqT2Qv1xdemqrzya6JJe9JPB8Jll17httycs9H+hywv/D
         Si7Ud0WsovTryBt5lURgGomTMBa9nYWDmVcA5f1Wzs88tPo//4NXp0sIpDtxzcMWNZ+0
         gwSvZm165gH2vqOhou5BoDrktLjUV5wZk3XqJDxXz01nomSHK/z6tN+DPPX2YG/S3aJD
         kw9w==
X-Gm-Message-State: AOAM533pP0/C+/hVBMsemmQkzyg4vNMffNJHuIp40rAtXNwTQT09d4RQ
        BjBpsjoLP1er3JYLToqSGK8zcA==
X-Google-Smtp-Source: ABdhPJwmidNzTZJLo6FoNt59fQ9wCqrOkTh1OvEDHY3GA0jq3pvnnNCUEsTLO6WWNVnFhJIs0j0Vxw==
X-Received: by 2002:a7b:c7d5:: with SMTP id z21mr3391788wmk.145.1597423405005;
        Fri, 14 Aug 2020 09:43:25 -0700 (PDT)
Received: from dell ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id d11sm17098148wrw.77.2020.08.14.09.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 09:43:24 -0700 (PDT)
Date:   Fri, 14 Aug 2020 17:43:22 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Martin Langer <martin-langer@gmx.de>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Michael Buesch <m@bues.ch>, van Dyk <kugelfang@gentoo.org>,
        Andreas Jaggi <andreas.jaggi@waterwave.ch>,
        Albert Herranz <albert_herranz@yahoo.es>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 07/30] net: wireless: broadcom: b43: main: Add braces
 around empty statements
Message-ID: <20200814164322.GP4354@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-8-lee.jones@linaro.org>
 <87v9hll0ro.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87v9hll0ro.fsf@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> writes:
> 
> > Fixes the following W=1 kernel build warning(s):
> >
> >  drivers/net/wireless/broadcom/b43/main.c: In function ‘b43_dummy_transmission’:
> >  drivers/net/wireless/broadcom/b43/main.c:785:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> >  drivers/net/wireless/broadcom/b43/main.c: In function ‘b43_do_interrupt_thread’:
> >  drivers/net/wireless/broadcom/b43/main.c:2017:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> >
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Martin Langer <martin-langer@gmx.de>
> > Cc: Stefano Brivio <stefano.brivio@polimi.it>
> > Cc: Michael Buesch <m@bues.ch>
> > Cc: van Dyk <kugelfang@gentoo.org>
> > Cc: Andreas Jaggi <andreas.jaggi@waterwave.ch>
> > Cc: Albert Herranz <albert_herranz@yahoo.es>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: b43-dev@lists.infradead.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/net/wireless/broadcom/b43/main.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Please don't copy the full directory structure to the title. I'll change
> the title to more simple version:
> 
> b43: add braces around empty statements

This seems to go the other way.

"net: wireless: b43" seems sensible.

> I'll do similar changes to other wireless-drivers patches.

Thanks.

Does that mean it's been applied, or is this future tense?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

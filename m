Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBA749EDE9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 23:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbiA0WCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 17:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiA0WCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 17:02:17 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2136C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:02:17 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so3136727pjb.5
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h7B17Czn1NdYhar5q6mNXeWtEv5jvJbyqpMg0rIIm6I=;
        b=IrZmbTVrbvABR6uiQSxx5K5YaDNTiUZO2i9ABzfPqYLbuE9F3niFk6W9CHNPTsWSkW
         Zf6yIn4xV6G881MRkU/2furhG7XxAmbX2M/yRTBA3DaQ36rLMqNR1pvlywtFavgtRqju
         eFQfdx91U0DYXW1QOB1ZSPVCEyVCfvPkhQA+mT1IlFbP+s13nbErbk4NMyBXta570MxA
         +JJ+t7v0pPkLY4l+Gwjw3no5s2IYXD3nWUtQBv/VqDRdDYaxHTgp7ZXiqQhxtroR15wH
         P6EK0CVuwpqNgmn3Ha5QO/S9psRWshiN9je8am1oNJOAGiI22/6RFaouiKEmYRCHG+Jg
         keKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h7B17Czn1NdYhar5q6mNXeWtEv5jvJbyqpMg0rIIm6I=;
        b=KUCb764A8QmBm41dpimyooWAMB59eJrzJ8yY+JBzedBkuMtV3E4KS2vYLELlXM5uhQ
         OS8d/1hu1t71X9gA1D1URZm2MIX5cJZEON7VRytCmn63VkMsYlet5ag14k3PO/i7Voa6
         AnTDb1FsqYgA8drs9dFm8g+Ep9b2d+z13TrGwhqRQMIQaMSYmtbKrvWmNvBTOsEs3FxI
         lzGCr/RBJcyEKK40a+AHLKtPQVrPC1Qqn1RxrcNtbp+uMWVDwEkdAlOdj+wdY3oJeMz7
         gVFPkORgdaUmTHh0OOIgG2eSq6awDOZoh/8/FAscwhnbe7XCf5N2rEVAGOg4J4kVFMrR
         ApTg==
X-Gm-Message-State: AOAM532GBKwy8bR1NEiaKJAfWjFOxDcKkRsDZqg82U2Ry0onHvAHHVqR
        TrNR2ZcTMBbrDqcWLX5ln0XAKYfTras=
X-Google-Smtp-Source: ABdhPJxukJM2onIn1sWoImioN6T8by+7kXHn0pWseBuL7+oEaH/SbI7Za/+7ACCzVCtSojC79/Z0ow==
X-Received: by 2002:a17:902:ecc2:: with SMTP id a2mr5090643plh.12.1643320937277;
        Thu, 27 Jan 2022 14:02:17 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d10sm3807459pfl.16.2022.01.27.14.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 14:02:16 -0800 (PST)
Date:   Thu, 27 Jan 2022 14:02:15 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] Virtual PTP clock improvements and fix
Message-ID: <20220127220215.GC26514@hoboy.vegasvil.org>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127114536.1121765-1-mlichvar@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:45:31PM +0100, Miroslav Lichvar wrote:
> The first patch fixes an oops when unloading a driver with PTP clock and
> enabled virtual clocks.
> 
> The other patches add missing features to make synchronization with
> virtual clocks work as well as with the physical clock.
> 
> Miroslav Lichvar (5):
>   ptp: unregister virtual clocks when unregistering physical clock.
>   ptp: increase maximum adjustment of virtual clocks.
>   ptp: add gettimex64() to virtual clocks.
>   ptp: add getcrosststamp() to virtual clocks.

For patches 1-4:

Acked-by: Richard Cochran <richardcochran@gmail.com>

>   ptp: start virtual clocks at current system time.

(I don't agree with this last one)

Thanks,
Richard



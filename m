Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554914142D8
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhIVHn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbhIVHn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:43:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995F0C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 00:42:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t8so4045282wrq.4
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 00:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=d55eamAySqf8b3clxNZoYmb1gYK8E1S3WLes7WqiIfs=;
        b=En1Lrh7mJNVgVfiySVL3wAibVB+mnm4S6GcLAluUemGC1iyQv+uSCHQEaTfHVObjy8
         XKOJ+SSfS5C8/i1rSH2QC4BBMkqkTQdNa2QXwdqkiMPCv9EyXNF3YE4Sl+gKkIvkobvv
         hM+xBoJ6LP8jak9c+k7JBFdT2syJ00EnZ3UtZw42KWWR1W27AiX5A8RSLzMT+M/Nvvjp
         t05X7P5wZmqhW3z+Byx/KoWs+YkCoYSQepiyQirmaBx9sGaSwagFKHkwqw4flL/V+U9H
         jIr3FdUZSoMSvceDmnAoOvmt9le3rU1Jqu+jp0bCSGo+7PqOvs2MjD4peYfi2JvnnBzs
         e2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d55eamAySqf8b3clxNZoYmb1gYK8E1S3WLes7WqiIfs=;
        b=GS1ZiAkP5CyCrQE0wgWcLb7TmWqiLb9QA60yodQEr10SAqKF/PdsUu1TeB2uHfupam
         LCdSL4YEcl9Lrv3LS7LftDoFWUQ+wkiRpiAqvtgIJ3157FSjrTgVuXKOqY+Izbh7qsHu
         uzo3IJt6XAS1mCLVMIgRn2GIL1UwbaS+DE+yaifo4cqhFBHpoHIJrVAVkEZjxsU3LkOQ
         0KTaQMPUev5KnGMaVqFg5xj6MUwTUTogmFPFawdLd+yZ2r6WOgOMkAruVnMaOuascpch
         N9KJoEfG1tkzoiLDVhZYM/7dwnGTO4fdCIE5kjDcXy/FHLL6X7DRdcfFLt7+AIelQ7ja
         v74g==
X-Gm-Message-State: AOAM531hZ7+085Y3E2FGU43fEEhAK2QaD5DsiiFNq6OEO0A+iQAvUku5
        pJbRWJcZFPAaYHvG+6Er0DIuRg==
X-Google-Smtp-Source: ABdhPJwGkzewC3Vv9V1KSEEwR05eeenEIB8MnobkkJ+f5yCBcI7TqKeLe7zyybS4E80mygjrwaogpw==
X-Received: by 2002:a05:6000:1186:: with SMTP id g6mr40525701wrx.126.1632296545202;
        Wed, 22 Sep 2021 00:42:25 -0700 (PDT)
Received: from google.com ([95.148.6.233])
        by smtp.gmail.com with ESMTPSA id b207sm1129023wmb.29.2021.09.22.00.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 00:42:24 -0700 (PDT)
Date:   Wed, 22 Sep 2021 08:42:23 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ptp: clockmatrix: use rsmu driver to access i2c/spi
 bus
Message-ID: <YUreX2Mzif7o0C1n@google.com>
References: <1632251697-1928-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1632251697-1928-1-git-send-email-min.li.xe@renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021, min.li.xe@renesas.com wrote:

> From: Min Li <min.li.xe@renesas.com>
> 
> rsmu (Renesas Synchronization Management Unit ) driver is located in
> drivers/mfd and responsible for creating multiple devices including
> clockmatrix phc, which will then use the exposed regmap and mutex
> handle to access i2c/spi bus.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/idt8a340_reg.h       | 783 ---------------------------------------
>  drivers/ptp/ptp_clockmatrix.c    | 769 ++++++++++++++++++++------------------
>  drivers/ptp/ptp_clockmatrix.h    | 117 +-----

>  include/linux/mfd/idt8a340_reg.h |  31 +-

Acked-by: Lee Jones <lee.jones@linaro.org>

>  4 files changed, 460 insertions(+), 1240 deletions(-)
>  delete mode 100644 drivers/ptp/idt8a340_reg.h

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

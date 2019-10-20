Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB00ADDFCF
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 19:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfJTRrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 13:47:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38525 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfJTRrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 13:47:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so6217039pgt.5
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 10:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+NHOiV4ILMivhVsErMoQGadLd+O5M8d6SmVTUKUJf6c=;
        b=aiUZonq8yybjw3ZL18BARLZP2MpsKIiO3CfvlaWAJcQgZknDX0nH0yIt8ocYdIZOdp
         J4/P15SpSob/Cls8+DVu7jghFaXAd2p0LqGsYMPzeVZ/aGMxM43yfSOfjbw0+X09CuIw
         PCrozSJFxypnaaRvGXUl8IIz/tYa78YxB+KWTtUx/agEVpC4dWCrSzL3oXV8nX4Vx5HZ
         Y0AGMIh8kQO6bHB+NeT4XpqgxnTZRO0ZB45JVCJt96lOKU1c5yA2WdxfGk5TX3TO88cJ
         U81g4F5abziAN28yS52ypTnuGawB8Wy+x19eDHv4/O3Gnv6hPPidRigOb6HUmayQWzLG
         dm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+NHOiV4ILMivhVsErMoQGadLd+O5M8d6SmVTUKUJf6c=;
        b=q1Pg8WzwQL357vSMJLHabRBb1FXT4GX3GIoLHI/Fio2Kz6nHb74fcwjg2sXgNtMntY
         umnOR63iABG69YxCtJay4eREUUq9Vro8WS+QxefERW8m5CvBzoHuqOPuqpYvBMeyNceg
         UWHIdzE+BTN9W5K6OiC0/OkTtY7IKrbgRnAACqA/pi7veS6vwTzdDmYMAjs/D55pMjCE
         NYBanWFxYtPohO16nF29px8kU/WQLMSAyLVRggdxKMGxFZF//GZFy1UXiOQbMf2DWSTk
         E4/zqkByh1/6sxlGmFQ2A4FPCgAv7WPhgrQzo8pYCjJatlpJ2GMEsAEQfbYwk1v3yegZ
         JUsw==
X-Gm-Message-State: APjAAAXGyHU5sWNRr0QmbAvs+ULM8qbxU0Plp8L+4zG5FDXTrxx06ifL
        rvHcjuNbGOsuWIxRxVPi4BXcFg==
X-Google-Smtp-Source: APXvYqyyiw+UfFAgN+yHPWQp16F7V3NbJONfPO/aPsfSOq9jomGHcCtm1CMmbKoFiHB+sBLaocfNvw==
X-Received: by 2002:a62:1dd2:: with SMTP id d201mr18687976pfd.131.1571593654926;
        Sun, 20 Oct 2019 10:47:34 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id y10sm12504739pfe.148.2019.10.20.10.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 10:47:34 -0700 (PDT)
Date:   Sun, 20 Oct 2019 10:47:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v5 net-next 0/7] add XDP support to mvneta driver
Message-ID: <20191020104732.4187fb9a@cakuba.netronome.com>
In-Reply-To: <cover.1571472169.git.lorenzo@kernel.org>
References: <cover.1571472169.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Oct 2019 10:13:20 +0200, Lorenzo Bianconi wrote:
> Add XDP support to mvneta driver for devices that rely on software
> buffer management. Supported verdicts are:
> - XDP_DROP
> - XDP_PASS
> - XDP_REDIRECT
> - XDP_TX
> Moreover set ndo_xdp_xmit net_device_ops function pointer in order
> to support redirecting from other device (e.g. virtio-net).
> Convert mvneta driver to page_pool API.
> This series is based on previous work done by Jesper and Ilias.
> We will send follow-up patches to reduce DMA-sync operations.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE92CAD28
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgLAUSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:18:20 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37905 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgLAUSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:18:20 -0500
Received: by mail-ed1-f65.google.com with SMTP id y4so5293743edy.5;
        Tue, 01 Dec 2020 12:18:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ns4HG9DM27lmRcUp9biCqhgyVmAToMpSvVFQa0yBXI=;
        b=qt74laS4NpZHcaZcw4vhseCgJbLGXyQYa8DQV9bHbwCtOqezp8iwVVaA5mOe+47IV9
         btOm8HmXA7eVMq7RdWkBext2KADK8V3DlHnBv2bvwv7+s9vT+ZaDOwPz+TLAD2VkNKSD
         P/ZikCFZPZ3G/WVK+9OUJRhtDlr6c7zcs3JI7UsGbRCXnyoeajRDEFUjDL3/fnzxs2Xh
         Yp7Ps+Fc4GS8ifAbVaM/nrDFTExWx0sfgHeQApFfTirKEdpPKFZOckQSRUElVDoJWrfe
         q/XGarvLeSsFwqcxYF4SUnrfM7G7bIuMVrknkHRRZjt8Atkz8k5tc9SvEvnYbwEJsWLx
         bJUw==
X-Gm-Message-State: AOAM530cr/wPjNIkJ2PwByzm0JAzH8TiMAshD45fyGPFVkfD89u1PCwb
        wQjQ1fR5/DhO32QFf+4WIZ0=
X-Google-Smtp-Source: ABdhPJytaTlX5sDtGX2dkVcTazbihS4Em7qkx3GYmCK6ADvKA5s0Ww+UFFOU8w6FLSmjPQ7UdihqTA==
X-Received: by 2002:aa7:cc19:: with SMTP id q25mr4847401edt.290.1606853857665;
        Tue, 01 Dec 2020 12:17:37 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id d9sm412152edk.86.2020.12.01.12.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 12:17:36 -0800 (PST)
Date:   Tue, 1 Dec 2020 22:17:35 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v4 net-next 3/4] nfc: s3fwrn5: extract the common phy
 blocks
Message-ID: <20201201201735.GC2435@kozik-lap>
References: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
 <1606830628-10236-4-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606830628-10236-4-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 10:50:27PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Extract the common phy blocks to reuse it.
> The UART module will use the common blocks.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/Makefile     |   2 +-
>  drivers/nfc/s3fwrn5/i2c.c        | 117 +++++++++++++--------------------------
>  drivers/nfc/s3fwrn5/phy_common.c |  63 +++++++++++++++++++++
>  drivers/nfc/s3fwrn5/phy_common.h |  36 ++++++++++++
>  4 files changed, 139 insertions(+), 79 deletions(-)
>  create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
>  create mode 100644 drivers/nfc/s3fwrn5/phy_common.h
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

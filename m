Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FFB61DB0
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 13:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfGHLL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 07:11:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45409 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbfGHLL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 07:11:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so16570370wre.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 04:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YbnDYfC9QqBJhnf6yzI8f/ByJtnQgGge3JUVVqJN8ac=;
        b=ORWFnPY6EPC07tgT42NqoIRTkSpWSqIHGA/MrW7vTjinLjjPtft2aoynKvNQ9mY6DH
         w40vgHEw08HSPE3jzyrkAeuWaA9cd9xl42afwcBxDDyLczm6zm3TOYec/YZn4w6c0NKc
         NTEGto74HzTLnj/syx0EUZKUgBVqzfsghkVNOYDhnKn2krg06Y+eNSx99HafLqz0zTIb
         rLDtDO+Uztg3Zywuv5ZNDRjtPg+zJ+UUlVOY1Ise+IYuMFq27bYSxFnhF6iN5WmYx16W
         sCQCmOl+Dh0G76GcSN98doySEwGwY+t/BhruMi7gmku1kBPoXbCdumu6nEgpMHY2LGvD
         JuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YbnDYfC9QqBJhnf6yzI8f/ByJtnQgGge3JUVVqJN8ac=;
        b=N+mlcRpGl8wZG7RVhtc+Piv2Zwg/rLmwxHrDonSuO0l5x2W31dJOLhIoYth9ZJHlW6
         FikZqAHbS4QGh0hHxs3sRjKW19lqHmiYfv6+djC8T9yQJBQw0rl1kz95As4btFLf8cdg
         4Bd+0vVLO05oOwtJXzxsKjpmNqkJTuK5nHe5EuG0ZmPVG6d7j2/7CaCNCUXLAbp9kFF4
         DMnCWzYcFJYxCL4E4sxisKssZ+bQwVwCViHNSJOP43nc4czG+ZLVZzUhLouFXuxW3Wjo
         P8MH9+EYIOAgZyZqbd21PrN9vIWWJHZlbCNOndHnswL97kUvRKFDfkpjLji2QOzpZXJo
         OAMQ==
X-Gm-Message-State: APjAAAVMhqpdAHtkeiPwm6yClDY9BauvkUCMAPnDNhkgDvNH9je34fXb
        5seGs/PweBcLcWglldwiueno1w==
X-Google-Smtp-Source: APXvYqw7dKhy/m8SZlo5BbgMo7zjVhJupDhoLj9ZF5u//vaGkwQaQBaboFmIwUBLVbh4RZVi9BELPQ==
X-Received: by 2002:adf:eecf:: with SMTP id a15mr17372486wrp.264.1562584314592;
        Mon, 08 Jul 2019 04:11:54 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id o7sm11879276wmc.36.2019.07.08.04.11.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 04:11:54 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:11:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 05/16] net/mlx5e: Rename reporter header file
Message-ID: <20190708111153.GC2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-6-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-6-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:52:57PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Rename reporter.h -> health.h so patches in the set can use it for
>health related functionality.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/en/health.h      | 15 +++++++++++++++
> drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h    | 15 ---------------
> drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c |  2 +-
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |  2 +-
> 4 files changed, 17 insertions(+), 17 deletions(-)
> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.h
> delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>new file mode 100644
>index 000000000000..e78e92753d73
>--- /dev/null
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>@@ -0,0 +1,15 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/* Copyright (c) 2019 Mellanox Technologies. */
>+
>+#ifndef __MLX5E_EN_REPORTER_H
>+#define __MLX5E_EN_REPORTER_H

This should be "__MLX5E_EN_HEALTH_H" now.

[...]

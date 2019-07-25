Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296F37591A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfGYUse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:48:34 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:42823 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGYUse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:48:34 -0400
Received: by mail-qt1-f170.google.com with SMTP id h18so50455700qtm.9
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 13:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ptUKGVoRRU8o1lCU6dbae1IctfrFFlzDr53AZzldROE=;
        b=UnYwlh3bFEgZ7RGMIqgOE/BevyyMheoLsPHAR6werjSpyyDJTlE7k2vsjg8lLzoPKx
         sZSVDnwK52/GM/kSdws1xLckOWVqL0RK0Yzwh28NhiUjSWuobma51XjjsvgMO+qXxAJT
         IJxJBLLtoiD2rcCegQw4DoCYM3eiN5rvkMck6ABRGA2M9x5jjomGDM3UBIFiKC9DRWSi
         LoqW9A5tXbp15kfDf5o34e9RpkEUVHUisMcjHX2ZeqeqA2bRM/CPSAZL93QaUBhCn4wR
         qlJWU8l0aN4DMx8rUUaSQBsyzL3KheXX8ARBCE9ZFv5tq1Q4zxZHpzfVsWUJDtIU+5VU
         +okA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ptUKGVoRRU8o1lCU6dbae1IctfrFFlzDr53AZzldROE=;
        b=pWNVCYEGv39r3OhuvY8naD4QOwTZ1Uao5l+9t5JGPvFMjFksG1/NSwIRTdf7GuoRwt
         0F7uzbTdt+RtNSgVWcbd3+rq5/lxToT03pt/WSU6FnRb9f9NPbiEVN3c06k3OsIf7LlO
         1I+GgYA7W1BYHijb/0INfjyYtnMjN3pjPSM4BNykJj19vs79ilOYWG1mS3KYTttXfXm7
         vQJZ+Ym56Zc4X7KjJIW/ltaOWMtvqjfWKkrZcEz0NEzHlYR2RFKP8xeBwWq4m2Mt1vJZ
         lzGXNTqIZFyt1C/G4BjpMSSPYGjNbesrtIA4Z2Qt/cNQe4Stb77SgiPWBGZzG4w8b+Qp
         YiZQ==
X-Gm-Message-State: APjAAAVPuOrOyddg9lg0x5zSJtngtT1l0S/pCdTyApXtN5smL0khJrgn
        T732lYo8zIBwGMOfu6DD+1ZSDg==
X-Google-Smtp-Source: APXvYqzKsXObXgP3VPjR0wUbKaBbY9NBI4qvyoWbmIYHy+DonXFnYdx+ZdQBy0BRLTnvUu306yOYsg==
X-Received: by 2002:ac8:2b62:: with SMTP id 31mr64119710qtv.140.1564087713173;
        Thu, 25 Jul 2019 13:48:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l6sm21389370qkc.89.2019.07.25.13.48.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 13:48:33 -0700 (PDT)
Date:   Thu, 25 Jul 2019 13:48:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 7/9] net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
Message-ID: <20190725134828.1c56e467@cakuba.netronome.com>
In-Reply-To: <20190725203618.11011-8-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
        <20190725203618.11011-8-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 20:36:48 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> A netdev mismatch in the processed TLS SKB should not occur,
> and indicates a kernel bug.
> Add WARN_ONCE to spot such cases.
> 
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

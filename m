Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5855B28F6F0
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389987AbgJOQhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388946AbgJOQhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:37:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D2922210;
        Thu, 15 Oct 2020 16:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602779870;
        bh=pALz783LzfRXbsIY9Fub1iKorTaknuPohUdE3VcLq/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EKlOIox5osiRTNx/dFwuDiQjY2CDCt+hx3oxlVxmgj1m8Vn1spi8zVrZWbj5SqTgk
         XM9w5SHCR5GQnFuUOFc3LRhX8+gHqw6SN4Zx+Xw9Q1DcUzgUxl/j7MOmWyQvQbbMAr
         EGH560caI8Y3vz02RvM6hCt55f342EoK5xRYshmE=
Date:   Thu, 15 Oct 2020 09:37:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andrii@kernel.org>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <masahiroy@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpfilter: Fix build error with CONFIG_BPFILTER_UMH
Message-ID: <20201015093748.587a72b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014091749.25488-1-yuehaibing@huawei.com>
References: <20201014091749.25488-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 17:17:49 +0800 YueHaibing wrote:
> IF CONFIG_BPFILTER_UMH is set, building fails:
> 
> In file included from /usr/include/sys/socket.h:33:0,
>                  from net/bpfilter/main.c:6:
> /usr/include/bits/socket.h:390:10: fatal error: asm/socket.h: No such file or directory
>  #include <asm/socket.h>
>           ^~~~~~~~~~~~~~
> compilation terminated.
> scripts/Makefile.userprogs:43: recipe for target 'net/bpfilter/main.o' failed
> make[2]: *** [net/bpfilter/main.o] Error 1
> 
> Add missing include path to fix this.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thank you!

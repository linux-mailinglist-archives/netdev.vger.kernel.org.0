Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96EF2E9EF6
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 21:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbhADUl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 15:41:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhADUl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 15:41:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79456216C4;
        Mon,  4 Jan 2021 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609792846;
        bh=1EcefIPb+WgnIe4InC5SctRL/ZMnIFyhL+D3wsxVlzM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WWzQOCiYmCuuOsEx7xaH35w2W19JFt+xvKhJNjDFrOGDMu0jMKphxFeVBhH58qyiK
         uYtWzJXY68KIn784O7e0ITGfKlLg4Bf+QcOORG36ULHUxgTUAmLw05OhuO0SJb9kgz
         YtKWAJSBEwIonw7cao3wKdRT834FJcsqaV3f6467bz4chTvOofR61FkUc0nQtdV3FN
         +o+J7E2XgrXL5MZljq80mFSBEY79aXXh4/Vudj8Lx8U9XMoWbjGUP/yQVCvn8P80vh
         MbrjH2qDrsvRJpw+QtKNN48s0TqsQdYUjlb/5O1LrABR/AZ+INYh5xAE4wGu907hbd
         aK2xw9JQkg8+w==
Date:   Mon, 4 Jan 2021 12:40:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, tariqt@nvidia.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] mlx4: style: replace zero-length array with
 flexible-array member.
Message-ID: <20210104124044.2e0a62ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1609309731-70464-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1609309731-70464-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Dec 2020 14:28:51 +0800 YANG LI wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use "flexible array members"[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/
>     deprecated.html#zero-length-and-one-element-arrays
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>

This breaks the build with allmodconfig, could you double check?
Are there dependencies?

In file included from drivers/net/ethernet/mellanox/mlx4/en_netdev.c:50:
drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:316:27: error: flexible array member in a struct with no named members
  316 |  struct mlx4_wqe_data_seg data[];
      |                           ^~~~

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C98E315F20
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 06:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhBJFna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 00:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhBJFnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 00:43:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D1B64E3E;
        Wed, 10 Feb 2021 05:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612935762;
        bh=LWLN+C2cwhauN4xaZIPOAGBmvFz2pWpCauybY9DtChw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MmZOvvXj5DXJD1nC14WUSOxmMJf3onbk/yUVk6MgsWgNrrlVUHaEYvLdwy1J4t3lM
         mKIARWxLVKQAWmpT4UWXi+0MrWzGXexahrZoQudeWizVLPinyZSGh3w5J3edazc1kE
         ZbxpABlaB8ZxSR/GygaZ3hRQSbUT0cwO4zDpqc7ULVLJGBZQWM3ZtMipB6KMgKkxoz
         VG863JxCY6i8ItD5mw/BJb6U9u28bs/GyBE4Jb3LbqsgWsUlN15GCBn/SoCqmvwGaN
         hKN0G0e2AKvslY0eq6Ar9Wbh4E106hhVunyFlTDbRs9sCV7Tsu6l7TVAWFHXS7q3u8
         Lw8XXPJq0fChg==
Message-ID: <28f0dde76d1dbc666a4eaf9e5b23eaec9989aad8.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: docs: correct section reference in table of
 contents
From:   Saeed Mahameed <saeed@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 09 Feb 2021 21:42:41 -0800
In-Reply-To: <20210205095506.29146-1-lukas.bulwahn@gmail.com>
References: <20210205095506.29146-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-05 at 10:55 +0100, Lukas Bulwahn wrote:
> Commit 142d93d12dc1 ("net/mlx5: Add devlink subfunction port
> documentation") refers to a section 'mlx5 port function' in the table
> of
> contents, but includes a section 'mlx5 function attributes' instead.
> 
> Hence, make htmldocs warns:
> 
>   mlx5.rst:16: WARNING: Unknown target name: "mlx5 port function".
> 
> Correct the section reference in table of contents to the actual name
> of
> section in the documentation.
> 
> Also, tune another section underline while visiting this document.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Saeed, please pick this patch for your -next tree on top of the
> commit above.

Applied to net-next-mlx5,

Thanks,
Saeed.


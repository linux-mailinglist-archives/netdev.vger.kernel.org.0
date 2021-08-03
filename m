Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62913DE4C3
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 05:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhHCDtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 23:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233436AbhHCDtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 23:49:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6993160ED6;
        Tue,  3 Aug 2021 03:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627962531;
        bh=EXeW4XQKyVPpPxYGyOEJ36UXmXCx4/m+0m8TH0EcSJM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YzmTeIjwlmWMES6nDkyis/jq3SVq/huVP9STpgYZ+cUJQoIlHQwVV4yZX8nsfnQRi
         5oormVc/F+nStYqg2qz3sLfhSzwq7MYM69l7JNoRTnRyqM0+QjBUIzl3u+I4piIVhD
         n/PCfKuxSk8KnNGi6soHhfkAhwsSWEL4CL6VQLWpVox6634i5eU7GEWkUyolOPgm3Q
         FFySuKxJRz9tELF6xXG8LvzE0oorohkPL+s8JbmFr2dQpnnwAJTF7ZJFcXJ7M2K/ct
         ahNy4z246zaUrAoKiR7CPJiHjmLdr5wQ32CRo3/inaeYAuNsG1M1Hyc6ozYPiMT2bt
         kwk28TRMvHEzA==
Message-ID: <cf0f21e0b9ba0101523dfe3213ab87e882613c5a.camel@kernel.org>
Subject: Re: [PATCH net] net/mlx5: Don't skip subfunction cleanup in case of
 error in module init
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>
Date:   Mon, 02 Aug 2021 20:48:50 -0700
In-Reply-To: <955a0ebca11c8e41470e37ec2eb2a3bbcd77bbe5.1627911426.git.leonro@nvidia.com>
References: <955a0ebca11c8e41470e37ec2eb2a3bbcd77bbe5.1627911426.git.leonro@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-08-02 at 16:39 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Clean SF resources if mlx5 eth failed to initialize.
> 
> Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---

applied to net-mlx5 


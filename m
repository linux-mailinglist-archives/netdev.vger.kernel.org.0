Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AB3245E48
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 09:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHQHqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 03:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgHQHqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 03:46:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD2DB2072D;
        Mon, 17 Aug 2020 07:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597650364;
        bh=/dLsCL59BBdZTdtBCg7uXsKIxA1wGNn+u3yRPL4hyps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SbKsIKt54aBDdbMJrQ7c4LgFhy50FOA4q3zHr9dWpjHvpn1HOpyEsCeQrUnVoVNl5
         7qJUfIYwmFLF3TbC9p08zGYs34vkWdpZbCzOBdojFxeanlCAFeHVEZw827wDg06VT4
         gKHlm5RlmR7cHwXHSEmZYMkKnc5dcQB8E2X2ZA98=
Date:   Mon, 17 Aug 2020 10:46:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v1 1/2] rdma: colorize interface names
Message-ID: <20200817074601.GK7555@unreal>
References: <20200816230256.13839-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816230256.13839-1-stephen@networkplumber.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 04:02:55PM -0700, Stephen Hemminger wrote:
> Use the standard color outputs for interface names
>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  rdma/dev.c  | 2 +-
>  rdma/link.c | 2 +-
>  rdma/res.c  | 6 +++---
>  rdma/stat.c | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1FD3168A1A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 23:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgBUWwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 17:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgBUWwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 17:52:01 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3618520722;
        Fri, 21 Feb 2020 22:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582325521;
        bh=bgEzadOXtjUpXaqTqkqpzVmbXb0tWTaYTcJw5FZd24Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1SqB9r6KMB8dl074DQRFzZpj4diqHyictwdLaKAEBcH9tnZLcCPDIw/Zb6J0USHGg
         c1vLdo8TJfrGNZlsSk2mfmEs+3nLjHFnN7KoYpTrcMn660iZdQP/xjmGLD9V5NjDc/
         HjrtXXRT4WQYaPXlEeN/kgENMA1L1mcM8mepbmHQ=
Date:   Fri, 21 Feb 2020 14:51:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next V2 0/7] mlxfw: Improve error reporting and FW
 reactivate support
Message-ID: <20200221145157.20c8eb7c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200221214536.20265-1-saeedm@mellanox.com>
References: <20200221214536.20265-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Feb 2020 21:45:56 +0000 Saeed Mahameed wrote:
> This patchset improves mlxfw error reporting to netlink and to
> kernel log.
> 
> V2:
>  - Use proper err codes, EBUSY/EIO instead of EALREADY/EREMOTEIO
>  - Fix typo.

LGTM, thanks. FWIW:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

> From Eran and me.
> 
> 1) patch #1, Make mlxfw/mlxsw fw flash devlink status notify generic,
>    and enable it for mlx5.
> 
> 2) patches #2..#5 are improving mlxfw flash error messages by
> reporting detailed mlxfw FSM error messages to netlink and kernel log.
> 
> 3) patches #6,7 From Eran: Add FW reactivate flow to  mlxfw and mlx5

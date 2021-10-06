Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32B242355E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbhJFBNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233994AbhJFBNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 21:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EB2D6101B;
        Wed,  6 Oct 2021 01:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633482718;
        bh=bdF0qWePoVu/tAw9xCP5yT2rmHXfGoXgQ+1qfqbMEmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QXQsy2UiZnXVTkqaIjYHESIw8hcWIj+Qb3/2uwiD14cD2pFFC8wACgJfxhBy7bc6g
         6Uj40uSRiYwJHqUsGaBUD5EjptkcDxWTTSgXWj0bE9LRmZsbqx8UrleXGwHpk2cr2T
         9I1+DMGiJTxjD3uWqccxYImwDZSU8iBsFIr9ABCIE8vJc8hADOEtorJTEC7T/Fj/+p
         5KQYoNTwZ+65Xyrdss5NqdwE++5cUFMdi8zV6TJ8tj+dwBkwd9y+I15dcUkitFGAb4
         uUMaYEsKWdcisdErM3ewUcsLwZF6KXFDW79Uf3mWSedfu4MgTqdt8yIJC4+FtdtYAC
         FILfO9iJfDF8g==
Date:   Tue, 5 Oct 2021 18:11:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-pf: Add devlink param to vary
 cqe size
Message-ID: <20211005181157.6af1e3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1633454136-14679-3-git-send-email-sbhatta@marvell.com>
References: <1633454136-14679-1-git-send-email-sbhatta@marvell.com>
        <1633454136-14679-3-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 22:45:35 +0530 Subbaraya Sundeep wrote:
> Completion Queue Entry(CQE) is a descriptor written
> by hardware to notify software about the send and
> receive completion status. The CQE can be of size
> 128 or 512 bytes. A 512 bytes CQE can hold more receive
> fragments pointers compared to 128 bytes CQE. This
> patch adds devlink param to change CQE descriptor
> size.

nak, this belongs in ethtool -g

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2F52D3376
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgLHUT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgLHUT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:19:26 -0500
Date:   Tue, 8 Dec 2020 11:19:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607455179;
        bh=7Y33f++WRd6rnyQYLzHMNsPNQkHOrkxPbcYvqD4IR9c=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=PJFTsKnBXx/+ut3Ywgf/7/rgVYBaAawEFqoVQT0TF4E2AhLT5jnLZVdMNzl+c5u0B
         HDuP0n9VCCwelIYNQA/fK6rMf85/uyUX/f+tKjXGGzHfBgq5UmV5O2+9vHdBwNpHmv
         4jYex/7A4niGbi6w6V3aq75a38AH80QTbJCYQiTbK8vLSgqqfWNICYXhUF+y/l5nh4
         JC7nsv/Bp2RQ7JIf3LSJIzxbnRtAjbtNyAaW/8O+s1Xt+ci9b6YIgyas+KbcLJY1pP
         pNql7G7g3/FusSHGiAkrg3/vKyNC2Mf8+omqeml201Ikg9eC74ahoJKDJBq3xY+EhG
         a082BRSrpvyHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next] net/mlx5: simplify the return expression of
 mlx5_esw_offloads_pair()
Message-ID: <20201208111936.56314fee@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208135625.11872-1-zhengyongjun3@huawei.com>
References: <20201208135625.11872-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 21:56:25 +0800 Zheng Yongjun wrote:
> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Please make sure to CC maintainers on your patches

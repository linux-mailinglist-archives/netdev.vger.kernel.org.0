Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E52DA87D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgLOHZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgLOHY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:24:58 -0500
Message-ID: <898c12e4f84707d1bdc172279037d0733821d227.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608017057;
        bh=dB78KuDToSldSUEysrE8FcyKsOPfqbzYG5JWvpOPY6o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nnJ23/J3nb7wLZnRd2Ck1HJoCxv79VSbCSYxxPUbSWAPgMvFyhEUUxTaxfcQmidBG
         5ghBnzmDMBjVP+xpHxtXXzK5Vfxd+a4APXc3cb1UQTzOhzbjvxSMd//ERo962UppAi
         +0i0TbUQD4gUwJaGY/yEUCY11OnTwC6m2c+bcS3tKWwkFEVEbN8gkwvHtkEHCnNT/l
         191M1/w/CGquQTt45NIubg7TFMWo75W66oFn5hQ+Y7glYHT3xBPE3D4EJQ2XYlLLjX
         R25SmPzjSn/NuNwKE8qRuBIjQwk7qamUz697Xcdl9NC6RRsVMcoOCXSJAdpFaF9P79
         rNxpxTh5ioL7Q==
Subject: Re: [PATCH net-next] net/mlx5: simplify the return expression of
 mlx5_esw_offloads_pair()
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Miller <davem@davemloft.net>, zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 23:24:16 -0800
In-Reply-To: <20201208.162518.612024256091904820.davem@davemloft.net>
References: <20201208135625.11872-1-zhengyongjun3@huawei.com>
         <20201208.162518.612024256091904820.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-08 at 16:25 -0800, David Miller wrote:
> From: Zheng Yongjun <zhengyongjun3@huawei.com>
> Date: Tue, 8 Dec 2020 21:56:25 +0800
> 
> > Simplify the return expression.
> > 
> > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> Applied.
> 

Hey Dave, it's great to have you back!

I still don't see this patch in net-next, i will take it to my tree
and submit it in my next pr.

Thanks,
Saeed.



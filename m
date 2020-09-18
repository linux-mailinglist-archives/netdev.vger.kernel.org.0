Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEDE270378
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgIRRng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRRng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:43:36 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EA5E21707;
        Fri, 18 Sep 2020 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600451015;
        bh=ntAJibKjZjceVsHkZnqQPsOnz+8GOgKGWmMUTDStI1E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CkCun1EIOwnX/QjKXTP5/sTnq/gTQPIHqqi/CInvJUuhin6TTpb6x/wDcwCj49IJ8
         ZJTZKMwxk3ANqbwxuAoPm1ZRxG4eiEmIZwgG7J++4PTBtygLoNAs5bD+r3H8pI5a1Z
         EcqPiIxZgsT3gz3v5w2jesbyUR1YL71Q+QArlAN8=
Message-ID: <f7209360006203a0f93eb50962d7274f1226f0b6.camel@kernel.org>
Subject: Re: [PATCH net-next] net: hns3: Supply missing hclge_dcb.h include
 file
From:   Saeed Mahameed <saeed@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, kuba@kernel.org,
        tanhuazhong@huawei.com, liaoguojia@huawei.com,
        liuyonglong@huawei.com, linyunsheng@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 18 Sep 2020 10:43:34 -0700
In-Reply-To: <20200918130653.20064-1-wanghai38@huawei.com>
References: <20200918130653.20064-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-09-18 at 21:06 +0800, Wang Hai wrote:
> If the header file containing a function's prototype isn't included
> by
> the sourcefile containing the associated function, the build system
> complains of missing prototypes.
> 
> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c:453:6:
> warning: no previous prototype for ‘hclge_dcb_ops_set’ [-Wmissing-
> prototypes]
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>



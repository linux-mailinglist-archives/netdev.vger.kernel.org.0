Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9EF299A4D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404241AbgJZXRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404185AbgJZXRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:17:46 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D2E207F7;
        Mon, 26 Oct 2020 23:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603754266;
        bh=U/wIU2YMem/MeIDvQSzY3yk+i3x+N3W+1pbbwvqLGGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UbqsEJLm4qA0OAi1ZR3Q5IM2RJ639hqnmxdmi3JIlqZ+yDdhrcpPzOduukTHgLc2a
         CUPMtXAAJSg7D/qFPxKUQ0WspSIgN3LvAfPWAdpdiP1dO6+eXzda2XzLVmektjgewj
         Aj4Dt2lxheTmiStRERhN0i8aQ3gqPJdCcsjuOIgo=
Date:   Mon, 26 Oct 2020 16:17:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: hns3: clean up a return in hclge_tm_bp_setup()
Message-ID: <20201026161744.4235569d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023112212.GA282278@mwanda>
References: <20201023112212.GA282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 14:22:12 +0300 Dan Carpenter wrote:
> Smatch complains that "ret" might be uninitialized if we don't enter
> the loop.  We do always enter the loop so it's a false positive, but
> it's cleaner to just return a literal zero and that silences the
> warning as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!

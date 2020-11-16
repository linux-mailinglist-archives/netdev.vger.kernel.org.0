Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14CD2B4DF7
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbgKPRkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732674AbgKPRkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:40:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C78420B80;
        Mon, 16 Nov 2020 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605548442;
        bh=4Uv6elfOe4XJfv/8Y1N8ZGGETKRJd1j6WYW+lJKrf4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DHPelutlJKFzz4P9BebZ/+DPupryCD9L9zH+xvZI9Wzp0ae0CnvT6CJH0Wo1uVkMs
         4B8PknBQByRQ3abcVU89Kw5hbKSdo3yon+Fm23YYj8FVz1Lu37XulBgv0NKdwrP/3s
         ZxxVGP98JCALNSYv1zRNG26HDTjzk3PK3CXMYyWs=
Date:   Mon, 16 Nov 2020 09:40:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Fix usage counter leak by adding a general sync
 ops
Message-ID: <20201116094041.7b6c4bc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110092933.3342784-1-zhangqilong3@huawei.com>
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 17:29:31 +0800 Zhang Qilong wrote:
> In many case, we need to check return value of pm_runtime_get_sync,
> but it brings a trouble to the usage counter processing. Many callers
> forget to decrease the usage counter when it failed, which could
> resulted in reference leak. It has been discussed a lot[0][1]. So we
> add a function to deal with the usage counter for better coding and
> view. Then, we replace pm_runtime_resume_and_get with it in fec_main.c
> to avoid it.
> 
> [0]https://lkml.org/lkml/2020/6/14/88
> [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139

Actually, I lied, this is a fix so applying to net, not net-next.

Thanks!

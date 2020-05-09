Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406D41CBDB6
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgEIFXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgEIFXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:23:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5572520736;
        Sat,  9 May 2020 05:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589001796;
        bh=RSbOqMu+eqL6J620BIH5Sc7XFtiDqn2HZQGT/Z0Bl4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H1eAmi4qagPKePxt0qy4fgxAcCyzN2ySgPRRcay0ZTweuF1Cz0f+h4DZCcWqlsv2N
         Q/dbGhzctq0/ixGWNd6o3dzr5x+1UTDEYg5UX+MF5yXap8T0mmPsot11jwCVrAPgq+
         pby5gC3GBGyUEuKqHpDksRs82tkCvVDlmC54HO+Q=
Date:   Fri, 8 May 2020 22:23:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] octeontx2-vf: Fix error return code in
 otx2vf_probe()
Message-ID: <20200508222315.3b672eeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508021519.179062-1-weiyongjun1@huawei.com>
References: <20200508021519.179062-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 02:15:19 +0000 Wei Yongjun wrote:
> Fix to return negative error code -ENOMEM from the alloc failed error
> handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thank you!

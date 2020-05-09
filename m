Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863C01CBC24
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgEIBmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEIBmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 21:42:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6CD20870;
        Sat,  9 May 2020 01:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588988558;
        bh=n5SQZvuF7YRwTsQwjSW3h/DoktJeurAnCZHom1CsK7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e4WQlqVCoQG3Ybcu1q0pNmiNgXW9z4uMKPAW/hIjZWx1cb1ExeTGSSKaZkTQcKi+Q
         niSYGT7SDmaDqMe+A/16M/x+lGyV0s7Pz6+9crnMgOTWV9ObmBjMAaKQX86rp7WPyV
         YULStkm9RYWKS9nuRai/UL/N50V08g1UMpLL9AJs=
Date:   Fri, 8 May 2020 18:42:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Qiushi Wu <wu000273@umn.edu>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        <oss-drivers@netronome.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] nfp: abm: fix error return code in
 nfp_abm_vnic_alloc()
Message-ID: <20200508184236.6229f2b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508072735.61047-1-weiyongjun1@huawei.com>
References: <20200508072735.61047-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 07:27:35 +0000 Wei Yongjun wrote:
> Fix to return negative error code -ENOMEM from the kzalloc() error
> handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: 174ab544e3bc ("nfp: abm: add cls_u32 offload for simple band classification")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thanks!

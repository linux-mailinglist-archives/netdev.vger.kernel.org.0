Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9217F2AE5D3
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbgKKB3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:29:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKKB3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:29:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 838E8216C4;
        Wed, 11 Nov 2020 01:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605058140;
        bh=4MKgZPevQw6204NooKbrTQxLZCQVgljSMZsn2eWTacM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZaHteEFlRZshKm8XIsuMzv8eOk9qHMxu/wsC+CKrtoyhp6/e81zcoY/FHrlfUOZ0
         yMshx8lf+NYtKMaT6Ojk6UgBzG6BAAzAwkslERnh8xlVXmv/fJgFdL2psoucvpUKfS
         lOliyQuYDInuOa5c8zA+NETtf16OBYKdkj3+ITls=
Date:   Tue, 10 Nov 2020 17:28:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V2 net-next 11/11] net: hns3: add debugfs support for
 interrupt coalesce
Message-ID: <20201110172858.5eddc276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604892159-19990-12-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
        <1604892159-19990-12-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:22:39 +0800 Huazhong Tan wrote:
> Since user may need to check the current configuration of the
> interrupt coalesce, so add debugfs support for query this info,
> which includes DIM profile, coalesce configuration of both software
> and hardware.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Please create a file per vector so that users can just read it instead
of dumping the info into the logs.

Even better we should put as much of this information as possible into
the ethtool API. dim state is hardly hardware-specific.

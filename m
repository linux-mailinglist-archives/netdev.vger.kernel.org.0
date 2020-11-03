Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897522A39F6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgKCBgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbgKCBgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:36:45 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D08206CA;
        Tue,  3 Nov 2020 01:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604367404;
        bh=Ha/FAv4vk3Ruxnbed9oZ1bK1/SyMpdc8DFWKgCiXDUw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IhgBYh7qh85/bsqxngoKCKD8fr0wxvWxigZTal9wUBhJMBi2R6fSR1o5jf63BQiIL
         L4rIvT9KGacsaXnCzphVPhw6KuS1K04B8fweKr8ODPdX0xFB7ZEuyz6bwrQWOb+LkN
         xWGAXOvIhybZtY1aygiPcMk1b/PRYyAd4YrtI/Fw=
Date:   Mon, 2 Nov 2020 17:36:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <linyunsheng@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: hns3: Remove duplicated include
Message-ID: <20201102173644.6b4fe422@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031024940.29716-1-yuehaibing@huawei.com>
References: <20201031024940.29716-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 10:49:40 +0800 YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks!

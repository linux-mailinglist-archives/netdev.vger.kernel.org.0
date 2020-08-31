Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91154258173
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgHaS7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgHaS7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:59:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8277C206FA;
        Mon, 31 Aug 2020 18:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598900370;
        bh=tZ+ratlhDoEvROEiPnk37lhwCGzc/2EESC2XmRrEDgE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hEOs542aHZn07ho2JgMu0BpjwwVC5Gy1ZX6W7LGjT9uRQ4WmF0dhZ91F9Nh4Hd4l9
         9v5lQrK/vvPKaL7k9nh37N0i2PWnrX82zYYj5RmoCNYdvcn5qsQl07WbifEjzsj5TV
         fDw3wBURO6yHvRE3gXICTnpfEWqZXUur+crgZ4C4=
Date:   Mon, 31 Aug 2020 11:59:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v3 2/3] hinic: add support to query rq info
Message-ID: <20200831115929.6646e680@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200829005520.27364-3-luobin9@huawei.com>
References: <20200829005520.27364-1-luobin9@huawei.com>
        <20200829005520.27364-3-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Aug 2020 08:55:19 +0800 Luo bin wrote:
> add debugfs node for querying rq info, for example:
> cat /sys/kernel/debug/hinic/0000:15:00.0/RQs/0x0/rq_hw_pi
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

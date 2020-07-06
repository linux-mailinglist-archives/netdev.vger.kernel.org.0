Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE73215C65
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgGFQ6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgGFQ6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 12:58:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD0220702;
        Mon,  6 Jul 2020 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594054680;
        bh=GEufiPLHL4Nbly1lFuGDh/rrlW5QF5QlEhBoJCGKZFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BeiZPfbQ50ORdx2w+4fNMZwRFQlWzivGquRkh1WpaxX14+4JQikNxziZ0wPFoyhoe
         UBoN3Mu8WqrowhpyX7jSiI2hFM52I+iza44p5eeAlEPc8WGQMwqjx7EIjBYNEC3KvX
         2j5rhZwDy7rdkylpjlqiWIPr2uRNWq3WsUX7+VUo=
Date:   Mon, 6 Jul 2020 09:57:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next] hinic: add firmware update support
Message-ID: <20200706095758.713a069a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200706145406.7742-1-luobin9@huawei.com>
References: <20200706145406.7742-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 22:54:06 +0800 Luo bin wrote:
> add support to update firmware with with "ethtool -f" cmd
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:1996:44: warning: missing braces around initializer
drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:1996:44: warning: missing braces around initializer

But really - please try to implement the devlink flashing API, using
ethtool for this is deprecated.

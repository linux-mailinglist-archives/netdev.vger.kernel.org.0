Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE01EDB80
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgFDDBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgFDDBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 23:01:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C9B8206C3;
        Thu,  4 Jun 2020 03:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591239707;
        bh=l4cGGOeQtX576EdkeXJ3SBIP9oSotpU6JYE4NkWSboo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fqZW2+BxmxhBH0SiAs7rfIX4Vs/xdbBeWAKHX1/JBtoZEDXq3NWr7VMLcLTmmLxeU
         2uVrT+D9hbOUpcIkWoMW+z5jOhcMxO2IVZ2Jh14LBp+48JtfufiyxdXRiPGYwBUU8y
         qAbs3TXuegSpgTVE7+mQ0YZ1MxWbZSEblVH7tB8s=
Date:   Wed, 3 Jun 2020 20:01:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <chiqijun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next 5/5] hinic: add support to get eeprom
 information
Message-ID: <20200603200145.41cf76fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200603062015.12640-6-luobin9@huawei.com>
References: <20200603062015.12640-1-luobin9@huawei.com>
        <20200603062015.12640-6-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jun 2020 14:20:15 +0800 Luo bin wrote:
> add support to get eeprom information from the plug-in module
> with ethtool -m cmd.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

drivers/net/ethernet/huawei/hinic/hinic_port.c:1386:5: warning: variable port_id set but not used [-Wunused-but-set-variable]
 1386 |  u8 port_id;
      |     ^~~~~~~

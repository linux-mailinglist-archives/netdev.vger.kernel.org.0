Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76372066B2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387982AbgFWV4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387455AbgFWV4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:56:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C792078E;
        Tue, 23 Jun 2020 21:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592949405;
        bh=iDdA48vspDLWJxCVZ0YB/g7BHH6fOiCWKMtXosvEw5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tPWbHZp/vnKbHPd2qr7EcqsZtjp9rPQ+GQfEfaEX5M0B2HFvsdtHxTXSTF+vLwQ/W
         7/G21VeNvwrzHThDlfJxehIqtZWr0qX0m78i8hxOx+KSp2BbRqlB8f2NYA/lIixQiS
         xUmZYw6ACLaFK1G9B8HTe7e81HlD3NpBj1PAmoBE=
Date:   Tue, 23 Jun 2020 14:56:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v2 2/5] hinic: add support to set and get irq
 coalesce
Message-ID: <20200623145643.0df35c48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623142409.19081-3-luobin9@huawei.com>
References: <20200623142409.19081-1-luobin9@huawei.com>
        <20200623142409.19081-3-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 22:24:06 +0800 Luo bin wrote:
> add support to set TX/RX irq coalesce params with ethtool -C and
> get these params with ethtool -c.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

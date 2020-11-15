Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD15A2B3198
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKOAZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgKOAZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:25:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E646F24073;
        Sun, 15 Nov 2020 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605399921;
        bh=4YtwiFMAKU7O5n0zitIAD2AbBo6E1Z6S8SKrGFCC5Bg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nbz5Es695NhLdX1qEW+EPh+JZZcnRgTajh+Nfkq3uZrbT9eOi9JoloKp3fxl8emS6
         B0vrCvFr1QMsZ8ZFYbNQvB//LT+SsaU6zAzgCIm14rVkpgnrtYE3QQsjl+0IUFodMj
         aimQh1AJ1TrPKLhzwkVzeP6LTO50kQlX0ReIhflc=
Date:   Sat, 14 Nov 2020 16:25:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <jiri@nvidia.com>, <davem@davemloft.net>, <idosch@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net] devlink: Add missing genlmsg_cancel() in
 devlink_nl_sb_port_pool_fill()
Message-ID: <20201114162520.594e58b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113111622.11040-1-wanghai38@huawei.com>
References: <20201113111622.11040-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 19:16:22 +0800 Wang Hai wrote:
> If sb_occ_port_pool_get() failed in devlink_nl_sb_port_pool_fill(),
> msg should be canceled by genlmsg_cancel().
> 
> Fixes: df38dafd2559 ("devlink: implement shared buffer occupancy monitoring interface")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied, thanks!

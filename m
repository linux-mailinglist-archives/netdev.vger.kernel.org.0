Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0658B2CFF8A
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 23:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgLEWfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 17:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEWfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 17:35:20 -0500
Date:   Sat, 5 Dec 2020 14:34:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607207680;
        bh=cMgJ5FN4yoxLMb7kikcjkva9GbT8haiAgzoG3+ezn8Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=fnGchznoa4sX0dD4vrAJT80RD++JmFEZjOPbDmnN97fen+bfpd9qsLcwwCPZrWp59
         YplD++KkSVxZMVa4tOpWRDKf6gXt4dP2l80EX4/hPlb0uH43r1YEKL3p948f/ukIl9
         2ibnBK7GXMozDGK9YQsnGIfxTyvXyxULRG/uJb1yH+YhuF4/8k89XKxPzoG53LFCrf
         YQMWarxaMqOYwVRkvulI7O9iFyuwyJfrQLPiWAmgH5QwkzwLSYipaYs7E6iPEU5dhd
         4UROZLNdpkLRaa7jPSEFVk9bEIBjXhEjmrywx5n0PjVlyuN4YT57dompUp2hWWpbU5
         VIIFJ3ydApdmw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: marvell: prestera: Fix error return code in
 prestera_port_create()
Message-ID: <20201205143439.3b3eb07f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1607071782-34006-1-git-send-email-zhangchangzhong@huawei.com>
References: <1607071782-34006-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 16:49:42 +0800 Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied, thanks!

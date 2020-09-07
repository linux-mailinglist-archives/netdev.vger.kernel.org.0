Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046442605C0
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 22:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgIGUjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 16:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgIGUjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 16:39:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EBDD21582;
        Mon,  7 Sep 2020 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599511145;
        bh=3mw0JYdczY6laRRrjKNsKqCHxTGTnBzH+AYqiYoKJTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QbKRTN23fD/j+mjVvouurhXNoa2igmJq1fOYjF8ZC3zq6z2BEAD2YdYIab9Qu7P0y
         PSfMAnZZDD2pnBrKQqbKhQngJKyIOK4yNu0cuxAW1g07oGSg44CTwDJ2y0ywZsXZel
         /z5XwUg5kZFUsxiQqq+8LP5ljAnzPDWcZsWnmguU=
Date:   Mon, 7 Sep 2020 13:39:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ethernet: fec: remove redundant null
 check before clk_disable_unprepare()
Message-ID: <20200907133904.4672abf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM8PR04MB731542047A051973B74BBAD4FF280@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <1599482984-42783-1-git-send-email-zhangchangzhong@huawei.com>
        <AM8PR04MB731542047A051973B74BBAD4FF280@AM8PR04MB7315.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 13:14:50 +0000 Andy Duan wrote:
> From: Zhang Changzhong <zhangchangzhong@huawei.com> Sent: Monday, September 7, 2020 8:50 PM
> > Because clk_prepare_enable() and clk_disable_unprepare() already checked
> > NULL clock parameter, so the additional checks are unnecessary, just remove
> > them.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>  
> 
> Acked-by: Fugang Duan <fugang.duan@nxp.com>

Applied, thanks!

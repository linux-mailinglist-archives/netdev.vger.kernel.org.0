Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB8EAB8F7
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392897AbfIFNLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:11:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389315AbfIFNLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:11:43 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA487152F692C;
        Fri,  6 Sep 2019 06:11:41 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:11:40 +0200 (CEST)
Message-Id: <20190906.151140.1592399122729083359.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Do not check Link status when
 loopback is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7db46f6b1318ec22d45f7e6f6f907eda015a9df6.1567683751.git.joabreu@synopsys.com>
References: <7db46f6b1318ec22d45f7e6f6f907eda015a9df6.1567683751.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:11:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Thu,  5 Sep 2019 13:43:10 +0200

> While running stmmac selftests I found that in my 1G setup some tests
> were failling when running with PHY loopback enabled.
> 
> It looks like when loopback is enabled the PHY will report that Link is
> down even though there is a valid connection.
> 
> As in loopback mode the data will not be sent anywhere we can bypass the
> logic of checking if Link is valid thus saving unecessary reads.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied to net-next.

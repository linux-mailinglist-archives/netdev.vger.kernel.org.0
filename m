Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7424D182946
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbgCLGpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:45:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387767AbgCLGpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:45:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F392014DD553C;
        Wed, 11 Mar 2020 23:45:30 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:45:30 -0700 (PDT)
Message-Id: <20200311.234530.105958086242766446.davem@davemloft.net>
To:     darell.tan@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH] net: phy: Fix marvell_set_downshift() from clobbering
 MSCR register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311224138.1b98ca46f948789a0eec7ecf@gmail.com>
References: <20200311224138.1b98ca46f948789a0eec7ecf@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:45:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Darell Tan <darell.tan@gmail.com>
Date: Wed, 11 Mar 2020 22:41:38 +0800

> Fix marvell_set_downshift() from clobbering MSCR register.
> 
> A typo in marvell_set_downshift() clobbers the MSCR register. This
> register also shares settings with the auto MDI-X detection, set by
> marvell_set_polarity(). In the 1116R init, downshift is set after
> polarity, causing the polarity settings to be clobbered.
> 
> This bug is present on the 5.4 series and was introduced in commit
> 6ef05eb73c8f ("net: phy: marvell: Refactor setting downshift into a
> helper"). This patch need not be forward-ported to 5.5 because the
> functions were rewritten.
> 
> Signed-off-by: Darell Tan <darell.tan@gmail.com>

I don't see marvell_set_downshift() in 'net' nor 'net-next'.

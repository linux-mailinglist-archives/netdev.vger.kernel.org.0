Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2843F12F243
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgACAi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:38:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:38:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D10611579F3F0;
        Thu,  2 Jan 2020 16:38:56 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:38:56 -0800 (PST)
Message-Id: <20200102.163856.1282537268610354575.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, Chris.Healy@zii.aero
Subject: Re: [PATCH net] net: freescale: fec: Fix ethtool -d runtime PM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102143334.27613-1-andrew@lunn.ch>
References: <20200102143334.27613-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:38:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu,  2 Jan 2020 15:33:34 +0100

> In order to dump the FECs registers the clocks have to be ticking,
> otherwise a data abort occurs.  Add calls to runtime PM so they are
> enabled and later disabled.
> 
> Fixes: e8fcfcd5684a ("net: fec: optimize the clock management to save power")
> Reported-by: Chris Healy <Chris.Healy@zii.aero>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied and queued up for -stable, thanks.

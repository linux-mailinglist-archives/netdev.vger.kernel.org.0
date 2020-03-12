Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1D182970
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbgCLHCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:02:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387845AbgCLHCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 03:02:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B55D14E226C1;
        Thu, 12 Mar 2020 00:02:50 -0700 (PDT)
Date:   Thu, 12 Mar 2020 00:02:49 -0700 (PDT)
Message-Id: <20200312.000249.2295354091870642301.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        Chris.Healy@zii.aero
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Add missing mask of ATU
 occupancy register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311200231.25937-1-andrew@lunn.ch>
References: <20200311200231.25937-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 00:02:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 11 Mar 2020 21:02:31 +0100

> Only the bottom 12 bits contain the ATU bin occupancy statistics. The
> upper bits need masking off.
> 
> Fixes: e0c69ca7dfbb ("net: dsa: mv88e6xxx: Add ATU occupancy via devlink resources")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied and queued up for -stable, thanks.

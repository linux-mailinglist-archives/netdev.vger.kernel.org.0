Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309A6172973
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgB0UaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:30:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0UaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:30:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72801121A82FA;
        Thu, 27 Feb 2020 12:30:02 -0800 (PST)
Date:   Thu, 27 Feb 2020 12:30:01 -0800 (PST)
Message-Id: <20200227.123001.1787370504567508304.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        Chris.Healy@zii.aero, Kevin.Benson@zii.aero
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Fix masking of egress port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227202049.29895-1-andrew@lunn.ch>
References: <20200227202049.29895-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 12:30:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 27 Feb 2020 21:20:49 +0100

> Add missing ~ to the usage of the mask.
> 
> Reported-by: Kevin Benson <Kevin.Benson@zii.aero>
> Reported-by: Chris Healy <Chris.Healy@zii.aero>
> Fixes: 5c74c54ce6ff ("net: dsa: mv88e6xxx: Split monitor port configuration")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.

Please put the Fixes: tag first in the list of tags in the future.

Thank you.

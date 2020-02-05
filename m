Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B61532B6
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 15:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgBEOUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 09:20:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgBEOUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 09:20:31 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7823158F78D0;
        Wed,  5 Feb 2020 06:20:30 -0800 (PST)
Date:   Wed, 05 Feb 2020 15:20:29 +0100 (CET)
Message-Id: <20200205.152029.1630456541275741568.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net 1/1] qed: Fix timestamping issue for L2 unicast ptp
 packets.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200205131055.17227-1-skalluru@marvell.com>
References: <20200205131055.17227-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 06:20:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Wed, 5 Feb 2020 05:10:55 -0800

> commit cedeac9df4b8 ("qed: Add support for Timestamping the unicast
> PTP packets.") handles the timestamping of L4 ptp packets only.
> This patch adds driver changes to detect/timestamp both L2/L4 unicast
> PTP packets.
> 
> Fixes: cedeac9df4b8 ("qed: Add support for Timestamping the unicast PTP packets.")
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

Applied and queued up for -stable, thanks.

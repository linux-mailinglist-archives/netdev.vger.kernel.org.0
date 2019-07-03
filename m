Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439B15EBA1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfGCSbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:31:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCSbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:31:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B49AC140C2FAB;
        Wed,  3 Jul 2019 11:31:08 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:31:08 -0700 (PDT)
Message-Id: <20190703.113108.512282943191543247.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next v2 1/1] qed: Add support for Timestamping the
 unicast PTP packets.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703060159.14121-1-skalluru@marvell.com>
References: <20190703060159.14121-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 11:31:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Tue, 2 Jul 2019 23:01:59 -0700

> This patch adds driver changes to detect/timestamp the unicast PTP packets.
> 
> Changes from previous version:
> -------------------------------
> v2: Defined a macro for unicast ptp param mask.
> 
> Please consider applying this to "net-next".
> 
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

Applied.

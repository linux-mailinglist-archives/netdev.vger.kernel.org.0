Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86F0A964E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfIDWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:25:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38676 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfIDWZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:25:28 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2D2F15285FEA;
        Wed,  4 Sep 2019 15:25:26 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:25:25 -0700 (PDT)
Message-Id: <20190904.152525.1791232543096824275.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v2 0/3] dpaa2-eth: Add new statistics counters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567419799-28179-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567419799-28179-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:25:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Mon,  2 Sep 2019 13:23:16 +0300

> Recent firmware versions offer access to more DPNI statistics
> counters. Add the relevant ones to ethtool interface stats.
> 
> Also we can now make use of a new counter for in flight egress frames
> to avoid sleeping an arbitrary amount of time in the ndo_stop routine.
> 
> v2: in patch 2/3, treat separately the error case for unsupported
> statistics pages

Series applied.

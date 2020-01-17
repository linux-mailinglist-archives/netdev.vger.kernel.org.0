Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5C2140872
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgAQKzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:55:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgAQKzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:55:13 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE7D4155CB1ED;
        Fri, 17 Jan 2020 02:49:03 -0800 (PST)
Date:   Fri, 17 Jan 2020 02:49:02 -0800 (PST)
Message-Id: <20200117.024902.278925400277491068.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com, po.liu@nxp.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] enetc: Don't print from enetc_sched_speed_set
 when link goes down
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116171828.2016-1-olteanv@gmail.com>
References: <20200116171828.2016-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 02:49:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 16 Jan 2020 19:18:28 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It is not an error to unplug a cable from the ENETC port even with TSN
> offloads, so don't spam the log with link-related messages from the
> tc-taprio offload subsystem, a single notification is sufficient:
> 
> [10972.351859] fsl_enetc 0000:00:00.0 eno0: Qbv PSPEED set speed link down.
> [10972.360241] fsl_enetc 0000:00:00.0 eno0: Link is Down
> 
> Fixes: 2e47cb415f0a ("enetc: update TSN Qbv PSPEED set according to adjust link speed")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.

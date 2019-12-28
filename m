Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0875212BEBF
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 20:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfL1ToA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 14:44:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfL1Tn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 14:43:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DEAF515461727;
        Sat, 28 Dec 2019 11:43:58 -0800 (PST)
Date:   Sat, 28 Dec 2019 11:43:58 -0800 (PST)
Message-Id: <20191228.114358.301966090114483227.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, richardcochran@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        claudiu.manoil@nxp.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net 0/2] The DSA TX timestamping situation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191228133046.9406-1-olteanv@gmail.com>
References: <20191228133046.9406-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 28 Dec 2019 11:43:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 28 Dec 2019 15:30:44 +0200

> This series is the moral v2 of "[PATCH net] net: dsa: sja1105: Fix
> double delivery of TX timestamps to socket error queue" [0] which did
> not manage to convince public opinion (actually it didn't convince me
> neither).
> 
> This fixes PTP timestamping on one particular board, where the DSA
> switch is sja1105 and the master is gianfar. Unfortunately there is no
> way to make the fix more general without committing logical
> inaccuracies: the SKBTX_IN_PROGRESS flag does serve a purpose, even if
> the sja1105 driver is not using it now: it prevents delivering a SW
> timestamp to the app socket when the HW timestamp will be provided. So
> not setting this flag (the approach from v1) might create avoidable
> complications in the future (not to mention that there isn't any
> satisfactory explanation on why that would be the correct solution).
> 
> So the goal of this change set is to create a more strict framework for
> DSA master devices when attached to PTP switches, and to fix the first
> master driver that is overstepping its duties and is delivering
> unsolicited TX timestamps.
> 
> [0]: https://www.spinics.net/lists/netdev/msg619699.html

Series applied, thank you.

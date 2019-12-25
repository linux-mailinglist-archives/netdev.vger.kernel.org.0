Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1298112A500
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfLYAFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:05:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfLYAFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:05:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35686154B95FD;
        Tue, 24 Dec 2019 16:05:00 -0800 (PST)
Date:   Tue, 24 Dec 2019 16:04:59 -0800 (PST)
Message-Id: <20191224.160459.513700743670795651.davem@davemloft.net>
To:     timofey.babitskiy@pendulum-instruments.com
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Subject: Re: [PATCH] stmmac: export RX mitigation control to device tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <AM6PR0702MB3639888440F0AC658E31FE25DF2D0@AM6PR0702MB3639.eurprd07.prod.outlook.com>
References: <AM6PR0702MB3639888440F0AC658E31FE25DF2D0@AM6PR0702MB3639.eurprd07.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 16:05:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Timofey Babitskiy <timofey.babitskiy@pendulum-instruments.com>
Date: Fri, 20 Dec 2019 12:56:50 +0000

> Having Rx mitigation via HW watchdog timer on is not suitable for time 
> servers distributing time via NTP and PTP protocol and relying on SW 
> timestamping, because Rx mitigation adds latency on receive and hence adds 
> path delay assymetry, which leads to time offset on timing clients. Turning 
> Rx mitigation off via platform config is not always a good option, because 
> some systems use default platform configs and only tune the device tree.
> 
> Signed-off-by: Timofey Babitskiy <timofey.babitskiy@pendulum-instruments.com>

The device tree is not an appropriate place to control what is already settable
via ethtool.

Make the appropriate ethtool setting on your NTP servers.

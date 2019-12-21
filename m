Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30ED128755
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfLUFTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:19:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:19:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0107F153CB382;
        Fri, 20 Dec 2019 21:19:47 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:19:47 -0800 (PST)
Message-Id: <20191220.211947.847462480497514150.davem@davemloft.net>
To:     alexchan@task.com.hk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] llc2: Fix return statement of
 llc_stat_ev_rx_null_dsap_xid_c (and _test_c)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576736179-7129-1-git-send-email-alexchan@task.com.hk>
References: <1576736179-7129-1-git-send-email-alexchan@task.com.hk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:19:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chan Shu Tak, Alex" <alexchan@task.com.hk>
Date: Thu, 19 Dec 2019 14:16:18 +0800

> From: "Chan Shu Tak, Alex" <alexchan@task.com.hk>
> 
> When a frame with NULL DSAP is received, llc_station_rcv is called.
> In turn, llc_stat_ev_rx_null_dsap_xid_c is called to check if it is a NULL
> XID frame. The return statement of llc_stat_ev_rx_null_dsap_xid_c returns 1
> when the incoming frame is not a NULL XID frame and 0 otherwise. Hence, a
> NULL XID response is returned unexpectedly, e.g. when the incoming frame is
> a NULL TEST command.
> 
> To fix the error, simply remove the conditional operator.
> 
> A similar error in llc_stat_ev_rx_null_dsap_test_c is also fixed.
> 
> Signed-off-by: Chan Shu Tak, Alex <alexchan@task.com.hk>

Applied.

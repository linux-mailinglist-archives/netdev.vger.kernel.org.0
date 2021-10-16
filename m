Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5F2430111
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbhJPIFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbhJPIFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 04:05:44 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BDCC061570
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 01:03:19 -0700 (PDT)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 81A0B4FFA3116;
        Sat, 16 Oct 2021 01:03:13 -0700 (PDT)
Date:   Sat, 16 Oct 2021 09:03:12 +0100 (BST)
Message-Id: <20211016.090312.864899799732614331.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/11] net/smc: introduce SMC-Rv2 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211014164752.3647027-1-kgraul@linux.ibm.com>
References: <20211014164752.3647027-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 16 Oct 2021 01:03:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Thu, 14 Oct 2021 18:47:41 +0200

> Please apply the following patch series for smc to netdev's net-next tree.
> 
> SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
> provides routable RoCE support for SMC-R, eliminating the current
> same-subnet restriction, by exploiting the UDP encapsulation feature
> of the RoCE adapter hardware.
> 
> Patch 1 ("net/smc: improved fix wait on already cleared link") is
> already applied on netdevs net tree but its changes are needed for
> this series on net-next. The patch is unchanged compared to the
> version on the net tree.
> 
> v2: resend of the v1 patch series, and CC linux-rdma this time

This does not apply cleanly to net-next, please respin.

Thank you.


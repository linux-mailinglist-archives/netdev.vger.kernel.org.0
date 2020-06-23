Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2884B2066DE
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388541AbgFWWET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387729AbgFWWES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:04:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790D4C061573;
        Tue, 23 Jun 2020 15:04:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03DC21294A15F;
        Tue, 23 Jun 2020 15:04:15 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:04:15 -0700 (PDT)
Message-Id: <20200623.150415.2264361246716668163.davem@davemloft.net>
To:     standby24x7@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        idosch@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH net-next] mlxsw: spectrum_dcb: Fix a spelling typo in
 spectrum_dcb.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623141301.168413-1-standby24x7@gmail.com>
References: <20200623141301.168413-1-standby24x7@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 15:04:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Tue, 23 Jun 2020 23:13:01 +0900

> This patch fixes a spelling typo in spectrum_dcb.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied, thank you.

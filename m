Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1050160967
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBQECD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 23:02:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgBQECC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 23:02:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FF5B1584BBE6;
        Sun, 16 Feb 2020 20:02:02 -0800 (PST)
Date:   Sun, 16 Feb 2020 20:02:01 -0800 (PST)
Message-Id: <20200216.200201.2244771423571479928.davem@davemloft.net>
To:     paul@crapouillou.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, malat@debian.org
Subject: Re: [PATCH] net: ethernet: dm9000: Handle -EPROBE_DEFER in
 dm9000_parse_dt()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200216193943.81134-1-paul@crapouillou.net>
References: <20200216193943.81134-1-paul@crapouillou.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 20:02:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>
Date: Sun, 16 Feb 2020 16:39:43 -0300

> The call to of_get_mac_address() can return -EPROBE_DEFER, for instance
> when the MAC address is read from a NVMEM driver that did not probe yet.
> 
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Mathieu Malaterre <malat@debian.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Applied.

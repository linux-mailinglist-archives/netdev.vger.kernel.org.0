Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC816096C
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBQEE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 23:04:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQEE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 23:04:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3D6A1584D826;
        Sun, 16 Feb 2020 20:04:57 -0800 (PST)
Date:   Sun, 16 Feb 2020 20:04:57 -0800 (PST)
Message-Id: <20200216.200457.998100759872108395.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net-next 0/5] add xdp ethtool stats to mvneta driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1581886691.git.lorenzo@kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 20:04:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 16 Feb 2020 22:07:28 +0100

> Rework mvneta stats accounting in order to introduce xdp ethtool
> statistics in the mvneta driver.
> Introduce xdp_redirect, xdp_pass, xdp_drop and xdp_tx counters to
> ethtool statistics.
> Fix skb_alloc_error and refill_error ethtool accounting

Series applied, thanks Lorenzo.

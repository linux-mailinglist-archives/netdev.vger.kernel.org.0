Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD08F104554
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKTUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:42:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKTUmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:42:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7358F14C25D03;
        Wed, 20 Nov 2019 12:42:39 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:42:38 -0800 (PST)
Message-Id: <20191120.124238.1949786507862615153.davem@davemloft.net>
To:     wahrenst@gmx.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: qca_spi: Fix receive and reset issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574270953-4119-1-git-send-email-wahrenst@gmx.net>
References: <1574270953-4119-1-git-send-email-wahrenst@gmx.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:42:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>
Date: Wed, 20 Nov 2019 18:29:11 +0100

> This small patch series fixes two major issues in the SPI driver for the
> QCA700x.
> 
> It has been tested on a Charge Control C 300 (NXP i.MX6ULL +
> 2x QCA7000).

Series applied, thanks.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A28A77D38
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 04:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfG1CN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 22:13:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfG1CN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 22:13:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D9F4126598DB;
        Sat, 27 Jul 2019 19:13:29 -0700 (PDT)
Date:   Sat, 27 Jul 2019 19:13:28 -0700 (PDT)
Message-Id: <20190727.191328.1351271863559760336.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next v3 0/2] qed*: Support for NVM config
 attributes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190728015549.27051-1-skalluru@marvell.com>
References: <20190728015549.27051-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 19:13:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Sat, 27 Jul 2019 18:55:47 -0700

> The patch series adds support for managing the NVM config attributes.
> Patch (1) adds functionality to update config attributes via MFW.
> Patch (2) adds driver interface for updating the config attributes.
> 
> Changes from previous versions:
> -------------------------------
> v3: Removed unused variable.
> v2: Removed unused API.
> 
> Please consider applying this series to "net-next".

I don't see where an existing ethtool method hooks into and calls this
new NVM code.

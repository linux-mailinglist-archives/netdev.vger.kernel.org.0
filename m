Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB32A4634
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfHaUcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:32:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbfHaUco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:32:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C396136D7632;
        Sat, 31 Aug 2019 13:32:44 -0700 (PDT)
Date:   Sat, 31 Aug 2019 13:32:43 -0700 (PDT)
Message-Id: <20190831.133243.954936321376279219.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next 0/4] qed*: Enhancements.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830074206.8836-1-skalluru@marvell.com>
References: <20190830074206.8836-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 13:32:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Fri, 30 Aug 2019 00:42:02 -0700

> The patch series adds couple of enhancements to qed/qede drivers.
>   - Support for dumping the config id attributes via ethtool -w/W.
>   - Support for dumping the GRC data of required memory regions using
>     ethtool -w/W interfaces.
> 
> Patch (1) adds driver APIs for reading the config id attributes.
> Patch (2) adds ethtool support for dumping the config id attributes.
> Patch (3) adds support for configuring the GRC dump config flags.
> Patch (4) adds ethtool support for dumping the grc dump.
> 
> Please consider applying it to net-next.

Series applied, thanks.

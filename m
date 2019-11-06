Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5709AF0C01
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbfKFCZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:25:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:25:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15DA21510815B;
        Tue,  5 Nov 2019 18:25:29 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:25:28 -0800 (PST)
Message-Id: <20191105.182528.1180883121697431560.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, manishc@marvell.com,
        mrangankar@marvell.com, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next 0/4] bnx2x/cnic: Enable Multi-Cos.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105055112.30005-1-skalluru@marvell.com>
References: <20191105055112.30005-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:25:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Mon, 4 Nov 2019 21:51:08 -0800

> The patch series enables Multi-cos feature in the driver. This require
> the use of new firmware 7.13.15.0.
> Patch (1) adds driver changes to use new FW.
> Patches (2) - (3) enables multi-cos functionality in bnx2x driver.
> Patch (4) adds cnic driver change as required by new FW.

Series applied, thanks.

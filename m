Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98659EE826
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfKDTTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:19:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbfKDTTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:19:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53E03151D3D7E;
        Mon,  4 Nov 2019 11:19:43 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:19:42 -0800 (PST)
Message-Id: <20191104.111942.674044184836510706.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     jack.ping.chng@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andriy.shevchenko@intel.com, mallikarjunax.reddy@linux.intel.com,
        cheol.yong.kim@intel.com
Subject: Re: [PATCH v1] staging: intel-dpa: gswip: Introduce Gigabit
 Ethernet Switch (GSWIP) device driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104122009.GA2126921@kroah.com>
References: <03832ecb6a34876ef26a24910816f22694c0e325.1572863013.git.jack.ping.chng@intel.com>
        <20191104122009.GA2126921@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:19:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Mon, 4 Nov 2019 13:20:09 +0100

> Why is this being submitted to staging?  What is wrong with the "real"
> part of the kernel for this?

Agreed, this makes no sense at all.

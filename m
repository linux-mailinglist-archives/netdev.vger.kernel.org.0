Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F4013CFF4
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgAOWOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:14:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAOWOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:14:48 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F31F15A0F05B;
        Wed, 15 Jan 2020 14:14:47 -0800 (PST)
Date:   Wed, 15 Jan 2020 14:14:45 -0800 (PST)
Message-Id: <20200115.141445.255495210028622138.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com
Subject: Re: [PATCH] devlink: fix typos in qed documentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114200918.2753721-1-jacob.e.keller@intel.com>
References: <20200114200918.2753721-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 14:14:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 14 Jan 2020 12:09:18 -0800

> Review of the recently added documentation file for the qed driver
> noticed a couple of typos. Fix them now.
> 
> Noticed-by: Michal Kalderon <mkalderon@marvell.com>
> Fixes: 0f261c3ca09e ("devlink: add a driver-specific file for the qed driver")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied.

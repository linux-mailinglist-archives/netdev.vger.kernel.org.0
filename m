Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F697160830
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgBQCbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:31:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47782 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:31:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6DA61538018F;
        Sun, 16 Feb 2020 18:31:11 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:31:08 -0800 (PST)
Message-Id: <20200216.183108.2129802839620015841.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
Subject: Re: [PATCH] ptp_qoriq: drop the code of alarm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211045249.8150-1-yangbo.lu@nxp.com>
References: <20200211045249.8150-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:31:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Tue, 11 Feb 2020 12:52:49 +0800

> The alarm function hadn't been supported by PTP clock driver.
> The recommended solution PHC + phc2sys + nanosleep provides
> best performance. So drop the code of alarm in ptp_qoriq driver.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied to net-next.

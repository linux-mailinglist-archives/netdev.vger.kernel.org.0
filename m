Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9059170FB0
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgB0Ehs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:37:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgB0Ehr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:37:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6466715B478BB;
        Wed, 26 Feb 2020 20:37:47 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:37:46 -0800 (PST)
Message-Id: <20200226.203746.306950955659779532.davem@davemloft.net>
To:     yangerkun@huawei.com
Cc:     netdev@vger.kernel.org, maowenan@huawei.com
Subject: Re: [PATCH v2] slip: not call free_netdev before rtnl_unlock in
 slip_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226035435.76431-1-yangerkun@huawei.com>
References: <20200226035435.76431-1-yangerkun@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:37:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>
Date: Wed, 26 Feb 2020 11:54:35 +0800

> As the description before netdev_run_todo, we cannot call free_netdev
> before rtnl_unlock, fix it by reorder the code.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied and queued up for -stable, thank you.

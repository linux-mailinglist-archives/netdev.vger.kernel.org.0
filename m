Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8689183CD5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgCLWxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:53:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLWxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:53:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AF0015842925;
        Thu, 12 Mar 2020 15:53:22 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:53:21 -0700 (PDT)
Message-Id: <20200312.155321.1860923182739836747.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, andrew@lunn.ch, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] octeontx2-pf: unlock on error path in
 otx2_config_pause_frm()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312113048.GB20562@mwanda>
References: <20200312113048.GB20562@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:53:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 12 Mar 2020 14:30:48 +0300

> We need to unlock before returning if this allocation fails.
> 
> Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to net-next.

Dan, please indicate the appropriate target tree in your Subject lines
in the future.  I have to dance around my GIT trees to figure out where
your patches apply and that eats up more time than necessary.

Thanks.

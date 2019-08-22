Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DE79A392
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391001AbfHVXLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:11:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732372AbfHVXLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:11:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E12A1539AF01;
        Thu, 22 Aug 2019 16:11:47 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:11:47 -0700 (PDT)
Message-Id: <20190822.161147.1083816539940454278.davem@davemloft.net>
To:     wenwen@cs.uga.edu
Cc:     skalluru@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qed: Add cleanup in qed_slowpath_start()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566362796-5399-1-git-send-email-wenwen@cs.uga.edu>
References: <1566362796-5399-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:11:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Tue, 20 Aug 2019 23:46:36 -0500

> If qed_mcp_send_drv_version() fails, no cleanup is executed, leading to
> memory leaks. To fix this issue, introduce the label 'err4' to perform the
> cleanup work before returning the error.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Applied.

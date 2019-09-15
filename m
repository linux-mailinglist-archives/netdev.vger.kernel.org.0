Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9798B3184
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfIOS4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:56:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40122 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfIOS4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:56:36 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8E02153ECDAF;
        Sun, 15 Sep 2019 11:56:34 -0700 (PDT)
Date:   Sun, 15 Sep 2019 19:56:33 +0100 (WEST)
Message-Id: <20190915.195633.37793800195155580.davem@davemloft.net>
To:     gerd.rausch@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH net] net/rds: Fix 'ib_evt_handler_call' element in
 'rds_ib_stat_names'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <914b48be-2373-5b38-83f5-e0d917dd139d@oracle.com>
References: <914b48be-2373-5b38-83f5-e0d917dd139d@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 11:56:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>
Date: Thu, 12 Sep 2019 13:49:41 -0700 (PDT)

> All entries in 'rds_ib_stat_names' are stringified versions
> of the corresponding "struct rds_ib_statistics" element
> without the "s_"-prefix.
> 
> Fix entry 'ib_evt_handler_call' to do the same.
> 
> Fixes: f4f943c958a2 ("RDS: IB: ack more receive completions to improve performance")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>

Applied, thanks.

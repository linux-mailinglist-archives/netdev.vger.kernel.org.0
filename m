Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C246C9F917
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfH1EIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:08:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfH1EI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:08:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D716153BB5B3;
        Tue, 27 Aug 2019 21:08:29 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:08:28 -0700 (PDT)
Message-Id: <20190827.210828.896795378408545710.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net] net/rds: Fix info leak in rds6_inc_info_copy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566812352-27332-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1566812352-27332-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 21:08:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Mon, 26 Aug 2019 02:39:12 -0700

> The rds6_inc_info_copy() function has a couple struct members which
> are leaking stack information.  The ->tos field should hold actual
> information and the ->flags field needs to be zeroed out.
> 
> Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
> Fixes: b7ff8b1036f0 ("rds: Extend RDS API for IPv6 support")
> Reported-by: 黄ID蝴蝶 <butterflyhuangxx@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Applied and queued up for -stable.

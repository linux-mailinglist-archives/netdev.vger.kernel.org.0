Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6191F8F412
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfHOTEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:04:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729407AbfHOTEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:04:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8596D13F45747;
        Thu, 15 Aug 2019 12:04:37 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:04:37 -0700 (PDT)
Message-Id: <20190815.120437.1520245379792336202.davem@davemloft.net>
To:     gerd.rausch@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next v2 0/4] net/rds: Fixes from internal Oracle
 repo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ee77e550-2231-be7f-861f-31d609631e9f@oracle.com>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
        <ee77e550-2231-be7f-861f-31d609631e9f@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:04:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>
Date: Thu, 15 Aug 2019 07:40:22 -0700

> This is the first set of (mostly old) patches from our internal repository
> in an effort to synchronize what Oracle had been using internally
> with what is shipped with the Linux kernel.

Series applied.

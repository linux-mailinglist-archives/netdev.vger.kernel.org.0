Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B2927D95D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgI2U5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgI2U5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:57:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A125C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 13:57:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23B221476E2BB;
        Tue, 29 Sep 2020 13:40:31 -0700 (PDT)
Date:   Tue, 29 Sep 2020 13:57:17 -0700 (PDT)
Message-Id: <20200929.135717.1474016123252953167.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, secdev@chelsio.com
Subject: Re: [net-next v3 0/3] cxgb4/ch_ktls: updates in net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929174425.12256-1-rohitm@chelsio.com>
References: <20200929174425.12256-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 13:40:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Tue, 29 Sep 2020 23:14:22 +0530

> This series of patches improves connections setup and statistics.
> 
> This series is broken down as follows:
> 
> Patch 1 fixes the handling of connection setup failure in HW. Driver
> shouldn't return success to tls_dev_add, until HW returns success.
> 
> Patch 2 avoids the log flood.
> 
> Patch 3 adds ktls statistics at port level.
> 
> v1->v2:
> - removed conn_up from all places.
> 
> v2->v3:
> - Corrected timeout handling.

Series applied, thank you.

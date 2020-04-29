Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE01BE755
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgD2T1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2T1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:27:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E993CC03C1AE;
        Wed, 29 Apr 2020 12:27:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5565C1210A3EF;
        Wed, 29 Apr 2020 12:27:21 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:27:20 -0700 (PDT)
Message-Id: <20200429.122720.1365020998978075421.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 00/13] net/smc: preparations for SMC-R link
 failover
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:27:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Wed, 29 Apr 2020 17:10:36 +0200

> This patch series prepares the SMC code for the implementation of SMC-R link 
> failover capabilities which are still missing to reach full compliance with 
> RFC 7609.
> The code changes are separated into 65 patches which together form the new
> functionality. I tried to create meaningful patches which allow to follow the 
> implementation.

Series applied.

> Question: how to handle the remaining 52 patches? All of them are needed for 
> link failover to work and should make it into the same merge window. 
> Can I send them all together?

No.

You must break these changes up into significantly smaller sized,
logical, group of changes.  That's part of your responsibility when
submitting changes, keeping the patch series small and reviewable.

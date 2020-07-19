Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5304B225486
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 00:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgGSWal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 18:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgGSWal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 18:30:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21636C0619D2;
        Sun, 19 Jul 2020 15:30:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36BE71281AB30;
        Sun, 19 Jul 2020 15:30:40 -0700 (PDT)
Date:   Sun, 19 Jul 2020 15:30:38 -0700 (PDT)
Message-Id: <20200719.153038.2294671622833273160.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net v2 00/10] net/smc: fixes 2020-07-16
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200718130618.16724-1-kgraul@linux.ibm.com>
References: <20200718130618.16724-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 15:30:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Sat, 18 Jul 2020 15:06:08 +0200

> Please apply the following patch series for smc to netdev's net tree.
> 
> The patches address problems caused by late or unexpected link layer
> control packets, dma sync calls for unmapped memory, freed buffers
> that are not removed from the buffer list and a possible null pointer
> access that results in a crash.
> 
> v1->v2: in patch 4, improve patch description and correct the comment
>         for the new mutex

Series applied, thanks.

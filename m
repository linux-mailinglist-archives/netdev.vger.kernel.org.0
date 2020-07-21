Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C01F227424
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGUAwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgGUAwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:52:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B13CC061794;
        Mon, 20 Jul 2020 17:52:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D12111E8EC2D;
        Mon, 20 Jul 2020 17:35:54 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:52:39 -0700 (PDT)
Message-Id: <20200720.175239.84496358252925760.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/2] net/smc: fixes 2020-07-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720142429.17916-1-kgraul@linux.ibm.com>
References: <20200720142429.17916-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:35:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Mon, 20 Jul 2020 16:24:27 +0200

> Please apply the following patch series for smc to netdev's net tree.
> 
> Patch 1 fixes a problem with a buffer that is not put back when the
> connection was killed in the meantime.
> Patch 2 fixes a wrong behaviour when the maximum dmb buffer count
> exceeded.

Series applied, thank you.

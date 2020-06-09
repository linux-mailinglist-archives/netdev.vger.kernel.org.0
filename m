Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF981F4759
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgFITns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgFITnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:43:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2F4C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 12:43:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E12412771EC3;
        Tue,  9 Jun 2020 12:43:47 -0700 (PDT)
Date:   Tue, 09 Jun 2020 12:43:46 -0700 (PDT)
Message-Id: <20200609.124346.1724934664118346472.davem@davemloft.net>
To:     valentin@longchamp.me
Cc:     netdev@vger.kernel.org, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com
Subject: Re: [PATCH v2 2/2] net: sched: make the watchdog functions more
 coherent
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609054351.21725-2-valentin@longchamp.me>
References: <20200609054351.21725-1-valentin@longchamp.me>
        <20200609054351.21725-2-valentin@longchamp.me>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 12:43:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is inappropriate to submit during the merge window as net-next is closed
and only bug fixes should be submitted at this time.

Your submission was perfect initially, just adding the necessary symbol export
to fix the ucc_geth build when modular.  Please don't tinker and add cleanups
for a bug fix like this.

Thank you.

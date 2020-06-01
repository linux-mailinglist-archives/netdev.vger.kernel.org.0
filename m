Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33801EADE5
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgFAStc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbgFASG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:06:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3125AC05BD43;
        Mon,  1 Jun 2020 11:06:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54BC8120477C4;
        Mon,  1 Jun 2020 11:06:55 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:06:54 -0700 (PDT)
Message-Id: <20200601.110654.1178868171436999333.davem@davemloft.net>
To:     patrickeigensatz@gmail.com
Cc:     dsahern@kernel.org, nikolay@cumulusnetworks.com,
        scan-admin@coverity.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: nexthop: Fix deadcode issue by performing a
 proper NULL check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
References: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:06:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: patrickeigensatz@gmail.com
Date: Mon,  1 Jun 2020 13:12:01 +0200

> From: Patrick Eigensatz <patrickeigensatz@gmail.com>
> 
> After allocating the spare nexthop group it should be tested for kzalloc()
> returning NULL, instead the already used nexthop group (which cannot be
> NULL at this point) had been tested so far.
> 
> Additionally, if kzalloc() fails, return ERR_PTR(-ENOMEM) instead of NULL.
> 
> Coverity-id: 1463885
> Reported-by: Coverity <scan-admin@coverity.com>
> Signed-off-by: Patrick Eigensatz <patrickeigensatz@gmail.com>

Applied, thank you.

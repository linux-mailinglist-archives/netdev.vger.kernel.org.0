Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C036A202889
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 06:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgFUEeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 00:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFUEeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 00:34:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADADC061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 21:34:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC6A21274A81F;
        Sat, 20 Jun 2020 21:34:17 -0700 (PDT)
Date:   Sat, 20 Jun 2020 21:34:17 -0700 (PDT)
Message-Id: <20200620.213417.712536082523670413.davem@davemloft.net>
To:     rrobgill@protonmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net Add MODULE_DESCRIPTION entries to network modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620020756.18707-1-rrobgill@protonmail.com>
References: <20200620020756.18707-1-rrobgill@protonmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 21:34:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rob Gill <rrobgill@protonmail.com>
Date: Sat, 20 Jun 2020 02:08:25 +0000

> The user tool modinfo is used to get information on kernel modules, including a
> description where it is available.
> 
> This patch adds a brief MODULE_DESCRIPTION to the following modules:
> 
> 9p
> drop_monitor
> esp4_offload
> esp6_offload
> fou
> fou6
> ila
> sch_fq
> sch_fq_codel
> sch_hhf
> 
> Signed-off-by: Rob Gill <rrobgill@protonmail.com>

Applied, thank you

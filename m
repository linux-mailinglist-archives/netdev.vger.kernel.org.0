Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EC6259FDB
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgIAUR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgIAUR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:17:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FF0C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 13:17:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 883CC1364C8A8;
        Tue,  1 Sep 2020 13:01:11 -0700 (PDT)
Date:   Tue, 01 Sep 2020 13:17:56 -0700 (PDT)
Message-Id: <20200901.131756.2234984624807510223.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: add a dpaa2_eth_ prefix to all
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831181240.21527-1-ioana.ciornei@nxp.com>
References: <20200831181240.21527-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 13:01:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Mon, 31 Aug 2020 21:12:37 +0300

> This is just a quick cleanup that aims at adding a dpaa2_eth_ prefix to
> all functions within the dpaa2-eth driver even if those are static and
> private to the driver. The main reason for doing this is that looking a
> perf top, for example, is becoming an inconvenience because one cannot
> easily determine which entries are dpaa2-eth related or not.

Series applied, thank you.

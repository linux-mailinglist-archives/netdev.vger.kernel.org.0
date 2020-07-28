Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959D62313D6
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgG1U0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgG1U0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:26:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C645C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 13:26:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D32CC128AB38D;
        Tue, 28 Jul 2020 13:09:58 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:26:43 -0700 (PDT)
Message-Id: <20200728.132643.1768558129617761705.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs
 stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728094812.29002-1-ioana.ciornei@nxp.com>
References: <20200728094812.29002-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 13:09:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Tue, 28 Jul 2020 12:48:10 +0300

> This patch set adds debugfs controls for clearing the software and
> hardware kept counters.  This is especially useful in the context of
> debugging when there is a need for statistics per a run of the test.

This is not necessary.

Sample the statistics at the beginning of your test and calculate the
difference at the end of your test.

I'm not applying this, it is not justified at all.

Thank you.



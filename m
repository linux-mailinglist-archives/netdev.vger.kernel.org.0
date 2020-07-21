Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675BD228C77
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgGUXHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:07:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220EEC061794;
        Tue, 21 Jul 2020 16:07:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C6C911E45904;
        Tue, 21 Jul 2020 15:51:04 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:07:48 -0700 (PDT)
Message-Id: <20200721.160748.512782775104680938.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        denis.bolotin@marvell.com, tomer.tayar@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] qed: suppress irrelevant error messages on HW
 init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721144143.379-1-alobakin@marvell.com>
References: <20200721144143.379-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:51:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Tue, 21 Jul 2020 17:41:41 +0300

> This raises the verbosity level of several error/warning messages on
> driver/module initialization, most of which are false-positives, and
> the one actively spamming the log for no reason.

Series applied.

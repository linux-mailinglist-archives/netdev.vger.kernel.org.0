Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9371E22744D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGUBAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgGUBAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:00:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB03C061794;
        Mon, 20 Jul 2020 18:00:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B17211FFC7EA;
        Mon, 20 Jul 2020 17:43:18 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:00:02 -0700 (PDT)
Message-Id: <20200720.180002.410400476834453177.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        denis.bolotin@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, andrew@lunn.ch,
        GR-everest-linux-l2@marvell.com,
        QLogic-Storage-Upstream@marvell.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/16] qed, qede: add support for new
 operating modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:43:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Mon, 20 Jul 2020 21:07:59 +0300

> This series covers the support for the following:
>  - new port modes;
>  - loopback modes, previously missing;
>  - new speed/link modes;
>  - several FEC modes;
>  - multi-rate transceivers;
> 
> and also cleans up and optimizes several related parts of code.
> 
> v3 (from [2]):
>  - dropped custom link mode declaration; qed, qede and qedf switched to
>    Ethtool link modes and definitions (#0001, #0002, per Andrew Lunn's
>    suggestion);
>  - exchange more .text size to .initconst and .ro_after_init in qede
>    (#0003).
> 
> v2 (from [1]):
>  - added a patch (#0010) that drops discussed dead struct member;
>  - addressed checkpatch complaints on #0014 (former #0013);
>  - rebased on top of latest net-next;
>  - no other changes.
> 
> [1] https://lore.kernel.org/netdev/20200716115446.994-1-alobakin@marvell.com/
> [2] https://lore.kernel.org/netdev/20200719201453.3648-1-alobakin@marvell.com/

Series applied, thank you.

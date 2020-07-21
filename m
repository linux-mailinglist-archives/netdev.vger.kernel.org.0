Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1001222745E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgGUBHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgGUBHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:07:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08214C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:07:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6D9411FFC806;
        Mon, 20 Jul 2020 17:51:09 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:07:54 -0700 (PDT)
Message-Id: <20200720.180754.294519294812439301.davem@davemloft.net>
To:     mstarovoitov@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/13] net: atlantic: various features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:51:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>
Date: Mon, 20 Jul 2020 21:32:31 +0300

> This patchset adds more features for Atlantic NICs:
>  * media detect;
>  * additional per-queue stats;
>  * PTP stats;
>  * ipv6 support for TCP LSO and UDP GSO;
>  * 64-bit operations;
>  * A0 ntuple filters;
>  * MAC temperature (hwmon).
> 
> This work is a joint effort of Marvell developers.
> 
> v3:
>  * reworked patches related to stats:
>    . fixed u64_stats_update_* usage;
>    . use simple assignment in _get_stats / _fill_stats_data;
>    . made _get_sw_stats / _fill_stats_data return count as return value;
>    . split rx and tx per-queue stats;
> 
> v2: https://patchwork.ozlabs.org/cover/1329652/
>  * removed media detect feature (will be reworked and submitted later);
>  * removed irq counter from stats;
>  * use u64_stats_update_* to protect 64-bit stats;
>  * use io-64-nonatomic-lo-hi.h for readq/writeq fallbacks;
> 
> v1: https://patchwork.ozlabs.org/cover/1327894/

Series applied, thanks Mark.

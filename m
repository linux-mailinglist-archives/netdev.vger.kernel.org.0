Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB451EB1EA
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgFAWwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgFAWwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:52:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38674C05BD43;
        Mon,  1 Jun 2020 15:52:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D3AB11F5F667;
        Mon,  1 Jun 2020 15:52:37 -0700 (PDT)
Date:   Mon, 01 Jun 2020 15:52:36 -0700 (PDT)
Message-Id: <20200601.155236.1578368535921098753.davem@davemloft.net>
To:     jbi.octave@gmail.com
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        paulmck@kernel.org, mingo@redhat.com, boqun.feng@gmail.com,
        linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] sfc: add missing annotation for
 efx_ef10_try_update_nic_stats_vf()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601184552.23128-6-jbi.octave@gmail.com>
References: <20200601184552.23128-1-jbi.octave@gmail.com>
        <20200601184552.23128-6-jbi.octave@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 15:52:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>
Date: Mon,  1 Jun 2020 19:45:52 +0100

> Sparse reports a warning at efx_ef10_try_update_nic_stats_vf()
> warning: context imbalance in efx_ef10_try_update_nic_stats_vf()
> 	- unexpected unlock
> The root cause is the missing annotation at
> efx_ef10_try_update_nic_stats_vf()
> Add the missing _must_hold(&efx->stats_lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied.

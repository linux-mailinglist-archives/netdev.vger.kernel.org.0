Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EC716B254
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgBXV3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:29:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgBXV3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:29:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7670D121A82E8;
        Mon, 24 Feb 2020 13:29:39 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:29:39 -0800 (PST)
Message-Id: <20200224.132939.1625539021646596115.davem@davemloft.net>
To:     jbi.octave@gmail.com
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        kuba@kernel.org, allison@lohutok.net, steffen.klassert@secunet.com,
        axboe@kernel.dk, hare@suse.com, ktkhai@virtuozzo.com,
        edumazet@google.com, tglx@linutronix.de,
        pankaj.laxminarayan.bharadiya@intel.com, arnd@arndb.de, cai@lca.pw,
        netdev@vger.kernel.org
Subject: Re: [PATCH 15/30] af_unix: Add missing annotation for
 unix_wait_for_peer()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200223231711.157699-16-jbi.octave@gmail.com>
References: <0/30>
        <20200223231711.157699-1-jbi.octave@gmail.com>
        <20200223231711.157699-16-jbi.octave@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 13:29:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>
Date: Sun, 23 Feb 2020 23:16:56 +0000

> Sparse reports a warning unix_wait_for_peer()
> 
> warning: context imbalance in unix_wait_for_peer() - unexpected unlock
> 
> The root cause is the missing annotation at unix_wait_for_peer()
> Add the missing annotation __releases(&unix_sk(other)->lock)
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied.

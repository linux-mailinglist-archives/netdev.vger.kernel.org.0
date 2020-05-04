Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B3E1C46B8
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgEDTGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:06:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BD6C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:06:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 971FC120ED551;
        Mon,  4 May 2020 12:06:12 -0700 (PDT)
Date:   Mon, 04 May 2020 12:06:11 -0700 (PDT)
Message-Id: <20200504.120611.2074556432362836429.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [Patch net-next v2 0/2] net: reduce dynamic lockdep keys
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
References: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 12:06:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat,  2 May 2020 22:22:18 -0700

> syzbot has been complaining about low MAX_LOCKDEP_KEYS for a
> long time, it is mostly because we register 4 dynamic keys per
> network device.
> 
> This patchset reduces the number of dynamic lockdep keys from
> 4 to 1 per netdev, by reverting to the previous static keys,
> except for addr_list_lock which still has to be dynamic.
> The second patch removes a bonding-specific key by the way.
> 
> Cong Wang (2):
>   net: partially revert dynamic lockdep key changes
>   bonding: remove useless stats_lock_key

Series applied, thank you.

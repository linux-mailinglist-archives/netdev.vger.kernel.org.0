Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE8533AF1
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfFCWPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:15:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfFCWPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:15:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5708D136E16B0;
        Mon,  3 Jun 2019 15:15:15 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:15:14 -0700 (PDT)
Message-Id: <20190603.151514.2135792251349356990.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] selftests: set sysctl bc_forwarding properly in
 router_broadcast.sh
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e22d53ba6d4dde4de8364f9c903a98061344cbe2.1559473795.git.lucien.xin@gmail.com>
References: <e22d53ba6d4dde4de8364f9c903a98061344cbe2.1559473795.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:15:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun,  2 Jun 2019 19:09:55 +0800

> sysctl setting bc_forwarding for $rp2 is needed when ping_test_from h2,
> otherwise the bc packets from $rp2 won't be forwarded. This patch is to
> add this setting for $rp2.
> 
> Also, as ping_test_from does grep "$from" only, which could match some
> unexpected output, some test case doesn't really work, like:
> 
>   # ping_test_from $h2 198.51.200.255 198.51.200.2
>     PING 198.51.200.255 from 198.51.100.2 veth3: 56(84) bytes of data.
>     64 bytes from 198.51.100.1: icmp_seq=1 ttl=64 time=0.336 ms
> 
> When doing grep $form (198.51.200.2), the output could still match.
> So change to grep "bytes from $from" instead.
> 
> Fixes: 40f98b9af943 ("selftests: add a selftest for directed broadcast forwarding")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.

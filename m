Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DFDA47EC
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfIAGoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:44:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725262AbfIAGoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:44:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 570F714CDC65C;
        Sat, 31 Aug 2019 23:44:43 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:44:42 -0700 (PDT)
Message-Id: <20190831.234442.1136062804304759437.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     borisp@mellanox.com, jakub.kicinski@netronome.com,
        eric.dumazet@gmail.com, aviadye@mellanox.com, davejwatson@fb.com,
        john.fastabend@gmail.com, matthieu.baerts@tessares.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] net: tls: add socket diag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1567158431.git.dcaratti@redhat.com>
References: <cover.1567158431.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:44:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 30 Aug 2019 12:25:46 +0200

> The current kernel does not provide any diagnostic tool, except
> getsockopt(TCP_ULP), to know more about TCP sockets that have an upper
> layer protocol (ULP) on top of them. This series extends the set of
> information exported by INET_DIAG_INFO, to include data that are
> specific to the ULP (and that might be meaningful for debug/testing
> purposes).
 ...

Series applied, thanks Davide.

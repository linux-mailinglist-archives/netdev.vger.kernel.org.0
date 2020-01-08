Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCA9134DBE
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgAHUjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:39:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47548 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgAHUjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:39:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C3CD1584BD18;
        Wed,  8 Jan 2020 12:39:09 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:39:08 -0800 (PST)
Message-Id: <20200108.123908.1308135200682526279.davem@davemloft.net>
To:     masahiroy@kernel.org
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tipc: do not add socket.o to tipc-y twice
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106073527.18697-1-masahiroy@kernel.org>
References: <20200106073527.18697-1-masahiroy@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:39:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon,  6 Jan 2020 16:35:26 +0900

> net/tipc/Makefile adds socket.o twice.
> 
> tipc-y	+= addr.o bcast.o bearer.o \
>            core.o link.o discover.o msg.o  \
>            name_distr.o  subscr.o monitor.o name_table.o net.o  \
>            netlink.o netlink_compat.o node.o socket.o eth_media.o \
>                                              ^^^^^^^^
>            topsrv.o socket.o group.o trace.o
>                     ^^^^^^^^
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Applied.

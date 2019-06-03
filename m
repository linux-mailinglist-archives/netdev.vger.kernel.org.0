Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1685333A32
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfFCVun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:50:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfFCVuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:50:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FACC14D41E0F;
        Mon,  3 Jun 2019 14:30:57 -0700 (PDT)
Date:   Mon, 03 Jun 2019 14:30:54 -0700 (PDT)
Message-Id: <20190603.143054.1734848612616501920.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     geert@linux-m68k.org, igor.j.konopko@intel.com,
        tahiliani@nitk.edu.in, o-takashi@sakamocchi.jp,
        eranbe@mellanox.com, mb@lightnvm.io, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, clemens@ladisch.de,
        perex@perex.cz, tiwai@suse.com, joe@perches.com, arnd@arndb.de,
        dan.carpenter@oracle.com, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rxrpc: Fix uninitialized error code in
 rxrpc_send_data_packet()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <15499.1559298884@warthog.procyon.org.uk>
References: <20190528142424.19626-3-geert@linux-m68k.org>
        <20190528142424.19626-1-geert@linux-m68k.org>
        <15499.1559298884@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 14:30:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 31 May 2019 11:34:44 +0100

> Here's my take on the patch.

I assume I'll see a final version of this under separate cover.

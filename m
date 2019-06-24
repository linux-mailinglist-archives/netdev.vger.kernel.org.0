Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C7150F67
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbfFXPAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:00:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55312 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfFXPAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:00:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E41D100047BF;
        Mon, 24 Jun 2019 08:00:14 -0700 (PDT)
Date:   Mon, 24 Jun 2019 08:00:13 -0700 (PDT)
Message-Id: <20190624.080013.1939618402337247105.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        sowmini.varadhan@oracle.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] net/packet: fix memory leak in packet_set_ring()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624093820.48023-1-edumazet@google.com>
References: <20190624093820.48023-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 08:00:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 24 Jun 2019 02:38:20 -0700

> syzbot found we can leak memory in packet_set_ring(), if user application
> provides buggy parameters.
> 
> Fixes: 7f953ab2ba46 ("af_packet: TX_RING support for TPACKET_V3")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F418816AE4
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfEGTJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:09:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfEGTJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:09:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B25F914B5B8A3;
        Tue,  7 May 2019 12:09:39 -0700 (PDT)
Date:   Tue, 07 May 2019 12:09:39 -0700 (PDT)
Message-Id: <20190507.120939.839641611414589004.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/2] net_sched: sch_fq: enable in-kernel
 pacing for QUIC servers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190504234854.57812-1-edumazet@google.com>
References: <20190504234854.57812-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:09:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  4 May 2019 16:48:52 -0700

> Willem added GSO support to UDP stack, greatly improving performance
> of QUIC servers.
> 
> We also want to enable in-kernel pacing, which is possible thanks to EDT
> model, since each sendmsg() can provide a timestamp for the skbs.
> 
> We have to change sch_fq to enable feeding packets in arbitrary EDT order,
> and make sure that packet classification do not trust unconnected sockets.
> 
> Note that this patch series also is a prereq for a future TCP change
> enabling per-flow delays/reorders/losses to implement high performance
> TCP emulators.

Looks great, series applied.

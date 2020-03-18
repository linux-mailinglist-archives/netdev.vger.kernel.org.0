Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BF01894CE
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgCREQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:16:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35548 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgCREQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:16:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01698146DA169;
        Tue, 17 Mar 2020 21:16:51 -0700 (PDT)
Date:   Tue, 17 Mar 2020 21:16:51 -0700 (PDT)
Message-Id: <20200317.211651.1801450460206939791.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, kuba@kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v2 net-next 0/3] net_sched: allow use of hrtimer slack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317021251.75190-1-edumazet@google.com>
References: <20200317021251.75190-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 21:16:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 16 Mar 2020 19:12:48 -0700

> Packet schedulers have used hrtimers with exact expiry times.
> 
> Some of them can afford having a slack, in order to reduce
> the number of timer interrupts and feed bigger batches
> to increase efficiency.
> 
> FQ for example does not care if throttled packets are
> sent with an additional (small) delay.
> 
> Original observation of having maybe too many interrupts
> was made by Willem de Bruijn.
> 
> v2: added strict netlink checking (Jakub Kicinski)

Looks good, series applied, thanks Eric.

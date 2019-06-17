Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC5F148AA2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfFQRlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:41:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35374 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQRlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:41:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3E3D1509B029;
        Mon, 17 Jun 2019 10:41:21 -0700 (PDT)
Date:   Mon, 17 Jun 2019 10:41:21 -0700 (PDT)
Message-Id: <20190617.104121.1475407136257245934.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        gregkh@linuxfoundation.org, jtl@netflix.com, ncardwell@google.com,
        tyhicks@canonical.com, ycheng@google.com, brucec@netflix.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH net 0/4] tcp: make sack processing more robust
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617170354.37770-1-edumazet@google.com>
References: <20190617170354.37770-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 10:41:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 17 Jun 2019 10:03:50 -0700

> Jonathan Looney brought to our attention multiple problems
> in TCP stack at the sender side.
> 
> SACK processing can be abused by malicious peers to either
> cause overflows, or increase of memory usage.
> 
> First two patches fix the immediate problems.
> 
> Since the malicious peers abuse senders by advertizing a very
> small MSS in their SYN or SYNACK packet, the last two
> patches add a new sysctl so that admins can chose a higher
> limit for MSS clamping.

Series applied, thanks Eric.

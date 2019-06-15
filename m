Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6958F46DE7
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFOCvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:51:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfFOCvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:51:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0378B12D6B4D0;
        Fri, 14 Jun 2019 19:51:24 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:51:24 -0700 (PDT)
Message-Id: <20190614.195124.1081256115731902331.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] ipv4: tcp: fix ACK/RST sent with a transmit
 delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614042235.15918-1-edumazet@google.com>
References: <20190614042235.15918-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:51:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 13 Jun 2019 21:22:35 -0700

> If we want to set a EDT time for the skb we want to send
> via ip_send_unicast_reply(), we have to pass a new parameter
> and initialize ipc.sockc.transmit_time with it.
> 
> This fixes the EDT time for ACK/RST packets sent on behalf of
> a TIME_WAIT socket.
> 
> Fixes: a842fe1425cb ("tcp: add optional per socket transmit delay")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.

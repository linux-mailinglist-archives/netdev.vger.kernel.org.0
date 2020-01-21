Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B128143BF1
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAULWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:22:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgAULWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 06:22:31 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCD0A10574DC7;
        Tue, 21 Jan 2020 03:22:29 -0800 (PST)
Date:   Tue, 21 Jan 2020 12:22:28 +0100 (CET)
Message-Id: <20200121.122228.846015323929949931.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net-next): ipsec-next 2020-01-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121073858.31120-1-steffen.klassert@secunet.com>
References: <20200121073858.31120-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 03:22:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Tue, 21 Jan 2020 08:38:52 +0100

> 1) Add support for TCP encapsulation of IKE and ESP messages,
>    as defined by RFC 8229. Patchset from Sabrina Dubroca.
> 
> Please note that there is a merge conflict in:
> 
> net/unix/af_unix.c
> 
> between commit:
> 
> 3c32da19a858 ("unix: Show number of pending scm files of receive queue in fdinfo")
> 
> from the net-next tree and commit:
> 
> b50b0580d27b ("net: add queue argument to __skb_wait_for_more_packets and __skb_{,try_}recv_datagram")
> 
> from the ipsec-next tree.
> 
> The conflict can be solved as done in linux-next.
> 
> Please pull or let me know if there are problems.

Pulled, thanks for the info about the merge conflict.

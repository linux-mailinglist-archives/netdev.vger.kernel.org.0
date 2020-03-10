Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E578117ED85
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgCJBAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:00:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbgCJBAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:00:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81E0C15A0139C;
        Mon,  9 Mar 2020 18:00:33 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:00:32 -0700 (PDT)
Message-Id: <20200309.180032.2250303823050962358.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, mahesh@bandewar.net
Subject: Re: [PATCH net] ipvlan: don't deref eth hdr before checking it's
 set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309225656.61933-1-maheshb@google.com>
References: <20200309225656.61933-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:00:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Mon,  9 Mar 2020 15:56:56 -0700

> IPvlan in L3 mode discards outbound multicast packets but performs
> the check before ensuring the ether-header is set or not. This is
> an error that Eric found through code browsing.
> 
> Fixes: 2ad7bf363841 (“ipvlan: Initial check-in of the IPVLAN driver.”)
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> Reported-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable.

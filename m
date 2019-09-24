Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2348EBD2BA
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436839AbfIXTd5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Sep 2019 15:33:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbfIXTd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 15:33:57 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9709153C0103;
        Tue, 24 Sep 2019 12:33:54 -0700 (PDT)
Date:   Tue, 24 Sep 2019 21:33:52 +0200 (CEST)
Message-Id: <20190924.213352.2279175030201650840.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     netdev@vger.kernel.org, keescook@google.com, dvyukov@google.com,
        edumazet@google.com, maheshb@google.com, lorenzo@google.com
Subject: Re: [PATCH] net-icmp: remove ping_group_range sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANP3RGeZaGD5JLw4VCLXe_6qmrGRLjROJuUNwbysq_1BhNbKOg@mail.gmail.com>
References: <20190919103944.129616-1-zenczykowski@gmail.com>
        <20190924.164016.43204807921728597.davem@davemloft.net>
        <CANP3RGeZaGD5JLw4VCLXe_6qmrGRLjROJuUNwbysq_1BhNbKOg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 12:33:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Tue, 24 Sep 2019 16:47:00 +0200

>> Removing this is going to break things, you can't just remove a sysctl
>> because "oh it was a bad idea to add this, sorry."
> 
> Yeah, I know... but do you have any other suggestions?
> 
> Would you take an alternative to make the default wide opened?

This also could break things.

The horse has left the barn on this one.

> Perhaps having it as a non-namespace aware global setting (with a
> default of on) would be more palatable?

Also could break things.

You're going to have to change this in a way such that the administrator
has to explicitly ask for the new behavior.

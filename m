Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85010DF47C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfJURrD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Oct 2019 13:47:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJURrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:47:03 -0400
Received: from localhost (unknown [4.14.35.89])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D78A1412C597;
        Mon, 21 Oct 2019 10:47:02 -0700 (PDT)
Date:   Mon, 21 Oct 2019 10:47:02 -0700 (PDT)
Message-Id: <20191021.104702.259004543485790564.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        patrick@notvads.ovh, pablo@netfilter.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ipv4: fix IPSKB_FRAG_PMTU handling with fragmentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191019162637.222512-1-edumazet@google.com>
References: <20191019162637.222512-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Oct 2019 10:47:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 19 Oct 2019 09:26:37 -0700

> This patch removes the iph field from the state structure, which is not
> properly initialized. Instead, add a new field to make the "do we want
> to set DF" be the state bit and move the code to set the DF flag from
> ip_frag_next().
> 
> Joint work with Pablo and Linus.
> 
> Fixes: 19c3401a917b ("net: ipv4: place control buffer handling away from fragmentation iterators")
> Reported-by: Patrick Schönthaler <patrick@notvads.ovh>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Applied and queued up for -stable, thanks Eric.

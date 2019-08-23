Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B281C9B823
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390167AbfHWV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:29:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbfHWV32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:29:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 08D2E1543B283;
        Fri, 23 Aug 2019 14:29:28 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:29:16 -0700 (PDT)
Message-Id: <20190823.142916.238167013292929213.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/9] rxrpc: Fix use of skb_cow_data()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <27348.1566550348@warthog.procyon.org.uk>
References: <20190822.121207.731320146177703787.davem@davemloft.net>
        <156647655350.10908.12081183247715153431.stgit@warthog.procyon.org.uk>
        <27348.1566550348@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:29:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 23 Aug 2019 09:52:28 +0100

> Question for you: how likely is a newly received buffer, through a UDP socket,
> to be 'cloned'?

Very unlikely, I'd say.

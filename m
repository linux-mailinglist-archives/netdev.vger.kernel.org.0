Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D649C46DCD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfFOC2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:28:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOC2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:28:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32A7F1341A573;
        Fri, 14 Jun 2019 19:28:00 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:27:59 -0700 (PDT)
Message-Id: <20190614.192759.352171429890636844.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        marcelo.leitner@gmail.com, lucien.xin@gmail.com
Subject: Re: [PATCH v5 net] sctp: Free cookie before we memdup a new one
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613103559.2603-1-nhorman@tuxdriver.com>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
        <20190613103559.2603-1-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:28:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 13 Jun 2019 06:35:59 -0400

> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> Change notes
> v1->v2
> update subsystem tag in subject (davem)
> repeat kfree check for peer_random and peer_hmacs (xin)
> 
> v2->v3
> net->sctp
> also free peer_chunks
> 
> v3->v4
> fix subject tags
> 
> v4->v5
> remove cut line
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com

Applied, thanks.

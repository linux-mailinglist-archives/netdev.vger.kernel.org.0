Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCFF228BF1
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGUWcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUWcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:32:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A15C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:32:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F8CD11E45900;
        Tue, 21 Jul 2020 15:15:58 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:32:39 -0700 (PDT)
Message-Id: <20200721.153239.840568562226163775.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        willemb@google.com, edumazet@google.com, kraig@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org, kuni1840@gmail.com,
        benh@amazon.com, osa-contribution-log@amazon.com
Subject: Re: [PATCH net 0/2] udp: Fix reuseport selection with connected
 sockets.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721061531.94236-1-kuniyu@amazon.co.jp>
References: <20200721061531.94236-1-kuniyu@amazon.co.jp>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:15:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Tue, 21 Jul 2020 15:15:29 +0900

> From: kuniyu <kuniyu@amazon.co.jp>

Please fix your configuration to show your full name in this
"From: " field, I had to edit it out and use the one from your
email headers.

> This patch set addresses two issues which happen when both connected and
> unconnected sockets are in the same UDP reuseport group.

Series applied and queued up for -stable, th anks.

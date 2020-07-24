Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC0822D26C
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGXXss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGXXss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 19:48:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD23C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 16:48:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA0C112755EF8;
        Fri, 24 Jul 2020 16:32:02 -0700 (PDT)
Date:   Fri, 24 Jul 2020 16:48:47 -0700 (PDT)
Message-Id: <20200724.164847.1111562996497649259.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com,
        kuba@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org,
        willemb@google.com, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net] udp: Remove an unnecessary variable in
 udp[46]_lib_lookup2().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724061304.14997-1-kuniyu@amazon.co.jp>
References: <20200723.151051.16194602184853977.davem@davemloft.net>
        <20200724061304.14997-1-kuniyu@amazon.co.jp>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:32:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Fri, 24 Jul 2020 15:13:04 +0900

> Yes. I think this kind of patch should be submitted to net-next, but
> this is for the net tree. Please let me add more description.

This does not fix a bug, therefore 'net' is not appropriate.

The merge conflicts should be handled by the appropriate maintainer
when the merges happen.

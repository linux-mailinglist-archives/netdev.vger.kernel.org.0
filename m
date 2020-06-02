Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7F1EC4D3
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgFBWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBWQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:16:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C345C08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 15:16:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1ED2E1277B97C;
        Tue,  2 Jun 2020 15:16:34 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:16:30 -0700 (PDT)
Message-Id: <20200602.151630.1855672322670645363.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net 0/2] tipc: revert two patches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200602044641.10535-1-tuong.t.lien@dektech.com.au>
References: <20200602044641.10535-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:16:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Tue,  2 Jun 2020 11:46:39 +0700

> We revert two patches:
> 
> tipc: Fix potential tipc_node refcnt leak in tipc_rcv
> tipc: Fix potential tipc_aead refcnt leak in tipc_crypto_rcv
> 
> which prevented TIPC encryption from working properly and caused kernel
> panic.

Series applied.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB153233C2B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgG3XaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbgG3XaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:30:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CC5C061574;
        Thu, 30 Jul 2020 16:30:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2102126BED81;
        Thu, 30 Jul 2020 16:13:16 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:29:59 -0700 (PDT)
Message-Id: <20200730.162959.708021188846061987.davem@davemloft.net>
To:     koct9i@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4: add comment about connect() to INADDR_ANY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159569777048.30163.2041497275480123382.stgit@zurg>
References: <159569777048.30163.2041497275480123382.stgit@zurg>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:13:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Khlebnikov <koct9i@gmail.com>
Date: Sat, 25 Jul 2020 20:22:50 +0300

> Copy comment from net/ipv6/tcp_ipv6.c to help future readers.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

This function is used by many lookups, not just connect() so the
comment is entirely inapropriate here.

I'm not applying this, sorry.

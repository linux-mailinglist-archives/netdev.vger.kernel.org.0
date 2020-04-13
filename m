Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE6651A61D3
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 05:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgDMD4S convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 12 Apr 2020 23:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgDMD4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 23:56:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [23.128.96.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7965C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 20:56:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62FEE127AD65C;
        Sun, 12 Apr 2020 20:56:13 -0700 (PDT)
Date:   Sun, 12 Apr 2020 20:56:11 -0700 (PDT)
Message-Id: <20200412.205611.844961656085784911.davem@davemloft.net>
To:     lesedorucalin01@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200408205954.GA15086@white>
References: <20200408205954.GA15086@white>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Apr 2020 20:56:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leºe Doru Cãlin <lesedorucalin01@gmail.com>
Date: Wed, 8 Apr 2020 23:59:54 +0300

> +static int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> +{
> +	struct sk_buff *skb;
> +	int copied = 0, err = 0, copy;

Please use reverse christmas tree (longest to shortest) ordering for
local variables.

> +static int udp6_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
> +{
> +	struct sk_buff *skb;
> +	int copied = 0, err = 0, copy;

Likewise.

Thank you.

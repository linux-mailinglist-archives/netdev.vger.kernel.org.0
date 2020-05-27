Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225AE1E50C4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgE0V5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgE0V5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:57:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0D3C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:57:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EA7C128CE44B;
        Wed, 27 May 2020 14:57:52 -0700 (PDT)
Date:   Wed, 27 May 2020 14:57:51 -0700 (PDT)
Message-Id: <20200527.145751.1432747576025154516.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/2] tcp: tcp_v4_err() cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527024850.81404-1-edumazet@google.com>
References: <20200527024850.81404-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 14:57:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 26 May 2020 19:48:48 -0700

> This series is a followup of patch 239174945dac ("tcp: tcp_v4_err() icmp
> skb is named icmp_skb").
> 
> Move the RFC 6069 code into a helper, and rename icmp_skb to standard
> skb name so that tcp_v4_err() and tcp_v6_err() are using consistent names.

Series applied, thanks Eric.

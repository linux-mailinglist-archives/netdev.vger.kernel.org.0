Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653741AF5A0
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgDRWro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbgDRWrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:47:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6E9C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:47:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 819B2127814A1;
        Sat, 18 Apr 2020 15:47:43 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:47:42 -0700 (PDT)
Message-Id: <20200418.154742.987894608917673223.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com
Subject: Re: [PATCH net] tcp: cache line align MAX_TCP_HEADER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417141023.113008-1-edumazet@google.com>
References: <20200417141023.113008-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:47:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 17 Apr 2020 07:10:23 -0700

> TCP stack is dumb in how it cooks its output packets.
> 
> Depending on MAX_HEADER value, we might chose a bad ending point
> for the headers.
> 
> If we align the end of TCP headers to cache line boundary, we
> make sure to always use the smallest number of cache lines,
> which always help.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.

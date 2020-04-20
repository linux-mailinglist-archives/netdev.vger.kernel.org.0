Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB01B13FB
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgDTSH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgDTSH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:07:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13290C061A0C;
        Mon, 20 Apr 2020 11:07:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FBDB127D38C5;
        Mon, 20 Apr 2020 11:07:26 -0700 (PDT)
Date:   Mon, 20 Apr 2020 11:07:25 -0700 (PDT)
Message-Id: <20200420.110725.484589741956408175.davem@davemloft.net>
To:     john.haxby@oracle.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv6: fix restrict IPV6_ADDRFORM operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2728d063cd3c34c25eec068e06a0676199a84f62.1587221721.git.john.haxby@oracle.com>
References: <cover.1587221721.git.john.haxby@oracle.com>
        <2728d063cd3c34c25eec068e06a0676199a84f62.1587221721.git.john.haxby@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 11:07:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Haxby <john.haxby@oracle.com>
Date: Sat, 18 Apr 2020 16:30:49 +0100

> Commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation") fixed a
> problem found by syzbot an unfortunate logic error meant that it
> also broke IPV6_ADDRFORM.
> 
> Rearrange the checks so that the earlier test is just one of the series
> of checks made before moving the socket from IPv6 to IPv4.
> 
> Fixes: b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation")
> Signed-off-by: John Haxby <john.haxby@oracle.com>

Applied, thanks.

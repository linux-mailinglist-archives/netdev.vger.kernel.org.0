Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6544593FD
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240239AbhKVRcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbhKVRcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:32:20 -0500
X-Greylist: delayed 581 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Nov 2021 09:29:13 PST
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F0EC061574;
        Mon, 22 Nov 2021 09:29:13 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] dccp/tcp: Minor fixes for
 inet_csk_listen_start().
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1637601568;
        bh=lAhXB7sgxAZWVt4Vo9HqdJmv4Tm7/9Bxewuoz1YhiLQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YJgxd9A1733N+eg88uD2liStzdvsgnVxsW5WgaWeeWRlZKTKER8qko8pxSsq9KEWs
         SmveswFt2oHwSLJ8qtoxc/iaN/j2LOUWLNOQPnHbJdv7ekc5g3ioZiK0pHVzAEObNj
         8yyjtmyoJAvo9PoHSfcwWZcSX0xkd7DoOrdmQ5B9Bmm2qRsftr7GIpHrYnhFr0lBLv
         7PpRMVe38jJWgZm3V6Z8oCRTJqkDxsqG6vj/nkv8jdYVfLhq1ZVIBCqIZjvjvrNh30
         UxL4SOn/spiyZp4RaY2AuLkKSuELgZNt+OW00iEU1mUjPoTbaje8UjDyEYB8MXxZjx
         ye12rM59/bJxQ==
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yafang Shao <laoar.shao@gmail.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        dccp@vger.kernel.org
References: <20211122101622.50572-1-kuniyu@amazon.co.jp>
From:   Richard Sailer <richard_siegfried@systemli.org>
Message-ID: <23d88c5d-d8a7-77a8-1803-07a28b25e7cb@systemli.org>
Date:   Mon, 22 Nov 2021 18:19:23 +0100
MIME-Version: 1.0
In-Reply-To: <20211122101622.50572-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2021 11:16, Kuniyuki Iwashima wrote:
> The first patch removes an unused argument, and the second removes a stale
> comment.
> 
Looks fine to me.

Reviewed-by: Richard Sailer <richard_siegfried@systemli.org>

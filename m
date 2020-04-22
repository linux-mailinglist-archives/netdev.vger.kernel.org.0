Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C431B4D2B
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgDVTPm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 15:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgDVTPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:15:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD38C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 12:15:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4E53120ED563;
        Wed, 22 Apr 2020 12:15:40 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:15:40 -0700 (PDT)
Message-Id: <20200422.121540.660167591277798308.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, ek@google.com,
        furry@google.com, lorenzo@google.com, mharo@google.com
Subject: Re: [PATCH] ipv6: ndisc: RFC-ietf-6man-ra-pref64-09 is now
 published as RFC8781
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420182507.110436-1-zenczykowski@gmail.com>
References: <20200420182507.110436-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:15:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Mon, 20 Apr 2020 11:25:07 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> See:
>   https://www.rfc-editor.org/authors/rfc8781.txt
> 
> Cc: Erik Kline <ek@google.com>
> Cc: Jen Linkova <furry@google.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Michael Haro <mharo@google.com>
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>
> Fixes: c24a77edc9a7 ("ipv6: ndisc: add support for 'PREF64' dns64 prefix identifier")

Applied.

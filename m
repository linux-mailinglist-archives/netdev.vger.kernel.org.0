Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE1FAC757
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436490AbfIGPsR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 7 Sep 2019 11:48:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390962AbfIGPsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:48:16 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CCE0152F1AD7;
        Sat,  7 Sep 2019 08:48:14 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:48:12 +0200 (CEST)
Message-Id: <20190907.174812.440810335403861625.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, dsahern@gmail.com,
        lorenzo@google.com, edumazet@google.com
Subject: Re: [PATCH] net-ipv6: addrconf_f6i_alloc - fix non-null pointer
 check to !IS_ERR()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906035637.47097-1-zenczykowski@gmail.com>
References: <CANP3RGcbEP2N-CDQ6N649k0-cV4AhQeWqF-niz7EMPFOFpkU1w@mail.gmail.com>
        <20190906035637.47097-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:48:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Thu,  5 Sep 2019 20:56:37 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> Fixes a stupid bug I recently introduced...
> ip6_route_info_create() returns an ERR_PTR(err) and not a NULL on error.
> 
> Fixes: d55a2e374a94 ("net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128 local route (and others)'")
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied and queued up for -stable since I queued up the patch this fixes.

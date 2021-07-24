Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2493D4860
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 17:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhGXO6c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 24 Jul 2021 10:58:32 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:37358 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhGXO6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 10:58:30 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GX9Mm2wCszB8p0;
        Sat, 24 Jul 2021 17:39:00 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Mhdamgu_XzUK; Sat, 24 Jul 2021 17:39:00 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GX9Mm1qk3zB8nr;
        Sat, 24 Jul 2021 17:39:00 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id 5083C653; Sat, 24 Jul 2021 17:44:16 +0200 (CEST)
Received: from 37-165-72-176.coucou-networks.fr
 (37-165-72-176.coucou-networks.fr [37.165.72.176]) by messagerie.c-s.fr
 (Horde Framework) with HTTP; Sat, 24 Jul 2021 17:44:16 +0200
Date:   Sat, 24 Jul 2021 17:44:16 +0200
Message-ID: <20210724174416.Horde.SGJpvfIKCho_9unV7fRnmA7@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Geoff Levand <geoff@infradead.org>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 03/10] net/ps3_gelic: Format cleanups
References: <cover.1627068552.git.geoff@infradead.org>
 <56efff53fcf563a1741904ea0f078d50c378b6cc.1627068552.git.geoff@infradead.org>
In-Reply-To: <56efff53fcf563a1741904ea0f078d50c378b6cc.1627068552.git.geoff@infradead.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geoff Levand <geoff@infradead.org> a écrit :

> In an effort to make the PS3 gelic driver easier to maintain, cleanup the
> the driver source file formatting to be more consistent.

Many of your changes in this patch go in the wrong direction.

For instance, you shall not use { } in an if/else sequence with single  
lines in both the if and the else. See  
https://www.kernel.org/doc/html/latest/process/coding-style.html#placing-braces-and-spaces

In a multiline operation, the argument of the second line must be  
aligned to the matching parenthesis.

Christophe



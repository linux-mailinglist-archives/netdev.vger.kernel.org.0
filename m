Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0709642EDC8
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbhJOJiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:38:12 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:42737 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237530AbhJOJiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 05:38:11 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HW1Nh4r8gz9sSD;
        Fri, 15 Oct 2021 11:36:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MyU2A-CjYCoR; Fri, 15 Oct 2021 11:36:04 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HW1Nh3fLJz9sSC;
        Fri, 15 Oct 2021 11:36:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3A8A68B78B;
        Fri, 15 Oct 2021 11:36:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 0DuQBx2oTJMm; Fri, 15 Oct 2021 11:36:04 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.255])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BB7868B763;
        Fri, 15 Oct 2021 11:36:03 +0200 (CEST)
Subject: Re: KSZ8041 errata - linux patch
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
References: <20211012035650.GA10335@francesco-nb.int.toradex.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <09cc480a-eaa6-48cf-859c-48387f448e2f@csgroup.eu>
Date:   Fri, 15 Oct 2021 11:36:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211012035650.GA10335@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

Le 12/10/2021 à 05:56, Francesco Dolcini a écrit :
> Hello,
> I found out that in 2016 you tried to push a patch to fix a KSZ8041 errata [1],
> what was the final conclusion on that? We have a similar patch in our kernel
> and I think that this should be really merged upstream.
> 
> [1] https://lore.kernel.org/all/2ee9441d-1b3b-de6d-691d-b615c04c69d0@gmail.com/
> 

I think I never got any answer to my last mail and it stoped there, 
without any conclusion I guess.

I can't see my patch in netdev patchwork so I guess it's been discarded.

If you have a patch feel free to submit it.

Christophe

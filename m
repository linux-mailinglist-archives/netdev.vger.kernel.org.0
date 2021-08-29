Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99793FAB54
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhH2M0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 08:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbhH2M0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 08:26:24 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1137DC061575;
        Sun, 29 Aug 2021 05:25:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GyCMn077Bz9sW5;
        Sun, 29 Aug 2021 22:25:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1630239927;
        bh=iBAjFvolmNyY2XZ92vAE2fPLtdbfMKz7ggBJnDVP5XY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=mkjRa/NB8vHgxfdu3l/F8pbrud+Fo5BKagyM0uRxjeTOdt8OWy59q2UNYjRakpxqa
         dtZGfZqT5BFbFBdansxFhWr6CYpmbCfg6wsQJWj3sdUWBf2lGB0Jr/5AX/ZSSiiw5m
         E8e9/0clEWAiKoSw2m9J5glNTV70KW+bMPOKzgHqPLF/Fn1tcxgHQ8ZWEUJBCMugAW
         zuJ6BQyAw7JV3eF3B2QYbjxsyWhCYKpq3PA46OB7Y4ciO4LOiSypNuZMzfFVycKrEI
         vFw9FGhvXCkDKyqpR5DaCNMwcR0hMTHNWrUvJCHXtGDxlNR+yig+pDPIe50oc/8Y5m
         3xYOxVFdfehsg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kou.ishizaki@toshiba.co.jp, geoff@infradead.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: spider_net: switch from 'pci_' to 'dma_' API
In-Reply-To: <90220a35-bd0a-ccf3-91b1-c2a459c447e7@csgroup.eu>
References: <60abc3d0c8b4ef8368a4d63326a25a5cb3cd218c.1630094078.git.christophe.jaillet@wanadoo.fr>
 <90220a35-bd0a-ccf3-91b1-c2a459c447e7@csgroup.eu>
Date:   Sun, 29 Aug 2021 22:25:19 +1000
Message-ID: <871r6cfnf4.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:
> Le 27/08/2021 =C3=A0 21:56, Christophe JAILLET a =C3=A9crit=C2=A0:
>> ---
>> It has *not* been compile tested because I don't have the needed
>> configuration or cross-compiler. However, the modification is completely
>> mechanical and done by coccinelle.
>
> All you need is at https://mirrors.edge.kernel.org/pub/tools/crosstool/

There's also some instructions here for using distro toolchains:

https://github.com/linuxppc/wiki/wiki/Building-powerpc-kernels

cheers

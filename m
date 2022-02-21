Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC6A4BE3C3
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240867AbiBULNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:13:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355662AbiBULNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:13:08 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266F827CE1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 02:47:11 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:49dc:a1b5:3fe0:3d2b])
        by laurent.telenet-ops.be with bizsmtp
        id xmn92600R3YJRAw01mn9Ur; Mon, 21 Feb 2022 11:47:09 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nM6Dl-001SWb-8w; Mon, 21 Feb 2022 11:47:09 +0100
Date:   Mon, 21 Feb 2022 11:47:09 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     linux-kernel@vger.kernel.org
cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: Re: Build regressions/improvements in v5.17-rc5
In-Reply-To: <20220221095530.1355319-1-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.22.394.2202211143310.347934@ramsan.of.borg>
References: <20220221095530.1355319-1-geert@linux-m68k.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Feb 2022, Geert Uytterhoeven wrote:
> JFYI, when comparing v5.17-rc5[1] to v5.17-rc4[3], the summaries are:
>  - build errors: +2/-1

   + /kisskb/src/net/netfilter/xt_socket.c: error: implicit declaration of function 'nf_defrag_ipv6_disable'; did you mean 'nf_defrag_ipv4_disable'? [-Werror=implicit-function-declaration]:  => 224:3

mips-gcc8/malta_defconfig
mips-gcc8/ip22_defconfig

   + error: omap-gpmc.c: undefined reference to `of_platform_device_create':  => .text.unlikely+0x14c4), .text.unlikely+0x1628)

sparc64-gcc11/sparc64-allmodconfig
sparc64/sparc-allmodconfig
sparc64/sparc64-allmodconfig

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/cfb92440ee71adcc2105b0890bb01ac3cddb8507/ (all 99 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/754e0b0e35608ed5206d6a67a791563c631cec07/ (all 99 configs)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds

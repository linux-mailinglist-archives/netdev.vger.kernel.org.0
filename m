Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD000135B15
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 15:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgAIOJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 09:09:52 -0500
Received: from mail-40132.protonmail.ch ([185.70.40.132]:34450 "EHLO
        mail-40132.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731444AbgAIOJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 09:09:51 -0500
Date:   Thu, 09 Jan 2020 14:09:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578578989;
        bh=AZPWS9rTDLBXczfbLEOLGJvc5ecIJMGlHW889aO12hc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=UshBWtvr7a4ZHDLXLfiPLrJLbER/U/CppNfPXFlPPXKejJYqpCOp21GOtE0KrmlDU
         0f1vr3kCdGM5CzIniuFzXO1a0H+Nl20WQ4Oi+liHr2w2rlGvMGY2f1Vkjzu8MNAj4I
         yTrzQUMK1xaUkwNpXIJEJlW9eSpPt5qSG92eYIsY=
To:     Eric Dumazet <edumazet@google.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <8rNBhBMBDWDkAi_-D7zpvZ_8NnhJLMsvdVsWlAzCdmWutIMYwqCw2A4V_6BZBKH0ryIhn4hcjlPEcOAUPPhbIWSUX8FipY7V5j2KTbI-c8M=@protonmail.com>
In-Reply-To: <CANn89i+zxbXv2O4C8B+AW5BNbTsQtn6RP7BRx7UQYfRcbWTsTw@mail.gmail.com>
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
 <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com>
 <5gI82sir9U2gaHqvZgEXtxtdFJnbS_9geSflUCqgXjNKjtQfHmBWsfqaNuauMKKpefp5yrcgF7rs7O65ZBGFXL8mLFODpfc_bmB2ZBUgyQM=@protonmail.com>
 <CANn89i+zxbXv2O4C8B+AW5BNbTsQtn6RP7BRx7UQYfRcbWTsTw@mail.gmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So now is it sure not to modify the kernel code?

If so, I plan to modify ip-sysctl.txt and submit a new patch.

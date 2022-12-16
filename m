Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6594564ECE7
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 15:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiLPOdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 09:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiLPOdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 09:33:23 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7065357B68;
        Fri, 16 Dec 2022 06:33:21 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1671201200; bh=kueXo826TahAQuE0I2AyPBQ0EX7J9vFz9+gNecyeodk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rxAbI6KpyNQP0LEJQLA7iFMAp5+03j9GyosYt4Rhv3vEzMes/zHpj9/VGZ00WwdG0
         sb4Sa4yBoEUZBoQTc1WEybgEPDYlLV/nlkFJrMK7MoXAWU+NoMXDot5M0Zm9TIuOVY
         Q55KbNtiKLFTO0zDhHrAEuch637Itc0u3zMRqQkfcp35kekwElgWNCqQ0iHqevJpao
         UzsS4xy+Ym9iiv98aD+pi/BEi73pDgdNKbtGhxKYP9zcqBKZwQlwmB090HKnr1C2d+
         VIvsFB73enrwtAmkgXSWNcKgPJwVdm3ofSjSDRetvGP38JWDPM9Dn4qI/SYamwwl1t
         ToCcZe4CKzuJg==
To:     Arnd Bergmann <arnd@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: use proper statements in conditionals
In-Reply-To: <20221215165553.1950307-1-arnd@kernel.org>
References: <20221215165553.1950307-1-arnd@kernel.org>
Date:   Fri, 16 Dec 2022 15:33:19 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87cz8jbeq8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> A previous cleanup patch accidentally broke some conditional
> expressions by replacing the safe "do {} while (0)" constructs
> with empty macros. gcc points this out when extra warnings
> are enabled:
>
> drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_co=
mplete':
> drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces ar=
ound empty body in an 'else' statement [-Werror=3Dempty-body]
>   251 |                         TX_STAT_INC(hif_dev, skb_failed);
>
> Make both sets of macros proper expressions again.
>
> Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

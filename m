Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB184C5838
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 22:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiBZVCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 16:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiBZVCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 16:02:22 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73C84D274;
        Sat, 26 Feb 2022 13:01:45 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1645909303; bh=PW8DryT1j0RzgBStJT0xURBoVehaZ5ACsqd1Obshzb4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=tnfMQzdaAbFrK/sYeR7opT9i50S6djct2PY1a2sGRuK9NzCh3A7Co2H3LxSyoDhLR
         a8hExqDlWfNwN8MErkoZzVNN10jVfkjkzSei3A2PYLDz1UqM+ayatBcmC+IIEmkoft
         zhGwt01bgj/jOBgTsTfKC65uBSNdgMW8gCTszPQMO3Uf8XFAqr5ZInij1cM8L1vBsb
         AWVCYhZC8i6dhuLeMy/9dHhqDFKTwVhBueA4UXIf3AuUixl5ojtQf97YaCVGhEu8gz
         by/52VZ08W3PnpJLs0Vs33SflZKBS8prsv7MGQuOtmkAglYPeKoHgP1s3e8CJKR1kC
         Ae4U/Y/PJmHHg==
To:     Colin Ian King <colin.i.king@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: make array voice_priority static const
In-Reply-To: <20220222121749.87513-1-colin.i.king@gmail.com>
References: <20220222121749.87513-1-colin.i.king@gmail.com>
Date:   Sat, 26 Feb 2022 22:01:41 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87czj9uytm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> writes:

> Don't populate the read-only array voice_priority on the stack but
> instead make it static const. Also makes the object code a little
> smaller.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

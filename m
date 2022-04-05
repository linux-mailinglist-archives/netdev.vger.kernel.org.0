Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D604F53AE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361318AbiDFE0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376730AbiDEUuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:50:15 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A38FED;
        Tue,  5 Apr 2022 13:27:43 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649190461; bh=nqSNpZUYa15jc1r1KsKxXRNob2r5GycPU1hZtLnFTY0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=x1wbzqS91lCyk12gCiBfIbywrwtN6fUVHpZBegaLMEy7Bz9Q9blZnokTdh+i27Agy
         zmPDF+jb0LWIbcb/qDtV48Z3vkA5AxeP/LzXZppHmmWnhlL5a3r9ORAYz6039Qjznw
         +lmRHDYVrpWkZSCNHQ9I40W76Fq4IICzBttjbgxJvt30MQn7roYNowipE6poMOCnT4
         YaU9eTbUE6BLQJF93mvk5kQcw+nzHZ4EU0VHBOEwuvy4R+G+6Cl/0uBXFizgXu8X+V
         quYgHL61oZNy4HKDADG47DLu8skRCyIYVsPKRBrnzOV7WsY46cb8QA2UBGvJYakj2h
         XRUH7fxYjzgnA==
To:     Peter Seiderer <ps.report@gmx.net>, linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] ath9k: fix ath_get_rate_txpower() to respect the
 rate list end tag
In-Reply-To: <20220402153014.31332-1-ps.report@gmx.net>
References: <20220402153014.31332-1-ps.report@gmx.net>
Date:   Tue, 05 Apr 2022 22:27:41 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pmlvcm2q.fsf@toke.dk>
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

Peter Seiderer <ps.report@gmx.net> writes:

> Stop reading (and copying) from ieee80211_tx_rate to ath_tx_info.rates
> after list end tag (count =3D=3D 0, idx < 0), prevents copying of garbage
> to card registers.
>
> Note: no need to write to the remaining ath_tx_info.rates entries
> as the complete ath_tx_info struct is already initialized to zero from
> both call sites.
>
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

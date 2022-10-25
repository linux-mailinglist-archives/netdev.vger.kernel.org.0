Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098E560C7F0
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 11:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiJYJXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 05:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiJYJWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 05:22:55 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E233BC0A;
        Tue, 25 Oct 2022 02:18:55 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1666689532; bh=ardSIzpxISEy34UnBacVac7as2n//ANewTamEDiOnNs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=J5FaTHnuaHYH8d9a/6XlrCytzfVgatxyQkuS05PTJGOhOOU7hcy5RzLuC+xuUcGmH
         UWfvOFeLkDyRbjxVN64rD92A+pLfP8nVucGJJK77ex4h4Kkm+f9tAg+JvkmwrxEs/Q
         B3Quq0wKQQ/Rq1E2oYv9nhErhXCxZV6TX4KxF9qLTCSSjf9YfFktq1C+svvzHcCrRL
         +VZrL11zunjVGdWeOgAQrc4iqKpndsl5Y5x18+icxAS2k0I6OkmG8VB6H+1vZIpcXv
         cqjL0YeyEXbYaNs9Q6zPiaj5uXPVLiF6jE8HlXbPsngXsXTwtf9YdAbat51L7IxJRF
         BPZI8Em656/iQ==
To:     Colin Ian King <colin.i.king@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove variable sent
In-Reply-To: <20221024153954.2168503-1-colin.i.king@gmail.com>
References: <20221024153954.2168503-1-colin.i.king@gmail.com>
Date:   Tue, 25 Oct 2022 11:18:52 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87czaggt1f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> writes:

> Variable sent is just being incremented and it's never used
> anywhere else. The variable and the increment are redundant so
> remove it.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

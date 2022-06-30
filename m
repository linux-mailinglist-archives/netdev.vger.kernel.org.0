Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BFA561267
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 08:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiF3GXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 02:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiF3GXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 02:23:11 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C976B49D;
        Wed, 29 Jun 2022 23:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1656570174;
        bh=9no9UVFH+eQR836qWFvRWMdx3fxP2OaI7OaE+hfAIMY=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=CnNiwm2MrxE1svdABLjcsOAK+WvrcIDPptmHBhtXTtMjOcjz/ByifP3xey3R/RV6x
         NbFhL0xeJ62jkXBm3hrbmosJUI7rHDQAFMtp0DmwMX0DF6SvQ2ed0Hl7RgagmsnmUB
         67zvLKSqQeiSQG6p0omuMCo8cLUSKW6z5DtDkeG8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.136.11]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQ5vW-1oJwjt411k-00M3Xg; Thu, 30
 Jun 2022 08:22:54 +0200
Message-ID: <04b47f81-77d6-9429-5b8f-fdf4fbbfb62d@gmx.de>
Date:   Thu, 30 Jun 2022 08:22:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] dec/tulip:fix repeated words in comments
Content-Language: en-US
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220629095405.8668-1-yuanjilin@cdjrlc.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220629095405.8668-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HZk557EiuA7heqLeox0iNOLRa7BQNU1W5AzmGYEGvOgGq05m5Fk
 wTbbwrvi6Hr6Pl1jCnl21CmMyfy9Dscaqw86Z2NT8wP4xTPVoxfrPdwUEYlfYcJo2Sl8GVR
 4AMafTR3qBBvh2ObQzngxyR+oJrzY0OlZGTeh3mjuSnMXoGb85Y38r+/MABqfV0Nav1omOX
 DiPL/AhKyKJVb8/3pu2eg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1cXFSoHM2eQ=:/o58ILoAMTSTmEZy3b2FZu
 7Ex2FuzVLfIQ4eIi+QLDd7NfsjyKqJZuzLSRMv7sr8zoGWsxHnjs4zZgTxHR7l0beLP9GFwjJ
 p5c3TkjIY0M3aECNjoqMxrfk8pFoxqqS5z706/y0WT2XIZDNIBWTuoz6ZJbdwXV7fA+9zb/PG
 MKXOtrhNagNCPfQ8zzjX8RxD3TUbBXBWZqPYFJr4LgopNazsucDywEVxBKtquZkKRp60ObYV+
 wtGJ7HHxRwWQj9p75vnCyr4sCfI+3EB+wgdU51le6GhOJ12Qvc1YEh3ObINC4tvME3DAWalF6
 1NlvsjSMabFofynxnQSvilGcd/rnqmfpcHvvP5H1QbFEwd1CAzgjLfu8aKL/zXjbcS1McgQbB
 st+/1KTZuePdI9Nvj+HVzXTkqX4ZplHd05YBxz2GuL+OI5py2BHMAMuBwC8FL9TeYIyUqKx/Y
 2NjjFv8BsJz6XjDvjizq0e/aV4lQ0Q0eKGQKEwbqqbrjCRQZv2aHpWMf5gHb8ef8BKECj8PaB
 Q1YZowxgHQ7rO+CgN4gE8uZlE6lDbJeWDuONszvXrbAKnOZ5GXSuHUNOqGMv2dW0epZnzQ0WP
 YHwFzZS2HVAH0dlDcq7CWhlQ+c97cGtxE5vK/nAwq76G760Lpcs4KLoh3RWrbhC2warwxQSDV
 7niYKfsV+MOsYKDw1SLmKKPFnqNYgbChhmVoT/pZexOKqfjqKyELuah2DTX/rb/thV7P4M2rO
 OItsGeoHgDOrr69LLmLJrNqOl1xXZGVafjkml8EzOskwbKZQLuglVteKLVHJ7wrKR7aE0SfeM
 QnyX6vDDtpOGfD2v04+10BxqG2kSj1/zHGKTQWcwPneZ3gc4BD5674dsO/cBSmr0wmeVsSahT
 ui9Kshm9v+7A8UnyGx1ZdfnueNySOmZ44Wvh2DZ47f5QoGG1TkW+Ts6QcKk4XbHIMXEGasWlt
 HuOhOx2hehle+e9z6SBNFYjeo3yHQvbylC3tIkDKioF5jG4LUCFz4Ehn/axc7q5noG/UmJIze
 3X9CXDCteHvgiR7Fyh9JSbuE9hA20hTmNBf+tdwYR+yaC0Pq7nS/H0cm3Mz3j5s8C4m6FAKxC
 2gP+dBrueh/2sILB0gAEQbWOHoDxK2VnsqkEU84Zx1eY04E90F7FKJ6jA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/22 11:54, Jilin Yuan wrote:
> Delete the redundant word 'this'.
>
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/dec/tulip/xircom_cb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/xircom_cb.c b/drivers/net/et=
hernet/dec/tulip/xircom_cb.c
> index 8759f9f76b62..61825c9bd6be 100644
> --- a/drivers/net/ethernet/dec/tulip/xircom_cb.c
> +++ b/drivers/net/ethernet/dec/tulip/xircom_cb.c
> @@ -742,7 +742,7 @@ static void activate_receiver(struct xircom_private =
*card)
>
>  /*
>  deactivate_receiver disables the receiver on the card.
> -To achieve this this code disables the receiver first;
> +To achieve this code disables the receiver first;

No.
Instead it should be something like:
To achieve this, this code disables the receiver first; ...

but better look at the whole comment including the next line,
in which case it could become:

Disable the receiver first, then wait for it to become inactive.

...

>  then it waits for the receiver to become inactive.
>
>  must be called with the lock held and interrupts disabled.
> @@ -829,7 +829,7 @@ static void activate_transmitter(struct xircom_priva=
te *card)
>
>  /*
>  deactivate_transmitter disables the transmitter on the card.
> -To achieve this this code disables the transmitter first;
> +To achieve this code disables the transmitter first;
>  then it waits for the transmitter to become inactive.

same here...


>
>  must be called with the lock held and interrupts disabled.


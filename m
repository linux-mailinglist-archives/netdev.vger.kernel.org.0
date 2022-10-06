Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3925F6D58
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 20:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiJFSM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 14:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiJFSM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 14:12:27 -0400
X-Greylist: delayed 16468 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 Oct 2022 11:12:26 PDT
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9799B86B;
        Thu,  6 Oct 2022 11:12:26 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665079944; bh=7ra4FxyMkrqZBjrGfQluuyoTdTJeQ8fbwvA0RTXTY1U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=vEbY2xBJV9JNAureEVzACRYpoGLB9tJBkLEZ7MxkQOBuezTLoAobrEF2Psk3es9Zt
         j3lGKDsWf3x1GdCmYkzzKbO/yDnP2xq0x1yWE60V2qqWM/BdCzkqTgEdktKoUkKbto
         QtnIOEk9d7fWX220sVHb22g6iDulzDd1liK5uhPWFBu0B9bOg74Ssm4MMHA5+1++hZ
         qesyhTgvaUubUdo7WHbyKaFIXjRnBDHXQWByCHIwJE++L30/aFDjPfqD2CNmwEFyKX
         IGs1tXA0N3LMfknvQ+yoUtCSz0FrNxAcG6lIcCNUIWQAgGgEYs2P47BFPh2XGKjWVb
         +JA/dkN64fTRQ==
To:     Colin Ian King <colin.i.king@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Make arrays prof_prio and channelmap static const
In-Reply-To: <20221005155558.320556-1-colin.i.king@gmail.com>
References: <20221005155558.320556-1-colin.i.king@gmail.com>
Date:   Thu, 06 Oct 2022 20:12:23 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k05ces8o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> writes:

> Don't populate the read-only arrays prof_prio and channelmap
> on the stack but instead make them static const. Also makes the
> object code a little smaller.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

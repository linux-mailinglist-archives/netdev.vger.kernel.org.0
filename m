Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64392529F61
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbiEQK1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343929AbiEQKZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:25:09 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A7D182;
        Tue, 17 May 2022 03:24:33 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1652783072; bh=4NsMZH0iSGXiN/MjWHJRukAiwqP9eAfEKGtYlhI1X8M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bXESjwSXOba8zLy/g5zj29ZEl0pCaDX/d6sdqyGgElBYYKXZiDnPjNwoPpYNmI5F4
         pe7KpZ04y6ncl0ZlzpUyBBSQ4FkEABaPfSybvvH/lZHM8XXdBEePUoFYjuQWbjnECv
         JCE1bioYK7Jzvt6OuTv1wuecXeK73bAKBXA7NWtChcyUv2HimMlPPyG4tY2s4oMyXo
         z0Fp4wozyWSOhw5sgmaWv7YfYeKoZTa5ZjvXe7mKp46KbR3Zq4J7mSDfVlzjHocezS
         OUZkr3mhTw1tRIviqsN5zv4CFXZUf8ThtUY+4HoTb0T6BOLsIyuvPK4KRMH1nrG8qO
         9KG9HodwfmpLg==
To:     Guo Zhengkui <guozhengkui@vivo.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:QUALCOMM ATHEROS ATH9K WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: Re: [PATCH linux-next v2] net: ath9k: replace ternary operator with
 max()
In-Reply-To: <20220517024106.77050-1-guozhengkui@vivo.com>
References: <874k1pxvca.fsf@kernel.org>
 <20220517024106.77050-1-guozhengkui@vivo.com>
Date:   Tue, 17 May 2022 12:24:31 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wnekbgo0.fsf@toke.dk>
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

Guo Zhengkui <guozhengkui@vivo.com> writes:

> Fix the following coccicheck warning:
>
> drivers/net/wireless/ath/ath9k/dfs.c:249:28-30: WARNING
> opportunity for max()
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

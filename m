Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430CC511348
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 10:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359323AbiD0INL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 04:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244734AbiD0INK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 04:13:10 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEC2237C7;
        Wed, 27 Apr 2022 01:09:58 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1651046996; bh=8IZuHw4VAQpc/c5fMYUJkTAtA9Skb0wCA70zXBoZJbw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BS81t7rBba7fCg16X7a51opdR1lsHAkf7hUUhYyD3R/Jlc1R+j6Foq3r9IXkSSoMd
         omMpa7b2/HEraedpY7QHRmIfyiMfBh6DfT/U85mj2PzqdYXYACBNKyC9kM6y6hIcqb
         sch64TPDLRgoWPJGI9BBDQoM2DzY5er1IZtlEvbp3IoKOO9FDirPJbQGLFZNWtmQxF
         aAF4zV0d2UpBNpzznyip3DBopjIjXtKCjmzcio3rG9t0rYRhy5Qy00CBZSA+TGgE+C
         a1toMfCakwBblzLBXtr9LWQA/Qzf/1B1dvba+tesey/Vx+ONnXm815pg8RjB3GdSiT
         jP4wlWD+qIkKw==
To:     Wan Jiabing <wanjiabing@vivo.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: Re: [PATCH] ath9k: hif_usb: simplify if-if to if-else
In-Reply-To: <20220424094441.104937-1-wanjiabing@vivo.com>
References: <20220424094441.104937-1-wanjiabing@vivo.com>
Date:   Wed, 27 Apr 2022 10:09:56 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qxjhrqj.fsf@toke.dk>
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

Wan Jiabing <wanjiabing@vivo.com> writes:

> Use if and else instead of if(A) and if (!A).
>
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

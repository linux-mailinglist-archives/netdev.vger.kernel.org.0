Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC606EBF21
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 13:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDWLac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 07:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDWLab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 07:30:31 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EA6E71;
        Sun, 23 Apr 2023 04:30:28 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1682249425; bh=63yuq0Ao6sJ222teYsNEJzBjVE1L+9u9bftou1rS5A0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZxfCWlctAwrKIy7L3PuKsDVgrAgnIuBDgwB/a6fJQip9LH81irot8gRWOtoysN0Hm
         iuklYzPJhI2wV7+2Vmhw8UlqUdMyFXhwosue7SdugDGebeNoAArxtGHSjw1+1VqwWG
         QoDAfVxBES6Isd6QUMYwIobeJt3JjGTkdBzHo5DrPfgfkrELfnUrkX7oMDzYA4nmrc
         mLhhvh1l7jfHlIbgxy/Mhx2IiW4VJHQtrmSL+GPS40ESnjpkomzRcJSDT0Vu0zAngL
         mJZD8y92PNtNLNMxTSsecp+9SesyLbUwJSI6eRvyHPia4qAAleCgiL8n+VTG1TZ9pF
         HrvvnNBWnnd1w==
To:     Peter Seiderer <ps.report@gmx.net>, linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>,
        Simon Horman <simon.horman@corigine.com>,
        Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v2] wifi: ath9k: fix AR9003 mac hardware hang check
 register offset calculation
In-Reply-To: <20230422212423.26065-1-ps.report@gmx.net>
References: <20230422212423.26065-1-ps.report@gmx.net>
Date:   Sun, 23 Apr 2023 13:30:25 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mt2yltta.fsf@toke.dk>
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

> Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
> calculation (do not overflow the shift for the second register/queues
> above five, use the register layout described in the comments above
> ath9k_hw_verify_hang() instead).
>
> Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
>
> Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
> Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F017=
7FB722F4@seqtechllc.com/
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>

Alright, better, thanks! Let's try this again:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

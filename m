Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206A165C1FA
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 15:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbjACOa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 09:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjACOaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 09:30:21 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15996B02;
        Tue,  3 Jan 2023 06:30:19 -0800 (PST)
Received: from fedcomp.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id A1B4340D403D;
        Tue,  3 Jan 2023 14:30:13 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru A1B4340D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672756213;
        bh=N59c1duLzzGpv+jk8LWJbX3Ft6CM71tskdCAVOE7edE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eS0hPc30V0YuMmrRNlRwKoGEpyCa0ZY7MbDMh2NU3Ak2xFoXmz0kU2Dhj/k4K/VW4
         GVthZ4vkyX8fk0OBQ4Ha/ekvV9JMVcNJRysi2Sb5abzq18GgcUU6Zyq4ZFPIgmhfof
         jgoJRKZ3MRZ2T1HfBwlf/eX0YThM3gqdz/X/GPFs=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails
Date:   Tue,  3 Jan 2023 17:29:40 +0300
Message-Id: <20230103142940.273578-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <87h6x95huy.fsf@toke.dk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is this the same issue reported in
> https://lore.kernel.org/r/000000000000f3e5f805f133d3f7@google.com ?

Actually, this issue is fixed by another patch I've sent you recently:

> [PATCH] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is
> no callback function

I've added the relevant Reported-by tags to both patches and resent them.

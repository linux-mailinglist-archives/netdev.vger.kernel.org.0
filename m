Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4243965C7F8
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 21:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbjACUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 15:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238360AbjACUSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 15:18:50 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A70140AD;
        Tue,  3 Jan 2023 12:18:47 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1672777124; bh=jXEomOxxc/HS+MsVqfL2IBvitZSrkEkYqHeJcArd848=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OT6nUvLMrGdo4suJLlBGdZpd416Xyz3LcSWcHInsbotVujn9orDYUVMGKy7tmZ+EZ
         cmkz1SJtMx/iYX9CVFyle4mpUfuZxhyod7kgUulerloDDFm/FmeHFTRcdBto59FIGv
         lnQPDkXh4RkCTbGhp7xlCmW11Ddsptx71rOSTb4zH9QrliHnm4vep4sMDjTfxGwvyF
         dxMI9qKkKTD9vToTC4H+XWysPUbZUBa6dYfZhWt1okYr0BE+RcnTxPFAfWlL+VfcT2
         GZtkWLTV0DZ2WQbNqe/G8JP4fmWOtpwQaISejm/9xBuX4RSepzn3qLiN1pAzS2taya
         mvn/fzK0snYjA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
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
Subject: Re: [PATCH] wifi: ath9k: hif_usb: clean up skbs if
 ath9k_hif_usb_rx_stream() fails
In-Reply-To: <20230103142940.273578-1-pchelkin@ispras.ru>
References: <20230103142940.273578-1-pchelkin@ispras.ru>
Date:   Tue, 03 Jan 2023 21:18:44 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878rij4biz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

>> Is this the same issue reported in
>> https://lore.kernel.org/r/000000000000f3e5f805f133d3f7@google.com ?
>
> Actually, this issue is fixed by another patch I've sent you recently:

Ah, great!

>> [PATCH] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is
>> no callback function
>
> I've added the relevant Reported-by tags to both patches and resent them.

Awesome, thank you :)

-Toke

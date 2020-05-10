Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986241CCC6D
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgEJQxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:53:41 -0400
Received: from sonic302-36.consmr.mail.bf2.yahoo.com ([74.6.135.235]:43881
        "EHLO sonic302-36.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbgEJQxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589129620; bh=Zt9NInXQx6m+UnQYkzUOjjtOOgPXZOTsh/eoelTXJIs=; h=Date:From:Reply-To:Subject:References:From:Subject; b=XP8SLhO0u7KL+84c6tYVbGHLoPl7qYX69vkVfjM38UubAlJXCwiwUebJKhI25Yy3NroV4x8gVOBs1RPXSufb/G472fw9P2F9HNNUiG+oSHnk+QpZ3rICscFJS8nakK6Yih93/5Xnecr0Ka423WksCKgsq6NxbmEiw55371Jj8n9AbJSQl5gtNK/4Ry7lXLCXAhaXDSbMy5jEgoDcCcXQK1ghQCsmnT1pSK2XA02Y9AoaUv2bZZOLwl/NGy7ZVcTzbBho9jfYJIwfZI02g+eo/A6R51f6zQ95MAAbi3/oGicRAfWCaud468p/g5xQNTDd6YLx4rincK9koFXde+RbGQ==
X-YMail-OSG: G2iidcsVM1mwmhjwgur5f.b7CKqLboWzWr02cMSmt7L.CyL_wnKMqd.FsaPkz65
 Z8nDIv3i.gBQpy_YS8ecrthZd.3eb4k7Z86Z4Q1BNe1u0OcvjTlbJDQo9ztuut1p0sqxYMkJVNEU
 F3bmhkPKzhF4eD61AwbAJKZ0wtx3xxWR70xCaQj8fUeDHA15fK52fBoaSQtKgGFhPXJYYryJuAV.
 434MQW6yax8908BPUJFHUbMVzm25f_Xm72yA4AHqXnbcawuOywpnh3zdIz_mkYbqpOU6uYQFJHf9
 UCObq4EE2rX7Qpa2jLrMictUMT5IE3y1xECQiy7l5YW1uvj0CWjSezVaGvRvzUG80Z.tpu_igfqk
 BFt_WFaaz7MqqeH0JdkeXNkxIsiU9u2Treg5SYWumOKVz2sRT0FgU0vkhiqOuaqs2gtLONbX_Ioa
 4ZvSNkB9M4alGSYKkM1y7nEJzphVvllLZQZkVsb5Z7bcc.d7eTt.sCxBWUr4Uvl3CoKceRJTJKt1
 Y9WGTewSCrfwa5YFlnPWETOpFYiqBUSnrg.q15zjny7qa8PUz5ulHFceipBKrLQ9BKsUPJWmRTme
 .H4rdnyRN9NJeOWsC1Lce9qe4Eyk0b0UZE4h8lHM6GfWMBoPk5ROrsGmIKptu0.kBnFPtfvG.ji2
 s_l82fUE5Ce4Jk7bzoA3t6P.E5yWfD4xB9YyAVVp7324lkyg.P2lApKpgEamD88UV_8RmF9xRALE
 .xLVJQuWjqtRkZxzuOagT0YqXnbpP9dwhzluSyBbqw6PKVFXrADF0eD.X_K9WFzNflN9DUv6Qp2i
 8Ji0pTN0o2QLdm_cpWW2t.zFT3oMCqBscx5U5nd6SOO1aXvwJELSnoFTtMqEsUfnircK9yZRdodw
 lV5HIK7w6CAF9I2WbonwRCAw2p5yLLr.HU5gjVurBXsvHPPGI0yz2KGMde1YT6C.gFPh1QUkJqKY
 N_nQ97oJpsvvtubcQ4C4GhLac3sao6xw0_gorXhn9dfeYOxV3ycaB2yvmpXRUBb8wAw72QtxoL6H
 a6K_QlYYOYY21bpFaLmfUqpiV_N1xwNNvjfF3SW1c5O2J3uElfNgLfKEoEvjRqS.A0paPcj4nmKc
 b6p9APGQJON_aK3iCXmeUgqHGbRQREpps9N9OoJqrTNV0bEM9XCM0HzM7visly1aGl1iLeu7Ekh1
 GS_QFg4wsK2sjQiQmwRuMf7DNrzIPbx6XA.4f6SmJzzhHjaNvktu4hsi4yLUh5a4cWXnW5Q42WU7
 sM9fFfOmBtbQwRKV9Lqib5CSkpFYEgx1zNlCba1HT8.B8H4alvQtq9SGY7xT3tum.5BsGn3mS7re
 3zkWmAEaTnt.LG1ZR.Q94AGn0Lj21KA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Sun, 10 May 2020 16:53:40 +0000
Date:   Sun, 10 May 2020 16:51:39 +0000 (UTC)
From:   Stephen Li <en37@bcutm.com>
Reply-To: stephli20080@gmail.com
Message-ID: <1344017654.362142.1589129499897@mail.yahoo.com>
Subject: Ref
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1344017654.362142.1589129499897.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15904 YMailNodin Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Greetings,

I was searching through a local business directory when I found your
profile. I am Soliciting On-Behalf of my private client who is
interested in having a serious business investment in your country. If
you have a valid business, investment or project he can invest
back to me for more details. Your swift response is highly needed.

Sincerely
Stephen Li

Please response back to me with is my private email below for more details
EMAIL:stephli20080@gmail.com

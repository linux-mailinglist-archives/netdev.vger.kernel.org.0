Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15EC519000
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 23:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbiECVUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 17:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiECVUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 17:20:52 -0400
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0365640915
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 14:17:18 -0700 (PDT)
Date:   Tue, 03 May 2022 21:17:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1651612636;
        bh=/0vA9ZHk4nsZ0nCXCjLXR4yS03kjJuP+2lBwjcWkdXE=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=aJ1ZgPcJ65nOsqK7ExE22Smle/lqrYGbDdj6OPcm39fYQWRKkRMQR+GP5Eh3dn0ml
         CN0YoHydSjz6UTrdfC/8UYeH1ImXW6HU6vI1EvXdhGnMX/47c4d0uOw+zEwVHd7orf
         h7d6LByhwtn1cqScJGYsp3sn3NCIxp2MuQmo91KqbY3q4NGfFBHED5deH0YqeAA/Y4
         96B2+13mb9I4Hdh9gpzK7RQbFAE7O4K+2tQzwIXtrTVz2h9ZBuSW38zEALj5aB3JvG
         EUifxFReuyQuYuPlaJkukVq5MjzSuotz5ZPZduw+ClRF33CdmhNVifSN1AughSGNsP
         nIkJFvhNd+ASQ==
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 bpf 00/11] bpf: random unpopular userspace fixes (32 bit et al)
Message-ID: <20220503211001.160060-1-alobakin@pm.me>
In-Reply-To: <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
References: <20220421003152.339542-1-alobakin@pm.me> <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 20 Apr 2022 17:40:34 -0700

> On Wed, Apr 20, 2022 at 5:38 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Again?
>
> -----BEGIN PGP MESSAGE-----
> Version: ProtonMail
>
> wcFMA165ASBBe6s8AQ/8C9y4TqXgASA5xBT7UIf2GyTQRjKWcy/6kT1dkjkF
> FldAOhehhgLYjLJzNAIkecOQfz/XNapW3GdrQDq11pq9Bzs1SJJekGXlHVIW

ProtonMail support:

"
The reason that some of the recipients are receiving PGP-encrypted
emails is that kernel.org is providing public keys for those
recipients (ast@kernel.org and toke@kernel.org specifically) via WKD
(Web Key Directory), and our API automatically encrypts messages
when a key is served over WKD.

Unfortunately, there is currently no way to disable encryption for
recipients that server keys over WKD but the recipients should be
able to decrypt the messages using the secret keys that correspond
to their public keys provided by kernel.org.
This is applicable both to messages sent via the ProtonMail web app,
and messages sent via Bridge app.

We have forwarded your feedback to the appropriate teams, and we
will see if we can implement a disable encryption option for these
cases. Unfortunately, we cannot speculate when we might implement
such an option.
"

Weeeeeird, it wasn't like that a year ago.
Anyway, since it's address specific and for now I observed this only
for ast@ and toke@, can I maybe send the series adding your Gmail
account rather that korg one? Alternatively, I can send it from my
Intel address if you prefer (thankfully, it doesn't encrypt anything
without asking), I just didn't want to mix personal stuff with corp.

>
> Sorry I'm tossing the series out of patchwork.

Thanks,
Al


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA077589D23
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbiHDN5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 09:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiHDN5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:57:45 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6621ADA3
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 06:57:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id E0526221;
        Thu,  4 Aug 2022 13:57:42 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net E0526221
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1659621463; bh=+V6iCwO56KFY3GnNQJKuMBxEUOxKYuSjeoQZQEKM58o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rOrv/Mh3CSDL0zA/ECoj0Az9F/uw6Abx6NTSuTiXIDYgmsWIriiwwPmjGy0ocCLtn
         +EqgLD05h4e51O2zzPSPINrHE15ERmjQdacqMz8Ihj79lLhWe8s+st/SfTiqDKTDql
         O2fZZ/4l/RsEkplCYQ4jfBjQQ+X2k7HA5WdnMy6CVsbuO2SifC1ciOdpY+m6KRHAiH
         VhIpezTG0CNaLIbYeSW4S1zyu9nSKFKqTh4sEXwF/MYLbgS2hICY/RWHCujXDf9K4m
         K96kF4VGViEWjf+vvSfoRpF6z7M5gRr9oiPZgR+4U0E++Lg6daU4+pDpTeBwnV5ELg
         Y4u6Q1XRmRzjA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Adel Abouchaev <adel.abushaev@gmail.com>, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        dsahern@kernel.org, shuah@kernel.org, imagedong@tencent.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC net-next 1/6] net: Documentation on QUIC kernel Tx crypto.
In-Reply-To: <20220803164045.3585187-2-adel.abushaev@gmail.com>
References: <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
 <20220803164045.3585187-2-adel.abushaev@gmail.com>
Date:   Thu, 04 Aug 2022 07:57:42 -0600
Message-ID: <87tu6scdrd.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adel Abouchaev <adel.abushaev@gmail.com> writes:

> Adding Documentation/networking/quic.rst file to describe kernel QUIC
> code.
>
> Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>
> ---
>  Documentation/networking/quic.rst | 176 ++++++++++++++++++++++++++++++
>  1 file changed, 176 insertions(+)
>  create mode 100644 Documentation/networking/quic.rst

When you add a new RST file, you need to add it to the index.rst as well
or it won't be pulled into the docs build.

Also...this all looks like user-space API documentation, so might
Documentation/userspace-api be a better place for it?

Thanks,

jon

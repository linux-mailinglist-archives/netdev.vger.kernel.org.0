Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3C45788C2
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiGRRtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbiGRRtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:49:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F8C2B608;
        Mon, 18 Jul 2022 10:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=SAGZqlv/8Ekeq7cG9+dcrh2VR2Q3Mh2/2a+2GmOEZ38=; b=led+XNtZy4DOs8zGSGMdVKgQCV
        o+5rhsSbXAm1WD2ABinuR6B/vzR+DxKu1xY2yskOvMGlItwad7UQlrx8JsMSDoEIk0HxBoQ50tOP1
        qKfDzBoyZw5BC6ybQrsPm1RR0XHex0ddNvhvIBgG22T0t0DPNqbA2iXyXe/2+/4mkFQMoSC2NRiQH
        qzD527277g92Y+GLhDfAo/KrQb/iLwAeA4WcyHmLwvlOGN2RNpAGcd4dwWlre2/SiBpdv+VtsdndC
        3wp1IUoMOezYiZ4u/0YrTtQBu1YMP8fIumHHg1fxZqpN7Te6S8beExSl/LfCjnNKR8a3QGdxy1Dfn
        GaCkBJaQ==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDUrl-00HKCn-4Q; Mon, 18 Jul 2022 17:49:09 +0000
Message-ID: <e90e0d6e-b4e5-b708-a431-cec27379bf51@infradead.org>
Date:   Mon, 18 Jul 2022 10:49:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/2] crypto: make the sha1 library optional
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jason@zx2c4.com
References: <YtEqWH2JzolCfLRA@gondor.apana.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <YtEqWH2JzolCfLRA@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/22 01:50, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
>> This series makes it possible to build the kernel without SHA-1 support,
>> although for now this is only possible in minimal configurations, due to
>> the uses of SHA-1 in the networking subsystem.
>>
>> Eric Biggers (2):
>>  crypto: move lib/sha1.c into lib/crypto/
>>  crypto: make the sha1 library optional
>>
>> crypto/Kconfig          | 1 +
>> init/Kconfig            | 1 +
>> lib/Makefile            | 2 +-
>> lib/crypto/Kconfig      | 3 +++
>> lib/crypto/Makefile     | 3 +++
>> lib/{ => crypto}/sha1.c | 0
>> net/ipv6/Kconfig        | 1 +
>> 7 files changed, 10 insertions(+), 1 deletion(-)
>> rename lib/{ => crypto}/sha1.c (100%)
>>
>>
>> base-commit: 79e6e2f3f3ff345947075341781e900e4f70db81
> 
> All applied.  Thanks.

Eric,
linux-next-20220718 has a build error:

ERROR: modpost: missing MODULE_LICENSE() in lib/crypto/libsha1.o

-- 
~Randy

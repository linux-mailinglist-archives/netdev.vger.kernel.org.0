Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3833964F20F
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 20:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiLPT72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 14:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiLPT7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 14:59:15 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E5C31D;
        Fri, 16 Dec 2022 11:59:14 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id r204so1632301vkf.8;
        Fri, 16 Dec 2022 11:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bp4UrwiDexefxjJldtrtiUBYkOKYxvyFu/xhEFJrl5I=;
        b=hZM+K+SsXSgV07DzOYpZfm3OfRLz0nrSeTliLzQ4sTojhJgcpPHgwWAgwrAsMNdLnn
         Mib0ztbGYdpGejA/3mfGIbmS3E38xJAWqKVBb9Nlk83ThvImdRLxLbE+GoEt8X7HHNGs
         fAkmwqhfCGSETQvW47XRN/zUMhCYP6zDdiblkGDwdoZlOTFLXGE0koYntAx1nejgZbxa
         zUb8WuVU23WMEo74RNrszzwSsXjxyEc3Bvp+orHcVJC3O6tOtL2sE5Ie2ZNLW5S7zgxj
         WCzl9YnE++g+I0JG55p7YvGP2ZVLT/qQ44hj+glPMm1maNGhGBj2pNrwOjZeLFtGCCMS
         YDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bp4UrwiDexefxjJldtrtiUBYkOKYxvyFu/xhEFJrl5I=;
        b=Ek7SpwlyfQS0mnhHyqijHjDgCL/SmA0x3jHLa1Tr0Ltmeud3zwJVBi3oGosf+yfS8G
         N0TuvH4I5j2sD4ac+wjKstgUzygAvKmzNcYkeqorC2NYN0X1v7075XCuQJlKB7wb4pRe
         WaIasPu/wynoPJs7gpjOVDI3F+333jFTaVdixtedlCyQhLTHItkHKFMmlfH0rmxQjFP6
         zlbYhnabE2AkZHeAa8ZnwMKIOIp2m0U7iETE3P8ymQiDaUP7IMrVbKlG9z8j+5HIHOFv
         kdZFNiJ8xpS9NsbZfvxMpEqk17FQn6ZFheQ/cHe5GTwnHcGh8Hyqa+fY7Ve/oiLuIbiB
         oBkg==
X-Gm-Message-State: ANoB5ply0EMPKE/B0bDMgrBmjqMJ8w3BnOX/u6d7fad4xc+lBYpzOCmm
        nLNwarBwA4sx30jbSHvDBvmz+NvlZ+eeZQ4o3Kq/12wJByln9w==
X-Google-Smtp-Source: AA0mqf7lDVhxar3LdgqZrWvNaMk4Ms0l935/pG6uF+4v83/LuToGWQImpJ8SsHpYVqjW4c0bCv2GA3H2mcjItYew3I8=
X-Received: by 2002:a1f:2dcd:0:b0:3b8:8bcf:e5ec with SMTP id
 t196-20020a1f2dcd000000b003b88bcfe5ecmr46406150vkt.19.1671220753074; Fri, 16
 Dec 2022 11:59:13 -0800 (PST)
MIME-Version: 1.0
References: <20221212071854.766878-1-tegongkang@gmail.com> <b98e8a7b-0610-6fd2-1b51-5feca73f79ef@linaro.org>
In-Reply-To: <b98e8a7b-0610-6fd2-1b51-5feca73f79ef@linaro.org>
From:   Kang Minchul <tegongkang@gmail.com>
Date:   Sat, 17 Dec 2022 04:59:02 +0900
Message-ID: <CA+uqrQAOwd+dV=0rK2Rqacd+=nU8ty676SoVecHCuG=QTY+bZQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: ipa: Remove redundant dev_err()
To:     Alex Elder <alex.elder@linaro.org>
Cc:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your precious feedback.

> The current version of net-next/master, as well as the
> current linus/master, do not include the message you
> are removing.  This patch removed the message more than
> a year ago:
>
>    91306d1d131ee net: ipa: Remove useless error message
>
> So at least the portion of your patch that removes the
> message is unnecessary.

Yes, I think I mistakenly worked on the wrong branch..

> Meanwhile, it seems there is no need to check for a 0
> return from platform_get_irq_byname(), but there is
> no harm in doing so.
>
> If you would like to send version 3 of this patch, which
> would return what platform_get_irq_byname() returns if it
> is less than 0 in gsi_irq_init(), I would be OK with that.
>
> But please it on net-next/master.

Ok, I'll send v3 of this patch soon.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E62A64CE43
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbiLNQoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLNQoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:44:12 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A417434
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:44:03 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x2so2600715plb.13
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYptZGTg2VQZsX4X87+pAXv+Pcob04z/xWY8jraQHOE=;
        b=lCU6gsy8TuMv2XvuFnED0f5nKcEIsTexB8mGh6Agks7j373j6hk4edNNBFixPJfc/T
         JsVHEMVbnf7C/48jC1YNKwS5hHX4+dM1w34dhCeXV/y3GBWoxcUzhti/i4u9g1qcmre5
         i9DOXpm32dYRYT0amKQ17FJqjPWT9STfxJXCI6etCAPGxknosJZ23uQ+cSui29QOzwE+
         axdL7EN+VJjIUkqocIamlOa0qAGaLBEnATbazeChQh3SZxT+/XZsI3TiIvquzh8Myn3Z
         F/Dzr7oGqZPJTL5Kv9RjiMBifsb+G3xW50P/5GQRzhOjc+4YL13bAIiZv+LePcLHZgSt
         d2Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lYptZGTg2VQZsX4X87+pAXv+Pcob04z/xWY8jraQHOE=;
        b=vBny9QttwBhHtaBhvxe88okpRSYit7BwmzQmspLob2G8Xh/ydT/6+5wMoUUWFuGZ3u
         PqWl6oqudB7gEYaK8M8byrv4uhAK/wdxefVuqYMZUqOesh4Rl+9VusyKpBHNmsDBy8G5
         5xOrAdn+CJYGxGVoOqcY68IXq4zIXrVPayzXL+V1gFeIDPrKZVmZ3z2q0d46BgxS4PBF
         apubEhuN7NOOZUHnmbtO6xGzWSf4EmUN0Tg7sOXYiIKdkXEAT8IpGZeQmvHq7j8ybtyf
         7QYgLH0y/GmGY6ISoIVIDyPf+b3IO4Cbbz1zbFewLp4sQDSt7/5X5NVKgJtcxyJRszp6
         NlSQ==
X-Gm-Message-State: ANoB5pkD0NkBYtCkDEmEUIpRPqwuqoPuBbFDFZL+24MRVx0hrqhPjiAa
        6liCN9vKmo6ATDPmE3J3N0596AjVwH0=
X-Google-Smtp-Source: AA0mqf7DAziCSR/mCwrTJu8odu8FaHLzVg8uHuHE6PGW3VTo4gE+zvAwzgjGmXRcPuclkbc0sB0/tA==
X-Received: by 2002:a17:902:7004:b0:188:760f:86de with SMTP id y4-20020a170902700400b00188760f86demr25977483plk.11.1671036242991;
        Wed, 14 Dec 2022 08:44:02 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id e8-20020a170902784800b00189db296776sm2135943pln.17.2022.12.14.08.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:44:02 -0800 (PST)
Message-ID: <5b837adf6f912cbd152d42b1ef0271c58d6e3690.camel@gmail.com>
Subject: Re: [PATCH net v2 0/5] net: wangxun: Adjust code structure
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        mengyuanlou@net-swift.com
Date:   Wed, 14 Dec 2022 08:44:01 -0800
In-Reply-To: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
References: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-14 at 14:41 +0800, Jiawen Wu wrote:
> Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
> And move the same codes which sets MAC address between txgbe and ngbe
> to libwx.
>=20
>=20

I am assuming this is for "net-next", not net since this doesn't look
like fixes but more like a signficant refactoring change.

So you may want to change this to "PATCH net-next".

> Changelog:
> v2:
>   - Split patch v1 into separate patches
>   - Fix unreasonable code logic in MAC address operations
>=20
> Jiawen Wu (5):
>   net: txgbe: Remove structure txgbe_hw
>   net: ngbe: Remove structure ngbe_hw
>   net: txgbe: Move defines into unified file
>   net: ngbe: Move defines into unified file
>   net: wangxun: Move MAC address handling to libwx
>=20
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 116 +++++++++++-
>  drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   5 +-
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |  12 ++
>  drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  79 --------
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  21 +--
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   4 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 125 ++++---------
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  58 +++++-
>  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  43 -----
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  36 ++--
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +-
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 174 +++---------------
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  22 ++-
>  13 files changed, 296 insertions(+), 405 deletions(-)
>  delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
>  delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
>=20


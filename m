Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB486665CCB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjAKNkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239317AbjAKNkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:40:07 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F661BC9C;
        Wed, 11 Jan 2023 05:38:05 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 8F7A7586A6705; Wed, 11 Jan 2023 14:38:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 8EAB9616497A1;
        Wed, 11 Jan 2023 14:38:04 +0100 (CET)
Date:   Wed, 11 Jan 2023 14:38:04 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
In-Reply-To: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
Message-ID: <n9108s34-9rn0-3n8q-r3s5-51r9647331ns@vanv.qr>
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wednesday 2022-11-23 13:46, Greg Kroah-Hartman wrote:
>
>The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
>any system that uses it with untrusted hosts or devices.  Because the
>protocol is impossible to make secure, just disable all rndis drivers to
>prevent anyone from using them again.
>
>Windows only needed this for XP and newer systems, Windows systems older
>than that can use the normal USB class protocols instead, which do not
>have these problems.


In other news, someone just proposed adding "RNDIS" things to UEFI, so 
now the security problem is added right back into machines but at 
another layer?!

https://edk2.groups.io/g/devel/topic/patch_1_3/95531719

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EDB52BC49
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbiERMre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbiERMrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:47:21 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C174A1BDAC4;
        Wed, 18 May 2022 05:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652877930;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=DALuquiPTpvakZ1hsawCfe1qGQYKJ9d3gJZOL4yRbi8=;
    b=I1+RBVUa8+5UKOMUJ7PRni8lMXTd8Grq9ftk0o0fZiHn90/WTNWd5Ra3/0hJYTkTdN
    vs4ncegtSSOEjLjbXPod2389zZSu2PcokzwYA63a1OxmUjFzlUPS2Gj6pK5s3uJn1UY4
    mXPVtZ1YEdXZ4IzE94fa1zlDxTmxFogra9qG65e8myFUPkj/uIBn0BCMRUn8dJfXMJJK
    gPmcYFjbijLxJwf2CRZfn2/kQqa1/m3WRrHwou4Lj52fAhCdVg/ZURWLfrNurVRYMRtC
    XycNcyX6w1YxOlLOrLG9sjD2bKvRwr5FzEnBZhCb1O1TTycIoUD5rk1nVBNZfEc4fHY/
    Ozww==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4ICjTHPh
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 18 May 2022 14:45:29 +0200 (CEST)
Message-ID: <b76ed65a-cc3d-ae75-e764-9ce627dcb4c4@hartkopp.net>
Date:   Wed, 18 May 2022 14:45:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Device Drivers: (was: Re: [PATCH v3 3/4] can: skb:: move
 can_dropped_invalid_skb and can_skb_headroom_valid to skb.c)
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Max Staudt <max@enpas.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
 <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de>
 <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
 <20220518121226.inixzcttub6iuwll@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220518121226.inixzcttub6iuwll@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.05.22 14:12, Marc Kleine-Budde wrote:
> On 18.05.2022 21:03:37, Vincent MAILHOL wrote:
>> On a different topic, why are all the CAN devices
>> under "Networking support" and not "Device Drivers" in menuconfig
>> like everything else? Would it make sense to move our devices
>> under the "Device Drivers" section?
> 
> ACK
> 

Bluetooth did it that way too. But I feel the same.
When we clean up the CAN drivers moving the CAN driver selection to 
drivers/net/Kconfig would make sense.

ACK

Best regards,
Oliver


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B4259C148
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbiHVOEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbiHVOEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:04:35 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F451A388;
        Mon, 22 Aug 2022 07:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661177057;
        bh=KKlnF744REi+KXU8Z42CcSkssCQpSuQOE0GMi0L8A88=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=X6zdPRrZDDL71sZxx+U/HbX+4NRtZwapnX9FmFueHM7/6uUzOp0PYKCtSTtxSY72/
         his3BzhBIElH9U1/bvpTe9g75r2M1lI6uIqzU+cgEmgzy3cCtcKvwvWp62gNi6/sWW
         UdbftjGwDmUclT6+NxUn7KFCVOYI4vK37eaP/Ybg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.225.169] ([157.180.225.169]) by web-mail.gmx.net
 (3c-app-gmx-bap06.server.lan [172.19.172.76]) (via HTTP); Mon, 22 Aug 2022
 16:04:17 +0200
MIME-Version: 1.0
Message-ID: <trinity-de687d18-b2a2-4cde-9383-a4d6ddba6a77-1661177057496@3c-app-gmx-bap06>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: help for driver porting - missing member preset_chandef in struct
 wireless_dev
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 22 Aug 2022 16:04:17 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:hgASkb09pfesvelog8ZkgE4rV5u+bEnCu7e8VGQkmVRhIZrJHVhavcYCaATtuRtgXaDGM
 S9CIQ6b7SKnqhmFaCDfyrntpURw2XgUnyEN+j+Zx6otTDLrE7LAbrFEDox+oadjGVaiiRna5zB0G
 VZe2vqt1uF6aawraXcQOx2c88dARZO7ZTjjQCD6x+e5gDqX7bcNEt+4uIIAPb+45qqW7a1XIyykR
 feOuV/VXug7tqKPQXn8ESdFySu2QeixF8lxbXIxDPGAEB+2hHKORxbLZi9yIBzv0UvVbksLs2ano
 lo=
X-UI-Out-Filterresults: notjunk:1;V03:K0:PIHFt+LmGLA=:uOIlu4G5NfH6TuHa61rQZ9
 hSrZxbkZEUbHkM4d0mMUHI8xpivw119CiI2pep+rMnxcGKR456Jetf/LEX25FOzGUXyDTbpVw
 x+zd/Nfdz++cAjBGQlxOe4T5uO5ijiszCwg2s1wvybhZDfoo+Rqh/Bke7usWHvbKXRiLdnn7P
 3udfX7ymOo7qf/L8UNQ/JemX0g0OjhlG4vZKEE4UpmCtseuiVyqCWenT98lfdSh5/3T5Gdmae
 hL6nj4ic30GlBlDza+OZqMpVXpu4auHZZuWFOWICSSIDOC/wIT1BuFLJCPoNmo9ndTZigp3zs
 CV2S+PUxLx0Zru+3wzlT2m2Evn7Rr8kDHGnYWMMURmeH42qFzpFDvLAXezmyR/2k0EnIUp6m9
 mjKcuJdhLLQQKOEtyw01p7rZgmqzYys/8I2rEbGEJkOd7iFpQV0x6w7xhi1j3c1W7emnJJkq6
 1adtDj6skXBX4Wi8SzVerfrV5L9qAzV7xLDxs6oMk7TNHzQdjFzmIH7nR/+pPRG3SPKMfO33y
 Kyr0qWMDlQpTL4+J++ilQmHxU+6j2jvWVf3pQn1oFLvKEW6jUGOJazY/WcXWLrmiwhY0NufRM
 xL/tTld1YUZACBOn+auFzJyfLvWyGYTSbJgW9v05ydAW4j26oh3EyORrr562tIl7cqdcBuBxK
 dv+QokiL04SqvQ8/hENSgJ3aCD2V9lEp990BtZRGKxA2Gp1S5tWrUJKynGckhijtQ9W6LQJDk
 ebvXkMFvvjmWp4goFay0aP+MgUyLPIUYw1YFeN7PXB6QqLh377jWh8qrl/8p24srLJMoVRpSS
 zi+jik6
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

i'm working on porting an old/huge wireless driver (mt6625l) [2] to linux 6.0 [1]

i hang on missing member preset_chandef in struct wireless_dev

	struct wireless_dev *wdev = dev->ieee80211_ptr;
	struct cfg80211_chan_def *chandef = &wdev->preset_chandef;

it looks like this member is moved from the wdev into some mesh structure...my driver does not support mesh. any chance to fix this?

i looked through the commit which drops the member from the wireless_dev struct [3], but have no clue how i can adapt the changes in my driver

can anybody help me with this?

Thanks

regards Frank

[1] https://github.com/frank-w/BPI-R2-4.14/commits/6.0-rc
[2] https://github.com/frank-w/BPI-R2-4.14/blob/6.0-rc/drivers/misc/mediatek/connectivity/wlan/gen2/os/linux/gl_p2p_cfg80211.c#L582
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b0a0e3c3a88260b6fcb017e49f198463aa62ed1


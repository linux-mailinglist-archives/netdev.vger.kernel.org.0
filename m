Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D6A53B678
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 12:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiFBKAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 06:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiFBKAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 06:00:23 -0400
X-Greylist: delayed 91909 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jun 2022 03:00:21 PDT
Received: from smtp-42ab.mail.infomaniak.ch (smtp-42ab.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B49DE01B
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 03:00:20 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LDM2S0hckzMqVZ1;
        Thu,  2 Jun 2022 12:00:16 +0200 (CEST)
Received: from [10.0.0.141] (unknown [31.10.206.125])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4LDM2R1hVrzljk0H;
        Thu,  2 Jun 2022 12:00:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pschenker.ch;
        s=20220412; t=1654164016;
        bh=6clftNNkW5b/aLVfOs7w8oDA4IjZgT0jJnfYalkyXtc=;
        h=Subject:From:Reply-To:To:Cc:Date:In-Reply-To:References:From;
        b=MpfhxnUiBgc+nT3XyFNggIH4DEYXpuPFvnua6h7NJWilzYTT4MomXlytP5wDq6uDj
         lP3sLe/hjP4cDifzRVZiBGxdxaZ7YA99O+wL3SUKgDsOPJqSKmqd1p6tvJs6nj47Az
         BGEAbuMmyRoRhgzAiPemv/lhoB+iIXufekVl5a7M=
Message-ID: <75b5f888b2e23f52aabce54ff38ddc70d1ad6a34.camel@pschenker.ch>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
From:   Philippe Schenker <dev@pschenker.ch>
Reply-To: dev@pschenker.ch
To:     Deren Wu <deren.wu@mediatek.com>, Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux@leemhuis.info, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev
Date:   Thu, 02 Jun 2022 12:00:14 +0200
In-Reply-To: <da79fa2a94c435a308ea763efc557fc352d0245c.camel@mediatek.com>
References: <20220412090415.17541-1-dev@pschenker.ch>
         <87y20aod5d.fsf@kernel.org>
         <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
         <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch>
         <87mtewoj4e.fsf@kernel.org>
         <da79fa2a94c435a308ea763efc557fc352d0245c.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-02 at 00:55 +0800, Deren Wu wrote:
> On Wed, 2022-06-01 at 11:58 +0300, Kalle Valo wrote:
> > Philippe Schenker <dev@pschenker.ch> writes:
> >=20
> > > On Tue, 2022-04-12 at 19:06 +0800, Deren Wu wrote:
> > > > On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
> > > > > Philippe Schenker <dev@pschenker.ch> writes:
> > > > >=20
> > > > > > This reverts commit
> > > > > > bf3747ae2e25dda6a9e6c464a717c66118c588c8.
> > > > > >=20
> > > > > > This commit introduces a regression on some systems where
> > > > > > the
> > > > > > kernel is
> > > > > > crashing in different locations after a reboot was issued.
> > > > > >=20
> > > > > > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with
> > > > > > latest
> > > > > > firmware.
> > > > > >=20
> > > > > > Link:=20
> > > > > >=20
> https://urldefense.com/v3/__https://lore.kernel.org/linux-wireless/5077a9=
53487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/__;!!CTRNKA9wMg0ARbw!=
09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B99Q14J4iDycWA9cq36Y$
> > > > > > =C2=A0
> > > > > > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
> > > > >=20
> > > > > Can I take this to wireless tree? Felix, ack?
> > > > >=20
> > > > > I'll also add:
> > > > >=20
> > > > > Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
> > > > >=20
> > > >=20
> > > > Hi Kalle,
> > > >=20
> > > > We have a patch for a similar problem. Can you wait for the
> > > > verification by Philippe?
> > > > Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe
> > > > failure
> > > > after
> > > > reboot")
> > > > Link:=20
> > > >=20
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/g=
it/torvalds/linux.git/commit/drivers/net/wireless/mediatek/mt76?id=3D602cc0=
c9618a819ab00ea3c9400742a0ca318380__;!!CTRNKA9wMg0ARbw!zCYyDcufJ-OLqQV6leCe=
gA5SkNOOVjAIo-jzTHTk6HUWT9Gjt-bvSz8lr81Zv95u$
> > > > =C2=A0
> > > >=20
> > > > I can reproduce the problem in my v5.16-rc5 desktop. And the
> > > > issue can
> > > > be fixed when the patch applied.
> > > >=20
> > > >=20
> > > > Hi Philippe,
> > > >=20
> > > > Can you please help to check the patch in your platform?
> > >=20
> > > Hi Kalle and Deren,
> > >=20
> > > I just noticed on my system and mainline v5.18 reboots do now work
> > > however Bluetooth is no longer accessible after a reboot.
> > >=20
> > > Reverting commit bf3747ae2e25dda6a9e6c464a717c66118c588c8 on top
> > > of
> > > v5.18 solves this problem for me.
> > >=20
> > > @Deren are you aware of this bug?
> > > @Kalle Is there a bugtracker somewhere I can submit this?
> >=20
> > For regressions the best is to submit it to the regressions list,
> > CCed
> > it now.
> >=20
> Hi Philippe,
>=20
> Tried your test with v5.18.0 on my desktop and both wifi/bt are still
> avaible after reboot. The only problem is I need to insert btusb
> module
> by command "modprobe btusb" to make BT workable.
>=20
> I will check the issue on different platforms. If there are any
> finding, I will let you know.

Thanks for your tests, I did test again on my platform. This time with a
hand-built v5.18 straight from torvalds/linux. And I can confirm my
findings I even loaded btusb (removed and reloaded) nothing helped. I
always get the message

No default controller available

In this case I guess it could be rather a BIOS issue. In this testing
round also some USB ports did not work.

If it helps any my system is a Lenovo P14s Gen2. I believe then the
driver is good.

Regards,
Philippe

>=20
> Regards,
> Deren
>=20


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255A7520E0D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 08:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbiEJGwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbiEJGwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:52:39 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA462AC0EB;
        Mon,  9 May 2022 23:48:37 -0700 (PDT)
Received: from mail-yb1-f171.google.com ([209.85.219.171]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MYeAP-1nJMX22lNr-00VkoP; Tue, 10 May 2022 08:48:35 +0200
Received: by mail-yb1-f171.google.com with SMTP id w187so28984979ybe.2;
        Mon, 09 May 2022 23:48:35 -0700 (PDT)
X-Gm-Message-State: AOAM532G2KwUR9bmYpsf2UYuio94xCY+jJ9MLVshXh5SECvI3EALCdqK
        fXW9xD82xhSwIgFo+LUyR2YFc5oJ6POwK24HzrI=
X-Google-Smtp-Source: ABdhPJwZLPKPegMnSAYKUMRPIlw4w0nMh5Ua1zzbhdIVDi8c5t+lK+3Bk06FfarQubwIRmz24ICGg9b2tvpgmnYuNnA=
X-Received: by 2002:a25:c604:0:b0:645:d969:97a7 with SMTP id
 k4-20020a25c604000000b00645d96997a7mr16021831ybf.134.1652165314213; Mon, 09
 May 2022 23:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220509150130.1047016-1-kuba@kernel.org> <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
 <20220509103216.180be080@kernel.org> <9cac4fbd-9557-b0b8-54fa-93f0290a6fb8@schmorgal.com>
In-Reply-To: <9cac4fbd-9557-b0b8-54fa-93f0290a6fb8@schmorgal.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 10 May 2022 08:48:17 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1AA181LqQSxnToSVx0e5wmneUsOKfmnxVMsUNh465C_Q@mail.gmail.com>
Message-ID: <CAK8P3a1AA181LqQSxnToSVx0e5wmneUsOKfmnxVMsUNh465C_Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon LocalTalk
 PC support
To:     Doug Brown <doug@schmorgal.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:4fxcH+zG31JR2D5fSC8tLGPdDxOCmtc2fjga73OYZJ7qrX6mnGc
 vHphlNKZaDjMe2A0FEywlctccpZeBErsqrXa5WRXNOh+RYdZzGqBBy/qBRaHnvtAf/lyOGW
 xBwuh1w0XCJdsUN+PmD37B4w9TtbOL1vTKSY/UaytI4u1RhD5fmrFsNbglTiyGl/XaQv/ut
 gzEvaM+fSTPDx2JylxE+Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gNZ1gOntbLU=:KDlqCAJY4XtzvRd9LHRg1k
 ZNGOaOTD6adm1drYyMVHcfXzExzT1C7RPwMaF096in2hD7rUALAJACPf81L0G1Xs1yDz/V0YM
 cuYtnR2q3HijhYrKVfM48dzchzgr+J5lZw8sMRtf+bn+m6RCO10gjyuu5BgNgNufnrV/zCo8K
 fbJK9XGaUKuKPSsvY7ER+BZudV1TAVCa7KGAE+ILBBiSAdczIkt7bA3UqgH534G8BI0VIbjAf
 KTT9J/YzohMLCHQphvNQT9tDzQ18fwg+mawhuIG8GkrEnSargnA6GwxrRIAvPrPDYQqbiI6yy
 6e7Kd3nzmMot5VRqPh/ikq2iu3FTJ+igdauAdxdBGfca2LSThuIqYl9PCpom47TIP67UlV/wF
 ZeaJyv1Cn1pXHxDmHH4Y01ZH83tUENE9Hty3Q6JnwPU8yKm8jst3wuDUKSl5cAVJcmnD2v97Q
 1wxa1OwiMGr7ganCEYm/jILPjCDkK2OejbQLLJ4RJrXPXYvL/ez0NZO6P3KcciDF4DB4sCoOF
 88mu7Sgm3D7ALTreJZpLCEc877tMFG4ptTfM6pcT8MqomPj/ga/Ocf0+C+WoTRuBuFdbjiOiq
 1v9US8RoD7ETKikr0hzdWge8U2xPnfxdimVQnd6W+aPsmS3FluC5tMYYHL/qT4ObJO7YHAQN8
 t+N9kIm3cxFKMObNXGsSy/8JWOMAyHwDf+3Dm3A2zEheadeqQTB3ZYOCW9JQqA7VM9lMyS4oe
 Xswixb8vg+f/7QfwmTU3Pi5M3vK9bsaLHsEZCsyBuzTXzGG2zNAKRcyM7ggb8I+0zAeqyo9iW
 3pVz8BuNxf0euD357GHHQ7kn/BS4FcbQScALlWdZiQ0ZrF/OIo=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 4:34 AM Doug Brown <doug@schmorgal.com> wrote:
>
> On 5/9/2022 10:32 AM, Jakub Kicinski wrote:
> > On Mon, 9 May 2022 19:14:42 +0200 Arnd Bergmann wrote:
> >> I think however, if we remove this driver, we need to discuss removing the
> >> last remaining localtalk driver (CONFIG_COPS) and possibly the localtalk
> >> bits in net/appletalk along with it.
> > Removing COPS and appletalk makes perfect sense to me (minus what Doug
> > has plans to use, obviously).
>
> I also think removing the COPS driver is a great idea. I actually ended
> up buying a compatible card in the hopes of working on that driver to
> change it to load the firmware through the firmware API, but the
> licensing situation with the firmware blobs kind of brought that idea to
> a standstill. I would be very surprised if anybody is actually using
> LocalTalk ISA cards these days anyway, so it's probably not worth the
> effort to maintain it.
>
> There have been a few "modern" LocalTalk interface projects. One is
> mine, which I haven't found time to finish, but I was able to get
> working in the kernel with a lt0 network interface. I suspect I was the
> only one in the last decade to actually use the LocalTalk code in modern
> kernel versions, because it was crashing until I fixed a bug involving
> too short of a header length being allocated. There's another more
> recent LocalTalk project called TashTalk [1]. A kernel driver could be
> developed for it using serdev or a tty ldisc, but all of the current
> development seems focused on the userspace side.
>
> With that in mind, I personally wouldn't be sad to see the entire
> LocalTalk interface support stripped from the kernel, as long as
> EtherTalk support can remain. There is still a decent sized community of
> users who are using it to talk with classic Macs using netatalk 2.x.
> So most of the stuff in net/appletalk is still relevant today for us.
>
> Might as well remove CONFIG_IPDDP too. It actually -interferes- with the
> current way that people do MacIP gateways through userspace with macipgw
> [2]. I'm not aware of anyone actually using the kernel's implementation.

Thanks for all the background information!

If I understand this correct, this means we could remove all of
drivers/net/appletalk/ except for the CONFIG_ATALK Kconfig entry,
and also remove net/appletalk/dev.c and a few bits of net/appletalk
that reference localtalk device structures and their ioctls, right?

What about appletalk over PPP (phase1 probing in aarp.c) and
ARPHRD_LOCALTLK support in drivers/net/tun.c? Are these still
useful without localtalk device support?

         Arnd

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212EC520360
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiEIRTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239592AbiEIRS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:18:59 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6FBD6D;
        Mon,  9 May 2022 10:15:03 -0700 (PDT)
Received: from mail-yb1-f169.google.com ([209.85.219.169]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MDhpf-1ngiix2051-00AqF2; Mon, 09 May 2022 19:15:00 +0200
Received: by mail-yb1-f169.google.com with SMTP id e12so26141366ybc.11;
        Mon, 09 May 2022 10:15:00 -0700 (PDT)
X-Gm-Message-State: AOAM530d3OIK7GJv5+EXB/DD8h/GeGrYjsEyoejzPQsNCbkbTOIUIGQl
        RHwcA6mH8TuEOeZmT4YJTlejClyUw+lao3S/7Iw=
X-Google-Smtp-Source: ABdhPJyHQFHeCYNt6/2XBDePebhfAxC0YGjrTQwobGsfzQ7IW7xMNDz27Uz4OVvO3KI6pi3WuaWgOmz48zp0xVuGn+o=
X-Received: by 2002:a25:cbc9:0:b0:645:879a:cdd3 with SMTP id
 b192-20020a25cbc9000000b00645879acdd3mr13447456ybg.550.1652116499059; Mon, 09
 May 2022 10:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220509150130.1047016-1-kuba@kernel.org>
In-Reply-To: <20220509150130.1047016-1-kuba@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 9 May 2022 19:14:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
Message-ID: <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon LocalTalk
 PC support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Doug Brown <doug@schmorgal.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ykdNElvweSdf3ikRi4LSALSGseHFAqFUbbGcOdVmpUUzUl8AQWF
 vg0JI+/rUvkWWP2JeYOUVD+v6jRwbRYQb6VYNFvj/1EOab5Akl1l9TM1cDaiWrlUL+WZlWC
 xlBhGDsYxHa6xPeb1YVsyaSNSG65lhil8w1FjFFYOCP2W/MnkoKDIV7YVFEN5Xlm0V262hJ
 n5xTNoVwrNrbq/mWrBAOQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:B3166jrh0SQ=:ZNrfK8pJTV0vBVl5DPEmHP
 t2JnwtJcCJEMXbQyaM81ntqJD7Pay6hX6Uk3+hs/StKnwuzgy6vxif+cf07vI1LSgBvOggkbg
 IohZ1ttBl1LoLBLIwqVMJx8TGkRZTbCW5Hnh87FLmoB7S+zI2C91bEJsyOiLP9MewzWbSCTpD
 nZPoqvHRG5wcRCR74MbWrnkMMINuGv9BSCyWeO6YBi87cGHWH8zh/zJSzpGpaSNV1wgPHYo6j
 5PbPwl7XCOSHAm8ar6YBeCeKZC+mscriuoC+013zwyp79a3Inx6XFyynd9VOGnudumFIMOwSP
 xRBdnOglF+ayISYV4OOsgdhWbWh/LJ5wtIWO1kMvBEPXHQNRUG6JWh/u/7YcZcxsfzzkP7IGe
 LCtRj+WacgRTbv7rAFrJHjDcimrGwML4NPu8ZWtRW5WIxY2U7HXQEKKu0HxLTmFbPRzwcUeid
 9jWI+Fce6CdPVxYo8bUJ5twSS+Vz37qg+PTgz0W3xgqz1qcQClBC5CXZAruTb9zs0mjc3mup7
 Ch+/LIblnxH8sHdG50zrUg88R5SCjIyBOG1KZlKG1k9Gg7QXG4b4BEL+e2dbyZr1LQycH7MCz
 AD1vnNci2YLvnD9DYLBbtOWJYU7u75iUAPQoem/S189dY4lnvfZdPXBkImsdL+aow8+0oOOPg
 OetJwm7ETYp+1zzRTimJcreCThYoxWWwulTFqQDJQKz9cr9O9RqqL1UrGINsSkpTY8EXhJExG
 p9Jug7iFPYoxA4wQKjY+IR5nios7mV4BFottla38i6tf/WFZb45jH4/CHWuscFbdbxUjDNaD6
 ztyDwE6Vks17qEgOFYmBOCOYJH7UxqFF9mopYB36OiwWhGg2ZM=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 5:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Looks like all the changes to this driver had been tree-wide
> refactoring since git era begun. The driver is using virt_to_bus()
> we should make it use more modern DMA APIs but since it's unlikely
> to be getting any use these days delete it instead. We can always
> revert to bring it back.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Removing this driver sounds good to me, your description makes sense
and it gets us closer to completely removing virt_to_bus() in the future.

Acked-by: Arnd Bergmann <arnd@arndb.de>

I think however, if we remove this driver, we need to discuss removing the
last remaining localtalk driver (CONFIG_COPS) and possibly the localtalk
bits in net/appletalk along with it.

Doug Brown suggested removing COPS last year for entirely different
reasons[1] but never got a reply. I suppose that is a sign that nobody
cared about the driver enough, but we should remove it. He also
mentioned working on a new localtalk driver, though I don't think he
posted that one yet.

       Arnd

[1] https://lore.kernel.org/netdev/6c62d7d5-5171-98a3-5287-ecb1df20f574@schmorgal.com/

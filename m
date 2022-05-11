Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECD2522E48
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbiEKIYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243621AbiEKIYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:24:11 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF3966687;
        Wed, 11 May 2022 01:24:09 -0700 (PDT)
Received: from mail-yb1-f181.google.com ([209.85.219.181]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MQvL7-1nStfM0uhD-00O1RW; Wed, 11 May 2022 10:24:07 +0200
Received: by mail-yb1-f181.google.com with SMTP id m190so2574877ybf.4;
        Wed, 11 May 2022 01:24:06 -0700 (PDT)
X-Gm-Message-State: AOAM530F/rs7V40kHDEiGuNXLmrG/p7lbti7GItpjdQdtPDsDX0Tf/tE
        ZwKWpgjgof6PPdqA5c39yuZvq0kzhQ+zjD1n7gQ=
X-Google-Smtp-Source: ABdhPJyFouUq4CPyqHhoX+wyzUMdk5CW1I4lCwx2Vb0ywqtufH4ws3JEs5ZA78mXb7f9SpKUbRnNZIcDW9YXE5YZ5Uk=
X-Received: by 2002:a25:31c2:0:b0:641:660f:230f with SMTP id
 x185-20020a2531c2000000b00641660f230fmr21930869ybx.472.1652257445777; Wed, 11
 May 2022 01:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220509150130.1047016-1-kuba@kernel.org> <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
 <20220509103216.180be080@kernel.org> <9cac4fbd-9557-b0b8-54fa-93f0290a6fb8@schmorgal.com>
 <CAK8P3a1AA181LqQSxnToSVx0e5wmneUsOKfmnxVMsUNh465C_Q@mail.gmail.com> <d7076f95-b25b-3694-1ec2-9b9ff93633b7@schmorgal.com>
In-Reply-To: <d7076f95-b25b-3694-1ec2-9b9ff93633b7@schmorgal.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 11 May 2022 10:23:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3Tj=aJM_-x17uw1yJ-5+DgKX6APgEaO0sa=aRBKya1XQ@mail.gmail.com>
Message-ID: <CAK8P3a3Tj=aJM_-x17uw1yJ-5+DgKX6APgEaO0sa=aRBKya1XQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon LocalTalk
 PC support
To:     Doug Brown <doug@schmorgal.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Z952orSfTHyBgIXeXcsCvkvztAO+z1GduLlvnq7aygZujRIllvc
 hUFlMYrOZdxt9lwEPuMJecBzlTNrib9a3u9Ow3h5lW+H3yLWs+syKF4GE3HYAHdQkuJ4/O7
 ba/OhYTIY2ccNzxU6ViK01x9kwwidCH1neRoMV1on/zCXK8wCGzETtiSh2Fp5jlKuyCekUi
 VcZfXBRPV6LPDQPr7SZgA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OTZcUvRBuKc=:WmoD9sIBRr16VnoGQSyzME
 8RvP6ktOq78ojRnfrRfF6RDAQeDYLhgit3zM13qWaUC+DuH7foox/ulDjTsfK9ozt+TkF4ghp
 3xLvDY/rWbsaDypIwLrhrWbHXD9fmPsqez1J4wKGplKZmd4O6N/alVmZB4zOLEHJa2jH9gpB+
 pxwJ0rEVbxPg/TIMT3T5hfgqcJFpulas+LejUOa6mAiENzYBeDNtBm0HDNYajyJ4VFR3CBb6y
 5QwFiy7Kqx6rBDVok0uHEb2G8CXj+QA56IO9VPC6TdYB58AnfUQny7oOdpkCVoIV9UmKHbnrV
 Inig72kmNfE/kokOBnJYg7IWT4HC4ZH2bZS0mkJR1/bCSkO0WWz6OiT4EORGKYh1dK9D2jGk3
 XWyjqn508Oep5btcvIxh9UZK1gCp2a9RYrrobNznvRNgdXG+A0qwiVeBT2k4bRGxz8gHWTY2T
 l4D82Z1xDhF8iDeGwsKpcq/Le7kI70E6sU0YkoZ4xrVWPsrW+8sMGX/SA+aRhyw+nAhgYR/qg
 Iiq0lGIFLI2YD4rHfkiFei/HzH6/JJBCqukCJV+5+9+aow/azZs7AQD2mpjM7Gc4yFHNE5d3g
 th3znq+GymAL+kVwcXtWmbTyeNGC96lW1EPkBgb7tqQPtOMze4492ZDKhELkNDgHCYgjyhn7h
 h/9DeaavpwCriJM04Vqy+nQi7oJgLXaf4JnZJx9jWj9hizCgYOpF5tner/TOC7E7FwNI=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 2:20 AM Doug Brown <doug@schmorgal.com> wrote:
>
> On 5/9/2022 11:48 PM, Arnd Bergmann wrote:
> > If I understand this correct, this means we could remove all of
> > drivers/net/appletalk/ except for the CONFIG_ATALK Kconfig entry,
> > and also remove net/appletalk/dev.c and a few bits of net/appletalk
> > that reference localtalk device structures and their ioctls, right?
> Yes, I believe so. At that point, would Kconfig get moved to
> net/appletalk instead? (Just wondering out of my own curiosity!)
> > What about appletalk over PPP (phase1 probing in aarp.c) and
> > ARPHRD_LOCALTLK support in drivers/net/tun.c? Are these still
> > useful without localtalk device support?
>
> I don't feel qualified enough to answer those ones definitively, but it
> looks to me like the ARPHRD_LOCALTLK support in net/tun.c could be
> stripped out, because tun_get_addr_len only gets called on a struct
> net_device's type, and stripping out LocalTalk would make that condition
> impossible (I think?)

Right, I came to the same conclusion here.

> The AppleTalk over PPP stuff probably allows Linux to be an AppleTalk
> Remote Access server. I'm not aware of anyone using that capability, (or
> if it even still works) but I would consider it distinct from LocalTalk.

I dug around in the early git history for this one, but I'm also not
sure if this is meant to still work. I see that PPPTALK support was added
to net/appletalk by Alan Cox in linux-1.3.78 (1996), based on the localtalk
support, and it continues to exist there along ethertalk and localtalk.

I also looked at the git history for the pppd user space, and I find no
indication of appletalk ever being supported there, this all looks
IPv4/IPv6 specific. There was support for PPP_IPX until it was
dropped this year (the kernel side got removed in 2018), but never
for PPP_AT.
Adding Paul Mackerras to Cc, he might know more about it.

> I would definitely be happy to test any patches to make sure that
> EtherTalk still works with netatalk afterward!

       Arnd

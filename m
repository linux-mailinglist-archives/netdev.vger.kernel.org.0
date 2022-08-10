Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06A458E951
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiHJJLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiHJJLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:11:52 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C4C86C1F;
        Wed, 10 Aug 2022 02:11:50 -0700 (PDT)
Received: from mail-ej1-f42.google.com ([209.85.218.42]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MYvTy-1nqmns3uuO-00UqaB; Wed, 10 Aug 2022 11:11:48 +0200
Received: by mail-ej1-f42.google.com with SMTP id dc19so26493172ejb.12;
        Wed, 10 Aug 2022 02:11:48 -0700 (PDT)
X-Gm-Message-State: ACgBeo0K7XE9U1+ayLNTMZ+rWY2o0cgH32BBrwkLPxNuKT9D0wtqzp1Y
        n31gAi+T1YQLUkd+xGdxOUSQEwis8N17Udj3Aok=
X-Google-Smtp-Source: AA6agR54UqR5KkP1nrlq8rv8pS4O149IPA0hIzpCIiH6gOpPCAZBchAVTdP8Kkuc+/cGpEwZbfM+QiK1g5NDj4jquFo=
X-Received: by 2002:a17:907:1c9d:b0:732:f9da:aa51 with SMTP id
 nb29-20020a1709071c9d00b00732f9daaa51mr4259542ejc.654.1660122708604; Wed, 10
 Aug 2022 02:11:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220426175436.417283-1-kuba@kernel.org> <20220426175436.417283-4-kuba@kernel.org>
 <8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org>
In-Reply-To: <8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 10 Aug 2022 11:11:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a01yfeg-3QO=MeDG7JzXEsTGxK+vMpFJ83SGwPto4AOxw@mail.gmail.com>
Message-ID: <CAK8P3a01yfeg-3QO=MeDG7JzXEsTGxK+vMpFJ83SGwPto4AOxw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: atm: remove support for ZeitNet ZN122x
 ATM devices
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, arnd@arndb.de
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:rlUgDwpljBmsDj7uc4yIqEt8ujtjVlTjLMlUVcO8f62yaAWqhvB
 lnCrKsjSyntNhQb0W24QUt1r2KnnqauWOV84fmhaghq52TqU57+6sM0G/I/dsQNo5M0AVZe
 /HB87cS6eKmTO0MmgwXCP/fARwVBQXIH/48IBn3ZGNZY1a9/cNb01G2OiPH/3htn+7B56X4
 N0+IKA9Il5VAZixSXCRwg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BBInhWANcsA=:euyLimCkXAysWjFlrG45rZ
 qlHxapK4ff35SwnRiLpsZl2PtvakRa3UJRZr7LyNKzIZI2Giojio604vVG3RbRm9BUOg7ZmEN
 c61P3HBZGzqb66+Dd4cqq9sV5gxKMqoHAdpifFrU8101RS4p+0WifOMxNrQyBGB4WcmRxLtmG
 nFbmkhyTA8RD73dOPVj3/+bPO5zrAP9J0CNg8x1nNVeq/XvrwI9r/SyjXJJtnIbBxf+FjLDxC
 TGW1t57hUZkQvnSpkvjhYXPp8Xd/rStzk+Qk00qMx3b/t4IBgwID5k8Ui5rIjVUV89YUufP7u
 w+d8MxM3wBUSeejSIyD+5yPgf+mZf2fkS0mY5GmPNK/E/p0fPNs2F8xoJuNOy2xTo04MWGFPy
 QAXD0K38v0e0mkJuQaKSd2BPgyevqapaIZ1o0S07qwtHlJQwjqtgxmNtTZ47JWF7rc0aZvS+u
 J7teQ1q5EqQOjXW5uGojjCma+y3UfcEySNArtWWA7SPmlq5CA134J1sD2jG9Sy795r3I6Img0
 LbzQOJ4r0MBrMBLLFmfPySDbjwxDYzheIUf6jySdESHSRX/SYeGJDSwBq7wJvKIefjEmh+15K
 sFS2h0HhAQBOK72/+aPeS8GRWrhOOvqLdrOc+nEV/klCIoIiF4TK1I0PyYFeLuaUrnWmgnGpJ
 19KubxrLhxYnrf0yy10ushkVRDLI99gojAPTOcZMbGbnUGIfxhsOL+M9NwLjnthnNE6u2FA+/
 8vGLZZnXwoVeDH6e4P10sR/ljvo1XiTfEVg5TA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 9:36 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 26. 04. 22, 19:54, Jakub Kicinski wrote:
> > This driver received nothing but automated fixes in the last 15 years.
> > Since it's using virt_to_bus it's unlikely to be used on any modern
> > platform.
> ...
> >   delete mode 100644 include/uapi/linux/atm_zatm.h
>
> This unfortunately breaks linux-atm:
> zntune.c:18:10: fatal error: linux/atm_zatm.h: No such file or directory
>
> The source does also:
> ioctl(s,ZATM_SETPOOL,&sioc)
> ioctl(s,zero ? ZATM_GETPOOLZ : ZATM_GETPOOL,&sioc)
> etc.
>
> So we should likely revert the below:

I suppose there is no chance of also getting the linux-atm package updated
to not include those source files, right? The last release I found on
sourceforge
is 12 years old, but maybe I was looking in the wrong place.

          Arnd

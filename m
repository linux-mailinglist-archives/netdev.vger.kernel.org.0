Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CA95330A8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbiEXSsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiEXSsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:48:12 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4241167FA;
        Tue, 24 May 2022 11:48:11 -0700 (PDT)
Received: from mail-yw1-f181.google.com ([209.85.128.181]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M3UhQ-1nu7o336bC-000dls; Tue, 24 May 2022 20:48:09 +0200
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2ff53d86abbso172614297b3.8;
        Tue, 24 May 2022 11:48:09 -0700 (PDT)
X-Gm-Message-State: AOAM530c9mwzpYOUEg3OKYtOORE5jxJWcZCIBjZ6k698dijeepdti8DL
        2E1fjKQm8gEAFlUI6HLKpTgDrnKhLy6v0GerDvs=
X-Google-Smtp-Source: ABdhPJwsYiBb9B3E79SnIJ4WcC5zF0hkd6+vxZqN+SGfjXixyjxuQWcb/oLhXG/F3pN01qSlI3UK0ow0dNpe7TWkBzg=
X-Received: by 2002:a0d:cfc7:0:b0:300:26d2:30eb with SMTP id
 r190-20020a0dcfc7000000b0030026d230ebmr4963055ywd.320.1653418088338; Tue, 24
 May 2022 11:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220524155929.826793-1-sashal@kernel.org> <20220524155929.826793-10-sashal@kernel.org>
 <CAK8P3a3J6gh-0Z8JKEBDva7ox39ps5CCxJ4K7T1LyWMbTHna8Q@mail.gmail.com>
In-Reply-To: <CAK8P3a3J6gh-0Z8JKEBDva7ox39ps5CCxJ4K7T1LyWMbTHna8Q@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 24 May 2022 20:47:51 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2EZKnLB5c9YuKbaug16tG7juidmQ+g-wLNHx_-zxTD5A@mail.gmail.com>
Message-ID: <CAK8P3a2EZKnLB5c9YuKbaug16tG7juidmQ+g-wLNHx_-zxTD5A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 10/12] net: ftgmac100: Disable hardware
 checksum on AST2600
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        David Wilder <wilder@us.ibm.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, guoheyi@linux.alibaba.com,
        chenhao288@hisilicon.com, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:96xrElVXySoqq9iS0axwBKlp/dRRWdxq7fv0K73xitxQOr4Nkrx
 lvghLgYzyuMj08MK4stMzgqFgiPZEM+OfqtZ+URRr7FtASUGNc3dQq7w86WItNKp+WIH7ix
 XtXp1SmTzXO7ZaK8Haloc+MSnemSR5Y+NcAqv2wV3jm/eFs4CXgbyVmlRdk7ilUzQbpuntH
 9hAPXo50RfOJ3cXCXS4zA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:puI6Pq3V28s=:JSAZuF4vBgB9vNUO9UHFIZ
 gUBDM3vqMIECFeKwqFVuLKqvWcGh5YZA0iPG0fBiJUW66YWD3QLfQP4+9yBmYGJABrD67fAIh
 oaAOUqDHeXKxNCCp7Be+wHlcMi/ap/lkZKCWl+Pqq79ugs21LQgKRiG7deEpxKerG7aeVwcb/
 Hp4Tf7cIo7v5eIAckaoWdFqPywXjuSQPRwg7qo8YLB7zHg5yk0EGM3/mEaPnDMe3q0IoT1ZnL
 n4BoUcBczZz6r1nu0SKX5Dl6aujEAuWshz1h3pQgd5fudy2AOgHqgtIZr5TaCxVPRz3TcnT/w
 jzmqnsLmXfsNwT09rl1nj9Zj9ZyJU47Fq1UpPEGtt4qHNLRxqmAPFIfJHt8Liib3J1zJrTLef
 2+6CYeDmjUjIMHn1yrGifMWaBsrQTm+gF1PgiDPCiB8ss6wx8cq7yaAFWLIVwzf6yRuHdzsbR
 BSZivE5VXztT7P5/a1HGMGuMYy8T/7gd8fpTJWnmjcUOrgibteOhVTQiuaIWbIFiKlaBcfF6Z
 fHn3v9AYoiDyHz1Jea+5WbRbu1eWLVGzYO9/LqQ2bp5XwxfuBu5ixCuCIFjDCic6XiIvh/i74
 DmqxGwSgQ+0DEuNtkroSvNMXKZaRDNjTfN+SZqdvEoPtoaZE2scJbxIY7C2t3YmoLaADN7Ze8
 Bd38wnhLgf68j1Xxc5F9lJWwe0FC1V1koDEw0lqkJkilce966WgGS6gA/idC/Y0vJGyACQ6Zp
 jM9bv6KGPP6rk5NjPzzfVaaWB5DWKtGCh3cv743HMHxOxKBEpkhg5D5lc6ycMrDosNzzcuylm
 skqYPxwgh5s6O8J2qU1cZ+0lnCJ0v+CfLUh4jDDrJp+cvGEwLL7F6v9spKO+DOMu/PdnpzqMx
 Hw+DluO957ZSJVtmcptLbiN8GhUB8+f86oE75ZqYw=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 8:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, May 24, 2022 at 5:59 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> >  # ip link set mtu 1410 dev eth0
> >
> > The observed results:
> >
> >  1500 - good
> >  1434 - bad
> >  1400 - good
> >  1410 - bad
> >  1420 - good
>
> Does it require multiples of four? Maybe it just skips the last bytes?

Nevermind, I missed that this was a backport of a merged patch, rather
than a new one.

       Arnd

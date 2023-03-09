Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D6C6B1C3C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCIH1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjCIH1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:27:10 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E1ADAB97;
        Wed,  8 Mar 2023 23:27:08 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so5441073pjb.0;
        Wed, 08 Mar 2023 23:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678346828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJHzsaxOituYDBkxOA8H81vwLH3ZviXpLecRvt7q+4o=;
        b=FhiF1bkIirhXX6zU1PYQDdyHDWrRZAVxDmgaiuyVy/G5zTxdknvqDQd2qQGbFKEF8l
         5pyrCJ5zPE0vQGooY0Xfz0Ac+OVH3fpkXkoBJJVBBD88eCVhRRIUBn+ENARTNH2bI3dC
         KVeCPVKk9hinoPfDuurpXdTOFZoT0S+7FrIICYy3nt9h33HcSm00AsqiGZD9nKaDtGpm
         OR1PZnp/p6+ePj5ADaRp0oHO/7WkhS4t2mjRnypLM+jUYPwJiytZQqz4foFpWXhyIWWi
         ebo3udUah9AJHHRd/ZUdZ30Qs/5+Rf/tqqbIRSvJ+oMF4OOL8KwOepLd3Q372C18Pc7x
         WDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678346828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CJHzsaxOituYDBkxOA8H81vwLH3ZviXpLecRvt7q+4o=;
        b=TRDnJnWxnqCYGYyKGLJnl5x3ctFYkkL/ckz6+Yw3L3mkEDMN1wdo6/JZhDGg8DnY53
         O/VTS/7c/r0rMX/A3SjIBdeXigD8RKcAbfikBL0pX8MAW3UOmj7EgGYsH4fE25gs+35w
         K57DEWrDFv+0Uz++htpzUDhquY8+oXDRYFc+CLlEhFMcN36zS3lXitTWmXqicX6IMuUZ
         dF9cmMNta6R+ceDiwhMGdJyvDfRB864mezkwa3OnVK+V79YL3aLTlTVtEeqIqdNaBeHF
         3VNZ6KoNsWEIkFB6qKTTosH76j9bImGQp2JXI60mWqDzKHJOEuEZ2BM4yRfYceWvw0KL
         mVRA==
X-Gm-Message-State: AO0yUKVdUlUCHxdet5Ekw3AJ2z+xUeLjVN/vhIPU5Nw8uyU7AcdA16La
        Abj/juhezk+0+X7hrNPKY/RqKIMaODM3UrKMu5c=
X-Google-Smtp-Source: AK7set/FlFpnQ7TXKx5oEOQ4GI/7HbhMjyIjqIVdCgszs0y16a7MjMC58+BqhJVX8tsNVesGvOBSCiL25Q3SzrH4ek8=
X-Received: by 2002:a17:90a:ea0b:b0:237:5e4c:7d78 with SMTP id
 w11-20020a17090aea0b00b002375e4c7d78mr7669919pjy.9.1678346827909; Wed, 08 Mar
 2023 23:27:07 -0800 (PST)
MIME-Version: 1.0
References: <20230309035641.3439953-1-zyytlz.wz@163.com> <ec579c96-9955-f317-b37a-4f3fcd0c206e@huawei.com>
 <c9bafa3d-12ba-e9fe-8606-8160a8c42517@huawei.com>
In-Reply-To: <c9bafa3d-12ba-e9fe-8606-8160a8c42517@huawei.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 9 Mar 2023 15:26:54 +0800
Message-ID: <CAJedcCyUW7h+5AY8BRN13S3wEMXM2tv0ioxFF3nKKM88g7Zmtw@mail.gmail.com>
Subject: Re: [PATCH] net: calxeda: fix race condition in xgmac_remove due to
 unfinshed work
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        1395428693sheep@gmail.com, alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yunsheng Lin <linyunsheng@huawei.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=889=E6=
=97=A5=E5=91=A8=E5=9B=9B 14:27=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2023/3/9 14:23, Yunsheng Lin wrote:
> > On 2023/3/9 11:56, Zheng Wang wrote:
> >> In xgmac_probe, the priv->tx_timeout_work is bound with
> >> xgmac_tx_timeout_work. In xgmac_remove, if there is an
> >> unfinished work, there might be a race condition that
> >> priv->base was written byte after iounmap it.
> >>
> >> Fix it by finishing the work before cleanup.
> >
> > This should go to net branch, so title should be:
> >
> >  [PATCH net] net: calxeda: fix race condition in xgmac_remove due to un=
finshed work
>
> typo error:
> unfinshed -> unfinished
>

Got it. Will correct it in the next version of patch.

Thanks,
Zheng

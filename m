Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0676DDA7D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjDKMMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjDKMML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:12:11 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8898D3581;
        Tue, 11 Apr 2023 05:12:10 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id e9so5198029oig.7;
        Tue, 11 Apr 2023 05:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681215130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rZdWxy8sZ5YKMWYXzvClQL7OwsheL4yusd/dv4cosA=;
        b=CUmyy3ClfuFZ2AO9UJHDVHNnGKqPoeyITT74oKPPKeVm7kzRQnfMe6PWRvL5i8tei+
         cHR54df6OeUFNkEecco8Jisx8RJUn/DKU/BH0KyOTTMrJxG8JBZab2gHHAfUjOb5X3lp
         MfPGglhWMmR6fDXfI6HXBU+8WkmpWK3dOUFrBtetjAA5Kbm2JwYsnMBb1RdQ7EPYL09f
         yEm8lwXX56maol+ATiYXSmYQmpwfIXPDiqsA0XLkCQt7flH2fAef8F/Uom+kAuPkJuXu
         3MQCUDxDBXBF3X7Vmy3SdKcYgmlFRyIjkM9z2kak2fPrAFPO9bcA/z0dbci4C1dJizSr
         /Idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681215130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rZdWxy8sZ5YKMWYXzvClQL7OwsheL4yusd/dv4cosA=;
        b=I128SWElMDFa9RM5SOMK3n4hjQyLoXMcUpIpkqKq5sXMq0jBpZIau+7GdE5HY5+dmj
         Nws93s5BVvFXual+QgeQJzsBn/og8CicyyG163eeLxwDXTZ8InDJxKIHoooElSz730fR
         urK8NIJJqX5ab9KjgXGvh/phqB9rQctj9OXvvhA73X6XrYc2nIQMS6zfpZSZkL7HcPnX
         ahk0GxyCKhe4tY3iq4FjYIFpu8WeUyGL/r8mOZJvmrIibVN32WYfvsBeYLLDNorH3F3E
         evupKHLbPqOyktDKeG0m2djlXucq896WvAM4tD/FlX1idbT1X19m20/Q3nMDYw2hvRMy
         2KuA==
X-Gm-Message-State: AAQBX9cTWqymH1N6lqZ/bdqCZDEhzjnFW9DAuV+7lhJV2Gii5VWp+YMX
        mwUS5kK0qM5Nzf2wF5cVgKwQIXdWMM5YIrBToFPGUjTeK0zcr3Zc
X-Google-Smtp-Source: AKy350YuwkaxsDROypPhaY0T7vaeoEt8MjvcKh5olBFlbcH90gMobEAEkBEc8yfNqIq6I7GCiP0hIZ7miYUq3VjgcPw=
X-Received: by 2002:a05:6808:428b:b0:388:5e96:2f6a with SMTP id
 dq11-20020a056808428b00b003885e962f6amr2956077oib.0.1681215129776; Tue, 11
 Apr 2023 05:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230411090122.419761-1-miquel.raynal@bootlin.com>
In-Reply-To: <20230411090122.419761-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 11 Apr 2023 08:11:58 -0400
Message-ID: <CAB_54W6tnKmjmRAmA=pZPUucDvmROTx-Xx3V1k2Ms=nemC_Vjw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/2] MAINTAINERS: Update wpan tree
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Apr 11, 2023 at 5:01=E2=80=AFAM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
>
> The wpan maintainers group is switching from Stefan's tree to a group
> tree called 'wpan'. We will now maintain:
> * wpan/wpan.git master:
>   Fixes targetting the 'net' tree
> * wpan/wpan-next.git master:
>   Features targetting the 'net-next' tree
> * wpan/wpan-next.git staging:
>   Same as the wpan-next master branch, but we will push there first,
>   expecting robots to parse the tree and report mistakes we would have
>   not catch. This branch can be rebased and force pushed, unlike the
>   others.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks.

- Alex

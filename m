Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E636DC005
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 15:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDINdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 09:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDINdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 09:33:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF2526B0;
        Sun,  9 Apr 2023 06:33:41 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y6so1485578plp.2;
        Sun, 09 Apr 2023 06:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681047221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQhQ7IEhFavcI76vQR7yRcQO09FERz3jOfHL+xsQeDU=;
        b=iWkjmYaJdPpBHDJQGKaYLICkccLrmez8x4oHYIG8AqjNb4tgpmf3xF2Mf68ylSdqBH
         +s7GSefa4TyxZA3x63YkRvopEww6DNPUvBAybgZ9vo74rvmqZaU21xP9183SYyzRZPwi
         AhRDb6OlnIYVdTAgMPgtt10TkWc2Euw9AFkMXSEiMpv8QqL5Hqm+Z8R4+MyajKGVV91R
         aw91Q+4cberHtnRE1tHtVV2fe72UQx1NHhoSnIxXg1RDcJ8av7KljjqKzOCgcFQpNUVk
         o9sO9hBveY97ME667smTsR+TH6qUp0aqPeGFbonY04N7onlHSA36C0cEh4YdZA8mp90G
         Q2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681047221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hQhQ7IEhFavcI76vQR7yRcQO09FERz3jOfHL+xsQeDU=;
        b=5IIYQLwOhWID40TnytI5xkNfsHc7P4cT2iEx5HlPT4CfOON13ByHhzz4fHPvM0PhFJ
         sdH5RB/h+Zqx2F38bpIc16Ghr/XUnDtPCl4Q7hILFBIXPRn9Rq5qyHW+hcp4MHn6DpFp
         e2Bl3uSuiV1UkeLGH7HD5yOzHGOUVjNrtuGl/FgaISyUIayubUr23yINwoMLZGz76vQU
         GKMMl5+qhxGTSJJe5uAwGjt1da3uFbPCTYF8EphXNkMl4ptmAiaKNfNg/OwP8I4kSFnV
         XNIiGDAetm//f8BguavA0UYEBrgvqo2LO2e6btBXDv4e0SmHEmRn5JiYNs1ww3Bw5OxB
         0uVw==
X-Gm-Message-State: AAQBX9e0WqoX6JMzWiBQOsQwqnJc0c2XyXoTUYQl70dpOs1f54rbqDWB
        sKNABPgt02yrWoO2hvm3x/XiXH1HF4W76puTEwQ=
X-Google-Smtp-Source: AKy350aXJil6ppcZ48yznHNVUhy/Tb2jOwv5ZbxGn8qVXKcqRHYw69kkbFF9FYFSmJyd4Qel6IaGECOMXAs24obCfg8=
X-Received: by 2002:a17:90a:8c06:b0:23d:30a:692b with SMTP id
 a6-20020a17090a8c0600b0023d030a692bmr1920225pjo.4.1681047220780; Sun, 09 Apr
 2023 06:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230409130229.2670-1-u202212060@hust.edu.cn>
In-Reply-To: <20230409130229.2670-1-u202212060@hust.edu.cn>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Sun, 9 Apr 2023 21:30:30 +0800
Message-ID: <CAD-N9QVTmKK533s4kMpdsM6LYGJhkb7pM3NZPo_F5Y-6Azcoww@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: fix inconsistent indenting
To:     Lanzhe Li <u202212060@hust.edu.cn>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        HUST OS Kernel Contribution 
        <hust-os-kernel-patches@googlegroups.com>
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

On Sun, Apr 9, 2023 at 9:11=E2=80=AFPM Lanzhe Li <u202212060@hust.edu.cn> w=
rote:
>
> Fixed a wrong indentation before "return".This line uses a 7 space
> indent instead of a tab.
>
> Signed-off-by: Lanzhe Li <u202212060@hust.edu.cn>

Hi Lanzhe,

Please remember to add v2 and changelog from v1 to v2 next time.

+cc hust-os-kernel-patches@googlegroups.com

> ---

v1->v2: change the author to make 'From' and 'Signed-off-by' fields consist=
ent.

>  net/bluetooth/hci_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
> index b7f682922a16..ec0df2f9188e 100644
> --- a/net/bluetooth/hci_debugfs.c
> +++ b/net/bluetooth/hci_debugfs.c
> @@ -189,7 +189,7 @@ static int uuids_show(struct seq_file *f, void *p)
>         }
>         hci_dev_unlock(hdev);
>
> -       return 0;
> +       return 0;
>  }
>
>  DEFINE_SHOW_ATTRIBUTE(uuids);
> --
> 2.37.2
>

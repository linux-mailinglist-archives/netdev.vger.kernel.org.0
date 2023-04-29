Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A96F25BC
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjD2SSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 14:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjD2SSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 14:18:01 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ED79F;
        Sat, 29 Apr 2023 11:18:00 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-44089f95265so290352e0c.3;
        Sat, 29 Apr 2023 11:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682792280; x=1685384280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r1iDAowj027iaBmQvYLZLlsdgLbrABEug20GI/GfAo4=;
        b=qFbq5Sj7+zxZlOrpitzMN8wuN/wkDrUeRn3nzPHxlf6QYDD9BDV9wa2Z5bpOvBCqOt
         R3UtJb7Pa/DUIRT6gTEKPJgTsf2BurAFEj8Qo2Mh9AS5gowIPPbkEhuiRcNVmW8+pQG7
         RInOsoIsMZQpz2rFLgXUzlZXgiW/ZfqP+ZRzNiv7PuuHLubvw6i3WD/68aiqqnadFchi
         Btv0PmA25qZ9ZihhRg+1Hgf8YcR7yCeteBIhppqaXyP/CRF69CrJWzNW4dqid56hpfL2
         1luN881Qa2CmFsUAkhd8OAV1aahJAbC6mVGVZmvXSQ2eaPOA1nz4UJQiIRbkZyu1Ud83
         7DWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682792280; x=1685384280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r1iDAowj027iaBmQvYLZLlsdgLbrABEug20GI/GfAo4=;
        b=dkSP7XsV1gt9w1JjqXADRFrYQwNg1XgciS3MUxg2GEdj4d2dcV1FA3004khp0ygAeJ
         cA0w5u3VkYTzXlhBYNw1ZlHg06AK0BL0IekMYqLUnzPY4oA2fss8xEtKVdXK0Pc64EV9
         mUlelWllbCHmEwaJ3NUf+LNU8hCbFr6O/NnTSkYFR6cK+SBXaByVMN3SD5wK/9YOTWeZ
         mXo01OSm8FZb2FuMYn4A/wQPKb/Lwe120qtepAd1BXKDXNRbdTmmIK0ztn8nOzea8Qnr
         r0KcN5o12KYG+OfGbjOhL75thNzoyZw38SbmXU1xofZMBYP6wxCY9dXD1rM42yrcrkRB
         rutQ==
X-Gm-Message-State: AC+VfDxjQzk+l5xpS38ScXVx8hUe16bPEJbN9vYbMR9BQdBlyQ0u/1if
        r1qPtXVhCAT7kWw6B/qT22GsSzW0HBZbJS5TLzQ=
X-Google-Smtp-Source: ACHHUZ4gAyBPwxEd6oY9ni3Df1iyIVtAfUw2w1QS6RzCTPmfziF/rQAQXVApUObLwF1k+G4lvXaJeFWCuo7dyiF05b4=
X-Received: by 2002:a1f:e282:0:b0:440:8a24:e71f with SMTP id
 z124-20020a1fe282000000b004408a24e71fmr3264011vkg.7.1682792279508; Sat, 29
 Apr 2023 11:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230429020951.082353595@lindbergh.monkeyblade.net>
 <CAAJw_ZueYAHQtM++4259TXcxQ_btcRQKiX93u85WEs2b2p19wA@mail.gmail.com> <ZE0kndhsXNBIb1g7@debian.me>
In-Reply-To: <ZE0kndhsXNBIb1g7@debian.me>
From:   Jeff Chua <jeff.chua.linux@gmail.com>
Date:   Sun, 30 Apr 2023 02:17:48 +0800
Message-ID: <CAAJw_Zvxtf-Ny2iymoZdBGF577aeNomWP7u7-5rWyn6A7rzKRg@mail.gmail.com>
Subject: Re: iwlwifi broken in post-linux-6.3.0 after April 26
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux Networking <netdev@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 29, 2023 at 10:07=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.co=
m> wrote:
>
> On Sat, Apr 29, 2023 at 01:22:03PM +0800, Jeff Chua wrote:
> > Can't start wifi on latest linux git pull ... started happening 3 days =
ago ...
>
> Are you testing mainline?

I'm pulling from https://github.com/torvalds/linux.git, currently at ...

commit 1ae78a14516b9372e4c90a89ac21b259339a3a3a (HEAD -> master,
origin/master, origin/HEAD)
Merge: 4e1c80ae5cf4 74d7970febf7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Apr 29 11:10:39 2023 -0700

> Certainly you should do bisection.

ok, will do.

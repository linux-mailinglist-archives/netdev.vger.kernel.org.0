Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D745058CEA1
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbiHHTil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHHTik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:38:40 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3323813DCA;
        Mon,  8 Aug 2022 12:38:39 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gk3so18396312ejb.8;
        Mon, 08 Aug 2022 12:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KdhUaq6OdOk1p11XCLxhEPLO9x0XdgUEsmxMT5H2xwE=;
        b=YKh2UlFCbyIRnCUTFWThV4ubZZ/PkIboFgG0z6OxIgWns9I7bSGZNcaLEygjUTLYFc
         U69mi2ARyPNhuhIlhkoSwGcK/iVnMllVvv3f6wSv8Cuui7HqGDp3z85S1gg4jW+KaxQu
         /oDIy/zqp1FbtLIw30n2O6pW9NEsoWQCTCFP2zvZ0gDZwZ/Xd4Lf7LD/kn1Xjft0P2mz
         7dXQMdRTxsx2UbLl/Ydbw4d3ZdMXqU5+UP5eLQiXy/XmDzkCYzWxgsMskjiaMxrUlPN1
         15XxO4R7MLgRX/0dOvUcrBF4U6Un6aY7eLWtPVUqhOSL/bs3nANjWrMEKAV9IlYpXSq6
         T5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KdhUaq6OdOk1p11XCLxhEPLO9x0XdgUEsmxMT5H2xwE=;
        b=TuY5RTJUlGrZMTtAb9Ql36ot5cxm6YneXKtQ3CHttTOr/RC4SfWamvNWn/AVeee3Qt
         f83Ctjkp/NqLj2Jy+PZdBtwDSMnljIccG/sHTBV8Yjv3tFeL4TE7RDU6CdaaYoWkyHwX
         6KkGuPfcrTniBQBf2/DjV9nClqlm8evMpCpNGY0CJ1gPHdoJe/tGiG23mbh3q3X6HF2K
         Ifa4KOoH0P+vkmUr/Le0tf19axLlKO2MmhMcqk7uvbZRwD2aS8R4EmOi1OFaQF1U/xch
         0tEUj/VxG1T/mP17Tu3RHe9cbMjiT6Csb60itR7nAGQ37ZZ++Hm3zqv7PFp1fGYKQzOY
         loKg==
X-Gm-Message-State: ACgBeo3QRTxresAeKoRum9t/J3On1oc0ysIU6UEXVqXphxUYlfQIDJJ2
        ZhRi/PjtX3t53x2lEZ5Ycv1pGSF0Xq90sHcsDhY=
X-Google-Smtp-Source: AA6agR4fs722bp/33kqB2yS9ElOJRl3V9PRu802MGFsjDqtjwj/K5Rvlf8v5d7s3GF3tn4ky7MAACPrxdw94ZLMaczQ=
X-Received: by 2002:a17:906:4bd3:b0:731:3bdf:b95c with SMTP id
 x19-20020a1709064bd300b007313bdfb95cmr7089537ejv.677.1659987517584; Mon, 08
 Aug 2022 12:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220805232834.4024091-1-luiz.dentz@gmail.com> <20220805174724.12fcb86a@kernel.org>
In-Reply-To: <20220805174724.12fcb86a@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 8 Aug 2022 12:38:25 -0700
Message-ID: <CABBYNZLPkVHJRtGkfV8eugAgLoSxK+jf_-UwhSoL2n=9J9TFcw@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-08-05
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Aug 5, 2022 at 5:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  5 Aug 2022 16:28:34 -0700 Luiz Augusto von Dentz wrote:
> > The following changes since commit 2e64fe4624d19bc71212aae434c54874e5c49c5a:
> >
> >   selftests: add few test cases for tap driver (2022-08-05 08:59:15 +0100)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-08-05
> >
> > for you to fetch changes up to 118862122fcb298548ddadf4a3b6c8511b3345b7:
> >
> >   Bluetooth: ISO: Fix not using the correct QoS (2022-08-05 16:16:54 -0700)
>
> Hi Luiz!
>
> Did you end up switching to the no-rebase/pull-back model or are you
> still rebasing?

Still rebasing, I thought that didn't make any difference as long as
the patches apply.

-- 
Luiz Augusto von Dentz

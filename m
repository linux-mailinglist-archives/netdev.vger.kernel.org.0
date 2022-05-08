Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E4051EACB
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 03:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiEHBgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 21:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiEHBgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 21:36:51 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC83387
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 18:33:03 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id s68so5359490vke.6
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 18:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=e7Q4y7iPGLCVPWqTkoNkP7leQjTRit1YqVpiGh/1AQo=;
        b=i9uJ5w8MHdbQ6l9faNgrqK9ZaUMhinLBYMEIUlHziSjNm8FZWvHcvW72bXUSjSpfkn
         zknU3yNOyGYtOruv9hwY5ikTFdPRBBQoUAJ7Eu8gNvwax+8ZI2DGHkfJlJ/T36pKkZia
         LR9ZgYHEKwpfnU8fpyVpJi2Gmczlt0oDH3eBuBOIRQNw+5KELuJKVTCjA3ESy9+gAE3x
         rG9WnRdKnzt++bv7hrVpRtl2Lca3nT3KuE03M3hgqxtOG0avfiRA+Yu1k2iuu5DvTzy1
         U24CvoAQOkfFoAx/9XqUoCKj9IVc8p++gXbsu806bkjr6tQ1yK5lz715N+Em3KgZjUmG
         9sVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=e7Q4y7iPGLCVPWqTkoNkP7leQjTRit1YqVpiGh/1AQo=;
        b=UiQBARXRk88fTCuhmETucSe4uyfM/2lrziKgY16qB04zwIhrCNeN1YVdP0gW0mv2xa
         zdLTElkeCQ0iLV70vTcLDM/dCo3/fWUqNkyob7qyY/6bnDwjZm7Ht4mtfTLFmm3l8y3N
         AnHPE7/kT8gysUe8O0l/mEkAbv/7HC3aCf8VLVWDUYDyI3KBCtmBdLlY5O6CXJODTlZQ
         CjvHlxlnMKqqs6L9xa8QfpumOcsvxZgWoBsgn4c+Iw2S5Te1WGYadeCxWmTg4sFJar+l
         UsuD+GqzHZF8trvFbBvIljq8Nni60Yyg+fb1aLfO1R2cUepnWHUkgrqivPB+qt4p6y8e
         tyZw==
X-Gm-Message-State: AOAM531kOZ8WFPqmk/vLabk58/cfW0CLl6p8a+3HorUnuPjphjCpF67O
        XGaYvni/w7GDdTEwHS58G02tswWHGi2Aa70tmLw=
X-Google-Smtp-Source: ABdhPJwMjgQkVHHw4b8ZQ+KMtnYWbaizSfHeYr4V1Q8IhDRNGfYD6NW+1UcMWHU45AxjRDSjORtdYrEaGu1G0SvB4X4=
X-Received: by 2002:a1f:286:0:b0:352:69d4:4823 with SMTP id
 128-20020a1f0286000000b0035269d44823mr5560356vkc.8.1651973582039; Sat, 07 May
 2022 18:33:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:3c4f:0:0:0:0:0 with HTTP; Sat, 7 May 2022 18:33:01 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Mr. Ahmed Osane" <osane706@gmail.com>
Date:   Sat, 7 May 2022 18:33:01 -0700
Message-ID: <CAC7Oyrqo4_E-_K5azOChjU13B=P8bjM5PLv5pep19Jt-iJgbUw@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a41 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4988]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [osane706[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [osane706[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 HK_NAME_FM_MR_MRS No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Greetings,
I'm Mr. Ahmed Osane, how are you doing hope you are in good health,
the Board director try to reach you on phone several times Meanwhile,
your number was not
connecting. before he ask me to send you an email to hear from you if
you are fine. hope to hear you are in good Health.

Thanks,
Mr. Ahmed Osane.

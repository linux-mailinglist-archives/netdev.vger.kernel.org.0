Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6214F65ED
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbiDFQxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238634AbiDFQw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:52:59 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A741DF66E
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:16:58 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i11-20020a9d4a8b000000b005cda3b9754aso1774902otf.12
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 07:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=necXboHIqIY4mU6mIoE/fX52SW22rYaizBJiUkWBqqjC2FwblXLvSB9fDNNlLEvaI6
         oqBXNj4VPdKIF9aJiyxPlWCzcK2KgHx1JAA7QdmvoboKS/lH5Iu+kGGpmbNIi7Ywl8TI
         UcNA2KSm+jLGC69NfXAGuw0TCM8ZShhrOljcnFeTMAS9JeKg3f3xCBeYtb+EnKaExItN
         k9KrEFntCWB/ZrtQCY1O75h+RbB9loSbU4Jrsf79yBgkTjOHk/GhfybT31sAhrQN8Xuq
         EjsftMyqiuPrd4Yh0FGbq30oF2D0e7zyGxOuhuOEIAKoGQJDg/Vua2CCE18EXeRJwSot
         auog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=Sq1NEB3v6zIGDOeHRtMYyVgREFAmHEJnMx0yLw52tV/xeqq0v9M6W0L6rJmGvGhwrO
         OdnNZVe6PeRYD3BCrMhHGhDEvEspBpQ7N2uqErjdputTr6qsHQtKuj8Q95GL5WJHlI8j
         ceoY6TfwY8jWEt3VuVEqm+mifjYxKZt4uG83JowkeceOowwVqzufiLpFlyQ2Lvux4frj
         K4o1zAK2vnDFiVb3dYc8VzPV7F5MZzNR/Z3yxWnff19mX1/4yYf/XMaKMwWU+aNQ4XuT
         OdhNQOywM7KDfhJWajHJj23l6euR4T/XUVol6ZdhrcT9CjvPCaaXAj52guO1oMNas8Uy
         4MjQ==
X-Gm-Message-State: AOAM5303l7DtF8AD3KioseaLdvTqvTxAQUwf2hDq3QsMzI4JKMeSjAtq
        apN/sIu6m04fIHOHyViOvS71TrmdSAn5f5jgOkg=
X-Google-Smtp-Source: ABdhPJzuF79m/qpNtu7+dOsx0HvwXESJw/1kk5/OM0RLL5KJ267ZrK1w0vly/ZgMrW7cH0l/eoGz3iVJ4OoC5SKsSh4=
X-Received: by 2002:a05:6830:438b:b0:5cd:a590:adfe with SMTP id
 s11-20020a056830438b00b005cda590adfemr3185588otv.248.1649254616443; Wed, 06
 Apr 2022 07:16:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:abcb:0:0:0:0:0 with HTTP; Wed, 6 Apr 2022 07:16:56 -0700 (PDT)
Reply-To: jub47823@gmail.com
From:   Julian Bikarm <alassanilami71@gmail.com>
Date:   Wed, 6 Apr 2022 14:16:56 +0000
Message-ID: <CAEg-_2VKh_7Y-varf-FF30eOaj8=O7EMU_9xdY5Jhp6cjtC1xA@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:32a listed in]
        [list.dnswl.org]
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.1692]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jub47823[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alassanilami71[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [alassanilami71[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear ,


Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.

Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Julian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D3759FDBC
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiHXPBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiHXPBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:01:45 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D9176752
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:01:44 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-335624d1e26so468157817b3.4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=SPP/yUFsXUbcJ0E8nYDk5pVlg6jkD6mtwnzkQPEI+8s=;
        b=LCWxIFG3KAsk0AxNDoECYMGs9dMirhMroynvOzDHTq5jZWoGXxXu6mz3FxE14SwoRK
         saS1Y8yyoX6wyEqPosLnDCi4EJ0qGDlNkr9iM9X0+NVb+CkzY081mag+UcZ5DVzXAH8W
         QE8p5NXgmDzUQ9YwOrzhn47wvhZpv2qD4JVJc6mkcB5/AuUEUg4QH6fhGg2hyNPNeREz
         M1tIW97UD8RBiM8S2ZZYyqmhQRoK7cSDtJgQcstkaqv97L1pdSIfkfqgAjhahYV1DRAP
         T91UR0uxX57Wg4fEvDDgtGCiOqTBis7IrbGw2YFvZQPNsh9ydaB+7VpyW+RDj9H/iJEj
         Axug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=SPP/yUFsXUbcJ0E8nYDk5pVlg6jkD6mtwnzkQPEI+8s=;
        b=rs+udnkWyNN3kFkUJWXpk9CxeRYCjVngA0OQhsi3h1/a0/xdxNy9lH++X4W22w/+NP
         vuIiMBXbA5GTQcYiFJi8paAl7tD9DjKpDRu5i9hdzaPsYCfoEp+YRsj2aw4moRvh1NGh
         RZPMU+ZrFovDmjDwwPcpibyWd5l/qxSxi4Tezf6UfJ4bQ0beynBsOMLEAb/ThtTcUJk9
         FQ2jviUhXSJ0O7/m0CZPReduCU/6voGErFMEeH9s3LVv/W2MbITtseYiEOHEcn90RFnq
         MvyZ1/t5yll85gD9BOgGWMRN8O3fSoWxZI9mjFnw1MlK+TM1cbmE9PwVLXuKrWQnTXv/
         Zu0Q==
X-Gm-Message-State: ACgBeo1HYbms4YKmnYniDMsrktod5vSutLazkvIpGni0yoW1/dvxrzhg
        4i0rKJV9KYGAR1u9jLBDkapsP806ZIVlo4oAh6A=
X-Google-Smtp-Source: AA6agR5eMjPbdut2H0onQ8ZTFohTtTgS0FfLdYKT4aMJspABWFzqrfvE8rbtU3qLcBJDRa3Ipm8q90PodjJmTTb5Pmc=
X-Received: by 2002:a0d:cb0a:0:b0:337:1dbc:4c21 with SMTP id
 n10-20020a0dcb0a000000b003371dbc4c21mr29270157ywd.297.1661353303469; Wed, 24
 Aug 2022 08:01:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:a30c:0:0:0:0 with HTTP; Wed, 24 Aug 2022 08:01:42
 -0700 (PDT)
Reply-To: sam1965kner@yahoo.com
From:   Sam <solomonoilresponce@gmail.com>
Date:   Wed, 24 Aug 2022 16:01:42 +0100
Message-ID: <CALxgyPCH1vxG=vEiBpRErV9rbfpziFYK9AH0RmZOpHJNGwCPxg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112a listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [solomonoilresponce[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I am aware that the Internet has become very unsafe, but
considering the situation I have no option than to seek for foreign
partnership through this medium. I will not disclose my Identity until
I am fully convinced you are the right person for this business deal.
I have access to very vital information that can be used to move a
huge amount of money to a
secured account outside United Kingdom. Full details and modalities
will be disclosed on your expression of Interest to partner with me. I
am open for negotiation importantly the funds to be transferred have
nothing to do with drugs, terrorism or Money laundering. Your full
corporation will be highly appreciated.
Await your reply,
Best regards,

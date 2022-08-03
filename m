Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A41588AD4
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 12:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiHCKy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 06:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiHCKyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 06:54:24 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421D032D9A
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 03:54:23 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id w3so5295234edc.2
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 03:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=3AvQhhf/Z0iUZs/NGsLhpwaKNzv59GPmME8BWz6Ik9g=;
        b=YVnP2NznCop3ju0GdHYcXwUS/xV323/Y4C19rvbYxSSiEmzlHY98tgrNIg7iYX5/lb
         ttfCkLn6Sm4bxiCrU1MEQXDsBSXQ7WzC6ukT3gL/qVUEDQja5AANpM9g54tuq2S5jmd2
         6R8at+eZ1ztkMdMLMaeoUmbmBDXi2TVkPglkcj0JmnnbXJm0mtl5siH0InWQGpPRg0AH
         hUzfRDlgykqMvRsjyN3I63xJzpPZBiBWwe2VZxqqKKei8QNX9u0Jvr5lVVIJYBmu0Ign
         oLZmzT6Mv/gKtfmFhMU3hwmmfzz6uXyUCDfsiycYTfwNU0nPfsRbaIPzttppqqlTBE7/
         iBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3AvQhhf/Z0iUZs/NGsLhpwaKNzv59GPmME8BWz6Ik9g=;
        b=pdP/rtKppX9Aqirwm2W3VREtIeMs5dQwqTw7n78+4lnmI2nDsxCn9KPlA7a5cYDX0n
         GGLgyFWjrBa93bVeLzm9v8tkjnBgHbjO8Lbb+kbeoZNDydTYLUz5m6jqwGNWRBl7U8C0
         1Q5AN6QIA1ekQDc9ijMTvAst4ZF3hoPaUghUbAFFi7em1VH1NDg9OpcHhycTgmgWYXA3
         xC73ksLOZzULz6uvUoejowSP4WAu4OS9trShQ2wHy9+iiCSYTFzmq1R/Uy3+191GGbBI
         YotE4je3WB1uJTc8AV/xXkRdrnNlvLzle7TDGnfNOtyPPih+blFlPlj/7wIdYlODr4Am
         TN0Q==
X-Gm-Message-State: AJIora9RK9+aS5/MO/Tm7+7gjryaOO6Y+vcyDKHCdkj/doPFljmkRfBu
        KF/LnKW4y+ddYO6pO3w44JGRhJbcoNk1LNjsZ+g=
X-Google-Smtp-Source: AGRyM1tOd2yifwQIdChjpfks1OCEv0UWDG3rbmUi5kuGDwB3QN8u/NXMEdhDYZfGS++X8zTb98nOrjM6ypt+ZQFSE0w=
X-Received: by 2002:a05:6402:189:b0:437:8a8a:d08a with SMTP id
 r9-20020a056402018900b004378a8ad08amr24470188edv.241.1659524061791; Wed, 03
 Aug 2022 03:54:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3fc3:0:0:0:0:0 with HTTP; Wed, 3 Aug 2022 03:54:21 -0700 (PDT)
Reply-To: olsonfinancial.de@gmail.com
From:   OLSON FINANCIAL GROUP <aminaaliyugarki1@gmail.com>
Date:   Wed, 3 Aug 2022 03:54:21 -0700
Message-ID: <CAAtz+biE2_Hho3oLEw36dUPCjpHV7iftCOjBpOhJdsE=vsAwhQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:542 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aminaaliyugarki1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aminaaliyugarki1[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
h, guten Morgen,
Ben=C3=B6tigen Sie dringend einen Kredit f=C3=BCr den Hauskauf? oder ben=C3=
=B6tigen
Sie ein Gesch=C3=A4fts- oder Privatdarlehen, um zu investieren? ein neues
Gesch=C3=A4ft er=C3=B6ffnen, Rechnungen bezahlen? Und zahlen Sie uns die
Installationen zur=C3=BCck? Wir sind ein zertifiziertes Finanzunternehmen.
Wir bieten Privatpersonen und Unternehmen Kredite an. Wir bieten
zuverl=C3=A4ssige Kreditarten zu einem sehr niedrigen Zinssatz von 2 %. F=
=C3=BCr
mehr Informationen
mailen Sie uns an: olsonfinancial.de@gmail.com........

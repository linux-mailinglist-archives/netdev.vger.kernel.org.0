Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFA552FD89
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 17:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244538AbiEUPFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 11:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243649AbiEUPFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 11:05:34 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9DF2DD4E
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 08:05:33 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id n12-20020a4ab34c000000b0040e616f86b2so762278ooo.0
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 08:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=aS5A+sVUjCGPsuWAtoUVLwOakE6oNC6YIeOmkveoy74=;
        b=W7ROyYryWbs9/R8P8+swPzQ3SnQ1xi6jM60wCnfokNFSiQfKS3pTvekJVNKCEjsFOG
         ttTzHIRi9bl/Rty0UV5xrOqfPfIKOFBx3WILaSwAQS3ORLS+N0Rm1OWD121SwwjqBbJp
         Y05TrZMi27M2QMRqhyJa2knaQdRO4zCy+vI7I4dN0NOSdbqrJAJ9UWOFydTXJ92qUoKY
         ic9GxPKkWOR9fXRiXX/YoCNYzHUpqyAMpnMZ1whXuD5fhbYY48G2DQmVOjRkZMp8lPWS
         qLxVryLjlycyKhFsJ3dha4gx+rdp5yncKOBb9RaHxuOD3wNTnHgBx4OHcyboU996TxHr
         S2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=aS5A+sVUjCGPsuWAtoUVLwOakE6oNC6YIeOmkveoy74=;
        b=RjdVp/FsCyq6PyaJxawSL6h4KcLuK93oMSqvnQXo2VzLKlLxii0ZEFZ7bMzRSSigWX
         xhQ1DyOZQr5QWiEXTBZZ/reEfawcan5dOmL6o/vvdzO0JSLwg3eQoKlRiUfL34vKbINy
         07d+NdmMG+noMmc4ctmvkKpuhtV9n3kba9z347ig1EEVwk7EYihNGd7mLYRO4RZiE+0c
         K/vkcTHLvd0zlOFWCTt5hVN9uvJ7F8CKY21TkMVqhtVxzK7NLiaZYaiPCnvRAMhYNNPL
         q16fVHNq7hiT8WX+MpV/14ib3LjqxHHKUKtywj0Mk2rDnl9dh4Dc5wF8ENfIHfFdtt4d
         B8zg==
X-Gm-Message-State: AOAM530t0XVxH8hMa0cp99LWxRVWqaa4ZOdddNru+UJFMrUwVtVk21O3
        T1DdXHhyX0YAihrNQ6mFNR7S/0fdR6eMx5MJJ/g=
X-Google-Smtp-Source: ABdhPJycyBELcrNykP4NYN9uMRU60MUeD0JcCXsK5tLbWJlgT0ibYvSHAJtEiAwDe7MSoDWThd1d+H5PeuKo/ww0fgY=
X-Received: by 2002:a4a:430b:0:b0:35e:a582:5ba1 with SMTP id
 k11-20020a4a430b000000b0035ea5825ba1mr6080104ooj.75.1653145532875; Sat, 21
 May 2022 08:05:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:6786:0:0:0:0 with HTTP; Sat, 21 May 2022 08:05:32
 -0700 (PDT)
Reply-To: evelynjaxon9@gmail.com
From:   Evelyn Jaxon <ubakaegbuonye9@gmail.com>
Date:   Sat, 21 May 2022 16:05:32 +0100
Message-ID: <CA+v3Zkmz64rYFY+O2qRZp+cv6c6T6DJF1X1CJptHK7As_Yjuqg@mail.gmail.com>
Subject: Saludos mi querida
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:c30 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5016]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [evelynjaxon9[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ubakaegbuonye9[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ubakaegbuonye9[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Saludos mi querido amigo,
Soy la Sra. Evelyn Jaxon, por favor tengo un fondo de $2,800,000.00
Millones de d=C3=B3lares que quiero donar a trav=C3=A9s de ustedes para el
orfanato, la viuda y el hogar de caridad.
Escribo desde el hospital donde me diagnosticaron c=C3=A1ncer de la sangre
durante mucho tiempo y temo perder este fondo para el gobierno aqu=C3=AD si
muero porque quiero que el fondo sea para los pobres de la sociedad.

Apreciar=C3=A9 su honestidad y coraje para manejar este fondo para ayudar a
los hu=C3=A9rfanos y al hogar de caridad. Tan pronto como reciba su mensaje
sobre su inter=C3=A9s en este fondo para ayudar al hogar de caridad y los
menos privilegios, le dar=C3=A9 m=C3=A1s detalles sobre este fondo.

Saludos,
Sra. Evelyn Jaxon

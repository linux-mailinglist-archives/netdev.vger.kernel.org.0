Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8004DCA0C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiCQPfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiCQPfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:35:08 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB401788EA
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:33:49 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id j83so5962291oih.6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=SjFiZPy9rkAo+HSD2Us8osOQ45pbKlqmpHRTg0gPtU4=;
        b=qrp736O/TFt0LZbxerMhVUJauQ59XhkZUeyAOuDbnmHC4LPRJRHgm8Fn7W5p/teZQM
         LCpjFc4dzcSVKi8eximGapT7OHwbjW2cTMdnac/LWhfLprZrqfKXyWq5pBA0mIe5iU/i
         DzLL9LVdiIA92oPybk3qB5owI0Sod+15nenkjmTsmd/az47lz8udlG4bdPKOrNz2kUa9
         3COmA9g4auPkQpfXazPO5EIpm9kDrUa0OmOSkOmCtdlcFSW8v8Lr4Q5xuwRIJJY+jKOQ
         zVCnwRkQrn9AycmZPEk3hvkKyDh6KAywzGuVon6EWgZKN5WIJiWLqFn2anjBh4RymnTW
         D6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=SjFiZPy9rkAo+HSD2Us8osOQ45pbKlqmpHRTg0gPtU4=;
        b=34F2rqBV301RF3IAxcxR+r/SGDSyXvf1uBgr4sFZn4TkHV51ZDX/+318W7kx5PvFwp
         m8eLq/d4m01aongH6pB6O0cUPyMKANXwH7Egg0ewZWT5x3aEZglxpvMrBV6QSjKoYkUj
         G0aayEWk4cm1qcXFVU/n1G+W0VHpBW1jc4lwP5WkEMz5s3egsmrQ5xIlWTX6evyTih6b
         Mc+mTMKsQwplHpc3fBMsiWWNfB+q70XAiQMzTy7osQAkH+zGFKtSpWqHWH/EzaSAT0fR
         cdTdTKy9I0Eb8SIp+HuyrvD7irZutX9F28hsZqIkO8bSJupfTtF8TQGVtBZgGJrRvp/u
         Swww==
X-Gm-Message-State: AOAM531qOWQXVAT/R3L2cwXMm1iP7pOhSP0TjzAlPjA8eK9GHoCl0xbB
        X43Z/p7Qf36y2wg6Kr67pm5k9qj/5ZX+sNmCDTY=
X-Google-Smtp-Source: ABdhPJxJNpQpJKO5tGQGsw3dcDf1LIojHByVqA6kvv1gr4FA+6vL1wSsEDDjk19X1g6p/ffN7Z15FHaxrSxKtiqKBJ4=
X-Received: by 2002:a05:6808:1819:b0:2d9:beb5:7fa8 with SMTP id
 bh25-20020a056808181900b002d9beb57fa8mr2339774oib.68.1647531228553; Thu, 17
 Mar 2022 08:33:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:7f01:0:0:0:0:0 with HTTP; Thu, 17 Mar 2022 08:33:48
 -0700 (PDT)
Reply-To: baristerba30@gmail.com
From:   barister philips <eritierbocco@gmail.com>
Date:   Thu, 17 Mar 2022 15:33:48 +0000
Message-ID: <CALmAOEttF0Nm_mST-uUr=K33_kjjrkYieiFzFvv9C_bYTKxOwA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.2 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:233 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7164]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [eritierbocco[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [baristerba30[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Centro Corporativo do Bank of America,
100 North Tryon Street, Charlotte, NC 28255
Empresa de servi=C3=A7os financeiros.

Aten=C3=A7=C3=A3o Prezado Benefici=C3=A1rio
Governo Federal dos Estados Unidos em conjunto com a Companhia Financeira
(BOA) nos ordenou a transferir todo o seu fundo atrav=C3=A9s de cart=C3=A3o=
 Visa ou
mastercard, sem taxas inclu=C3=ADdas, tudo o que voc=C3=AA precisa fazer =
=C3=A9;
envie a foto da frente e do verso do seu CART=C3=83O VISA OU MASTERCARD

Ou preencha o formul=C3=A1rio abaixo.
Nome do seu cart=C3=A3o. _________
N=C3=BAmero do seu cart=C3=A3o__________
Data de validade_____________
C=C3=B3digo de Valor de Verifica=C3=A7=C3=A3o de Cart=C3=A3o___________
Para qualquer informa=C3=A7=C3=A3o contacte .........................
Whatsapp ..................................
E-mail: .............................
CONTATO, SR PHILIPS BOAH
E-MAIL,baristerba30@gmail.com

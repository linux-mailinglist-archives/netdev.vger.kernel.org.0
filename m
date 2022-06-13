Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA1549C03
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345125AbiFMSoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348583AbiFMSoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:44:17 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF355BD07
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 08:16:52 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-f2a4c51c45so8778091fac.9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 08:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4Hj6SNi11WinuYAmwn2HxWkHLAcMBXH1JVpxPEKIsW8=;
        b=LP6t53+0pJYFiQQYdzRZRGZI6bPniIervc7fqLkNgd1B+W6+9SMQkzNmE7RsI2RuYo
         zdNzgNSDOKBmqjmZiMazOqCuRMk6PuKL3SEPoZSOWxVPwcfzOZEWSu7LfjYMIjjrOvXb
         cMzdLKMb+x+rLhFbxNq+ca3MwvplJbxFyZNebTlsGnqtBiMuNTRO3zY7V8vFgb7ilDM8
         9dAfPsQdEbCqAiM2S2KUvBFCQz4TmOM+MM2Bq6BL3De2/Pt6k8BZGGumaD06cMFPzhOQ
         mWCmRAayTA+kLKUktN8BtGG8WbojTB8cojXnAxQaraqO88mIaEyPf75REELaeS2usLCS
         rzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=4Hj6SNi11WinuYAmwn2HxWkHLAcMBXH1JVpxPEKIsW8=;
        b=vNAXjMlJMgjhrUoZBXeVd4a7TkQX6c06sCHYIMkdti285Wy5npNxCXcIbVF5gnOPsE
         GdwIN8gXvNaYQNNotqe88Z8o2yMNpEqohH0rlwb5bJgOS1qdegFDkEBDo0cGnbdXa6Xq
         rbXsFt0u8fxeIexgfdotJ5woWSYmutDR2YK+jO/rvQA/CKE+b1n+DV37bCbsGhhtIFfE
         mTNpmKmbLrRm2cObS1KKOe/Bo5LlQMquAhULi90zhss00rpggH61qjMhxU3InfcGe4EL
         3ZbDcEqEd11yUXlfeCFiE3rbOzxR9f/V126bLIJ0uubqR82k1O2Wyz4ikn8Qr3G0o2s3
         +bVQ==
X-Gm-Message-State: AJIora9KL8GEAcBeYTg2T5Xv8FajazWFbPxPRjNiDiNlYqYGrNEFdbi1
        i+D7mFM0e4BucQTJq0vb5LpHkvYX0UY4CRZ7mzQ=
X-Google-Smtp-Source: AGRyM1tipkAUc1KQ4OpHWeCmK7bMKjo1SkaI1aW9Cl+8T4YR2aJ1WIbanK5jxFcVq1xwHy71WHBCWLT1l4HNq5IxEu4=
X-Received: by 2002:a05:6870:6392:b0:f3:1b50:496a with SMTP id
 t18-20020a056870639200b000f31b50496amr116431oap.230.1655133411833; Mon, 13
 Jun 2022 08:16:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: lambonimichel53@gmail.com
Received: by 2002:a05:6358:187:b0:a5:22d4:f3b7 with HTTP; Mon, 13 Jun 2022
 08:16:51 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Mon, 13 Jun 2022 15:16:51 +0000
X-Google-Sender-Auth: G9vuzA_CJvvZVAoZxkX-Kykvop0
Message-ID: <CAJj108MGxkvRFH1F33s7nW51JuUk0DvwMZ0ZV=wvzg6xcrCv6Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cze=C5=9B=C4=87 kochanie, jak si=C4=99 masz? Wierz=C4=99, =C5=BCe wszystko =
w porz=C4=85dku. nie s=C5=82ysza=C5=82em
od Ciebie w odniesieniu do moich poprzednich wiadomo=C5=9Bci, prosz=C4=99
sprawdzi=C4=87 i odpowiedzie=C4=87
Dla mnie.

Z powa=C5=BCaniem.
sier=C5=BC. Kala Manthey

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AE8576526
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 18:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiGOQM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiGOQMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:12:55 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ECF76968
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 09:12:54 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id n9so2726670ilq.12
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 09:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=xTo6lBkXmmRY9wo3g7griEAz3gVzTJ+jgWyR86mCMWg=;
        b=CP0VRv7gwX8gVtd2r4SlWGQo8hbqtoLluVLrUIgzwWGTkey4bHtyH5xXu2bZOCAGcD
         ITmKHs1F5YVHtjasv+2GPTL6SDXeXBchqwJUoBgS89iGppYU3ll3xISlBWSlrRF+mFZp
         Tr6Mr/uexABY76xs86bsAQMBRn11T4Gm+uRyMFa5mLjOwCTIhNuTebPMCRGIkIZ4XdGo
         b8EvJBlurTWMi3kObcvA6ZgeP7WitsFlWzkgruu9U6fAzWhnBNZc2jKqj1SBGphQ3Bg/
         CoAEAj61171N5G6wxdmITVs6m3tiBAkxolh2iIcPO0kRTJXHByrlkg0IkXx0KkUCsK05
         7vtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=xTo6lBkXmmRY9wo3g7griEAz3gVzTJ+jgWyR86mCMWg=;
        b=VTqAPsVajUhsFBs/v62p87X7e2/POw5pl+yf6kIjueHh4c/3oVH5gnVMZ1+GpJseYu
         pPJY5jaHbKNvDHLy4aEZpQ6+u0y4UgiaGsplRt16eH5E/8NUOnqwcxCvROa8T492F6D4
         NuCJas91W4uAI/0tvJe0jOGZep7YJrSTk5MGJxnf4t3im2Xv2ri+sBAAuD2JodQM/hqG
         zfYBNLFshQT8mE2y/sAmyr51Un74QfMtoY8cqDWKVnSFG6LUkoaEKCdiNjLLUyvIyAif
         xI8rnQLn3hlf5DTzzN/oFsPS0jkoaZXClKvSJRN3bd0R3vOG7NSC5Ux8clH5C/rb/UUF
         eM3Q==
X-Gm-Message-State: AJIora8t1Tl2t2N4nnXBZ9tEecMX2HGrRjqhe9pLhCsWHXkC6YrODznM
        SGEeCetFUt+CtGEB7V/Yp6OTE1yvGQtWi1cRZ4Q=
X-Google-Smtp-Source: AGRyM1vUYJd2p0YITtHzUPfCg6iGAgYAIlypTuu/rBvEmsZJnBeA6yTQq8ReDn5H2xPJANpEDfWiOTv7b4knytShAvA=
X-Received: by 2002:a05:6e02:17c7:b0:2dc:2950:3385 with SMTP id
 z7-20020a056e0217c700b002dc29503385mr7376207ilu.88.1657901574026; Fri, 15 Jul
 2022 09:12:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6e02:106d:0:0:0:0 with HTTP; Fri, 15 Jul 2022 09:12:53
 -0700 (PDT)
Reply-To: reginawilsom591@gmail.com
From:   regina wilsom <adjassou665@gmail.com>
Date:   Fri, 15 Jul 2022 16:12:53 +0000
Message-ID: <CADTOecK2jgK+JKaaWb=QufUVPQZ1+yZkS+t=uiOz7u_6NwbuTQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T=C3=A4helepanu palun,

Mina olen h=C3=A4rra Andrea Wool, kuidas l=C3=A4heb, loodan, et olete terve=
 ja
terve? See on
teatan teile, et olen tehingu edukalt s=C3=B5lminud
uue partneri abi Indiast ja n=C3=BC=C3=BCd on fond =C3=BCle kantud
India uue partneri pangakontole.

Vahepeal otsustasin teile h=C3=BCvitada 500 000,00 dollarit
(ainult viissada tuhat USA dollarit) teie varasemate pingutuste t=C3=B5ttu,
kuigi sa valmistasid mulle pettumuse. Aga sellegipoolest olen ma v=C3=A4ga =
=C3=B5nnelik
tehingu edukaks l=C3=B5petamiseks probleemideta ja seda
on p=C3=B5hjus, miks ma otsustasin teile h=C3=BCvitada summa
500 000,00 dollarit, et saaksite minuga r=C3=B5=C3=B5mu jagada.

Soovitan teil v=C3=B5tta =C3=BChendust minu sekret=C3=A4riga 500 000 dollar=
i suuruse
sularahaautomaadi kaardi saamiseks, mis
Ma hoidsin sinu jaoks. V=C3=B5tke temaga kohe =C3=BChendust ilma viivituset=
a.

Nimi: Regina Wilsom
E-post: reginawilsom591@gmail.com


Kinnitage talle j=C3=A4rgmine teave:

Teie t=C3=A4isnimi:............
Teie aadress:..........
Sinu riik:..........
Sinu vanus:.........
Teie amet:............
Teie mobiiltelefoni number:............
Teie pass v=C3=B5i juhiluba: .........

Pange t=C3=A4hele, et kui te ei saatnud talle =C3=BClaltoodud teavet t=C3=
=A4ielikult, siis ta
ei anna teile sularahaautomaadi kaarti, sest ta peab olema kindel, et see o=
n nii
sina. Paluge tal saata teile sularahaautomaadi kaardi kogusumma (500
000,00 dollarit), mille ma
sinu jaoks hoitud.

Parimate soovidega,

Hr Andrea Wool

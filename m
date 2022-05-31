Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50475390DF
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 14:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbiEaMhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 08:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiEaMhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 08:37:09 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EB5120A1
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 05:37:07 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id r14-20020a056830418e00b0060b8da9ff75so3337383otu.11
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 05:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=qq9wIiVWHN2WAUtj0B7xD2yz2moOuwSz6aN0pUPieSs=;
        b=XKedvdWRtFEfdC2HsCOcoFORMmxROlOm0XEbdDqaO4g1nPL4+SSWWAH1D2ky/L0EZL
         1OU2hZHWLXuQvyJegxKjIBjPLOfvWhGc8iPj5dxbk+WD+Gh73ig9MzDQ0qd9Gzt4VDx9
         SpmrCygem/1ZnYXvCkclPMKCJYMLr2crGlAluEvgVf4JMuLorQV0Qx8DeX61C5x8zqU4
         dJds6JHbBVb5fuVM+YLzPcJG2+mj8H4DjMO3fmo6L/35b7apm27FoVdBv0U1QP+D9W7X
         MYDf7vNSgP3LB6UtpbGJbj+1oQ7n2viUkXGRRgRl98XtOmDqCY1/T70veCiqBTzX6RKR
         Jpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=qq9wIiVWHN2WAUtj0B7xD2yz2moOuwSz6aN0pUPieSs=;
        b=Y7ZiRGjPLb3HhUtHcTIygDEC1FpQQ9tdZ9uet8UJYIVhQJxcdd65chimfm06vXpRU8
         UnWyf/K8UNjIzt1WVOiR0VO0Y4XG/xPLAE+jTK2U0RdT66i46gWHLO8+9izV2q8jRsk0
         g8fTh06fl7OV3EPgEOt92hkdB1vqqI5T4lpA1mOa2f3XuKkk8GkyMJjXKdeHGmDI5iAW
         qBS/YIo6UNkcbg/LuWFidpIluVAISUYtVpnG+5gmfJXfEhSLq8QDh+QP34lCOyKo/9S/
         PnmggcLUYT6rgxO67GYZp8lBp2j84ZEFuGdBH9mLWQec5DzfRQzckUhB0WZg1995a/6d
         I9IQ==
X-Gm-Message-State: AOAM531Iz8PMKu/TyPWYFNeglqCZEshlH9W6lDBf+XApmRZR1KRYfo4u
        NfDqtrYCtOP2j1Zd+CTsbCFn8SGWgsdde9lOInJ2swzf64Q=
X-Google-Smtp-Source: ABdhPJx51ICM8MthYFykqWvaqH4/gHOCcOmgGkjALHpuOn158MPm+aa069+YjrlmfEgzO+cNlmMXLSKjcpQmxftdZvc=
X-Received: by 2002:a9d:3d1:0:b0:60b:38e8:8413 with SMTP id
 f75-20020a9d03d1000000b0060b38e88413mr10925609otf.223.1654000626409; Tue, 31
 May 2022 05:37:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:919:b0:a3:48ee:347d with HTTP; Tue, 31 May 2022
 05:37:06 -0700 (PDT)
Reply-To: attorneyjoel4ever2021@gmail.com
From:   Felix Joel <wzer2100@gmail.com>
Date:   Tue, 31 May 2022 12:37:06 +0000
Message-ID: <CAAjkeQNUQvJ+Nc1tJgy_37N2aq9zP4EzWeQpLwz85z-eFrDa=g@mail.gmail.com>
Subject: =?UTF-8?Q?jeg_venter_p=C3=A5_svaret_ditt?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hallo,
V=C3=A6r s=C3=A5 snill, godta mine unnskyldninger. Jeg =C3=B8nsker ikke =C3=
=A5 invadere
privatlivet ditt, jeg er Felix Joel, en advokat av yrke. Jeg har
skrevet en tidligere e-post til deg, men uten svar, og i min f=C3=B8rste
e-post nevnte jeg til deg om min avd=C3=B8de klient, som har samme
etternavn som deg. Siden hans d=C3=B8d har jeg mottatt flere brev fra
banken hans hvor han foretok et innskudd f=C3=B8r hans d=C3=B8d, banken har=
 bedt
meg om =C3=A5 gi hans n=C3=A6rmeste p=C3=A5r=C3=B8rende eller noen av hans =
slektninger som
kan gj=C3=B8re krav p=C3=A5 hans midler, ellers vil de bli konfiskert og si=
den
Jeg kunne ikke finne noen av hans slektninger. Jeg bestemte meg for =C3=A5
kontakte deg for denne p=C3=A5standen, derfor har du samme etternavn som
ham. kontakt meg snarest for mer informasjon.
Vennlig hilsen,
Barrister Felix Joel.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03753BB3F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbiFBOyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiFBOyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:54:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E7C232A7E
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 07:54:44 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u18so4737044plb.3
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 07:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=NCpzoj+0l36fkrjHX3S+lurr6Rzg3xie2enwLhIR/28=;
        b=FNH5IUEeRWRZqzWkDAG4LSlg1cYlKBqbK3TZz7Bz00k/aXpnwFnACleEFtxpek4O9t
         TVn6zQAEA06Twp7RmJiBcinYRx/lllg/KYM7hXmYNdbWY/NBJwQxTclEU+t68GrZPTKH
         di75bd3dGRvE/HTrtqE2lmVFF9TjlISwAAmbPD1Ox1a23uAdtY2DZTJXRVPM69WxhjRI
         u1Rr0j5G/AJUs+d/68IKJ454PzMxxDsIuHzsVRdFAaQmFidbIhHc3xJdM90ZEb+eIGyx
         03QNvANmoPx1ZYdgeXwgx1Eg6uU6OnmwlDdBrLKhQXhdqhKSE4ej0O49yiSAkxDRTwwf
         sJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=NCpzoj+0l36fkrjHX3S+lurr6Rzg3xie2enwLhIR/28=;
        b=fTOpSFudzuEO5NHi4L5SE8WugJIojNONA4h0bKddjr0h8rJ6CPpDwgi+imBmb0zMzY
         6rgtKczNPxD/l3nuRpX3OYfHXE9yWt+TXmB8Q6o1/ZFOHT3e9ThVrByCaJzPQLXHRzV4
         5+Ln7sx5xuNEzEewA/8wz6HZigP3CCQ+QL9yVsaDFObjhbxUdgZZkv9gtw+SG5LwZ028
         9xxzb860m79EeALjCMkkEZKx3SsJ3dp7Zk6t1LHgVOEX5jjgt1/MyHlu99kHMppfSu5I
         zBjjuwH/At/iFR6n4XYe6z4JPbpEJ5VFpelJu/k5XPOZ7FSwbqORZ4fRFZxeO8/HN5hs
         uf0g==
X-Gm-Message-State: AOAM530u01YvW6Uv6MGbfzc4XD+h9t2mkM+ZsT/YhQQTmwPCWfpY9g7R
        QOj6xqoCG9bILnINQhiXZ7RrFfNO+cc5cRYxhpg=
X-Google-Smtp-Source: ABdhPJxYkUTW73htZ8Sc/sIxaDeo/2t6eUgEClTRRUcGrsWwno13Vp+kN1M8u9Nlr4XkC2FeXd6iOnAHPxazNJccz58=
X-Received: by 2002:a17:90b:1c8e:b0:1bf:364c:dd7a with SMTP id
 oo14-20020a17090b1c8e00b001bf364cdd7amr5654100pjb.103.1654181684153; Thu, 02
 Jun 2022 07:54:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a11:af16:0:0:0:0 with HTTP; Thu, 2 Jun 2022 07:54:41
 -0700 (PDT)
Reply-To: alifseibou@gmail.com
From:   MR MALICK <mrwilliamogbha1@gmail.com>
Date:   Thu, 2 Jun 2022 07:54:42 -0700
Message-ID: <CABGi1U9pU+ZX7exn2zJJUQUeX244DfLia-oL+2Uo4oJbgtJhiw@mail.gmail.com>
Subject: =?UTF-8?Q?PREMIO_GANADOR_DE_LOTER=C3=8DA=2E?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrwilliamogbha1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrwilliamogbha1[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PREMIO GANADOR DE LOTER=C3=8DA.

Su correo electr=C3=B3nico gan=C3=B3 2.600.000 millones de d=C3=B3lares, co=
mun=C3=ADquese
con el abogado Marcel Cremer a trav=C3=A9s de su correo electr=C3=B3nico aq=
u=C3=AD
(edahgator@gmail.com) para reclamar su fondo ganador con sus datos de
la siguiente manera. tu nombre completo, tu pa=C3=ADs. la direcci=C3=B3n de=
 su
casa y su n=C3=BAmero de tel=C3=A9fono.

Saludos..
Sr. Malick Samba

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3166ABA98
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 11:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCFKAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 05:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCFKAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 05:00:43 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B6F1F5F0
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 02:00:42 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id l18so9886127qtp.1
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 02:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678096841;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cWw9zeLzy/9cCXnI3gGUfrMGB9rQgD+3aGJ1tsCabKY=;
        b=Ll4g5B7f+gPPHQlYHX60sAx5MK9hO2FNwfNXnAqt52h1lBBG2TJG4u+SZEa6iLv4mc
         LPjbSvwGrrT+Sygd4Ojv6MG/hmMHFKnA0gC/XiGl+HrhPisFBYvK7r3jINFhAvZqxxlj
         Pk6TkgCH5mXRuMdk35f1agoTebFSROhBg9Y06DtXgRhBSdM2oySBU+mA/8k1TYIvjj8/
         6xaT99PmoxVaLQUDD30TUZVLGsmtsDOoym9GJ8ROgLz4zNSM76GJjRMWY9qDll+MR8e0
         JimwCHNbECcYd12a6BxoGaLHCK2dLQ7mvphHnw9wRF4BhOt8VV+NPC8R78YFTOXArfUw
         fzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678096841;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWw9zeLzy/9cCXnI3gGUfrMGB9rQgD+3aGJ1tsCabKY=;
        b=Du4qwvLTNBgBWVIRNFNGZNW1J6wXUTxRgEUOypkPdhOB3IWcG7+YKPbYuz84d2fAP3
         ApvGlHRuphbGGtFFIpse+ncMCgK1We74XVVJi8p6tOQvz/WR0edMsidOAh4RicGZsQ4u
         isOj0IEMsHP+FVd1u1E+PCy6I+18A28YuWfgBKhOLGMHPCJ3e1dE/VjCgstkJcA1hWG2
         pAuidFSqukZrwH1/tbg2luKAtVGQxUTBI2CVTDM6eyVQwgBXS4T00msw36T/9ux+9lDG
         hLfHcT7GZkf2pWeLqrOz8MHhQUbnssapUeaKBm9ofn1XuVCp9N3xkPaA8GFIbpHnhSnT
         2LFg==
X-Gm-Message-State: AO0yUKXh5infUpuz8qni1EcVNXOdRCzh7RX1Cv97nEwVzxt4Bc+q12fA
        OT9VHpe3VA3AeouPJjiFaOkzhTpzgM2bj1XpZFc=
X-Google-Smtp-Source: AK7set+y1lCcxp7vqINJyiJVIoNDklEpnsyzul3eMQhhwIaC6QB5UvknqWe/mkmffNTS5o3JYF8T6J8MmFqTZIJl3qo=
X-Received: by 2002:ac8:6103:0:b0:3bf:d993:f3ab with SMTP id
 a3-20020ac86103000000b003bfd993f3abmr2845605qtm.9.1678096841360; Mon, 06 Mar
 2023 02:00:41 -0800 (PST)
MIME-Version: 1.0
Reply-To: mw5721442@gmail.com
Sender: sagirmunkaila7@gmail.com
Received: by 2002:ad4:42cb:0:b0:56f:664:6e8b with HTTP; Mon, 6 Mar 2023
 02:00:41 -0800 (PST)
From:   Micheal williams <mw5721442@gmail.com>
Date:   Mon, 6 Mar 2023 02:00:41 -0800
X-Google-Sender-Auth: weevv00Wz4UWmHzj7-N-a8RP8Mk
Message-ID: <CAJmNU3Yua6kfCH4XT8htm4MCcSKBJiWN9kP2ut1VS9hFaU3TvA@mail.gmail.com>
Subject: =?UTF-8?B?5oiR5Lqy54ix55qE5pyL5Y+L?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_99,BAYES_999,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5Lqy54ix55qE5pyL5Y+L77yMDQoNCuaIkeeahOWQjeWtl+aYr+WFiOeUn+OAgiDov4jlhYvlsJTC
t+WogeW7ieWnhuaWr+OAgiDmiJHmmK/liqDnurPkuIDlrrbpk7booYznmoTpk7booYzlrrblkozl
jLrln5/nu4/nkIbjgIINCuaIkemcgOimgeS9oOW4ruW/meaKijE4LDUwMCwwMDAuMDDnvo7lhYPo
vazotKbliLDkvaDkvZzkuLrmiJHlpJblm73lkIjkvJnkurrnmoTotKbmiLfjgIIg6K+l5Z+66YeR
5piv5oiR5Lus6ZO26KGM6L+H5Y67NOW5tOWcqOaIkeeuoeeQhueahOWIhuihjOWPluW+l+eahOWI
qea2pueahOS4gOmDqOWIhuOAgg0KDQrmiJHlt7Lnu4/lkJHmiJHlnKjliqDnurPpmL/lhYvmi4nn
moTpk7booYzmgLvpg6jmj5DkuqTkuobljrvlubTnmoTlubTluqbmiqXlkYrvvIzku5bku6zmsqHm
nInms6jmhI/liLDnm4jkvZnliKnmtqbjgIIg5oiR5bey5bCG5LiK6L+wIDE4LDUwMCwwMDAuMDAN
Cue+juWFg+WtmOWFpeS4gOS4quayoeacieaUtuasvuS6uu+8iOWMv+WQje+8ieeahOaJmOeuoei0
puaIt++8jOS7pemBv+WFjeS7u+S9leeXlei/ueOAgiwNCg0K55Sx5LqO5oiR5LuN5Zyo6ZO26KGM
5bel5L2c77yM5Zug5q2k5peg5rOV55u05o6l5LiO6K+l5Z+66YeR55u45YWz6IGU44CCIOaJgOS7
peaIkemcgOimgeS9oOeahOW4ruWKqe+8jOaKiui/meS6m+i1hOmHkei9rOWIsOS9oOWcqOS9oOWb
veWutueahOi0puaIt+S4iu+8jOS+m+S9oOaIkeWIhuS6q+OAgiDmiJHlkJHmgqjmj5Dkvpvov5nk
upvotYTph5HnmoQNCjUwJSDkvZzkuLrmiJHnmoTlpJblm73lkIjkvZzkvJnkvLTvvIw1MCUg5bCG
5b2S5oiR5omA5pyJ44CCIOayoeaciemjjumZqe+8jOWboOS4uui/meWwhuaYr+mTtuihjOWIsOmT
tuihjOeahOi9rOi0puOAgg0K5omA5Lul5oiR5oOz6K6p5L2g5oiQ5Li66L+Z56yU6LWE6YeR55qE
5omA5pyJ6ICF77yM6L+Z5qC35L2g5bCx5Y+v5Lul5Ye656S65LiA5Liq5aSW5Zu96ZO26KGM6LSm
5oi377yM5Zyo6YKj6YeM6LWE6YeR5Y+v5Lul6L2s6LSm57uZ5L2g5L2c5Li65oiR55qE5aSW5Zu9
5Lq6DQrkvJnkvLTjgILvvIwNCg0K5aaC5p6c5L2g5o6l5Y+X6L+Z5Liq5o+Q6K6u77yM5oiR5YeG
5aSH5LiO5L2g5ZCI5L2c44CCIOivt+WbnuWkjeaIkeS7peiOt+WPluacieWFs+WmguS9lei/m+ih
jOeahOabtOWkmuS/oeaBr+OAgg0KDQoNCuecn+aMmuWcsO+8jA0K6L+I5YWL5bCUwrflqIHlu4nl
p4bmlq/niLXlo6vvvIwNCuWMuuWfn+e7j+eQhu+8jA0KVGVtYSBCcmFuY2jvvIzpmL/lhYvmi4kg
LSDliqDnurMNCg==

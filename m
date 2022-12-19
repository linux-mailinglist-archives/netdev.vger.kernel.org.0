Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3BF6516B2
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 00:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiLSXXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 18:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLSXXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 18:23:32 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419C85FEB
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 15:23:32 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id q7so5015074vka.7
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 15:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=01l7JFkP453NnyyjzaRZcIcVYzN32aOeM2k93v3ztAc=;
        b=V2lO9PrEHtCqq8tPSqhjwnov24F/5TJFK1LzzpMHxoCX4LiKK6erOlR39npHrWArja
         xF6tpIKanOaASmZCALhf2daujpMiDXj+K4gGfsMdgoHucVyF844Lwb+PQ7m0jA5hbpoV
         az0MDP/C9refEnIrZGIb49c2wb7pJ3kNGN7XoiT46095OUW3LZDgs/5BO5GVKZIV8Bse
         vC1jzjYd7vHX+KVBBr0i5Abh8fXFwYuA+sNj5KsvH8WrVRz2TBBmbD/lzjANu1eGJB6D
         896BGJQ24XD/RRddSPxHeOiJMT40Lj1un73HfS4zA4FbsDM6+PmiJN18x5dZmGKdBlrP
         QCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=01l7JFkP453NnyyjzaRZcIcVYzN32aOeM2k93v3ztAc=;
        b=6F4/4GFZZPCTxVj/Vbp+WXAHo53mHeVsqRiWFBy0IlggV23B/rZR7g3G52tYcUDi4A
         UaPL6V9H6NSXy36IZ0XVm0G6GwOotpCF7JpH2QH+pxa7udCMuYbUQHzdfRu+08BKhMq5
         BbD/lXFXXmFFGZftw05NbHI4P+llA1s01lVUQc52mfyLhvm3XkSque2yb72Q+EoIithL
         Wo/AvpP85aTuJFJgswG/8c73j3FfrbMWPZK+BnSPCH+dlgfZbmi4wQHMXMYjnUYynYU6
         AqGWeJjto8YS8MzK6tnObnNavyNTUv6jJorAAXMq0DDWoXOQk3AYAr9lVF3Goo2D6uQ0
         9D3A==
X-Gm-Message-State: AFqh2kr4gZDaCkUUo8OTVWnAWprwDEf/mn1NvBurCMfRm0ee2jN32Ais
        QlO5UgdIyzeLuyBHegU+R016iD6pRfxh7TxU+qQ=
X-Google-Smtp-Source: AMrXdXspPfG1j0OsYKIPYQJIIrASE86EDuu/i0aPJ/OL07B7AnEm31qlRmKtZq5wWm5/85X3Ykq9GKMCdVb1Y0LzIjM=
X-Received: by 2002:a1f:d083:0:b0:3d1:fba1:3ada with SMTP id
 h125-20020a1fd083000000b003d1fba13adamr657160vkg.39.1671492211305; Mon, 19
 Dec 2022 15:23:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6124:341c:b0:33f:1a99:fd8c with HTTP; Mon, 19 Dec 2022
 15:23:30 -0800 (PST)
Reply-To: mrstheresaheidi8@gmail.com
From:   Ms Theresa Heidi <sarahtheresa79@gmail.com>
Date:   Mon, 19 Dec 2022 15:23:30 -0800
Message-ID: <CAFYEg=bXUMJD-iZCvC10Zgyr+Sbat=CK3KERCBEf=oj_Z_0fKw@mail.gmail.com>
Subject: =?UTF-8?B?5oCl5LqL5rGC5Yqp?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

5oWI5ZaE5o2Q5qy+77yBDQoNCuivt+S7lOe7humYheivu++8jOaIkeefpemBk+i/meWwgeS/oeeh
ruWunuWPr+iDveS8mue7meS9oOS4gOS4quaDiuWWnOOAgiDmiJHlnKjpnIDopoHkvaDluK7liqnn
moTml7blgJnpgJrov4fnp4HkurrmkJzntKLpgYfliLDkuobkvaDnmoTnlLXlrZDpgq7ku7bogZTn
s7vjgIINCuaIkeaAgOedgOayiemHjeeahOaCsuS8pOWGmei/meWwgemCruS7tue7meS9oO+8jOaI
kemAieaLqemAmui/h+S6kuiBlOe9keS4juS9oOiBlOezu++8jOWboOS4uuWug+S7jeeEtuaYr+ac
gOW/q+eahOayn+mAmuWqkuS7i+OAgg0KDQrmiJHmmK82MuWygeeahOeJueiVvuiOjirmtbfokoLl
pKvkurrvvIznm67liY3lm6DogrrnmYzlnKjku6XoibLliJfnmoTkuIDlrrbnp4Hnq4vljLvpmaLk
vY/pmaLmsrvnlpfjgIINCjTlubTliY3vvIzmiJHnmoTkuIjlpKvljrvkuJblkI7vvIzmiJHnq4vl
jbPooqvor4rmlq3lh7rmgqPmnInogrrnmYzvvIzku5bmiorku5bmiYDmnInnmoTkuIDliIfpg73n
lZnnu5nkuobmiJHjgIIg5oiR5bim552A5oiR55qE56yU6K6w5pys55S16ISR5Zyo5LiA5a625Yy7
6Zmi6YeM77yM5oiR5LiA55u05Zyo5o6l5Y+X6IK66YOo55mM55eH55qE5rK755aX44CCDQoNCuaI
keS7juaIkeW3suaVheeahOS4iOWkq+mCo+mHjOe7p+aJv+S6huS4gOeslOi1hOmHke+8jOWPquac
ieS4gOeZvuS4h+S6jOWNgeS4h+e+juWFg++8iDEsMjAwLDAwMCwwMOe+juWFg++8ieOAgueOsOWc
qOW+iOaYjuaYvu+8jOaIkeato+WcqOaOpei/keeUn+WRveeahOacgOWQjuWHoOWkqe+8jOaIkeiu
pOS4uuaIkeS4jeWGjemcgOimgei/meeslOmSseS6huOAgg0K5oiR55qE5Yy755Sf6K6p5oiR5piO
55m977yM55Sx5LqO6IK655mM55qE6Zeu6aKY77yM5oiR5LiN5Lya5oyB57ut5LiA5bm044CCDQoN
Cui/meeslOmSsei/mOWcqOWbveWklumTtuihjO+8jOeuoeeQhuWxguS7peecn+ato+eahOS4u+S6
uueahOi6q+S7veWGmeS/oee7meaIke+8jOimgeaxguaIkeWHuumdouaUtumSse+8jOaIluiAheet
vuWPkeS4gOWwgeaOiOadg+S5pu+8jOiuqeWIq+S6uuS7o+aIkeaUtumSse+8jOWboOS4uuaIkeeU
n+eXheS4jeiDvei/h+adpeOAgg0K5aaC5p6c5LiN6YeH5Y+W6KGM5Yqo77yM6ZO26KGM5Y+v6IO9
5Lya5Zug5Li65L+d5oyB6L+Z5LmI6ZW/5pe26Ze06ICM6KKr5rKh5pS26LWE6YeR44CCDQoNCuaI
keWGs+WumuS4juaCqOiBlOezu++8jOWmguaenOaCqOaEv+aEj+W5tuacieWFtOi2o+W4ruWKqeaI
keS7juWkluWbvemTtuihjOaPkOWPlui/meeslOmSse+8jOeEtuWQjuWwhui/meeslOi1hOmHkeeU
qOS6juaFiOWWhOS6i+S4mu+8jOW4ruWKqeW8seWKv+e+pOS9k+OAgg0K5oiR6KaB5L2g5Zyo5oiR
5Ye65LqL5LmL5YmN55yf6K+a5Zyw5aSE55CG6L+Z5Lqb5L+h5omY5Z+66YeR44CCIOi/meS4jeaY
r+S4gOeslOiiq+ebl+eahOmSse+8jOS5n+ayoeaciea2ieWPiueahOWNsemZqeaYrzEwMCXnmoTp
o47pmanlhY3otLnkuI7lhYXliIbnmoTms5Xlvovor4HmmI7jgIINCg0K5oiR6KaB5L2g5ou/NDUl
55qE6ZKx57uZ5L2g5Liq5Lq65L2/55So77yM6ICMNTUl55qE6ZKx5bCG55So5LqO5oWI5ZaE5bel
5L2c44CCDQrmiJHlsIbmhJ/osKLkvaDlnKjov5nku7bkuovkuIrmnIDlpKfnmoTkv6Hku7vlkozk
v53lr4bvvIzku6Xlrp7njrDmiJHlhoXlv4PnmoTmhL/mnJvvvIzlm6DkuLrmiJHkuI3mg7PopoHk
u7vkvZXkvJrljbHlj4rmiJHmnIDlkI7nmoTmhL/mnJvnmoTkuJzopb/jgIINCuaIkeW+iOaKseat
ie+8jOWmguaenOaCqOaUtuWIsOi/meWwgeS/oeWcqOaCqOeahOWeg+WcvumCruS7tu+8jOaYr+eU
seS6juacgOi/keeahOi/nuaOpemUmeivr+WcqOi/memHjOeahOWbveWutuOAgg0KDQrkvaDkurLn
iLHnmoTlprnlprnjgIINCueJueiVvuiOjirmtbfokoLlpKvkuroNCg==

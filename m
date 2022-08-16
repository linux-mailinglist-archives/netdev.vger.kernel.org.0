Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40059599E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiHPLNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbiHPLNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:13:01 -0400
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF53D98CB6
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:30:37 -0700 (PDT)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-33387bf0c4aso27637287b3.11
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=vOyvKMGmiQKE01wX427fZCzLBK7SLIeb1lBJs6G1KxU=;
        b=eAMoSWCLP1r6r9jM9+CtaVpQ6Rqml3JnwDtzlOwHwWalkUwWuOUfJzc0nq7qHtLYD5
         wChhCyVuhVm+vHY2WJ7koR+jDXrU0aL0TgZ85igIaG95wZm5toBR50GJAiQ2FXuhp2En
         rhdBUqjP11KLk2xOG1CWLSHOZsAEUJOPk1r0OHH5Wwf5EGxSTjHRrfkl4JyXWNm8x2CK
         HQSDO5wTWVU0VBQtw2wGZHJN5K3czINBTs/N1RBnlmNCegz6bBvZRtvL20VS5NW76YqK
         5TNY9byZXAVy0Q+xfVc7ee6fFjo290b1oSGNhN28+NMbAhDZ+1M3SwmgWBtgvy1c1S7W
         PqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vOyvKMGmiQKE01wX427fZCzLBK7SLIeb1lBJs6G1KxU=;
        b=VvlX9g3d/Paf/TcRu8Vz0oMakaFBpwdVMdVHripmnade+EnwwnEaax5TsoSgAFg+Xd
         Yv0fvG3QdG+LntK0wETogUnY4BDv5T/YlatVQ88bS5JEfW5EZ9rWYVO2RSEds66bjl7d
         dzD/XTu9utsP23bcIUwfYwHsrMcjfVeaI+/cPo8of+FDvEvDYqrKTzB2zcmUF0h+NChF
         3SpTy4uhHMsHoPyYufAKCDMxNR6tvl+DlXj/dzjJ3Xq0o7Fv1wwxTnhvbQqlYXg8lW0y
         Z1ICfC77U6U60le6dmRhs1lH/VkAYMxVKw0d7rIUxukqMtN60wnjL2eaXNEPOdTYrfb6
         2D8Q==
X-Gm-Message-State: ACgBeo0RU/hsROIjGDxSod2NnOu+ccGQi8XCziPG67f9Tjj2vHzNVEJL
        xoTPbYax/PepgS/usmeHPyYiSTFJS/PR1u4L2ks=
X-Google-Smtp-Source: AA6agR41kjqlNA2KTiVgQhf19PSmEm/nhzAkl5fE/WTfWTv/mk0fyu2s7GFUNnfTU+zPc85A2AzmNT+wyf4LYSuNT+4=
X-Received: by 2002:a81:25cc:0:b0:329:da3c:23fe with SMTP id
 l195-20020a8125cc000000b00329da3c23femr15706437ywl.338.1660638636658; Tue, 16
 Aug 2022 01:30:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6900:1505:0:0:0:0 with HTTP; Tue, 16 Aug 2022 01:30:36
 -0700 (PDT)
Reply-To: stephenbord61@yahoo.com
From:   Stephen Bordeaux <baslealio.58@gmail.com>
Date:   Tue, 16 Aug 2022 10:30:36 +0200
Message-ID: <CADG+sOanTpGEpMFHr0fCZwkhn4jLJfpDfZK+iLZCMDToSgg_cg@mail.gmail.com>
Subject: =?UTF-8?B?2YXYsdit2KjZi9inINiMINij2YbYqti42LEg2KfZhNix2K8=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1143 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4924]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stephenbord61[at]yahoo.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [baslealio.58[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [baslealio.58[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2YrZiNmFINis2YrYrw0KDQrYo9mG2Kcg2LPYqtmK2YHZhiDYqNmI2LHYr9mIINiMINmF2K3Yp9mF
INmF2YYg2YXZg9iq2Kgg2YXYrdin2YXYp9ipINmB2Yog2KjZiNix2K/ZiC4g2YTZgtivINiq2YjY
p9i12YTYqiDZhdi52YPZhSDYqNiu2LXZiNi1DQrYtdmG2K/ZiNmCINin2YTYsdin2K3ZhCDYp9mE
2K/Zg9iq2YjYsSDYo9mK2YjYqCDYqNmC2YrZhdipIDguNSDZhdmE2YrZiNmGINiv2YjZhNin2LEg
2LPZitiq2YUg2KXYudin2K/YqtmH2Kcg2KXZhNmJDQrYrdiz2KfYqNmDLiDYudmE2KfZiNipINi5
2YTZiSDYsNmE2YMg2Iwg2KPYsdmK2K8g2YXZhtmDINmB2Yog2YfYsNmHINin2YTZhdi52KfZhdmE
2Kkg2KfZhNix2K8g2KjYtNmD2YQg2LPYsdmKLg0KDQrYs9iq2YrZgdmGINio2YjYsdiv2YgNCg==

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759BD4D399C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbiCITNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbiCITNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:13:31 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392E6BA5
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:12:32 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id u61so6375755ybi.11
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=n5JZG3l5wSabHxVEIH8twRo71vloJ96XZUgmhfr5JbA=;
        b=YPpwwCpIhoysNSskEjZoEwlL4G4NXKHZGQ25GZpfY0dcBUsy4HbemeirCRBNSJ04av
         PrlaGd9crBZhKZo/gKFZHDQKejsnx6IlgNba/wJ3lln44Yr4AZOakwXrcX4qORcZU252
         GD4rJiNoDUUII/2bjqq40X596ASrd3onpkZinRx+50MrZw8qUpTPtcZv3FzJIS7rVpJ6
         2Vv5D8N3BqTRB9vGug+TB4f1u8h/nSScgvIMZ31j4Y/OrZGgN6ABHnLsBpGxarSPZvwe
         T7OW1U8Kr1hN/VKQGlTatCS/SrMHXpVxIx5xORexQ4Ix04BU7pnX2AtGHC73KhLhlapy
         BCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=n5JZG3l5wSabHxVEIH8twRo71vloJ96XZUgmhfr5JbA=;
        b=1mzC7N4QmFckg3dWsjemTOwh7/CDi4QSUVErY1gvAl+rD6H1a61sZznq/WX8jMiiOr
         qCNeA4ReN+06Y6Uzbm9Tlt9kJZssA3qPjYgu1TXQ3RJmIvXQTtVff1i8cf44enViEb3y
         rl3G6kxcz/PainxOCYxe0JDkljO+J7XBzMEEBUGQOEFEcG4oIrIKu9AzOrkzLZDtYScA
         4llh+bOAIvlk+cWJeZjFiws17nPRLc8uSnRbh6rlyWusR8hQnq5flhw7MoJLao3gd9sm
         ImRd4bY2FrPW84gQ7tjRVWAaPukvSzqTCYJ0pn6Tv7Q7JRa9szCGQwdLSzkZ3G9+jTd3
         hsMA==
X-Gm-Message-State: AOAM53361bB4zCmVyx37ZflSHK7e18ILQN5m1I1PoxkP3tCTWDGFMJV7
        jqFY3q/yGRNsQUeVUo3zRTQUmcg2Gc4h9yqBnR8=
X-Google-Smtp-Source: ABdhPJwlZ2bY9M0fgjoLWKiPzHLkDbKM4VcC8uF4PQOPPt3kcXp7S6LjXSkG2sMERUsc0iS6d16OWqxIIpC5+sT/y9Y=
X-Received: by 2002:a25:1f04:0:b0:625:3660:a64a with SMTP id
 f4-20020a251f04000000b006253660a64amr1065099ybf.615.1646853151375; Wed, 09
 Mar 2022 11:12:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7108:2dc9:0:0:0:0 with HTTP; Wed, 9 Mar 2022 11:12:30
 -0800 (PST)
From:   Jack Fred <jackfred0000@gmail.com>
Date:   Wed, 9 Mar 2022 19:12:30 +0000
Message-ID: <CAG3RAgjbSi79Y-qzaoz2FJYqH3dRRyeE6y_vxdkfcifDwtV63Q@mail.gmail.com>
Subject: Dearest
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dearest,
I sent this message to you before without responding.
please,confirm this and reply for more
instruction.(jerryesq22@gmail.com or wilfredesq23@gmail.com)

WILFRED Esq.
Telephone +228 96277913

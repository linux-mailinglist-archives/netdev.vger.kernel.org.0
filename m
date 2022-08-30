Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC775A5D42
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiH3Hqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiH3Hqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:46:34 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8ACA00C7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:46:32 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id m1so13065090edb.7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=S2u9Q+tjkz31iCRfklDeKGl5LtO3Yk8kTNoA3qpbsNs=;
        b=F2uR18KBhlmVT5IFcauwDK+EENS42wMke2ZVWrmaLcnLXPkFLwqrj3qXXohe338LIk
         APZtkzxFXU5OEXMShVbil1Ljc7CAgY0n0R05wU/5YDssR/H//NRwVnA63YpXZb9gPViu
         vCv4e/rpkO9jizfOrVoyc/IFf02R4JnE+sBppT8GeV/+EBVilj7xeMCQqmo5W/rxEDGz
         uJPYNwu/iC03yu08ZyD0KR67TBSeLTIKwgm/NAxI9pvTmEBsMvBcXDExw23EALwwacFd
         nxVBkxgA9TNjBRD14JJri0s4iXb0WS5ypOuiDSYlNylV7Xzq7diiTrBytioTtjE2lelo
         t6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=S2u9Q+tjkz31iCRfklDeKGl5LtO3Yk8kTNoA3qpbsNs=;
        b=6WWRqeeNLSeqlPZk76gVcFZkmpcBLlB4EndoeFLK2V13o39d31x91AVxVFpcr/Xldc
         TZx/zyxMIdzhrgnOnH9z1v61Rtr2wozlshPhuCCw1Lp3x99E+SFBdSylsyM7uc8vq+qa
         xaEPB6jhGt804DGAL2CGz+w28EehDsG2FY/96fRiUFhP6/NXSLsyaAuEVtudfNRS/dzD
         vBokPmXkw4HntO2WCAnCl9RQzum03XNCd141cPk8f8lRF0GZcNcE5E/lNWLybvgwmoUY
         K/FvdDIugYrIkjMK71mthSm8xq61TvYWlnHx/BkDNZDyIGB766xecTJ2Px/AtNPQBHd4
         BHKA==
X-Gm-Message-State: ACgBeo2fZo6+KPvm2M+OVJlMdGCtX0hvfN0qmJaQCeaPpWtvt5C0zHQ1
        vhcD9rdKJsrOf1iG3J2o6UzGdgIAgS+GE1Yr+Qg=
X-Google-Smtp-Source: AA6agR4C5NHX5IlcPpFYEvmjzrgk57+ucC4rBEF+vHCEkb524fPS2Mu8Nc8bRjamE7foT41Fmr6KcJhoGzLXeH9f0kE=
X-Received: by 2002:a05:6402:2b8d:b0:43a:5410:a9fc with SMTP id
 fj13-20020a0564022b8d00b0043a5410a9fcmr19329107edb.99.1661845591304; Tue, 30
 Aug 2022 00:46:31 -0700 (PDT)
MIME-Version: 1.0
Sender: goodw771@gmail.com
Received: by 2002:a98:b482:0:b0:17f:79f3:35a9 with HTTP; Tue, 30 Aug 2022
 00:46:30 -0700 (PDT)
From:   Ariel Nah <pb589847@gmail.com>
Date:   Tue, 30 Aug 2022 08:46:30 +0100
X-Google-Sender-Auth: RzLKTGZW8GJwm_jN_VzUmpq2ans
Message-ID: <CAM0SVCY0S=p6sEHFuDb9CxvLg92wUgL1a_=pF_dLDkEYajGoWQ@mail.gmail.com>
Subject: GOOD DAY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i am Mrs  Benaiah and i was diagnosed with cancer about 2 years
ago,before i go for a surgery  i  have to do this by helping the
Less-privileged,so If you are interested to use the sum of
US17.3Million)to help them kindly get back to me for more information.
Warm Regards,
Mrs. Peninnah Ariel Benaiah

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B76CC338
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjC1OwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbjC1Ov5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:51:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852B4D50C;
        Tue, 28 Mar 2023 07:51:47 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d22so7367922pgw.2;
        Tue, 28 Mar 2023 07:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015107;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bsKwpvtiQoDLspEBMkXsCnDvjo923fDOoGDyxh50cps=;
        b=OE90hZF1ZKPClTWnLJlSIsn1hAXNShsM6tyPv3xKvJeP3Z8MCoRqstY4lDZ/eoHnEA
         nDxsnnZlRGnhMT8luEDBpLOA3iNuaKYRofit3Fne4lo6JH7MVataoYvRTqyNUtMyxf0j
         dmhwIV6Q9UmltPsgsv1pjyJMp7IFZPNRzOgS2Xdv+s8hkvEvjUafS8Yf7nde8mVDnda7
         4PlheTdKAIp4w+X/D5klNkchhdqEq5ZFNRTvV2Pbmx9oTOSPOtKeRQO85tODK8kQpHuJ
         ARUf0imEWU9YG9hbrCKIv3Nnh099I5jHSe5so3aQJWjoqx1joZ2rjHPFDJkL1naVXyTr
         98jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015107;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bsKwpvtiQoDLspEBMkXsCnDvjo923fDOoGDyxh50cps=;
        b=EY4GZdQ9Mm7XG4k5JfkjEiXDrAcsMtTm2vvOWMz1iiIhsdFqp1tdZdm+nTlpSuV+vy
         uz8KuvUFPuqpoiH5VfMQXlIyPDZuOPDlAlP8Nz94yG/2XF8VqYKvIYDCJcaiiPJW6ynV
         WQByPlsH+zUmf04kkqC+RW0Xnr9vl3X1dOHB5QKQt4pOg/bKJEkXNkcijvgIn5EN3QV5
         a13CAJ9gdpNxst0rXeC6wpyKFAjSHJUynaeiRa4gSgebSi1ZtDj4ZG3syeXHCmFG1bzm
         H77yUuQ+itihItpNqDkw8ccmoWu3MPlAtlZU/zRJ1jhdlRgq2RQ8y/XWbZzimRxF2CIr
         3kDA==
X-Gm-Message-State: AAQBX9c3YwkSRSoLitXH9X0iADwMui7p5/369V0vTipPRmd0gyYIAYVi
        TDvYVH1/6lgcSPSEiqGWN1P/tZH84EmB6NzinKU=
X-Google-Smtp-Source: AKy350ZQuMilvavN0CtY2koePQa9CNJBjbeIEICDpza43Kabg2jPtTxomDNHMot7/NDs15IgGbqfn9Szd4FmTMNTYOE=
X-Received: by 2002:a05:6a00:1a03:b0:623:8990:4712 with SMTP id
 g3-20020a056a001a0300b0062389904712mr8411018pfv.1.1680015106776; Tue, 28 Mar
 2023 07:51:46 -0700 (PDT)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 28 Mar 2023 11:51:35 -0300
Message-ID: <CAOMZO5BTAaEV+vzq8v_gtyBSC24BY7hWVBehKa_X9BFZY4aYaA@mail.gmail.com>
Subject: net: dsa: mv88e6xxx: Request for stable inclusion
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am running kernel 6.1 on a system with a mv88e6320 and can easily
trigger a flood of "mv88e6085 30be0000.ethernet-1:00: VTU member
violation for vid 10, source port 5" messages.

When this happens, the Ethernet audio that passes through the switch
causes a loud noise in the speaker.

Backporting the following commits to 6.1 solves the problem:

4bf24ad09bc0 ("net: dsa: mv88e6xxx: read FID when handling ATU violations")
8646384d80f3 ("net: dsa: mv88e6xxx: replace ATU violation prints with
trace points")
9e3d9ae52b56 ("net: dsa: mv88e6xxx: replace VTU violation prints with
trace points")

Please apply them to 6.1-stable tree.

Thanks,

Fabio Estevam

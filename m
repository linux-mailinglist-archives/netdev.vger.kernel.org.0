Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F67A503654
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiDPL25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiDPL2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:28:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D163E5D2
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:26:22 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y6so8953124plg.2
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6vYx3JbvVsiL3zhGAbJQC+kPjCGgnDC5DdXmocu9kt0=;
        b=dH4aJFzB9ro6Cl+9XwLsCtQxoV3IQGnT0s82AN75oFdl9SN5zOB69/ZIheBuZHMEv5
         oihfoeNKTmB2QwEJZ/Q2Kos+4cLgsq6WMAA4uS/F4SKazM9iAnVYqOSnxEiI9NgdMLfN
         3yjdYDBxDUsAwhWrOa4qRsAuV/X8gLH7wcazohZgvhy7hjzcdSoxPLvaZmuUmjJqAxH3
         YmZmt1hiNULim1yBjRmaK7m7EOnxvTlnl6rVog5FJ0G3Lup4LeT+nDC+OhOZ3EwRMHs1
         dp+lUxY01BsOwj+/8x7TNYcTMTNuW9PUdX+y/2mi92acDyuqAr83XtZnaazUmEDYv227
         eBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=6vYx3JbvVsiL3zhGAbJQC+kPjCGgnDC5DdXmocu9kt0=;
        b=6uQ7iAgB66ysgQyPfjOdKCws74KF7pzi3MAIka6LNbskbGQsGiOHuiCylNYbUGWSpo
         biXptVHcqKM1if1SkdxQuO4hprFdcRfkg1A0svsVFhqclc+QpCHj75ErufLbOg7eetON
         4PO4Sg1mvCHKsTZNQwpq1FHzgzt/YKCxhuxT+gV5cmZO+rDribY/8GVanmFYzGjhXAbd
         VISJ+e4twSYeGUsJl9o4dcTLaYAmO5GxeqSdnWYXHtwDR9II/0HLuhn1+sBxoQTb9FMD
         LiX6EPpc2nfnZj3xpM+oC6/wMyCLySuku8tTxG45BVF291cElIBtYCpKQfnSMNoJ82+f
         p+4A==
X-Gm-Message-State: AOAM533m4mYIg36vaJoug3LIN+UEX3yV9KN9eIm/NNmVVqKnEyZ/Jp92
        OsQ622RwDKiVN1zCBSYqaROaZT07gIOx/2KdvVc=
X-Google-Smtp-Source: ABdhPJwYG9iEgrQ+chAVcPtD6ht7kr0qDjIBHCIa/Bq8gZXZbKTieiJnfB3Wp/yu61FpXLUxQyPtjJHgs+V2qliXzT4=
X-Received: by 2002:a17:902:f64c:b0:156:4349:7e9b with SMTP id
 m12-20020a170902f64c00b0015643497e9bmr3062845plg.139.1650108382228; Sat, 16
 Apr 2022 04:26:22 -0700 (PDT)
MIME-Version: 1.0
Sender: barrlucasnubueke2@gmail.com
Received: by 2002:a05:6a10:43d5:0:0:0:0 with HTTP; Sat, 16 Apr 2022 04:26:21
 -0700 (PDT)
From:   "MR. EDWARD" <edward.esqchambers@gmail.com>
Date:   Sat, 16 Apr 2022 12:26:21 +0100
X-Google-Sender-Auth: ZksK-Fp7LqK_0dWs1Xz5mlo2yN0
Message-ID: <CAHcyid_2Jm6-tzUFMcqhtRzEB=bD3xN701Lh3Jasy8nEicNx6g@mail.gmail.com>
Subject: =?UTF-8?B?VsOhxb5lbsO9IHDFmcOtamVtY2kh?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zdrav=C3=ADm V=C3=A1s, kone=C4=8Dn=C4=9B z=C3=ADsk=C3=A1m d=C4=9Bdick=C3=BD=
 fond s pomoc=C3=AD nov=C3=A9ho partnera.
Mezit=C3=ADm nemohu zapomenout na va=C5=A1e minul=C3=A9 =C3=BAsil=C3=AD, ab=
yste mi pomohli
z=C3=ADskat fond, a=C4=8Dkoli jsme v minulosti neusp=C4=9Bli kv=C5=AFli ned=
ostatku d=C5=AFv=C4=9Bry
mezi n=C3=A1mi. Nyn=C3=AD chci, abyste nal=C3=A9hav=C4=9B kontaktoval m=C3=
=A9ho ctihodn=C3=A9ho otce
Solomona na jeho e-mailov=C3=A9 adrese ( rev.christlovesolomon@gmail.com )
Nechal jsem mu v p=C3=A9=C4=8Di o v=C3=A1s =C4=8D=C3=A1stku 800 000 $, tak=
=C5=BEe ho kontaktujte a
dejte mu pokyn, aby v=C3=A1m p=C5=99evedl celou =C4=8D=C3=A1stku.

Pane Edwarde

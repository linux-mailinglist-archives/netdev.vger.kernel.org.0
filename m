Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15958D37B
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 08:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiHIGAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 02:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbiHIGA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 02:00:28 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B597103E
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 23:00:27 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id d4so6014299ilc.8
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 23:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=/mIApTZ5ORl/xrCdkKtKMRgzC3PHdDTAoEMupXtPSiE=;
        b=eSGMTknoXDuJqOzbPWaKyF2MMhkZwC82tMlZ6+XB6XBSGHPogM5dOHSAUX8qUZvW02
         uRbKKpkaqc674dX9EsXoi4Ywj1c0WzsPVFcm4AarsfKmG2meJqmxPJktrkAd9izGlJ0I
         0QLeE96kRFaakIahxyDs8CqbCPl0TpGBvQdbOgmKFg9uslmrZC7FZ36bQN8zqIHdLjoX
         vmezvI6AUkgXWzBnlw9CvJQryj/imjlLAVp+PVLlX4dCqzeKwhiAKajCRipxHj24mxx0
         ESbXaL+uMz5IwvK8ZjTVe82HWZc057foaveVVD4//wtFIdrZrQnsLxnWTK7ohmXe9io2
         lcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=/mIApTZ5ORl/xrCdkKtKMRgzC3PHdDTAoEMupXtPSiE=;
        b=RFO40KmzXl2Uty1mW0zPkFrIW5ZKo6YK+cJXWjdksHax/c9X1DOdHV8WtyZzTLG5y4
         7SJejQn0yUDWc3hOuf2gmctSfHpndswJ4/iC/Sjw1cWW4/FjP/8Fgne9vsi/E+eTEEI5
         +s3N+EWL26HESzNMfGEa2H7etvYiMBPY18ei31vGNSiJL56QJO8PEyooWmCMRbq4AFE7
         QNbgo1NXZsJmRDjwwIfrqt574SoEP1jS91GvMgMtNsSMAXfMPdIayTqTh3/iN/IXpxPu
         Fw1uSWYT4H8moFdT3GBZzmU3CZpKJxwZ03GezBjGkWDtJSMLG+ryMJFgLwbsI+dXpR2z
         q5tA==
X-Gm-Message-State: ACgBeo3FfXak25qXesFEanJF6V38B18WZ0Xek5vj4Qs12EfAxvlMYsnI
        6qtz/mcTJo5QiEWnw7Kf6qLP+cZxTqkKClyDCns=
X-Google-Smtp-Source: AA6agR7qtoN8vkSanLc39n5eOUutvIU2p90vHvltpxfsQAbyVnveHbAFhZkQz538v/V0RyWLfTfnt9U99qH0hhV3RmA=
X-Received: by 2002:a05:6e02:1bed:b0:2df:6a1f:4f8a with SMTP id
 y13-20020a056e021bed00b002df6a1f4f8amr10502394ilv.117.1660024826608; Mon, 08
 Aug 2022 23:00:26 -0700 (PDT)
MIME-Version: 1.0
Sender: luckyokiridu@gmail.com
Received: by 2002:a05:6e04:1408:0:0:0:0 with HTTP; Mon, 8 Aug 2022 23:00:26
 -0700 (PDT)
From:   "mydesk.ceoinfo@barclaysbank.co.uk" <nigelhiggins.md5@gmail.com>
Date:   Tue, 9 Aug 2022 07:00:26 +0100
X-Google-Sender-Auth: kT9m6qQx77O1ztJp5BYdSPIgmtM
Message-ID: <CAPy23v7TYrvZ_U74ppq+uqM4=dSe=F6JLi-vbQYUJ5ZqP2_8=A@mail.gmail.com>
Subject: RE PAYMENT NOTIFICATION UPDATE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_2_EMAILS_SHORT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Congratulation! Your delayed payment has been released this morning.
Kindly reconfirm your details for payment to you.

Nigel Higgins, (Group Chairman),
Barclays Bank Plc,
Registered number: 1026167,
1 Churchill Place, London, ENG E14 5HP,
SWIFT Code: BARCGB21,
Direct Telephone: +44 770 000 8965,
WhatsApp, SMS Number: + 44 787 229 9022
www.barclays.co.uk

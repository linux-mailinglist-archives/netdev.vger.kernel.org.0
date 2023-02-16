Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A03698997
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBPBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBPBBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:01:52 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C70457C1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:01:46 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b1so464692pft.1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mkqwuerB9bLLBh5xDWizden+lsAl749z2Y+hf0vHNao=;
        b=CTFzk5I7LXsn6i92eL/VVXNk3ohM9KUXP7w+fD+ROVCHHdvFvaFtN0/SB/APlPcgLX
         AETQFlEidjZfqfpkOFcvJWNw1YeTSucfME0m2vlFxixRWd2I3fmVwXMEWu68KARB4seK
         uLyjscl3tA30H3KHTC+H+3+FGyr2m14cIisjs77omnt5OBJvn911QMnyrd3Jk/xCiMGr
         znBbMbI6q7FMFzTXOI76fdLzOMdR1d0pY0hmu/vyRC5Brqt3rPLSJJpmdOZp77yZP01g
         Ei0o2pPEe51YpPAGuLalonKKkD1V0XTMQWxeHi7V3hZQqeVd8lvUl0/yhkC5aSL/mi4B
         rhHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mkqwuerB9bLLBh5xDWizden+lsAl749z2Y+hf0vHNao=;
        b=qcfs5KTcscPAmGLF1hYOdbe6BevWx2btLOVaBiAgGiysGws7jBrOtGrVQJdgJ0JhVv
         DrgFOTMzFB/uKx0TBHvkyG7pjkxE0qC+O/yTcduDXySFQjF/b/1pWVWGfW6xiFn4awEg
         kMR3x6UDbb5yYSQ/5d3VfPWSVGcfJ+Alj1XvvA4NBIVIqVEQ6wVLTVa3yIfZ5kSzPvV3
         CQC2Q+EimmnD9KHmyB9F4xNV9byi7rxyXw4wvueMii1kR8TMiSRs1Oi9kF9AkUDZcMvD
         tz08Rs+y/k8X3agSiV2M2e6uyR5Vh+cyx2PK0KVb/gHbKH1gPOh3SMdtGZFxi74SEvyL
         HDJw==
X-Gm-Message-State: AO0yUKXU3t1U+my+9xRVW0z4jvd8ay+0o/Oma/DIEPEBMdlzb1b5lBGg
        PGy+q1qu8kUxKw1kQe1B2H7pWa3Qh7MoyPpOq7A=
X-Google-Smtp-Source: AK7set80kan9a+z2sRBWSlfJQ9CJLwTR0/NCVsZK4q84m06gWpLJZ23wK4T/8Ikw+dcKYncVGF2hfjkXbuvqamnr8EI=
X-Received: by 2002:a63:3508:0:b0:4fb:9b70:2c03 with SMTP id
 c8-20020a633508000000b004fb9b702c03mr477383pga.29.1676509306305; Wed, 15 Feb
 2023 17:01:46 -0800 (PST)
MIME-Version: 1.0
Sender: azeyidouaboubakar@gmail.com
Received: by 2002:a05:6a10:4b23:b0:415:d906:7525 with HTTP; Wed, 15 Feb 2023
 17:01:45 -0800 (PST)
From:   Miss Katie <katiehiggins302@gmail.com>
Date:   Thu, 16 Feb 2023 01:01:45 +0000
X-Google-Sender-Auth: sBLMAbkC0b5Y9fJ9_Nxu6WOZXo8
Message-ID: <CAC=5C6A7Be4fDmu-vJWZ-PkHoZw4CvZvvhbV=LjaARkLxndR=g@mail.gmail.com>
Subject: RE: Hi Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cze=C5=9B=C4=87,

Otrzyma=C5=82e=C5=9B moj=C4=85 poprzedni=C4=85 wiadomo=C5=9B=C4=87? Skontak=
towa=C5=82em si=C4=99 z tob=C4=85
wcze=C5=9Bniej, ale wiadomo=C5=9B=C4=87 nie wr=C3=B3ci=C5=82a, wi=C4=99c po=
stanowi=C5=82em napisa=C4=87
ponownie. Potwierd=C5=BA, czy to otrzymasz, abym m=C3=B3g=C5=82 kontynuowa=
=C4=87,

czekam na Twoj=C4=85 odpowied=C5=BA.

Pozdrowienia,
Pani Katie

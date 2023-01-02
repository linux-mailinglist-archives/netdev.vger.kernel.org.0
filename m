Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1024B65AE8A
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 10:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjABJFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 04:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjABJFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 04:05:52 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA247132
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 01:05:47 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id cb7so432227uab.13
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 01:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l+6hJaFXZ+fnsaoq7UdvptfxPR1jMpOXwooJaOdu/P8=;
        b=OR/KffhaPsNVPFxY2sAu67g8HDyEeiG7C7QpbABc/0yMUqdc8rkfO8McSaDnj+u6rU
         hC1HopebNe4PX+1iV3NbHZWiZTPVSjD1M8gkp87RTEKwT5P19gU+PNCf/WNjZ7BWv2sS
         2XIFsgD+7pvThbjyu1Z25B5QX2qiEWQjNKg6mD1ttgXyuyHg03Zpbp3li1VUo24YZd4x
         Xd70eyYSoFb/6BRpj4tRTn0icHi72FcC7ypJXxPn4Q1gsYJ6z9XLM40qWZ723zO/Yfyg
         YTypEwsLK3jxKIOQg6GwH6WjIMWAo10j35oTT0ZbyJuXHyekmpLOtCTqJ8QMOexLUa1b
         0d6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+6hJaFXZ+fnsaoq7UdvptfxPR1jMpOXwooJaOdu/P8=;
        b=EXHl1+htDR66xWZT9RZmC5kKWoKW3hhZJ+hwnLliqucMAbHdlLH722eprmfX3cFGP4
         T9H6WN9tuBl/01/oRgkneixOPtQ/JrVvyz3b4VNV3ucKv9DX3IVP76RSVjwN+7GU56bJ
         c8NYfCB1QF2S8vYMlvE7Be19AK5fSiMb2Oua4h215PF/E1mxfZLwNInBPXXwVpc7Z2VE
         0lIRHtwVtgZOxgt5E+E3qv3XiWjrR2vZoF5y1RYUST2Kr+sUA29ykxG7ercpDFncoAma
         6sgVcEKUaFxsdmvnn7lBmViqTbfhGJQRbleRvZmjMDCxg2UxAjQJttACEUPuYTBWWYDX
         hVfg==
X-Gm-Message-State: AFqh2kqy9AEA/e4dcqKhLMZFEDYSxHjnhKpKiHZt/Qii9XQK/NhT5wdF
        1UJhKmD9RgSImUXiwKhyutwE98KEFUvQk9gyl5c=
X-Google-Smtp-Source: AMrXdXvWGhShAiyZ6E21pcg2TptI2YtU2Mu1hfDz15vxmvw2QUptFydrt2vVYrLdCZAks1zcjBViu3V12HI+trnP6R4=
X-Received: by 2002:ab0:4566:0:b0:419:2452:150b with SMTP id
 r93-20020ab04566000000b004192452150bmr3915183uar.20.1672650345860; Mon, 02
 Jan 2023 01:05:45 -0800 (PST)
MIME-Version: 1.0
Sender: wangasalam@gmail.com
Received: by 2002:a05:612c:281f:b0:32e:20f:93fb with HTTP; Mon, 2 Jan 2023
 01:05:45 -0800 (PST)
From:   "Ms. Beatrix Bahraini." <msblakebianca08@gmail.com>
Date:   Mon, 2 Jan 2023 01:05:45 -0800
X-Google-Sender-Auth: cxE6OHW4Uq-Ab9v9p8xbaGCS2vM
Message-ID: <CABJKMkrUN0Z9fAH9=YkC6vvioNzw_gzintW6LTyymTvpWYKH8w@mail.gmail.com>
Subject: My Dearest in the Lord:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_99,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
My Dearest in the Lord:
Greetings to you in the name of our Lord Jesus Christ. I=E2=80=99m Ms. Beat=
rix
Bahraini. the widow of late Dr. George Solomon, I=E2=80=99m 56 years old. I=
 am
a Christian convert, suffering from prolonged cancer of the breast,
from all medical indications my condition has really deteriorated and
it=E2=80=99s pretty obvious that I may not live for up to six months owning=
 to
the rapid growth by stage and the excruciating pain that accrues to
it. I have an amount of $ 6,300,000.00 (Six Million, Three Hundred
Thousand) only lying fallow with the Royal Bank of Scotland (The Nat
West Bank) which I inherited from my late husband that I will like to
will to you for Humanitarian service, for the church of God, the poor
and the victim of cancers and other vulnerable diseases. Kindly get
back to me for more details on how the fund could be claimed and
transferred to your desired bank account. May the grace and blessings
of God be and remain with you.I shall be awaiting your response.
Regards,
Ms. Beatrix Bahraini.

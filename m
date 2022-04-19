Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6174C507AE9
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352971AbiDSU3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 16:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbiDSU3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 16:29:00 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA88344FE
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 13:26:16 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id d6so13734876lfv.9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 13:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=UEC93eKtP8fTeJfr8YXcBU7wcI+mEnSQYUYDqlTK8JbVXxT6n+gF4OqAry72CArqdN
         vGq+2pIDF4lxag4QbUjFNWk7KnWBk1hgw5P7+4+wnhJgPS5DEIcB7hCUTQGO34ZrWzU/
         BHY04WP2iNzx1Cb2NvojBj+zGuEIYmrDB0tJDPfP6/5GOPkONv5j59/103E3/l3sbl/r
         37qK6effKbqkPE+eFKlblTLNSzV/jdhKinRd2V0w4YfYQHM2O2alyg5DqlCLBGysLjKT
         eIsfjXvNLYwLdmpV/eOrprjmCPZiEXgM63KZFyfrNqIC0j1NHE1kpt3UxsVNmulbLiFu
         CAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=O8kEEn0QQGMun4blpkcrpqk886LjLmavj8MremR8LjVTgWh1vCVaXYowJJLatsTBZS
         LFlzfHxLWfWJYaviKGvKkB8K7Mxv/xDwTNM31BINbbSn+MXdwDtepO/EvaXceYQyPXb6
         dLkyTNoysFXBkSz8qcxJsB7Izeh1IIprEMyWvcZFjbtbHIlieo++oe92ckdFvBhlqHuj
         eFRr3GptjIuFP6riW5WPWUwNX7hpDooLH9ZgbH7tD5sMM+ac5UgKzJPDMlucHnLcH0LF
         YPuQWs5hmszblKp2Q45cqW5ELmKyjBAT4shv5A6cPCDt3vSCzGyoje1tVOUiAfkVbgHg
         +Cnw==
X-Gm-Message-State: AOAM531eHbIt//Ok42A725ETnNqi2XHFagbEvcanQjAZlzc+mPXAkWOR
        DuQUszJLkjCVBz+w4K/izHhcU0Q+qaOUhWmviik=
X-Google-Smtp-Source: ABdhPJx9VqHsDOYn09HHHVsFlMFD1ZNDX3K8js47g9AcqmuROSxJnH7GDo6qV7nQh9O5U1nZKeFnzvYQGDO1EpZa4+g=
X-Received: by 2002:ac2:4431:0:b0:471:5259:298 with SMTP id
 w17-20020ac24431000000b0047152590298mr9635597lfl.284.1650399974997; Tue, 19
 Apr 2022 13:26:14 -0700 (PDT)
MIME-Version: 1.0
Sender: sandarmohamed@gmail.com
Received: by 2002:ab3:5486:0:0:0:0:0 with HTTP; Tue, 19 Apr 2022 13:26:14
 -0700 (PDT)
From:   Miss Qing Yu <qing9560yu@gmail.com>
Date:   Tue, 19 Apr 2022 20:26:14 +0000
X-Google-Sender-Auth: gbNI7REZsDLXOGAjX2SSmQfmpac
Message-ID: <CAAzhOZTRk6Np-BWY=qAjawzYKj9k4EDKdcWpZ876jd-WpF6nVg@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_NAME_FM_MR_MRS,
        HK_SCAM,LOTS_OF_MONEY,MILLION_USD,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:143 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sandarmohamed[at]gmail.com]
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.6 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it with the critical condition am in because all
vaccines has been given to me but to no avian, am a China woman but I
base here in France because am married here and I have no child for my
late husband and now am a widow. My reason of communicating you is
that i have $9.2million USD which was deposited in BNP Paribas Bank
here in France by my late husband which am the next of kin to and I
want you to stand as the replacement beneficiary beneficiary.

Can you handle the process?

Mrs Yu. Ging Yunnan.

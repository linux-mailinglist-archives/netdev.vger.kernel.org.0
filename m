Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B8C5A34F7
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 08:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiH0GIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 02:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiH0GIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 02:08:23 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5515D0D2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 23:08:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gb36so6589054ejc.10
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 23:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=HD0C+vijYy0hCXPKpjsTOCXB37VEeR3fSALh7dwqTLc=;
        b=lCcMMFSY0yva0cQMDn9rqafdgvmxdUUHvOe5AyFG4VteGyzmFudaEzpShUy5WOwbKf
         T4OZgBfRSPhEHqwr4jYH31rHhzN4dhRj9l4KI+tEv+NXgvfXIAs9KVt8/QmZrVFoDnrZ
         QbwqA6ucA5J+oe0f1dx+1Hm/mKbPs1vP2PsaBQSmKbSpZDYMh6+An6R13cbVOMcKG284
         GNDLzVddcDJmIEFhvxU5JPqxx5m6UoEjCbXc6UVQ3T4WvOMQnyV0VpAXKxvZn0GQ82Fi
         L2eQetLcW8L+65nG/4z/bN8M/HU5Dudv33I6RtMcyOggZjRCpcCq2MsGUmN3RpIXp4FX
         SKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=HD0C+vijYy0hCXPKpjsTOCXB37VEeR3fSALh7dwqTLc=;
        b=JN+1bpRmRAV8TzLE7XdZH38YlJrMtEIZ3jXkC/nwxxUbDRT991lXfZGzfJHpss3roq
         zoM3nwGkyO3rA2g70fLFMqocnl4FVSB4Hc/H2ej8X1TRgeurMGhAe516gxtDPo+urkZK
         LI4OD91gd1qt0hcxoRsauOSSWBnT7XiU9dZPGH2ctY8Kc4odux2pRCujZEt+Y/Dd/ahK
         lnWj8ChD09YcqHD9BiUh7peHaliLb2MiVEERtClWOh6R3M/egfAu3ngXJ9S9otGigVmf
         VE8/kCSimH/olanet9U5e94/OZmGKqdMZMyb4WStXIicAT0s4pPMMeHi8cHwPQ/mPU42
         ymYQ==
X-Gm-Message-State: ACgBeo1dFI/NuSmw+EKSdw4+Y8s5JdA1ubxMF5pIHapK5JBLj4aG5jy5
        OoNEw8YvkyGbHcGOSrEXMpFyRIIBfz4ZdqnMTfw=
X-Google-Smtp-Source: AA6agR4uRr9XcZLTYiNFDB4X9wTF0nqmsbbXu7ukovfwj0FCXEcaLO2O2KdOglBV+A+mf7CJ7FBCgY0RNrQqv1Tkqps=
X-Received: by 2002:a17:906:730c:b0:73d:6756:d082 with SMTP id
 di12-20020a170906730c00b0073d6756d082mr7317133ejc.47.1661580501143; Fri, 26
 Aug 2022 23:08:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:a398:b0:22:8659:3b50 with HTTP; Fri, 26 Aug 2022
 23:08:20 -0700 (PDT)
Reply-To: jennifermbaya036@gmail.com
From:   "Mrs.Jennifer Mbaya" <taibaondikwa445@gmail.com>
Date:   Sat, 27 Aug 2022 07:08:20 +0100
Message-ID: <CAJvZ1T7JzTnfrZwkcqQh_ywph40mw9ZEMoA+bekbz-PLamKmuQ@mail.gmail.com>
Subject: Mottaker
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jennifermbaya036[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [taibaondikwa445[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [taibaondikwa445[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
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

Mottaker
Det er en pris i ditt navn fra FN og Verdens helseorganisasjon
tilknyttet det internasjonale pengefondet der e-postadressen og fondet
ble frigitt til oss for overf=C3=B8ring, vennligst bekreft dataene for
overf=C3=B8ringen.
Vi ble bedt om =C3=A5 overf=C3=B8re alle ventende transaksjoner innen de ne=
ste
to, men hvis du har mottatt din fond vennlig ignorere denne meldingen,
hvis ikke overholde umiddelbart.
Vi trenger din presserende svar p=C3=A5 denne meldingen, dette er ikke en
av de internett svindlere der ute, det er pandemisk lettelse.
Jennifer

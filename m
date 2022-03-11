Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB074D57E6
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 03:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiCKCGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 21:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345161AbiCKCGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 21:06:43 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7007B1A6149
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 18:05:41 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id b16so8691468ioz.3
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 18:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1WmTiruYcLYjgfCVpwaSh4JcERuBX8rKufTgiQZnbQI=;
        b=UoLJwNFCONozXrSjxTaJ6CQMua4tKdfIBGwWrcuH+qg7qV4qvIQvKd6ZDBpfNl02B5
         7/f3NDnXewP4MWvXArhhRIRgFfG5UHtOC8GFRmWoc9PoyDIH2OX7pe5JW5uJcZ3wDP1S
         Yn21PV0Lv/2OgyaKFXFlcqz1E6zMkmznF70Xusq/1kkD8r2ZFWVVBH8EmOD3Wb8YItQG
         J/2LjYjdLPknMZc7RLd2joKTTigo11SHOv7rIySkRSAj3EH8x3p4s3Cul6kdkGI86z9P
         rkTtCf8I4vUc8NCgtF2G8j2Q79qe1CyULZ+SvV22FYAYLG43TpvlFIzdybDtrm705aHX
         A0dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=1WmTiruYcLYjgfCVpwaSh4JcERuBX8rKufTgiQZnbQI=;
        b=SbR6ffvoRC0vRqHr2y7MuuNy+3HV+LBOqGli/iXA7nRHWLxSc4QasKZO8EtJAz3wZc
         m74E+N4eyqRUdCY6kh4plMrZoYrRxxKQJmG06a03VzKcvIrH90AIVTTJaR0QQsQ0Z+A5
         jbErIUNgJxW/GkeexIzyAiD/Qi2mBljXeUEknolWulTa8p2tN8gCPpUklhHw9+Wy7CjK
         VyMFbDi90WReU+5w7g1aydA5b/Epovi1qSM33sxJIRpFH23ISeItPWEPCfzXpAREkEuo
         bT4aofwK44wiBC/2RDD9JJCSyliz7RR4NUd0udKXz580KgPfQXBkVAh4Wj0/V/jYrxO2
         xuxg==
X-Gm-Message-State: AOAM531jMZbuZbmKJrLcT2hpdNmzcTBKvllAG7UD4FrQRv4Tm8pRjO4C
        xb68+jh5Xmt/6smaE/zNV2nYmMZoq72oazgJVSE=
X-Google-Smtp-Source: ABdhPJwzGv/EUFPjRAcnxAhD9CuVUfBUgzFPenxOjwyDW485lIubfpRBOLJ90AB7TTN85L7sK3xWajnPEHl2vMYBat8=
X-Received: by 2002:a02:6383:0:b0:314:d9da:13b2 with SMTP id
 j125-20020a026383000000b00314d9da13b2mr6425055jac.99.1646964340692; Thu, 10
 Mar 2022 18:05:40 -0800 (PST)
MIME-Version: 1.0
Sender: aishagaddafii331@gmail.com
Received: by 2002:a05:6e02:154a:0:0:0:0 with HTTP; Thu, 10 Mar 2022 18:05:40
 -0800 (PST)
From:   Aisha Gaddafi <aishagaddagfi@gmail.com>
Date:   Fri, 11 Mar 2022 03:05:40 +0100
X-Google-Sender-Auth: CITmde-pPdp_g8mnybwmsbu1uXo
Message-ID: <CAMrsXqNqn4XWsG0U-Y5b-EWFJB9yY6gExOZg_EQHigQ6WBAkPg@mail.gmail.com>
Subject: I want to invest in your country
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,MILLION_HUNDRED,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5003]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishagaddafii331[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d42 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aishagaddafii331[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.6 URG_BIZ Contains urgent matter
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  3.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Greetings Sir/Madam.

I want to invest in your country
May i use this medium to open a mutual communication with you, and
seeking your acceptance towards investing in your country under your
management as my partner, My name is Aisha Gaddafi , i am a Widow and
single Mother with three Children, the only biological Daughter of
late Libyan President (Late Colonel Muammar Gaddafi) and presently i
am under political asylum protection by the  Government of this
nation.
I have funds worth =E2=80=9CTwenty Seven Million Five Hundred Thousand Unit=
ed
State Dollars=E2=80=9D -$27.500.000.00 US Dollars which i want to entrust o=
n
you for investment project in your country. If you are willing to
handle this project on my behalf, kindly reply urgent to enable me
provide you more details to start the transfer process.
I shall appreciate your urgent response through my email address
below: madamgadafiaisha@gmail.com
Thanks
Yours Truly Aisha

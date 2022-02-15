Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866A34B76E6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiBORsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:48:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiBORse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:48:34 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42986B2E37
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:48:24 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y18so13646330plb.11
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=QIB7aLFBTioRvWut3pvKqPG9srSBlHnNG15j1/CXbAw=;
        b=ELo2xtbGeFFIq4BT0r3RS7jl9OYroRD6Aw0SBkNzznCq04USSRYg6dywtuLfk7upNq
         BXDxiefPl7kWti3Loo8SqYKk6mV29xncgHlPNBfVuYY5S5ioBn2I0Wb4a9eA22jOuBWW
         s/YnoC0hzLBUTBTD+JAvGq1z9/tKqIub8LHZozDoXHboRvBxdTyMdaAkTloAQl4kYwb6
         fuHzHqnsB3zhvhwiXqVorGie4pnC6TE0/Wov38BW0nxgkZpHcjh9dj5udSzWT0466vHi
         0bcFyNifoXp0AUKVHJX92QUT35zHAt6nFV4tT6mQuwkEehUhoj0v/ossEqrYO+mLQzdX
         9a/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=QIB7aLFBTioRvWut3pvKqPG9srSBlHnNG15j1/CXbAw=;
        b=6rde5vqUwgSyjye3s3OwMq4LAkWPcD79KwfVKP6itGrkctBXCSuQ8OqpJg3YFH5Rlo
         tgEBnftbSuIB2gDgWt/W1brs+IVpkUOzAnFLGWV4oPMM8Au4xRaIF3vEwNl7tAh3olP3
         Q9Gi/rYLO1CkniIau9rsgvThDxNCwYcCwoG8WtlhZZAdxMrwXrkc/B0U1hPJugAjaK3u
         nd5LF+JSJxcWnfr9o7w2mtpKiY3oQCagNvzX6pvt7eAyuEm+ASn+sHBLcaZG5edg7y3Z
         JiQJDWsAOHFRqmT7yOrdY21Yh1jWMgpujDyNRyWGbaEd+7XTr3UWJc1wXRvExiNQlgea
         bAcA==
X-Gm-Message-State: AOAM533h8yA6mvQTHmRRsixVV/a/omF+gF4Gcmhg2XIInX2gIemKezXK
        UqPRL1CbgJh1wuVH3D0br+rOo9ejhTTBR0D/KW8=
X-Google-Smtp-Source: ABdhPJxLK3Ulosh5NBRCTuNlHrFgYkvgciZMm1VA53vLpu7C2H2N5kcqmwAqRyjFDl8032cNi2L+qiYifhEFMOS30lg=
X-Received: by 2002:a17:90b:4f43:: with SMTP id pj3mr5588630pjb.227.1644947303570;
 Tue, 15 Feb 2022 09:48:23 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:1248:0:0:0:0 with HTTP; Tue, 15 Feb 2022 09:48:22
 -0800 (PST)
Reply-To: nelsonbile450@gmail.com
From:   Nelson Bile <readderss.addammss55@gmail.com>
Date:   Tue, 15 Feb 2022 18:48:22 +0100
Message-ID: <CAMUiuSXpDYfWvUEDg2=QBCs8ZJ621L=FzYzf6nkVxYGvUjeMYg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:632 listed in]
        [list.dnswl.org]
        * -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
        *      [score: 0.0367]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [nelsonbile450[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [readderss.addammss55[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [readderss.addammss55[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings I sent you an email a few days ago. Did you receive my
message? Urgent response please

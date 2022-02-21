Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2032C4BE01A
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358606AbiBUNIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:08:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358604AbiBUNIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:08:37 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8CD1EC6B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 05:08:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id ci24-20020a17090afc9800b001bc3071f921so2950983pjb.5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 05:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=r1zJaBUPNQBJIkixJM/WVkMBxWgtgajvPcDkUoia8nw=;
        b=QxqPjpDi7wL+7ZIsp5J2H6BQ16G8QsKCJ7quH6sQ7ZxrYjyLx3BFW7pBriWYPlwgEU
         Jroc/8jOe9By28aVKN3zjKrv6H9AMaLHFt7l81eBLA6n2jnblIIlFJTghc0FQEgpJ4oq
         pk2Ga33ER3TXY8knSRfJFJIVJKu4+aNGBmVsDYHUZ0DrBVpwIStyykBy8f4IOiwsfWJf
         AQVZe6wL9Lk56SvZw5dvgSceUU/9TY2j5fRwG8lc6CJXSRxl39kQb4h9noGL2It7XTRL
         4WXjI0IKInREfBIni89kLS8znRfOz6AFYEpzwafnCd++b+NxU2AeZy0G/7XvSqFI2Vz/
         Lc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=r1zJaBUPNQBJIkixJM/WVkMBxWgtgajvPcDkUoia8nw=;
        b=KgPi7OOtgvN1isohDx/vb/5vpbec2tZEEjlo25SHQTIBfGJo0dTdEc18dRt0k1B0zs
         Y3oSmkbWnfVKyknLHGE8xuc4qZvVgSoTeicnh799Z/kW9TD8R0cJCE3SHLyyMpTXvI8h
         etdXL8t3L0fiWLiydtHOY9Drwb3Tuec1EfnYVwOvua/DnojmhtnTkARn8RkgPgGAk+gi
         RYHenHn5tpvnR1PgOqEFZes7/aBgGRa0WYiF58WmAs6fHhww3bQj19vhBOIPcmtCXuOU
         hv2nsuNxkzWYaIwDQNtsiIaWWqYgHdrRJclhBCH/v87u8z2KgO8pf+WddiNnEjWlXF/I
         bVlg==
X-Gm-Message-State: AOAM531XtYn943AxfeawrLmMmeDvP+5k6fSRz1me9CgIMCILmm5kpfhM
        LW2SWU7BbyPu/tyRPQhnS97Ow0UOK1bZi2UiLts=
X-Google-Smtp-Source: ABdhPJxPk3V5aN1NC0VaOVPwStgdHK+BQoBlDWm4VpaKI+lTtN3H8uRU3lTygGWIp3x3Fue/0LlyYubE7efIdgTBhps=
X-Received: by 2002:a17:90b:1b51:b0:1b9:b61a:aaf4 with SMTP id
 nv17-20020a17090b1b5100b001b9b61aaaf4mr25666081pjb.79.1645448891664; Mon, 21
 Feb 2022 05:08:11 -0800 (PST)
MIME-Version: 1.0
Reply-To: wallaceharrisonun1@gmail.com
Sender: mj6455009@gmail.com
Received: by 2002:a05:6a20:4a09:b0:76:527d:adaa with HTTP; Mon, 21 Feb 2022
 05:08:11 -0800 (PST)
From:   "Mr. wallace harrisonun" <wallaceharrisonun1@gmail.com>
Date:   Mon, 21 Feb 2022 05:08:11 -0800
X-Google-Sender-Auth: k85gDkU6CBEmzur8UYqilUz8y7g
Message-ID: <CALQs60yt6XVau0mx2DKfo+kNGkVuGaJmVz_NgkhRLcuXC8fnUw@mail.gmail.com>
Subject: Palliative Empowerment
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,
        MONEY_FORM_SHORT,MONEY_FRAUD_3,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [wallaceharrisonun1[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wallaceharrisonun1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mj6455009[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  1.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!

 We are writing this message to you from the United Nations Centre to
inform you that you have been chosen as our Representative in your
country, to distribute the total sum of $500,000 US Dollars, For
Palliative Empowerment in order to help the poor people in your city.
Such as the Disabled people, The homeless, Orphanages, schools, and
Generals=E2=80=99 Hospitals ,if you receive the message reply to us with yo=
ur
details, Your Full Name Your Address: Your Occupation: Via this
Email:<wallaceharrisonun1@gmail.com>  For more information about the
payment.

Regards
Dylan.

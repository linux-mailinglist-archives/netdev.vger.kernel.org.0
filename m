Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B226520604
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 22:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiEIUmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 16:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiEIUmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 16:42:43 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF35D89
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 13:38:46 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so220657wmj.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 13:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7va6PYBEaxzVzOFHDSxBigUPhGrAPiX/eRU/9Co02p4=;
        b=l93xZyCr6nJE5UdrUWPGTvE2uRhQaTwbDk53+Nl5tIpitiU0ZsTdmORL65dGJwAwWz
         CQxtpxvXboq9kYNfYvMf0UbONQ3nPoZ/gevlkW89UMhqSRBph+0eJbQBKpl2Awk6pXS/
         69URk0TjjU8nT4s6PPfSMT5x4mkdt5VpQLOZm0vLLKlP6vCzBn0v6MHFBZFgv70K+JXU
         g0Mbm7UZxQvfaE2UeucANE78k9cZHwqGwe5EbB4GhlbebI4r/wfh9/dKrPiEpc8Hl+Dy
         VpJDPJ32X2v+1lSoySwzrBNhRs81eUad9eXE5utJVS3zKGFxx+Kp6LRIbaSUt71Mb8Lq
         4+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=7va6PYBEaxzVzOFHDSxBigUPhGrAPiX/eRU/9Co02p4=;
        b=t+36K0MSu2CeblgwUIph+L9vW67DjF07O2MsdB7ZODh9KTj4E5w5gclXsz8DHF4rMc
         wMbrbXeYrrPgC7ifUaWB3aZ3YYQKqALPyZP9DCZsrk/4ZX0y5SVUisGWW3VMPfhAEr9u
         ZPODMHfJ41sqPNC1fme0gSkzrsuxc8f4Ykk1rdqqbQGnOkgojbvfxdbKHqzTNFvrel4G
         4oq8hdUaIjs4qcf3TmLO9GrUJFeBP+CnLOxy029KWwizNg1TMpmsaMSXN9k8R6vSw8kn
         cjF+lzsxNrFSeCvRc/ASzTCPGXWBuh4CcS7nKm1BNEMdnPbjDaZ38IVjJHPeD7PVKHbS
         HGgg==
X-Gm-Message-State: AOAM530b1oi8A+EHKs/XDP3PmH0kL9JFbQkoYEYvzHg+0bMkZRN0I/qD
        lzBd/tm2Vl9Pr79DNZlG4tKQMJdVpGHf2SaFng==
X-Google-Smtp-Source: ABdhPJyDbzoDohhdgOvN4FFOAwKF+o66C1chT5SEfPjwiQSlW7OHRec8hW4ICrb4p/5+dTp5Qrpt+X8Lvgtd7Sf6gzM=
X-Received: by 2002:a05:600c:5104:b0:394:7d22:aad8 with SMTP id
 o4-20020a05600c510400b003947d22aad8mr16907704wms.68.1652128724455; Mon, 09
 May 2022 13:38:44 -0700 (PDT)
MIME-Version: 1.0
Sender: felyikpuckan@gmail.com
Received: by 2002:a05:600c:a07:0:0:0:0 with HTTP; Mon, 9 May 2022 13:38:44
 -0700 (PDT)
From:   dr adama ali <dradamaali4@gmail.com>
Date:   Mon, 9 May 2022 08:38:44 -1200
X-Google-Sender-Auth: HLb2Q91GeN6cT2knBZDHOY_dOKU
Message-ID: <CACF60Hj4Vce4OHTv2Bar6QucoRgM=vP7QVGp6OxL7Fav_w=Hcw@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.0 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:331 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dradamaali4[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is not a
hoax mail and I urge you to treat it serious. This letter must come to you
as a big surprise, but I believe it is only a day that people meet and
become great friends and business partners. Please I want you to read this
letter very carefully and I must apologize for barging this message into
your mail box without any formal introduction due to the urgency and
confidentiality of this business and I know that this message will come to
you as a surprise. Please


this is not a joke and I will not like you to joke with it ok, With due
respect to your person and much sincerity of purpose, I make this contact
with you as I believe that you can be of great assistance to me. My name is
DR.ADAMA ALI, from Burkina Faso, West Africa. I work in Bank Of Africa
(BOA) as telex manager, please see this as a confidential message and do
not reveal it to another person and let me know whether you can be of
assistance regarding my proposal below because it is top secret.


I am about to retire from active Banking service to start a new life but I
am skeptical to reveal this particular secret to a stranger. You must
assure me that everything will be handled confidentially because we are not
going to suffer again in life. It has been 10 years now that most of the
greedy African Politicians used our bank to launder money overseas through
the help of their Political advisers. Most of the funds which they
transferred out of the shores of Africa were gold and oil money that was
supposed to have been used to develop the continent. Their Political
advisers always inflated the amounts before transferring to foreign
accounts, so I also used the opportunity to divert part of the funds hence
I am aware that there is no official trace of how much was transferred as
all the accounts used for such transfers were being closed after transfer.
I acted as the Bank Officer to most of the politicians and when I
discovered that they were using me to succeed in their greedy act; I also
cleaned some of their banking records from the Bank files and no one cared
to ask me


because the money was too much for them to control. They laundered over
$5billion Dollars during the process.Before I send this message to you, I
have already diverted ($10.5million Dollars) to an escrow account belonging
to no one in the bank. The bank is anxious now to know who the beneficiary
to the funds is because they have made a lot of profits with the funds. It
is more than Eight years now and most of the politicians are no longer
using our bank to transfer funds overseas. The ($10.5million Dollars) has
been laying waste in our bank and I don=E2=80=99t want to retire from the b=
ank
without transferring the funds to a foreign account to enable me share the
proceeds with the receiver (a foreigner). The money will be shared 60% for
me and 40% for you. There is no one coming to ask you about the funds
because I secured everything. I only want you to assist me by providing a
reliable bank account where the funds can be transferred.


You are not to face any difficulties or legal implications as I am going to
handle the transfer personally. If you are capable of receiving the funds,
do let me know immediately to enable me give you a detailed information on
what to do. For me, I have not stolen the money from anyone because the
other people that took the whole money did not face any problems. This is
my chance to grab my own life opportunity but you must keep the details of
the funds secret to avoid any leakages as no one in the bank knows about my
plans Please get back to me if you are interested and capable to handle
this project, I shall intimate you on what to do when I hear from your
confirmation and acceptance.If you are capable of being my trusted
associate do declare your consent to me. I am looking forward to hear from
you immediately for further information.



Thanks with my best regards.
DR.ADAMA ALI
Telex Manager
Bank Of Africa(BOA)
Burkina Faso

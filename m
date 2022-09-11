Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FAD5B4ED1
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 14:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiIKMl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 08:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiIKMlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 08:41:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A098C32ECD
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 05:41:52 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id y17so9241015ejo.6
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 05:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=VXlBS00/GuegNihbP9LSEb4G+N9nTOzbXeMOhsINvjI=;
        b=qFxBM+4WmE84b9kc42AjML7y/u79qDnKy/I3R05YmDaHugd3sJm0ErbEJibh/jSPji
         6y1bg0o+pu35H3n2Re5/9Cq+QgAEL22L1Xab1dCakQu6XF/iVZKGbL5N2XXly/eqTnr9
         JkrloLvEIL0pAPJ1FUx9fhbHlyPMfgq5M7J2bzOlu7WXA+zu9HLvgoiQafb9+8Uf2bDk
         ovpSEVBiurmmku5vGgI41iMuvBBDkutOwnL0nw7IlmU6f0/PMOueGk+UKgsPulwLQNyq
         UYfQAY9yWKkeCpWupwq4TcOhrqapeUbZ7J5gltMMKVtMCBOXR0iT93jPs/41qEhHBU6A
         wJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VXlBS00/GuegNihbP9LSEb4G+N9nTOzbXeMOhsINvjI=;
        b=aoXppnrhjse0wexMLMZShfB+S9rTAJ3A+ILpE93sZxJ91OM2TLzyGlCWkkzqwZaKVw
         x6WqY937n45YQmZWq6g7uhDAgGGsgLI+w0bA87PppPRugsUBaXW9uleAHrH4qyTeg1R2
         Yh48lmGqNW8om1F43b4bhTYD2Ly8k4hFXh4S5uimt/jesc5nxtVgjaIzPFaDIynTF85D
         HgHPay2KIcRe9L665urt08cEpGr1+8fLgTIJrIGvuThSFBuCjRQr8jsTlmcG5QoUkdcK
         yIeS1gZ0ih9oMHCRwMSiWnFOrxg0xZEqzVsM1z1tEd9HEQpzwnJwGseOYvQJk4q5z/cA
         qCqQ==
X-Gm-Message-State: ACgBeo16W6SrSdb0XDxGnHfmMB7QDV7SQiZR6iSUEfiMB4smUGpMZCdv
        jYaLtXs2fo7PHA7W1/ZoT8MCMCVpy3ObgHw+1r8=
X-Google-Smtp-Source: AA6agR4HwaGiVvzSAOcg4mei3ZtJ+TXfr9Q0likya65KAprVU9U15MhWXWOAlk2p7qnWIdCDEWUMbl5oAnUWNDL927c=
X-Received: by 2002:a17:907:2d14:b0:779:fa1d:1aac with SMTP id
 gs20-20020a1709072d1400b00779fa1d1aacmr7440962ejc.585.1662900110865; Sun, 11
 Sep 2022 05:41:50 -0700 (PDT)
MIME-Version: 1.0
Sender: peppersben3@gmail.com
Received: by 2002:a05:6402:1d55:b0:451:74ca:49f2 with HTTP; Sun, 11 Sep 2022
 05:41:50 -0700 (PDT)
From:   Mrs Aisha Gaddafi <aishagaddafiaisha20@gmail.com>
Date:   Sun, 11 Sep 2022 05:41:50 -0700
X-Google-Sender-Auth: ddOE6hVQREXuYiUVQ-X5lPaQTfo
Message-ID: <CAF6h66rvkmAjBKqNY8qmimnWPJ+gmWOarcZsvYZvTX7kYTfPyQ@mail.gmail.com>
Subject: GOOD DAY MY DEAR.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORM_FRAUD_5,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,
        MILLION_USD,MONEY_FORM_SHORT,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_FILL_THIS_FORM_SHORT,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:632 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishagaddafiaisha20[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [peppersben3[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  2.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
        *  0.8 FORM_FRAUD_5 Fill a form and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm writing this letter with tears  from my heart. Please let me use
this medium to create a mutual conversation with you seeking for your
acceptance towards investing in your country under your management as
my  business partner, My name is Aisha  Gaddafi and presently living
in Oman, i am a Widow and single Mother with three Children, the only
biological Daughter of late Libyan President (Late Colonel Muammar
Gaddafi) and presently i am under political asylum protection by the
Omani Government.

I have funds worth " Seven Million Five Hundred Thousand United State
Dollars" [$7.500.000.00 US Dollars] which I want to entrust to you for
investment projects in your country. If you are willing to handle this
project on my behalf, kindly reply urgent to enable me provide you
more details to start the transfer process, I will appreciate your
urgent response through my private email address below:

aishagaddafiaisha20@gmail.com

You can know more through the BBC news links below:

http://www.bbc.com/news/world-africa-19966059


Thanks
Yours Truly Aisha
aishagaddafiaisha20@gmail.com

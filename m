Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE25523DE
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245413AbiFTS3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245396AbiFTS2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:28:22 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE28140A2
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:28:21 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id a10so11955141ioe.9
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NTFM/4VkpDM2qI5OcPL5gWkEDJT/oSyHrioA8LlzOIU=;
        b=aSKVtffmz3QNrbI6AfMjpHOi7dR22/XMjkwuUa1rUdiyZHhHDH5IhQDv2zrCwAS3Rd
         Ut7gGihbDQFKwEV/RrNE2BDxuwumRPQHV1ZkGAKBnlQUXBPyWL0vtV3U/rw+rjsrBpIp
         gMEAorP2KJLq7IYrUV8lE0aEdnjmTD0hA2UMGjpPfHUBFfo4m7SHvn+127HlZjrM6tZT
         i1atnOT4dJOE/a1qlYzwOSVf25tZ7n/PO59+TKw0VCuvJGnJsENPd8Mnh4y4AjDGa2Tp
         zOC5YTMd85CofMH+p6BK+CTFfsSJHyXZDHsJRkPB5GOeUZtldpBiin0sSRGcW/hBFWo8
         DwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NTFM/4VkpDM2qI5OcPL5gWkEDJT/oSyHrioA8LlzOIU=;
        b=bSX6c26Gf68tKK4wZtlU/P+pYP8MscfQ9Cnfw+rAfDd84We6v2sEHqkHjFTIl1TUjk
         einCljRcr0glrKbV7akjIeQj4DCCp5bm1PLehlnfva7PoZkkows+9XWHi9MUZyGlkB45
         hUJGqkwa02F2chFvyxGo0VW4v5CGxdpVAU2hMxoo8HntPAwTxqJO/pMxNtsN8rDQ+DDS
         bCtJZAWbfc6smuVzcC9yFSHo0sZ7x+uoRB+0gOFEur2K8ElFZu5mi/7PVQbKNTclYFAR
         qbhQQ6kWPtidalCE8DKJJOqxLFU4ryTULUvGzylUEnbPUMiSfhXptxrjgxbiGTqgsNkz
         Q1SA==
X-Gm-Message-State: AJIora/cg+nnO18jwz3rN9+WorS42nKdytezuL5dHr4WXGrPvToJRRJ2
        55fww71RGsVh8QGo6+RwM1zK4dD3mYHO4pcC2ts=
X-Google-Smtp-Source: AGRyM1uy/OVi8SRBztp8LPRbt9VW7FRsFaCHo5j/ZaDG/8ULmt9RXkLPCq1kC6AhX0OKW62sWx3X6XLqZ0NJH9fzzI8=
X-Received: by 2002:a02:bb85:0:b0:331:7a13:201b with SMTP id
 g5-20020a02bb85000000b003317a13201bmr14417922jan.41.1655749700418; Mon, 20
 Jun 2022 11:28:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6602:164c:0:0:0:0 with HTTP; Mon, 20 Jun 2022 11:28:19
 -0700 (PDT)
From:   robert anderson <robertandersongood2@gmail.com>
Date:   Mon, 20 Jun 2022 18:28:19 +0000
Message-ID: <CAPOVD_g06OVV+4x3vna8wLNP9O6m=_JmD_DqJJ3Maz8yOvnMtA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.9 required=5.0 tests=ADVANCE_FEE_3_NEW_FRM_MNY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FILL_THIS_FORM_LONG,FORM_FRAUD_5,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,
        MONEY_FORM,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [robertandersongood2[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [robertandersongood2[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  1.1 ADVANCE_FEE_3_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
        *  0.0 FORM_FRAUD_5 Fill a form and many fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Congratulations!

The United Nations has come into conclusion to endorse compensation
fund payment of six million us dollars ($ 6,000,000.00 ) to lucky
beneficiaries across the globe through the help of the newly elected
president due to covid-19 ( coronavirus ) that has cause economic melt
down in different countries and global hazard to so many lives.

 The United Nations has instructed the swiss world bank to release
compensation fund payment in collaboration with IBE bank in the United
Kingdom.

The payment will be issue into atm visa card and send it to lucky
beneficary who apply for it via IBE bank in United Kingdom through
diplomatic courier service company close to the beneficiary country.

This is the information United Kingdom management require to deliver
compensation fund payment to beneficiary country door step.

1. Your name:
2. Home address:
3. City:
4. Country:
5. Occupation:
6. Sex:
7. Marital status:
8. Age:
9. Passport / ID card/ Drivers lience
10.Phone number:
Contact our Agent email id:
name solomo brandy

EMIL ADDRESS (solomonbrandyfiveone@gmail.com ) for your payment without a delay,

Best Regard
Mrs Mary J Robertson.

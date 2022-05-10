Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D85211BE
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbiEJKLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239331AbiEJKLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:11:11 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F54F185C85
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:07:15 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id r17so11008807iln.9
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=vjJ/DPgH5OA8A+lItdmXvfVjesRSStJY4gQ0upgp36A=;
        b=qUiOgZQ3vKLQY20FsRvUHdigKSd5enIjdw9kPx67vubtqw9g14Ql8ThfhhFNv4mKEb
         orN604PtxpDWoSSQexF9abgjQvjRClSLO46QDnuzeHQ7jiVP8/cNZMJhrsKke3+xKInQ
         SxQS5rEpyM/n5CmrrdzopF7Xh7/MKjfu0AfE71amHzqmkpPRMkx7BCbWLVmHgqpguBE0
         k2Zgw4sa1BEZEc8ONiSewMsbXBZnWbKLBbeRiYg8ldil6JFyBX3EOu5NrCsTG8fkCcHu
         rEVpOkPR2fitUP0IPlJSp3CGHndiaiDfncLfwvOUy1WVDwJJwmGQzknZkth0sJE/MdCW
         p/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=vjJ/DPgH5OA8A+lItdmXvfVjesRSStJY4gQ0upgp36A=;
        b=0MhZbLwE6BIiuo9JYEpnGBG/ckb7jRRi3QyCbHPDlIipQyu4HOorGDryykOAHbMZx+
         Kp4c7dNFrVxwOm0vSQwayB0Zfr4rI9shNXbwhbEifwkZ0gnEr/tJQEbccKNKjsx4qNkp
         C6V8qd16CfFyxyH14m0Jvx0pkjscOPhwPr7pYqxmdFI342t9CW0YsrzTme/LudAoWvSW
         HtS6fHY9R2KnLT3KwSax/THBK3YwzthWFN6Wz7BTAGCUJ//Gb/CH5tr/6IIVQ+zANNyq
         tSkxntot0Y7QLEgI3uulnolUcQ39pMWF09fVBsjJaGhxXiFnBDKgvQCgzwANDlbkzcY3
         3TvA==
X-Gm-Message-State: AOAM531hU6uTAu3bhvhDvnpRVqRyrgiHDDWMen9rcfnhymlSSTylxxNj
        traquwxVMqS6GnWXe6rW+t63o+IApVvmPBEQwdw=
X-Google-Smtp-Source: ABdhPJytQAlyWArhcXEXf+iOzQYvUQJOAujqZ1El56119ohIU8YQNDNyK95nEu+4nM4WyrngkZRHe9956sn/GRR3uLE=
X-Received: by 2002:a92:ca07:0:b0:2cf:95c4:9e9d with SMTP id
 j7-20020a92ca07000000b002cf95c49e9dmr6543125ils.99.1652177234774; Tue, 10 May
 2022 03:07:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6e02:1ca7:0:0:0:0 with HTTP; Tue, 10 May 2022 03:07:14
 -0700 (PDT)
Reply-To: qatarfoundationendowment1@gmail.com
From:   Qatar Foundation Endowment <philiplawrence58@gmail.com>
Date:   Tue, 10 May 2022 11:07:14 +0100
Message-ID: <CAKhidwXwyBsOXvgTTqznCzYkfUD_7LiZgJwxL6VAC666Fk777Q@mail.gmail.com>
Subject: Dear Beneficiary
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DEAR_BENEFICIARY,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:12c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [qatarfoundationendowment1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [philiplawrence58[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [philiplawrence58[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 DEAR_BENEFICIARY BODY: Dear Beneficiary:
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Beneficiary,

You have been selected to receive (=E2=82=AC1,000,000.00) from the Qatar
Foundation, kindly reply back with your full name and address for more
information;

Regards,

Mr. Rashid Al-Naimi.

Chief Executive Officer of Qatar Foundation Endowment.

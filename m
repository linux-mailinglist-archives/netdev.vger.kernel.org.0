Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC737591ECD
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 08:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiHNGzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 02:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240291AbiHNGzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 02:55:38 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D525F18383
        for <netdev@vger.kernel.org>; Sat, 13 Aug 2022 23:55:36 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso11879845pjf.5
        for <netdev@vger.kernel.org>; Sat, 13 Aug 2022 23:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=t2xo6E1uDVXBL9rtyALdnKwGeumoPy0aKoIQA7ijnWQ=;
        b=O9BDcGUKG7K1ZnOxwd098b2+3PW/h7Fd7PRIO70QzOvpYjdQf9Y909xjiRJoTT5Rwz
         k07LbcL4I/6nIALW4rzEwamiMA+TNRID+lmKpM2Opd+i3VeGdFi7XL853jWf7RKS65qx
         4tmDI/hXKtFtf1Rt/3FOzuUCU6H5fhS02lQ9hTm1PEv8MaAVXxMy0/60icXX59KQDgV7
         MNIpv/KCyimBf0U+FClQIaRQonRQ3XF+/8q+LJ8+a+hmkSRKwWr1p/sMvMnl/t4qlBBD
         Doek25yyPgAbYqgMSGgqHfko8+mITuy/klgf9xYgOLHCWPMFFfZv67vq9BGVWoYtA9wY
         Kelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=t2xo6E1uDVXBL9rtyALdnKwGeumoPy0aKoIQA7ijnWQ=;
        b=GhEfmYkON0Wec0TF1Mp2vf5uSy/A06e7iMXo9obctVXJqCjNZlD++ATTR5T6cfebcX
         eo7kytKZNRCz4Z8pp4VJpyZZrhE0YTRRFfxeUindcf0MB6Tq15iMbSTeuHxsezoyu0vU
         oOM5Z71D8W/17fsgKJnNkaU/VTXbPv/16oCVP+yqbHOcX8d1OAVFOqmDLcO92ogc3wa1
         ZhMRLpNrNkR2Iqgq7VzK0J9E9AvbcWxIWF6Iza/bbkTNDMIgNgHhN/RayHFB0YAecjKu
         BvphiNyCVsGFJgooEP4K8IKQ2IoXIf/afq4HyquaVAqB0NcsheIhbdv2auJt/YeooOY/
         uXFA==
X-Gm-Message-State: ACgBeo2zldpBPqnutsvMpiM3S+0ENYc+xGFLgN4HxiNJm8rYNaS3y6jm
        AzdjFo7YpYiHV+6B/H2Bwq0YeUG4E7ZnpI6ot34=
X-Google-Smtp-Source: AA6agR7NaKpyG/1e9WSMpXQ8eN9GA6mq/rMvtEFFq32H7IJM9IKYsK6aMGnKwp4ZNhtAJOhTrQYMRDobZh2aSvyvxQU=
X-Received: by 2002:a17:902:788f:b0:170:8b18:8812 with SMTP id
 q15-20020a170902788f00b001708b188812mr11387634pll.1.1660460136207; Sat, 13
 Aug 2022 23:55:36 -0700 (PDT)
MIME-Version: 1.0
Sender: rayngwu1@gmail.com
Received: by 2002:a05:6a11:5a3:b0:298:df7d:dd9d with HTTP; Sat, 13 Aug 2022
 23:55:35 -0700 (PDT)
From:   "mydesk.ceoinfo@barclaysbank.co.uk" <nigelhiggins.md5@gmail.com>
Date:   Sun, 14 Aug 2022 07:55:35 +0100
X-Google-Sender-Auth: wiErEe-BxUikpJixAttp3aONGw0
Message-ID: <CAFUkv_AvR7odX9N9N_2Asq+5kq4uxap2rmyyViXLNUicbK5cpA@mail.gmail.com>
Subject: RE PAYMENT NOTIFICATION UPDATE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_2_EMAILS_SHORT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,YOU_INHERIT autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1044 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rayngwu1[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nigelhiggins.md5[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.5 YOU_INHERIT Discussing your inheritance
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.9 FROM_2_EMAILS_SHORT Short body and From looks like 2 different
        *      emails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

I am the Group Chairman of Barclays Bank Plc. This is to formally
notify you that your delayed inheritance payment has been irrevocably
released to you today after a successful review. Get back for more
details.

Yours sincerely,

Nigel Higgins, (Group Chairman),
Barclays Bank Plc,
Registered number: 1026167,
1 Churchill Place, London, ENG E14 5HP,
SWIFT Code: BARCGB21,
Direct Telephone: +44 770 000 8965,
WhatsApp, SMS Number: + 44 787 229 9022
www.barclays.co.uk

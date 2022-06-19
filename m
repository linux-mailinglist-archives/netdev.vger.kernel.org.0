Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17294550C11
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiFSQam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 12:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFSQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 12:30:41 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515D0AE66
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 09:30:40 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id x38so15140986ybd.9
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 09:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=06aReM9jfRAlY7hrHnKqsjfzL0Vm0W0X9h6r/U1qeAQ=;
        b=lJUvpMnLts9+nOcXP/qTjQh1798PhsP3toOjxH4Hn5CyxdYvxzn/7Rm0IIFdHmQ0YM
         d9+vOTVEec62GoD88v+899cn5fFsAO1ZZOFtEZd6/FWcdBzC9okbNW2x3xh90u3mKMUO
         0uCP4hUKkLhgM1GCMzw9KXFit/KGxAgD/qcjHSIj9s9qGWcLh3/Yduk8OsEfM7xOXXT/
         ssYO7lCbK7NbudN4yb4gNSAUKrBb6ILtwgLYlQQVsVdwIo6Ara/74hlaA1V6UKIltHVQ
         5ji9bJBkgTV6i5neBwlwhGz6PRNRl/IYfGxzhhg9bOHf/cXISSPkp5c52NsoHlyMvStp
         uKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=06aReM9jfRAlY7hrHnKqsjfzL0Vm0W0X9h6r/U1qeAQ=;
        b=0RUtToN2AkAi9FoEklFH/W18xMSi22H59y8WJg46nrybzOaFuFRkIfqrBW6VeGYFiM
         wpp7ZUhKKsyyiyxm9pom0ng8zMiJ0pLC7aIxvMpI2Xpb3bk+w/u5S1CKAblgxbDMpbjz
         xGofs4MtyP8ikoErhigfUZAK/AsOtN6KGazmuxO+xNsgS/bNQShNWXnqQ4GYrLP+Fhjp
         jJwB9odSk1oPKhWR9M0fKs/WHYssYYvWCzM3/9NclcTLQ18e66GE9biIQdwQc+cXue6J
         lz5eI0BydVghNHa2MjcByOrPz38FBiK3EsFn+LM+T63OYn7WezfpYOqFmgG1N/+itjSq
         mfCA==
X-Gm-Message-State: AJIora8CSBtY+hV26sukbV3S0D+ZhSPsQZ3+1s7+uSb1elaY484L59eS
        aVRrdTLFIyf2W0CJ0aGyhPBPLQcQX2KEI/eF7xc=
X-Google-Smtp-Source: AGRyM1uMDIqInmgQQ3QVA3xDKQVs/Wk2Skx3I5GSQZqGjOiaKnDNWj5FRPr2Y9XZIsqIdEr0l9v/W/WkIjGBGfX7qjM=
X-Received: by 2002:a25:a28f:0:b0:668:dc91:a16 with SMTP id
 c15-20020a25a28f000000b00668dc910a16mr7024138ybi.391.1655656238769; Sun, 19
 Jun 2022 09:30:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7108:700d:0:0:0:0 with HTTP; Sun, 19 Jun 2022 09:30:35
 -0700 (PDT)
Reply-To: ibnahmadmustafa.aseelfinance@gmail.com
From:   "Ibn Ahmad Mustafa(ASEEL Islamic Finance)" <kateb0343@gmail.com>
Date:   Sun, 19 Jun 2022 17:30:35 +0100
Message-ID: <CAGBY=PEqNT8APS2qfi=veOnxz3S4zEfHyMnCgX-qzDTL7zPzig@mail.gmail.com>
Subject: LOAN AND INVESTMENT - ASEEL ISLAMIC FINANCE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_80,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2f listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8117]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [kateb0343[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kateb0343[at]gmail.com]
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Sir/Madam

I would like to introduce you to Aseel Islamic finance PJSC which is a
private joint stock company that was
established in 2006 and has built a leading market position for itself
in the UAE's Islamic finance market which specializes in loan finance
and investment activities in real estate, hospitality, industrial &
sustainable technologies, strategic financial investments, specialized
education, healthcare services, agriculture, manufacturing,
mining,energy and additional environmentally sustainable projects.

I would love to send you further details with your consent.

Regards.

Mr. Ibn Ahmad Mustafa
International Business Coordinator
Aseel Islamic Finance PJSC
Telephone: 800-ASEEL(27335)

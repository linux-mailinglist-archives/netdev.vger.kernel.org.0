Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36395339A6
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiEYJN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 05:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbiEYJNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:13:10 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5E18D68F
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 02:09:15 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id e4so23214689ljb.13
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 02:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=djGKhvUF8lAsiTuKU98fE1SgBbCGkJsAmy7BmMcoar8=;
        b=oUhvHVwtjkX8aSGqHsZNBS8FC0AZjutoIsi8M/NjoiYYksR4ipdlYFw7lCpuYujOgk
         F3tAK8uV/iuEXiUJbTfquiEm7fhq3T1/vZcLN0xok6wN+o1RZnpd8n57y/JKtSvpfzm5
         DWE090RBaan2UJXiKwM9WXD7oexNx1NZBM92gAOJ3skC3L/DsBYsG+yBu1tQ9+lW2Awh
         va2vDPSvi98nn4kOj71ke1tIcSCoPDeTuxdZGXIdadJnC3/5spZ6FHNTMOYmqzbOk8Mg
         /zQIP9ZZN3XeObiSbOogYEgHA3/1NctBkFgRUMK4DaG2kBqUXh2bP9znstW7+wA8n92o
         zteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=djGKhvUF8lAsiTuKU98fE1SgBbCGkJsAmy7BmMcoar8=;
        b=yiVuIYt9v0x+FzSwAkfJ2f1qXF45YsCUMRNliLuWUTjiO7Nf9xpM4iOg0GszWwvyDX
         ZElaQzYH21MDm23OQFtl5KfjqyvUvcJxibSntWlOPBlnexoRqMT67EWN+mJsTmFfrAIn
         NtQRRGvPjX1Si9ga8u5AtXH9DEOiRvJIrqOgl+YYViCsXkGoXZCrSKzZC/5V35E/Os+2
         8QJswuKBSYon8DMTmEWrxlUfql7F7P0Q51nWdLnfKRQ45GvJesbOeDmDinWWxrw6ka1X
         Ak0j21/vOURAT1AkJ19FIYSsih4rCjOETtuSl91I2x55BnG1wy73I3nxLCj8cTtoWbKc
         sWKQ==
X-Gm-Message-State: AOAM533gq3Bxzr36yMVbZIV+q8BhaWAdO4+OENl0XPMCg3L35tzHXs9O
        2GiJFuBZgfegjkFRd1XOdgl3+aDP0v8zP6cxwYQ=
X-Google-Smtp-Source: ABdhPJwJUoSeP+dNwviTlgTBwRz6jlptbxiA99jMLHEZJMEqCBuJcA9OeHuTzdLwC1FOsMFKR2iBUSdeo0CKdoPz4rw=
X-Received: by 2002:a2e:a7c9:0:b0:253:e736:a767 with SMTP id
 x9-20020a2ea7c9000000b00253e736a767mr9961561ljp.218.1653469753929; Wed, 25
 May 2022 02:09:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:aa6:cd8e:0:b0:1e5:6dcf:3c78 with HTTP; Wed, 25 May 2022
 02:09:13 -0700 (PDT)
Reply-To: ukofficeimf@gmail.com
From:   IMF <gaevoleg82@gmail.com>
Date:   Wed, 25 May 2022 09:09:13 +0000
Message-ID: <CAOWpCPMx8q27z1S0o5sXeyiAT=3VyuJmrgqF=GwGDxRtjm7Ryg@mail.gmail.com>
Subject: news
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22f listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6233]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gaevoleg82[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [gaevoleg82[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Good Afternoon from UK,
How are you? we guess you're well, Our office has sent you a message
last week, did you read our notice? get back to us upon the receipt of
this mail.
Thank You,
Mr. Hennager James Craig
IMF Office London United Kingdom

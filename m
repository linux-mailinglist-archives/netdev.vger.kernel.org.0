Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBEE4DAEBE
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 12:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350353AbiCPLSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 07:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240971AbiCPLSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 07:18:24 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A2354BD6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 04:17:10 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id j7so740589uap.5
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 04:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=9jxPHAajMDwbyaNvV+uuNHGerZhKbi9J9L5FM+MhtUc=;
        b=oeBqBjRxadYCvJkV96ijAOnmwi7VZUfWg5D/qr7idQ8RQM/AL5bxsu46zBu4UWb5IR
         KNC+9Snqk4tX/d0Jhh08jAki7f43Hdcg1XP9PHGv8PtYaQFl8YaPhJW8mLPC9LvkUn2y
         jWMn0bEOFLFb2qEvPGSHdk/SCmEDxSN6IsfYpDWvIKn9zJ9GNIKdxS6iiScVMzGdAClz
         dKSRqzf10HtbTyLq0fBynneB4Qgzv74IXyhpRe9E07JezjmElG6zV+WAkxG3ldzNf3TR
         I/iy76OUrAlLbD8gyIs7apX+aDDXhA7E4vTCguwIQGZFblatciGRB9ijpfKs79+4bwO5
         +BuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=9jxPHAajMDwbyaNvV+uuNHGerZhKbi9J9L5FM+MhtUc=;
        b=RWHwTfaIXztaFalaxB15fgdKEplunghOUvj+4/rOf2L6+QcsJ4L8/3pN2tMnYCjnKo
         80XgUj6i4u5rYm9kETzATaATyItr2q1fTJlYa/7Urv7eqUdegyiPgAMxLVjmmQBDNRrb
         jE7VmJlInTWvgsomzDlBnoZxUbuDNbyewb+opN4VURN7JavbQnsCGl6Wf5GA9l8j+j8V
         qvAistRQYTcQ/NYDkFEInnB1Mt0cF/IIWnbgWFUtQwnx2+b8C3HWoSyIIAHWowT7bMw8
         b+5k9Cxgj5zPxaDIvR2dkIqKQDMEXV9D3y+NJVrLiM/AiwNLuNp4vpywG41iTUNF6nmJ
         +8WQ==
X-Gm-Message-State: AOAM531FergbIQBGGvp+E7J9/mBteqhFQdQhx/5afjGBKge61kikuoxm
        d817e9geoLskniZuNHOnsCo61jzUlYjTU3i8ngE=
X-Google-Smtp-Source: ABdhPJyuaOiMJfoS3bMGkYqY8GAN/FDs7EPMk/63e2Kqpoc9b1utSsnXfwrHZWW7d/2TwFRPQMEoxG2EtjyScM2cZz8=
X-Received: by 2002:ab0:3b8f:0:b0:350:639f:c511 with SMTP id
 p15-20020ab03b8f000000b00350639fc511mr2517892uaw.123.1647429429998; Wed, 16
 Mar 2022 04:17:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a67:e2d0:0:0:0:0:0 with HTTP; Wed, 16 Mar 2022 04:17:09
 -0700 (PDT)
Reply-To: myerjvj@yahoo.com
From:   Loch Charlotte <lochcharlottee@gmail.com>
Date:   Wed, 16 Mar 2022 04:17:09 -0700
Message-ID: <CAJSodkzxJxNSZ+zTx+oOUGN8LCfBXWR0s8+VAdVmadoJtvy7-w@mail.gmail.com>
Subject: Hello Dear, Is Ms Charlotte Loch
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:935 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lochcharlottee[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello dear,

My name is Mrs. Charlotte Loch. I'm from BERLIN, Germany. Please, I
have a profitable philanthropist project proposal that I wish to share
with you. This may not be your area of specialization, but it will be
another income generating project for you. Please let me know if you
are interested.

My email address is: myerjvj@yahoo.com

I am waiting for your reply.

Best regards,

Mrs. Charlotte Loch.

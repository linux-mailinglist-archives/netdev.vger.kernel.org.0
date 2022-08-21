Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA62559B2F2
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 11:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiHUJih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 05:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiHUJif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 05:38:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC4D95AD
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 02:38:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id bf22so8306783pjb.4
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 02:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=hitAXJeOLFv+6OBzWrU6/8VrM0Ahx+7YPY/MmnzEWd4=;
        b=U5TnSKd1mGnlkfSoKlXM+X41suDcRHD7aheQd6OitqJDlDBhJV27wfc77Vn8EQzc7q
         nJZKSb0RSsr1OOhATW+ELF+pU70E6B7UWuFbs72LBz60mMnQAVU7JbinFbqHpA6HP957
         moIwrAR8gahheVAgcysVX8/hf3Sd6wAwoBs+xy2CsjWFlCb9EuHbAjGtTAUFC/LOu1nY
         Zfa5CSO0SJfRmNUlkHHlN4A7Cb3dimp/0F/zsljp/bvxel/4z7J2526oPDR5cskyl2w2
         5x5rHvJRNpfkzcT0Ja89zIjtGG3RHjs6J+53X7pCgmygijEQB6p19ywi4T9B7I19T+qm
         2PHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=hitAXJeOLFv+6OBzWrU6/8VrM0Ahx+7YPY/MmnzEWd4=;
        b=XhdwLD5iFZ5j++i3fO0q9Qdvtf7eID13Ug48HiKFOFDWvTjHy8iHTSQE05588L1TFT
         yJs7rDoQq43zyRcnH+PRnKnNWtvP60YRA9Qy8i3HxBhlfItnoXsb7Nbpapt5LfELVvdw
         CFVFS4MvXkHODnikxJ5Fa/HftxOCogG8h1c9Z27HmtV6HYQ8gnxuncetU7OqJ7mctT8I
         +9vOjycZ6beORHq2Qp2XIKhpFlIhU2t+2XocDWzY0WE8NpxYB3pxyoZnlfzAp2+Ea4kb
         D1kTOFRgV8jw4fPZIv+Y5LT8zRWsc/vRuKKMecpMHg7eLrueUrXz+TWKzD2HBiEsM/2R
         sPHw==
X-Gm-Message-State: ACgBeo1WkdlqT9Zd2Bd+hXB/RBnO/psMGv4Dyq64cNp7VDQm702rpjWV
        m3tpNK+zrY7pZ53zCOOM+gJhTmC6q0gs1Yp5N+0=
X-Google-Smtp-Source: AA6agR79jyOJL6tIdacnO1iWICEsbvM7omSEacErZnN35Icnt4Xdpu84C+eEyU6rIbW3b0nupVqxN97G5yxcs5UT0zI=
X-Received: by 2002:a17:902:d509:b0:16f:1e1:2067 with SMTP id
 b9-20020a170902d50900b0016f01e12067mr15138160plg.140.1661074714326; Sun, 21
 Aug 2022 02:38:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:38c9:0:0:0:0 with HTTP; Sun, 21 Aug 2022 02:38:33
 -0700 (PDT)
Reply-To: peacemaurice482@gmail.com
From:   "okenwa@me" <saboubakar878@gmail.com>
Date:   Sun, 21 Aug 2022 09:38:33 +0000
Message-ID: <CAEUHdv0uOF4+3uhQSzwKXS4KLNEdyjvOL7Dmd9QN5ZF9h5UriQ@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4956]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [saboubakar878[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [saboubakar878[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [peacemaurice482[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1035 listed in]
        [list.dnswl.org]
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I wrote a previous message to you two days ago, but no reply from you,

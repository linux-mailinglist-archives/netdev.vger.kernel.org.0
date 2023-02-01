Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FBB686545
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbjBALTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjBALTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:19:05 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C3C12587
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 03:19:01 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-169b190e1fdso2030974fac.4
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 03:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FocuR5aXn3z28LzYD0rCmA/t4By4lcIW0G986gs+i74=;
        b=ZWf9hWIw/LOh8Qbhyh380e1xceK9VauGinRirk/+HDCbwXuB/aLuid3KOYpyf/HNE/
         WlNjBoC4v88gcHYvJ7jo6TGcMwkef+Dnb3UWCfP9+Zrq62Fagon+xqRiUjNdGoOFVUOw
         iBCgIkiRoNfX3qJ3uX65QTmkB3PvsdBg4kWiZSGhucNSrvEkr1R+2J8CB1YSE7cBTeX6
         6JmG2DyKt/TtrPwg5skkl0BGmIrKPnoMjZGEIEOfMKdTmeOf9cLhEoWhO+oLwIJeF3Ud
         Z5IGl1wgtROjC9CJi763KDZB2ow4KXsh0xKp8HFFCI7c8JtW8Sp1xxsYxjVHedG+NmRt
         RKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FocuR5aXn3z28LzYD0rCmA/t4By4lcIW0G986gs+i74=;
        b=BShJ6Fk3CB0h/8ewA5mAw6zVUhacbL9apgk5Jhxsa4++TkKcviHB8+rjHcIoR4jc/r
         Zs9W+/m4so12xbl60Q1btOsXyX8pfo3DH0Q5j5gUqgAKf/cKpMQjhYls+2BrzRM8E/DC
         //zV2HPpvmXHhKWOrm3wGrC7lfGc6zetSKvhkZz2NZKkhwGMK+whyD7Fc8JgjvGQ+vty
         UOlAkNb58XCZiyyNyqmygjd9RsVfXut97AwcBlRPybMBJxtxUni1gHabhBVQ4Xj8DITz
         XPByiw+Wp5lUiSuafcMZ21/x8uFBPCy1Paer9WHJPJHxoamfxAlpw5SCJSWIMdkSxTYP
         pg7g==
X-Gm-Message-State: AO0yUKW33FTqLbF7JfygYO5OCbz58KE/vsWa6OKH0Rk+lpVVY6OgYST2
        T11PNTSmy7Yi1Lrk9m7OP0y7b/R0TnnU5sFaguc=
X-Google-Smtp-Source: AK7set97vLp9iSAPUj5qvlyj08uqdIw4w48s/tuTbn3yL8WPwSr8drKtrLPNvCyWemjigZcHqZ+h0V6ONlePA9esBW4=
X-Received: by 2002:a05:6870:9121:b0:14c:8198:e971 with SMTP id
 o33-20020a056870912100b0014c8198e971mr165817oae.269.1675250340552; Wed, 01
 Feb 2023 03:19:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:6842:0:b0:49e:bb5a:5f3f with HTTP; Wed, 1 Feb 2023
 03:19:00 -0800 (PST)
Reply-To: khalil588577@gmail.com
From:   Abdul Latif <huntingtonnationalbk@gmail.com>
Date:   Wed, 1 Feb 2023 11:19:00 +0000
Message-ID: <CA+idcZEwJfm5AcgJWewDXk475Tkx5O7-_JvyoJ2fGftM7RsT+Q@mail.gmail.com>
Subject: GET BACK TO ME
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:30 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4908]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [khalil588577[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [huntingtonnationalbk[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mr.Abdul Latif i have something to discuss with you

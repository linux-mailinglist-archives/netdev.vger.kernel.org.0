Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D600A5991B7
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbiHSA1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiHSA1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:27:04 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DFA63F16
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:27:03 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bs25so3460560wrb.2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=zBgp779WqhreJixwzCa1lDAelVYJN0lnI11zJWZf/zQ=;
        b=aghXJta+xN1lq58dOg8AiG9UgxKosMPoHjQWWVm+HaUsAdZRvfzAy4n1/NJrXAXx1H
         Y8p7UuZeH62SRrzemNlq1Uu673u4g+n32KWLQt6VINgLqFO2N1WJ5kL6WjhdbbQALErb
         7jxIws0b0EFYrHx5BbgU5FCnM1vUA7d160xkMeGnok9QND+v4G4WT4uAw/FUv/zF9mC9
         n9kzVa5vMkKWDE3p84B6V3KOq/c59M7prQND7flmtu36q0GvKkYDxzlnIY20cUc9EE+z
         xfcWnk/1lZvRRxyk6EEZX7rHdjxT6dmFt0AhVK3CHBjwU6qFSQYrMu9E6ZQhRchD7EF3
         H3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=zBgp779WqhreJixwzCa1lDAelVYJN0lnI11zJWZf/zQ=;
        b=N/C/rolTmuXiY/j9qjJAevlvz1GIUVN/C1qsns17ZIGgv2ImO76SvgSpqdvgjGhVl4
         I10UIDDhR3RQNct9nBExJveS9d6dIpffghXlh6LL75jJQett2uB7ewCPPVvNJ/NTfk8U
         4CSqwdtYi222+iSZUKYPwjkZ2TlS/nCUt1ftLVhR2Ons7EqEkj6iPe+2OVzAlFVrlvLL
         JQFOGZnGCqVvN+eVg1o4U2JZCpVG6hDlP+39jb7WK1MSYgvdq4AJrJ8hvTwPtQMQf3i+
         2AvGDZmLJLHRPUJKjdUtAFEme8OTMWNkP+QyV+MC6D2hDtirhg3Zon/iIeepc+/YyPZS
         01wQ==
X-Gm-Message-State: ACgBeo1enO40dXpoaMwcBJHYvzDFzovLBy7/Qd03tSFOU96YAqDQlWKN
        b7LPhpLQhWB/+A7lbk4St1gJyPMqQVGcJiOtUiY=
X-Google-Smtp-Source: AA6agR5d0jszbeDLm0f6/WZYaxiE7ZYZgYsgW8T9hIw67i5o50Nht7TYtmSCh1B1m0UmoJeS1S2Uh6mQJUXsepK+Cgk=
X-Received: by 2002:a5d:6501:0:b0:21e:cc1c:ae5b with SMTP id
 x1-20020a5d6501000000b0021ecc1cae5bmr2798725wru.341.1660868822062; Thu, 18
 Aug 2022 17:27:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4346:0:0:0:0:0 with HTTP; Thu, 18 Aug 2022 17:27:01
 -0700 (PDT)
Reply-To: mrs.sophealjonathan@yahoo.com
From:   "Mrs.Sopheal Jonathan" <oumarouilboudo088@gmail.com>
Date:   Thu, 18 Aug 2022 17:27:01 -0700
Message-ID: <CAECznDaToL3YeWMUYe4Poxe_zV=Qrb9A1OTtAN0Ci52o+sq+PQ@mail.gmail.com>
Subject: THIS IS MY WISH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.7 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:42c listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8790]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [oumarouilboudo088[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [oumarouilboudo088[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am a dying woman here in the hospital, i was diagnose as a Cancer
patient over  2 Years ago. I am A business woman how
dealing with Gold Exportation.I Am from Us California
I have a charitable and unfufilment

project that am about to handover to you, if you are interested please
Reply
hope to hear from you.
Regard
Mrs. Sopheia jonathan

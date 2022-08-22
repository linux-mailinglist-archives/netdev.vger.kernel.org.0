Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF83459BC39
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiHVJES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiHVJEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:04:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4E518B1F
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 02:04:16 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 20so9331276plo.10
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 02:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=p9eXFPYaWoUQYd93GZHfKWGzwlV1gqge90LRrpP+sWM=;
        b=OL+MODffpKAcV3zXGVEgGF5U6UzKDQuZEVr8RwjSlzNyarWhrgZqcYxGiuMbUN0eOL
         +35YiCkSP9Z4e88SGQsygFEHQTup96Yw6bHA1/aFAOLV5OI7m0248T32538K5hdNBDf1
         XBQ1c+5uHnGczH0ntzJ3swsMZ6VucXDS3TTqrLsfIMJumUmjBbRLbyV78n1WjJvVGNWD
         7V/d/7+whN7XNIgfXZjUxYOe69ZAghEdEN+KUk4BsuKTZVJnLz2ZGzeHY0Y66uYDkfzL
         6aCRTqnr/83ZH5C9mD63/UNYnPiFtB4fOuZOnfIdslv1mXh9oKK6HsKnZSvSJpHzTk6I
         q/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=p9eXFPYaWoUQYd93GZHfKWGzwlV1gqge90LRrpP+sWM=;
        b=A1pXi9KtbGlu55d+6dthZRZR1OfEp+ns3wST5Q/gi45X1aYgBC+d+NtqytzqtkDErc
         5Q15ChYeLOt3s27fCoY+lym8q4eU7jFP8dZl26t/Qwp0LdDMEJN7c5pHsoKWpxZI4I8Z
         y71LodR2lUGL4AdOTDFTCArrDxTNM3BaqlEhO5LDcNLSsdkwP0DVsW3kCeOb5r0fJTtM
         IW8F16i71Ph7Mkg1U/j2js1DYkUzQmZA6U6eFhfpIQCSIxlCbgXzwVPqZbe7VRuhHPpY
         d/OxnGD5/CKWOa+QftrfVyLcFBJdilZB+pxYj7SI2Q/DNNKpZRnrj1UTcg91GSfF3fKm
         LDFA==
X-Gm-Message-State: ACgBeo2JBlJRCOHqjIxdACkEfVGMVBDMFpyz3N0raQwhEHoECg97+YvY
        Jw3TtMKPkerueEM/YPvtLADZ8o3VNIofdRb48P4=
X-Google-Smtp-Source: AA6agR5516h4x7YW5dZwC2Y7+TqZkgs/oM/3W7qbdLtTeVQvFAQULqtQo/5XA/ebhYn/ylDiMA4QraKv/pd4o9YGdmA=
X-Received: by 2002:a17:90b:1c90:b0:1f8:42dd:9eba with SMTP id
 oo16-20020a17090b1c9000b001f842dd9ebamr28439725pjb.160.1661159055705; Mon, 22
 Aug 2022 02:04:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:4185:b0:43:a6bb:bfcd with HTTP; Mon, 22 Aug 2022
 02:04:14 -0700 (PDT)
Reply-To: lindacliford05@yahoo.com
From:   linsa cliford <linda27cliford@gmail.com>
Date:   Mon, 22 Aug 2022 06:04:14 -0300
Message-ID: <CAKYqKb5BCjF_fbO3tgzRgMwfSmDsRQTNSH3UHA_S0qmW+LoKFg@mail.gmail.com>
Subject: WITH DUE RESPECT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [linda27cliford[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lindacliford05[at]yahoo.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
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

  Drear Love One,

  Good day dear love one my name is miss Lnda Cliford  from cote
d'ivoire please i need your help for fund transfer of 2,500 000 us
dollars  if you  are
willing please get back to me  for  more information thanks and have a
good day,
Waiting to hear from you thanks,

your s Linda Clifford
Regards

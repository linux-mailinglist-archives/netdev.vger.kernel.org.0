Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4AC4DE389
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbiCRVaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238547AbiCRVao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:30:44 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F082614B85F
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:29:24 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id g24so11647435lja.7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=T/YT8jITLgW7f0YnEkkxDYteBnHJRvTOMarDgnnU8jo=;
        b=EEw0FXJGs+GEus6Harc5qnDqDQxJpbyEwqdriPnXPqYbGVk4FGlRk6V+Fpo00ehlq3
         yRS9VrJmYAMw+FHgFHtN51MpN8SiHYLuoy5OEgVQ87q6Av2WuP8e0MJczE1M6Lh8OX8F
         vGBQWTZQcqQ3iIT87Sz7QHDq1z12lV6EN3E5jsMziu36eQb7pjUos3wahaoshycLLawf
         8KD2WhgPdE11APAQz/2NWuyXJ0DQ8dCvI1dT8zH4V46ixQtADNieaSMxE6SSPwR3QrmD
         KFnRXApOeKBBQ57Ayj94677dlESkxO8HHUA4bM6LCm9SDkxyH0olR1qaB5j7MBC4M1n/
         bA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=T/YT8jITLgW7f0YnEkkxDYteBnHJRvTOMarDgnnU8jo=;
        b=7fFyfWMtioFftzV+fsElGt6bPQ8zW/N7RMVm1Cqq4jTpr0QEEXi+ITeres5qM4ky4Y
         dAVEaoMTVrd8wO6H+IH6oz62CX6Gn819TJKk6ryLuoO2xjkO6sHGtHbFN7aNXQPky/By
         g+ToudKMp21ysFHyme3xSJG9xMYk09RWmmCMkMBWFWvRyq5uuhD+jiAj0+ULAjCoyKu7
         tOPgUEswfPOxax8bv6uv7FW7SeukA51azbWPQpUx9kF2vmcBWSCCKr5HYWNsIoDlecQc
         IDDDUb5bOhtjuWFWs29GsJBss7w3c4Lxa95pnk4Rrci2Az8XmZPTg/7po4duQP02od/p
         mIUQ==
X-Gm-Message-State: AOAM533GgKeMMSCs/P3VmTf0ByfnhrPV2jyjIwHb6qrmzA1oso/XoOWu
        v/la44CPKUeUhe3br0qEroaqxta9BllXSinpkEGb4vBwcPKGCXG+mCo=
X-Google-Smtp-Source: ABdhPJxUjihJQUMKJEP1Ynazve66yvk16Gax5CQSBg2OQ1nJxxTOPQS+Tj9Z3vOBWIdEyLRfcbHuSrkkpKBd1GEAqTo=
X-Received: by 2002:a2e:8053:0:b0:23c:fa2a:5d3e with SMTP id
 p19-20020a2e8053000000b0023cfa2a5d3emr7465267ljg.96.1647638963280; Fri, 18
 Mar 2022 14:29:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:402a:b0:199:feb0:3ce7 with HTTP; Fri, 18 Mar 2022
 14:29:22 -0700 (PDT)
Reply-To: clmloans9@gmail.com
From:   MR ANTHONY EDWARD <nillapep@gmail.com>
Date:   Fri, 18 Mar 2022 22:29:22 +0100
Message-ID: <CAHJCGRgFUcO0r-SUXiphn6YoDTaZC5E0inrjQenA15AA7GzXMw@mail.gmail.com>
Subject: SICHERES KREDITANGEBOT BEI 2%
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:232 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4983]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [clmloans9[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nillapep[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Ben=C3=B6tigen Sie ein Gesch=C3=A4ftsdarlehen oder ein Darlehen jeglicher A=
rt?
Wenn ja, kontaktieren Sie uns

*Vollst=C3=A4ndiger Name:
* Ben=C3=B6tigte Menge:
*Leihdauer:
*Handy:
*Land:

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB996697ED
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241553AbjAMNCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241515AbjAMNCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:02:14 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE94190E49
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:46:59 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s3so13569777pfd.12
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7bDIwWVCRlNTvDwsFQzlmS++5tBa1uCLSFWFBYXobMg=;
        b=RcyMgGyDz7ENt3A6b5+DuXjJVRgadWCKjwILajmIYKb1tqdzwpOmy0ecjfv0KiylJ5
         2CxzK0VkI+re5c9q49E9KN5kHcFh0SKGkppFlLY1zbdb2hJtOZXwZLKj9wh/vDMiRhHz
         cgG2Nq7RHvcG8xSstYccx9IfOfJ9FxC3xpntw6J9KhPmmfXTJnCmbwb3AEcXM8KVAQLQ
         AEbhOwYqtE2WbuI3/kG0n/qrFuA4r189VKX8Zlp16yNjORn9nECJODR53WQXHBQY0D02
         D041m+TA/Ie6Jrs86pgv8FYW1NHhFrIcHWg9/WyuF2KWEsA2NaQpMg30h233bX+6XuQl
         AKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7bDIwWVCRlNTvDwsFQzlmS++5tBa1uCLSFWFBYXobMg=;
        b=bIQ9as4iC2Kw6E2BdRwkLNyDljxJgvdCxA7v5CnrcgRUj5QWtbvpSnw84X6Zf6ZgeQ
         XnBXeO/2suiJ/IHHHo6XDaM5tpjVX2RNCOy9Wb6TTM61NGUKay//XrOTDdvZm0fnfr94
         b8DV7hEXK/3PgfB6vYWIF/gQtU5adSA/yD1YmtY+8zUoShhl9FT3K7o6CEVTDL2Pkrxi
         MvikYT4ywHgI2HyY9FOX0TuL4eQ2YO1MiKn408CbgaiMVZtbI4KihvSwta9HyeOke0az
         nh462F40yBxALB2io+QvQpgTKUkKYyI/bMwPziQIlCd99hjQFLcjdngF7UFhzVW8lXI1
         N0yA==
X-Gm-Message-State: AFqh2kqreOcFloKRXmvoojGFSm7JITuGLGbL2A/cWk0Tv94CYa9q6SHW
        iCqN4j6PJuxIWKpIBHdmwrdj9fdCJK8mhGeLlhs=
X-Google-Smtp-Source: AMrXdXsBZx6YMScswXycumdZg5XF/+0WjKRGNBvkgI4IBeEKnT8xernU1Vcn5BaDOWVURhC95fJweYbUaOgF2g6tvYs=
X-Received: by 2002:a05:6a00:2a05:b0:576:5a2a:d6b2 with SMTP id
 ce5-20020a056a002a0500b005765a2ad6b2mr6164473pfb.11.1673614018638; Fri, 13
 Jan 2023 04:46:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:53c5:b0:96:127f:4446 with HTTP; Fri, 13 Jan 2023
 04:46:58 -0800 (PST)
Reply-To: ska.anna794@gmail.com
From:   Anna <judith443.uriah@gmail.com>
Date:   Fri, 13 Jan 2023 13:46:58 +0100
Message-ID: <CAGOAMFqdds2=3NeAyMH51sDemYTd2kWnKzBaMc-Zk_voqvPMxA@mail.gmail.com>
Subject: Hospital
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_60,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:429 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6081]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ska.anna794[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [judith443.uriah[at]gmail.com]
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sincerely,

Dear friend, how are you, I have a charity donation fund that I want
Contribute by helping. Please try to contact me to know more
information. Hereby I will tell you more about myself and my plans
Money when I hear from you.

Waiting for your reply to provide you with more details.

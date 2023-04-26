Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E186EFA98
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbjDZTFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDZTFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:05:31 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B83C39
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:05:27 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-38e9dfa543bso2134876b6e.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682535927; x=1685127927;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=enjYQ1xRKll36ZQBsxot0VcX88RsU4QxjTsmFCXceCM=;
        b=Vxu4FPxOP3vRTMEaPcdiIhBcaS+/7Gygj/rvmwhoaxEPCSTzWbSp5umHOQSD8S3+Tq
         YMcYCAFqFWVyZBHvEN7ZonDRk2KxztUZCvXXWa8fJi8k78shy2/0rrhLj7zSynGVcLM0
         xUbPUOUOSUzPpMFwsKhLmjpnuBxpKRlga4neCk6HIXE4aSQ0vye3bv7m6ZEwjTHC8so/
         +r8dUgDExerynYeEJ98fS+crmBv3gdOilsTkXCEzQPbHha9AFKu7KFJis8MOmb02VEng
         bqhlUVkYS6e+bb9zq+9i9c2Za0gfFh0cTj92r29gxScQO70iuimZVjXhGJ4namGn2B58
         /01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682535927; x=1685127927;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=enjYQ1xRKll36ZQBsxot0VcX88RsU4QxjTsmFCXceCM=;
        b=BlJYuEnXMzS9jp75aKQXIwSqHlIxjOMymCo7MIgsHmgxdl9tTTkrIG8Mjz+x6OC2OI
         5kvGzP63+JNd0x7L89G5Q4vyn+T8470qQM0zpnHRfeofm22/On0wBxN+yaNf5ri5112t
         XaJKTo5NVWER+w5uP9kehTuhNzCXWfapdVHTR/tQwIUntPLE/DW8BrqeKwo3CGBWWC3W
         dGqcckf5ZLyseNYU5QQiHec6n1nUYHCyypZSG0GkYixrxhjc7gABxFLV13Ta0AemHROL
         BGJ5PXHOjPyJZnbKObohZ2eO0NlcQxaimop/CJ3K4VKs+1Tvd43Ju1f+9BIUjVr++G05
         XKgg==
X-Gm-Message-State: AAQBX9dLVGtDDSj0LspLYRbYWFQLsknhymQaWFl6QJFJb2hLKGciG0QQ
        3wduGjrSNxB4DIMeW764Cyn8RiNt5/LIdQk/wgE=
X-Google-Smtp-Source: AKy350Y8780P5zkQDoZGwiXDi6RO5mAHe+AxPZEy2Dab3vv7hWwdA8PFn8G18TAlleazcykjqS0GFRfOD8MV9i4WuGk=
X-Received: by 2002:aca:1012:0:b0:38e:a26a:8e0c with SMTP id
 18-20020aca1012000000b0038ea26a8e0cmr7572488oiq.56.1682535927208; Wed, 26 Apr
 2023 12:05:27 -0700 (PDT)
MIME-Version: 1.0
From:   Cheryl Roger <bestviewdataprovider3@gmail.com>
Date:   Wed, 26 Apr 2023 14:05:15 -0500
Message-ID: <CA+QguCxzn5qGJnbEschbFFpZfH8XxS1VNH_tW4Rh=5WT3Ei5GA@mail.gmail.com>
Subject: RE: NTI Critical Care Exposition Attendees Email List- 2023
To:     Cheryl Roger <bestviewdataprovider3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Would you be interested in acquiring AACN's National Teaching
Institute & Critical Care Exposition Attendees Data List-2023?

List Includes: Company Name, First Name, Last Name, Full Name, Contact
Job Title, Verified Email Address, Website URL, Mailing address, Phone
number, Industry and many more=E2=80=A6

Number of Contacts: 11,429
Cost: $ 1,526

Kind Regards,
Cheryl Roger
Marketing Coordinator

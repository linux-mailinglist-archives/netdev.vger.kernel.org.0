Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96534C2F23
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbiBXPNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235743AbiBXPNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:13:40 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216AE20A956
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 07:13:07 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id i1so1975732plr.2
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 07:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=kR+/1q6XUfazEKNratlM0OWZ82/VxhpJeAa8ChXIJKo=;
        b=XPMhWZ6Uh4pQT/mD0SpI7dSKPws+yObkvY3Nzj+JkGrTepIs2rBrQTWpF774kD0+vz
         Lu5TrV/w8kfOesHIqeznEpc42j1RposZBYMx3+kzDScKvht7sG7GFf+NgoimI5pdcEJz
         qpCusrEyolN9U1gwwpkGZ50u2HP5T/85OwiQVVgK/SCR/ovkjiKbm9g8MJdmNxjvE2s2
         gVmoitYCk1uozF/ypcyHE05x0OMt8AKrX28wVSK9Hc3YUt5A77U4PWbbdqTW5BbwdNs2
         PV/Aj9YWb/Mv1+5MppRb2p8wsts0oAIlL9hUn8NeDOGKLE+5sqpQh8YFsRO4W7f3zJ58
         x4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=kR+/1q6XUfazEKNratlM0OWZ82/VxhpJeAa8ChXIJKo=;
        b=ySeRO7w+7GNFudQ89Neo0fMNgKiJ67askEFuHKvcfmOJEvr9WP7vMm5jsAL1B02rbg
         lIkAmwYbja08PMLILwOHRq9qbSrG0NL1o4aPT4NvrSHjdEp4k1GTb1AMqosc+guUNi0g
         mw+gooB0ljB4YnxyfM8rcNIeQ1+YCjcf/ch1fgeTwLQTiHUKjIC8Z4/N6qgdE0sU7LAS
         tqjrUrHQMSgvWD/E4khgI9UFZl9gL9FRjc3tj7Gdd6vnj47fepllVVwGrsC1tLm/7jYo
         8dQ12OZXhxH97+E/BNtX3ftYAl5wwmSpt8P/hDrsb8hQWprzJ5pTG9WppKdSoFZzixgr
         VsHg==
X-Gm-Message-State: AOAM531euapAipNkpFfKOS0dSSZ4C7bz5lMYqIKKcMWB5DG5S+k31TEr
        3BwlGuho3ZIGsSwIvKFkCJqkE+q2lOvc9cXIiJo=
X-Google-Smtp-Source: ABdhPJwA61fKbMORIWq1pH62Jlh506+pOyeGqdHgdAa0lKXqSt0uAbpbeYhS8oB4tvVPL9RfGJxQV2qmUTiRJSOUtEs=
X-Received: by 2002:a17:902:7205:b0:14c:9586:f9d5 with SMTP id
 ba5-20020a170902720500b0014c9586f9d5mr2966706plb.77.1645715586694; Thu, 24
 Feb 2022 07:13:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:522:18d6:b0:434:899a:6745 with HTTP; Thu, 24 Feb 2022
 07:13:05 -0800 (PST)
Reply-To: jja31jja@zohomail.com
From:   JEONG JEONGHWA <mrrobertskoffi1@gmail.com>
Date:   Thu, 24 Feb 2022 07:13:05 -0800
Message-ID: <CAD-u-WbwXdC_aSdPoWeaURY-vE0RJcTMCuUZdz+=yoebKsyqsw@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.7 required=5.0 tests=ADVANCE_FEE_3_NEW,BAYES_50,
        DEAR_FRIEND,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4471]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrrobertskoffi1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrrobertskoffi1[at]gmail.com]
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.7 ADVANCE_FEE_3_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Dear Friend it was very great to me when I found your profile,i am
very happy to know you. I am DR JEONG JEONGHWA from SOUTH KOREA but
live in Togo , I am a Staff  in  Lome Togo CHU Tokoin (Central
Hospitalier Universitaire) . I have very important issue i want to
discuss with you get back to me as soon as posible also i will like to
know more about you and your job Thank you

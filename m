Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7751B823
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244994AbiEEGqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237878AbiEEGqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:46:11 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EA747063
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 23:42:32 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id r8so3456982oib.5
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 23:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ZEKTenIZ2FZGbVvXbK6R3bSGQKZjKfnDEXc7amdyUIY=;
        b=fh4ULbAdkWT0pwPhcuvkFrDpZeltRkZtuPI5Wj4eWkHkrkQ8ZDaxOySKZw/xnsz8Wp
         ptzD6MJiuyso6GyGMA6qPfG7nfs0ogQ6ksIszUISnX3IIRLic9Cas24LHXqXc5pn4Qpc
         71QAdukbEOUd/4/beO1BAMinTjkBXx2g53pl3Wznq4N33XkY8tMSKnm0WJBl1kFFxNjV
         sj/YAZE3Yon7i0d/jCV28a8/6DqQ5X8bmPXn7F4WHXtkGingwI9/+IL6DpLxmZE970oZ
         V/PGXFcB4r7dUkctC1rtPJ5lvfiDuehlqUKGPCPL/nEGOW/zbM+reTUClcMsL6u3wW+r
         8EMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ZEKTenIZ2FZGbVvXbK6R3bSGQKZjKfnDEXc7amdyUIY=;
        b=ki5ebUqrls0ZluKmC9GJOjlrr8SL+mgiCZ4sXVYjxNpmq15uBk3+gSPdoG9CBQNrXp
         oYdIXUK/axM+KgEpHZg46KU5S8X7jLd9TOQ/LcZ7qKD0Tlguz3Ca+ZxzyFLMUaOzTWNu
         I0+0x72kNhPbToKOKL6HUe9vjJYhi7l1a2of9uc2Kmlb1Dlc+VmFBUh3xBKidJhNotsA
         MhuLaepUERJHGAF54YE9r6RBHqkcxCx/vZUqXnv0CdwpiV+ax8PmyKMFZ1v5ODYwYqrj
         CXdiZA5T9AxUnbXMPzhfydruNUDA3mW+PYY4TGyU7c/bq1g62Dec5FcE37c3IBij7dtw
         FNsw==
X-Gm-Message-State: AOAM5337ldFsWlfsD7a8dgQigRf5CqjsxrST07gNwnYiLVpc79TKCuWr
        hx9pqR/WSbIWHctbRyD9EbOtIDYFd7phR8EI4rQ=
X-Google-Smtp-Source: ABdhPJxLKtoFKiC8lA4LUK9i+cXU7tp69nxTNOZkXX0qTFGvZEzRMMk+LoQj/u0KuMiboQtT5Bdc4mJqWsWr82jqdmo=
X-Received: by 2002:a05:6808:13d3:b0:322:b8f6:45fb with SMTP id
 d19-20020a05680813d300b00322b8f645fbmr1608140oiw.68.1651732952085; Wed, 04
 May 2022 23:42:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:724e:0:0:0:0:0 with HTTP; Wed, 4 May 2022 23:42:31 -0700 (PDT)
Reply-To: mamastar33m@gmail.com
From:   "Mrs. LENNY" <ssbutt07@gmail.com>
Date:   Thu, 5 May 2022 06:42:31 +0000
Message-ID: <CADEVqW2zApwBme2dAZUNG+Rvqi8WzU+NLy9dfKsQWqYMC3GMEQ@mail.gmail.com>
Subject: Please Help me
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:243 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5356]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ssbutt07[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ssbutt07[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 HK_NAME_FM_MR_MRS No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day


With due respect and trust, please exercise a little patience and read
through my letter. I feel quite safe dealing with you in this
important business, you have to believe me and let us work together. I
have a business to discuss with you,  just let me know you received it
and I will tell you more about this 10.6 million business which will
benefit the both of us.

Reply and send this information to me at: mamastar33m@gmail.com

Your full Name.................
Age.......................
Country....................

Thanks and I look forward to reading from you soon.
Warm Regard

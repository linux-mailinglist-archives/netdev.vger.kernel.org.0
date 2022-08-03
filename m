Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3674B588E2D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbiHCODa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238459AbiHCOD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:03:29 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3702B638
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 07:03:28 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r70so12922931iod.10
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 07:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=bXGIJDAG0QTQ0XzeuyQJGjRMFwzwMo1v56Xq876/o4IOViVYVE5+DzXMKaxVk0pP3D
         B+0bxu/cPxLmu/CcPCyIl52NGpXz9EVM36dOEG0aqa3j4XEIescjwVgl8I5qHs8d5GPu
         7UFgQcWv+dabt3k1QHc7HJ+wdxpHL6UEaSouEHdyDbsmYuyHf/1dtfDpfGpClGGLrWSL
         rgQ/muu6d3Qkod27MiC45IJH5iAIORtSlcBh9rIEGv+upa8lCPbxvs4AgGdYbcHxs11c
         VD1iShRiKrKHOkxS0tv13FCFmqslOKHlRqhFeVQ7kzf90M3HDBDx+kxbmFJm0JSLQwKn
         C/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=oBNf1il5pBgXnvGrdp2teL7DgSZacH+d1bJ81ZElZvdhtfnuFes9SbO2VH9PR1rTz3
         oBoF5TMCm+7+HVosrnqDmD0OXSfkqCyxUB7+y+zJnr2HENMDFd5kgqnipg9yjQ9noMLv
         oa1EYDBSZqYNwxdOtG35CLDyTWAs4O2l19LfFCtur73kbd/188C/hrBJ8Z0wZYRRiYhn
         HkqXasQns7QyiWw3MS0WA5yEGRPSGlrCvFVwnYYHJxBvQf0bbn26czZH6HTksdBpvqYb
         uZNU5wmbUP24w9NcfEAXTyMxiEEACMQrIeg2TBgRKcYCvD9Xy5VCTo3+QJ7e3byzIxxG
         /Zkg==
X-Gm-Message-State: AJIora8AOCINaWtm5tO7hxH/4Qq+fc0Surkej46zmvF+mKzRgw+gLs85
        bca0Wk8piDMx+OTB5DOmPIkT3WulEPSD1IalpTE=
X-Google-Smtp-Source: AGRyM1sSIbbJBLUN/Ol8GFA8boziVAySqbvcjpUW3+uHU4yAcsEGPSbrjVvIjhNQi2gpMlbYAnc7yQufsWS0/Orguso=
X-Received: by 2002:a6b:5d1d:0:b0:67b:e426:78a2 with SMTP id
 r29-20020a6b5d1d000000b0067be42678a2mr9163547iob.42.1659535407828; Wed, 03
 Aug 2022 07:03:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6602:2c06:0:0:0:0 with HTTP; Wed, 3 Aug 2022 07:03:27
 -0700 (PDT)
Reply-To: biksusan825@gmail.com
From:   Susan Bikarm <bikarm033@gmail.com>
Date:   Wed, 3 Aug 2022 07:03:27 -0700
Message-ID: <CA+w3s0qDQWM4B3yiV5u-4fzYue9B51YkLHKRUzV1AS0ksbHLyw@mail.gmail.com>
Subject: Waiting to hear from you
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d2e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bikarm033[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [biksusan825[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [bikarm033[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan

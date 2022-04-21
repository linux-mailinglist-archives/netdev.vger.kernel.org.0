Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186C5509DB1
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388401AbiDUKcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388398AbiDUKcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:32:48 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C249FFEE
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:29:58 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id z8so5161326oix.3
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=J+KIl1e3y91rMXMpUk5IiGWIs7jVHadid23YQSMkgLNqjxzmrAUBpAUmgg2gkgJaDz
         WfXWu9Mfu+QgwvP5fA05is6ExQCn4OvuyrOJ47eoxZR2gH1QfE/66OJzDlpqBAFIEiec
         ZnuO2Bw635wWQDU9P+pEoOB45crOtW6F4URyEKgAWerZ1NQElVrJSuHE9URCXzm6K2ux
         lMCRS7DbvuRRo1vxeul0VvA2ZRpVkGLHin3/5Ji1uptKTEsyOcq/8JttujvwfZSM9IDL
         JB2/0SRqOmAAa91myq0UBZnJSXUEAZ+kTHa5DTSro0v1rBcEBVjOZjcRBEMnp/GD5Od1
         yrng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=kYU0d7A8YDujHpXusbfwxOKxEaUMuYixXclahUH3YwI8Rb6dLSF6ifu+uWfgdM/OXV
         V1N5F9RaouWUwZGlkS0xuMJcP+9naTwnejpnA/58JWl8b0sdgr9mVBFyv+6v/j0e9QXy
         hQ0evNQ+6ikYOS1LKjg0/XWGJxr1mwAVFpznfDm4I/J8jQVDWxevycrmHLwrf2oEebXd
         imBgmSH2zd0myLu2jCDSDKhEqOqZvYVxpcMtgJmPgJM39tOr1IlhaEmkYWQ6pjoehl3E
         LEIu6RtcYpT756LN9CU24PBhNPw78yq2SZlFeUFz/UvE/+vpLk29KJY/DVaqrPxAC5oD
         Za6w==
X-Gm-Message-State: AOAM531pHTuuZ0VJMqmY3zikAg+EfqqHSI4y2dedJGUNYUY9CB0Z3Qc6
        28EkldImkcTDLqeOcM/YcR8oFJCVR72qnj9PYlI=
X-Google-Smtp-Source: ABdhPJzWiIIEjKnEzSWpcyM//MBECAczKWAQaIxekA0sRqiew4ewSTEl2mIQUcXUDlTrh/j4j/ep5JRZhdh7dzYrfHE=
X-Received: by 2002:a05:6808:1592:b0:2d9:fd1a:1a69 with SMTP id
 t18-20020a056808159200b002d9fd1a1a69mr3929292oiw.110.1650536998119; Thu, 21
 Apr 2022 03:29:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:5f09:0:0:0:0 with HTTP; Thu, 21 Apr 2022 03:29:57
 -0700 (PDT)
Reply-To: jub47823@gmail.com
From:   Julian Bikarm <micheladanlessome@gmail.com>
Date:   Thu, 21 Apr 2022 10:29:57 +0000
Message-ID: <CAJFV=6CPrsn+Pgu4OkOF162usih=DJFDisHtCNCkk8AhC-LrQw@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
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

Julian

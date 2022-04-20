Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F745084C0
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377152AbiDTJVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359423AbiDTJVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:21:44 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EAA3DA6A
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:18:58 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id y129so776671qkb.2
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=bhX8qiMMZSDn17ZnOYGqng/FOi+v6OpJrz6Bj69PtGxpbAsfvmK7c1YUmFKKphVLQj
         NTSvSE7wufuo2I9n8opRbHRcnRVYmc4BNbfDE+URas6t8ODFJClMOj8Wm9RupxSAz75p
         tSOheH5xVeBxHaIeUQ/WjD/BsSdV2/DxYah1Cilya/hdlVb43ilz/LfVSrFKaqsFo5vW
         v2MuJaV3sZ3uIwvh/9r7+Ay0vAuFRqPs+v7oNfYxuy59DnXux7FJKkwC6KT+5WjmRDk5
         j5Wae7PscZ68nvNunPkzeJrR9VtaavWOZ0W/dNFvc1vKLsCuFyYYIVu7l2n4KFLzev7U
         QNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=drd44EIofF2TogBndd98HMwDEc6BtqoVCr9tcROaIR/C5dXH+RdNC29l3hHoa2iZae
         +wcmgPhZQwBGEmVtcmQuDifjsn690zw36AL6GbVW0gW6Z4DL8tuppDmajmTbhj7jT7QK
         4bO1HodjNkmxncegFgWhMQ9rf9qQY+m4HYjoHqfGGN20z8oIT3IedvQGoXV0N+sZztAZ
         cF1ZBYfjLH8lav2maICB42iSu8p61mi9/HhwUMxMGT3y3dRM9kPXG4AtFMC3hcwtxkJd
         UQmFPlYB3yBAoUofVyMzisqaEOfgC71eGbeQQHwohK5z3CADMWi3NwXw+HSqH9kxR8xX
         lDJQ==
X-Gm-Message-State: AOAM533ieV5ULnTRqOYl7+IhiApOmM9Y3VCL3FAzLXXgJCLx7OnH0f8t
        VDdgS6iiFvJ4PvD8TYXFO0FxePzAQYgpWiAf9w==
X-Google-Smtp-Source: ABdhPJydfI4tCwFtiCkK7PqtQh/J7KO04ISgk+Dl641KRAT3p/7/0wBFPMaGoCLUtkd9E4wEIrgNEdXonVtuY4wkVj4=
X-Received: by 2002:a05:620a:4156:b0:69e:cb23:8b03 with SMTP id
 k22-20020a05620a415600b0069ecb238b03mr3408814qko.444.1650446338067; Wed, 20
 Apr 2022 02:18:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:622a:48e:0:0:0:0 with HTTP; Wed, 20 Apr 2022 02:18:57
 -0700 (PDT)
Reply-To: jub47823@gmail.com
From:   Julian Bikarm <philippesbilibri@gmail.com>
Date:   Wed, 20 Apr 2022 09:18:57 +0000
Message-ID: <CA+j1esP0J_8KtripJt8nS9cjRMbe9bUq_hNqri7L5pM=aakJoQ@mail.gmail.com>
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

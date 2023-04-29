Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5E6F2478
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 13:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjD2LkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 07:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjD2LkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 07:40:03 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04679BC
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 04:40:03 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-42e20e8405bso321274137.0
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 04:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682768402; x=1685360402;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPER73ryVVRTIjMIzOcJeLz+gA3jNhcxkGDLzNMgB8U=;
        b=or3CAZQNoR0SuJkJ2J7ow17h4Jhx3Z6X08Wq5pJWVJkq5ZP5io267UfqRIJhNwisry
         XO/phuCxIy0W0A6FQCNwW+JSj3o9autl6UZXos3ZhM9m6+jyMYgn+yI5UqxUUir3TTav
         kSVp7gLjQMs5xIDvj18RkF+a1qdq84NSWodZXPHP33fLlRHMmLtATX3F23DB1HT9Cor/
         ksUDHGcwJJePbq6rsxmWhdS6Pah3T3lILceoo2IVCZvSNuRTnNZrxaVDUk0u3Z82DK7Z
         eGuKdJSkmVd9qeNksqg+oSl0dkWVBZZ7eT2sMfMQrSyypVgYXmY4DnGSf8ROnX6xhCgy
         zARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682768402; x=1685360402;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPER73ryVVRTIjMIzOcJeLz+gA3jNhcxkGDLzNMgB8U=;
        b=BTTtZMgw/oP7zc3TO0woT/lWn6mVAhBDuEy27P1tzLpJGABV9LTyx4SA9fNZ0KdWmn
         HLeKqWyQJsMFDmgvU3XqycWekVuvofO2bN6aQQEACqHrXwLPpX56k2e7TGDi79CBKkXJ
         2Uf3C6xQz4YO94GP6jzIOBsFpieusCMIRcPFhdOOno33owRbiL49wQqABZyVfCUWEwyC
         kiPNaLmgMx2ccGrhdKzoD/1z3+3ceyTPdm0Fi5Jr7qXNm1opH5ThVD65k1V9s1WWrycw
         ie0XwZwhKPRht05pWnBztLzEo1jp4MxASOuOtWEAXboDtEUxpkjDZagpefJVZjMbmg0I
         hU6A==
X-Gm-Message-State: AC+VfDxocpo5Ue6KQSfO4m7XmqjhJ44XdX6ymA+zB3MZ7okbJsndQwSK
        ChVTQ/6xfkXlZggtD6zndbhzjQ+RqN7Kpjp+xmg=
X-Google-Smtp-Source: ACHHUZ4r+H2IBmZkLHMCk261hYHwhLd97ANEX4DyQYBt4WlHvz2Jlc9OcoJkXoyJV0BDign2cMthuTSVs5ZYNoX4f3I=
X-Received: by 2002:a67:f646:0:b0:430:16c1:4d8 with SMTP id
 u6-20020a67f646000000b0043016c104d8mr3803558vso.25.1682768401928; Sat, 29 Apr
 2023 04:40:01 -0700 (PDT)
MIME-Version: 1.0
Sender: mastergassol@gmail.com
Received: by 2002:ab0:7c4c:0:b0:779:1141:e6e2 with HTTP; Sat, 29 Apr 2023
 04:40:01 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher001@gmail.com>
Date:   Sat, 29 Apr 2023 05:40:01 -0600
X-Google-Sender-Auth: 6YirKkbhBhze8LF0gBxzvjoOrbU
Message-ID: <CAHTKmojkvjS2yjdKt2PYSV+9m07W1tF_oHMqvB0+LFMfGgAkeQ@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_NAME_FM_MR_MRS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Regards.

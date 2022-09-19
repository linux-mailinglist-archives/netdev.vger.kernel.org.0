Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED75BD75B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiISWdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiISWdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:33:17 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5854F646
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:33:16 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id j7so1094039vsr.13
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=eWguYYbcnqR7kUrMiFUz4VNtT5lnhmS8b34DhqmSR/c=;
        b=hfUlpEQ7qmMdmAcmrPMb+6uN2WsyFhMyaHjHAddLTORLaCsaC8mPjPabXg30xvHWIp
         bCzv7NbPdNmhSvYaXAgIZQSQDQhR8mMb1vXZk2rXu5xxvkkM36HNSO8Hya1Sl38DV/l+
         p43p2dRn40XAENTLqQ2G8Aw/oxDZTOE5OZay0dVJmR1ArSR+J+PR3CtVl9H9uT6K979+
         wKRmmqIXG8qQ2Hr7e2gQI69hoRZjCQuK51jmkc9LbtLHTfBIq4a341Y8q8eWAuXVnePF
         bOwdR54DsCo5U4t40bg3GpWQuTu0PMrHuYvF0/BYSaZwH5p28VYJUoKdiqBc1B+MzTYb
         JzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eWguYYbcnqR7kUrMiFUz4VNtT5lnhmS8b34DhqmSR/c=;
        b=X3uYIb/ZMlGmkO+wEV6npXf2iIyw97IY03P3pG/scguIuRl/N7eiA+KyIKRVNHAY2e
         Nj5m4v8kv5iNj23/SrGqeqUQmjysRL9Watq8ZzI4j5Mk6b37EQuc0L/HqwOZs8MD3ITj
         bzMsZjBnKhL08SQZDPAoVfwN0+rxYKgrjW6H4txOeWsjT4/l4m0v/0n8/fbckrhWY3Zy
         SJhL2bKFzqhe9UxPddRwDCHhcP+AdIU1JcxXPEjBrXup/O3IXTaAzuhi4VrRUszHcbXd
         kPxWPX9PBAeLmSUWoVDZGlmd1eM+dDDxH3oKtlk8+jMJm60S2sYUaImUNPC2AtxRsxQ4
         Su+Q==
X-Gm-Message-State: ACrzQf22fqnvuMX5oR7VAsixFgGib3wKypum6E2ZIjgZ8c8asf9rUhUP
        luCq58AI6F5u0ZSMz4UGGo/TxHd41pCl2E/hHTo=
X-Google-Smtp-Source: AMsMyM6PsNLLCaH6tVUpbdrewURnvtB07znFA0UoiVxMgW1HXug3cRLWo9UT1WiqJVtK0iz4DZOs6pTeSSG2CunYST8=
X-Received: by 2002:a67:e197:0:b0:398:16c1:430a with SMTP id
 e23-20020a67e197000000b0039816c1430amr3086522vsl.62.1663626795687; Mon, 19
 Sep 2022 15:33:15 -0700 (PDT)
MIME-Version: 1.0
Sender: ric485454@gmail.com
Received: by 2002:a59:c52d:0:b0:2f5:fee4:b4f9 with HTTP; Mon, 19 Sep 2022
 15:33:15 -0700 (PDT)
From:   Richard James <damianjohn6016@gmail.com>
Date:   Mon, 19 Sep 2022 22:33:15 +0000
X-Google-Sender-Auth: OJ8djiNVARtlNpYg0aVIRe-Ppuo
Message-ID: <CANH_S3-c-ZbQTC5GZmD4v8wW7sgvdhYfJfBjBoNFmdVHK=KQ=g@mail.gmail.com>
Subject: Nice
To:     ric485454 <ric485454@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
My dear,

Excellent day to you, trust this mail finds you in good health? Could
you please reply back to me if you receive this email, i have
important information to share with you.

Sincerely,
John Damian

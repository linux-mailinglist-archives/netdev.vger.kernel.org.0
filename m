Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F098B5BBBFB
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 07:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiIRFG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 01:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIRFG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 01:06:58 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1579B26114
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 22:06:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e17so36821307edc.5
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 22:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=kFnzhGGcxC/Bh+BFC9IVquqFYsE3kbWmLtZgFQNXNtYOxe/BIB2jm+yvj19+4TAQ7D
         KrVWyIQ6L57zIvhwgD3YdKOmN0x2+2APkyTnCI6d34P5CJwkmwAe83BIySEAfI7kVNb3
         3rx5gRPHO3u5EybQHVDPQvksXkJP6HVhZHnsVx/dr7UJ38upRqxMs6YWkTHvqf/tTxH3
         YbYhs//7zW67tXhxKVBlJgcAy88amFZQAN8AgqZ6I+sNZ7Zbcekv5XntONqJWBL3pJM4
         OPUwE3YvdIf8McwkyGMXtsK2DCSjej4jUT1dUzv1QnA9GssIFPHRXe+FwrJTfFJeWUm9
         oftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=7Hf77ymskeO3khX026miqS77wKyDLqMZA2cNvDDywJ2ncKZTT+OD63JNONjacicwdd
         3MYjNp0wYmFx3p4AKZ4iC0swaphD05F4exPPUo/T6Wn8NufyEAR1RNopRBOhy2wCHJO7
         UsLauyfktiKNc8+fX5I30P6RSxXtiLxqgviz35ytfA/lUJGWI+q0biqtzfALHZTl8yRy
         5J/wdmxVhaHrAfH97WUDgeJPzA/v9BnFSoU8RWZTBUZO3K4kEZXRZGdKiTtIs/wARgeF
         8u4ao2pVpiOFwHhyh7PT1Gl17SgZHHeV8TBR17GyicvDztVvDHM5i1XzEbkUC7hphNTk
         An7Q==
X-Gm-Message-State: ACrzQf0wj0FOr81qGkbK8VjPbTO8svygChTHh4FwqMu/NV3jfEgS8Ltw
        YuabApL1KCaeX9fX8rZ1wYD1r4ph+H9RIsYKzpiDC19wAJI=
X-Google-Smtp-Source: AMsMyM7x/oCZFMn/ZTFamHq5cmAkNRuwaoICQHWlLKKA2BprWtFizkNZcVlYVQJzbPx54Iqwk3NNKim1PowBkW9N118=
X-Received: by 2002:aa7:c90e:0:b0:44e:b410:b1d5 with SMTP id
 b14-20020aa7c90e000000b0044eb410b1d5mr10292222edt.359.1663477615578; Sat, 17
 Sep 2022 22:06:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:49d:0:b0:1d8:9ed7:a097 with HTTP; Sat, 17 Sep 2022
 22:06:55 -0700 (PDT)
Reply-To: maryalbertt00045@gmail.com
From:   Mary Albert <edithbrown047@gmail.com>
Date:   Sun, 18 Sep 2022 06:06:55 +0100
Message-ID: <CAFM-KKa5B6hz+stXrrTwADEvn6erfRDb69QBMCsrF8CFeBc-bA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:535 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4856]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [edithbrown047[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [edithbrown047[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [maryalbertt00045[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
how are you?

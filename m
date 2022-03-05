Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690294CE37F
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 08:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiCEHvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 02:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiCEHvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 02:51:22 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5C14FC61
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 23:50:32 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id f8so13447145edf.10
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 23:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=8Ztj7EWQ5t5f1IAnCCOuXDpfbxmiXcehQ7Ei8yvyqMM=;
        b=q53UOAwYJjg7NLhUIJDT/dRTsMi3YY00YZ2N2xZoZzYDRjyKD9mNW0O1ugZVLFJ0dF
         rbBBAizvUIBV3aqOJ3LbNZUUp6FyrXlH2WINmwLBJa5fFV96b9RSlAAYH6Ej93jti/ES
         JpWw5klGP4ZOc+oVKJdEA9MVx6wKtA0fFHW23QOIPy9MV/0RBJ3sfNoQpvRRzHyFniiM
         qABMKHFuoCSJ//keMWcpp83oGSVDImjiBivg52wLz2ISx/rzuLQmjWb+YMPA5h5rHqPq
         hulps69C6EgNSmBDx6V295NtwObPUb5bztcWe4kepL22dPDdxrN4E5lu84xC/KIYYNKr
         fRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=8Ztj7EWQ5t5f1IAnCCOuXDpfbxmiXcehQ7Ei8yvyqMM=;
        b=GaoebsuIagEw8vDaMfErihxOXuFBb1JKYZYWaXuWQgYYWhJX2mfZOI0vqZ4HHEYFoe
         pcVmzytirIukxn8cxd76d0Jx+Nnj858mtMhbxWz8f345AzTaKzIF9fWS+hZCcg9Wzwre
         bBNW7Yatn7uCfqjB4UfrdENPy0Kkmj7yJa9l3aaH8vNK6x+YkXEWnPopBv/6jVN3nHCO
         WwndkbzP2oZvdfrY3dlT1y8axLRPnRLTwa+UKv6pS7qCJzBY0QmleqxV4ZlZbR1fW0z1
         uTlbnNjaXkO3pCp4dhj6/19U1ybe9ELz/6eZZQJtvaVrHZ98w14zGc5SOrUigkWJpOKz
         5grQ==
X-Gm-Message-State: AOAM531zqWale0X4yjWl2WjYMR4/6vPo5XwPg2vGO1YGD17BUH2nrUig
        ta8F5zqPQv8ye8/LrLYSVzpU6sCvVv8ErHCjkUM=
X-Google-Smtp-Source: ABdhPJwIs5BDv2uE2+l81tfiByaCr4XvW4zUmbX8egD7Va9whQzDECcrEARhf4pNb0WhGC9zOUZxVdzct0tes7fRUqw=
X-Received: by 2002:a05:6402:294b:b0:413:d1e5:884e with SMTP id
 ed11-20020a056402294b00b00413d1e5884emr2011468edb.4.1646466631116; Fri, 04
 Mar 2022 23:50:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:3d94:0:0:0:0 with HTTP; Fri, 4 Mar 2022 23:50:30
 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <drwilliam48@gmail.com>
Date:   Fri, 4 Mar 2022 23:50:30 -0800
Message-ID: <CAFd1zB0508d7iKZnUjEjPno4tbv+gr1A=NtcW5HcHKUuwD_=1g@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:541 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [drwilliam48[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [drwilliam48[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
My name is Dr Ava Smith from United States.I am a French and American national
(dual)living in the U.S and sometimes in the U.K for the Purpose of Work.
I hope you consider my friend request and consider me worthy to be your friend.
I will share some of my pics and more details about my self when i get
your response
Thanks
With love
Ava

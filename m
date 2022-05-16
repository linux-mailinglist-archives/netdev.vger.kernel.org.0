Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092E35285F9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbiEPNwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiEPNvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:51:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E78B39171
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:51:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t11-20020a17090a6a0b00b001df6f318a8bso1355748pjj.4
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=goOJzuLgIxMTCzBVVyjbxao2+sLkllMXvzNjggwwrGw=;
        b=FtAPe8bszC40W6sVBh7Cm5/yBQ9SZFD+aX1UvQWJOGOzy4THrNPzeN3yDO9w5MOJbQ
         6A/GYxlDcUejy6k/uG85Dwnv623jT+Mlf+KeslsjjjcT9AVJLJxEOg/N521Md8YJ+p83
         5lL/0rI829k+w34m8AhR+jaawMQNBRHKAxdUCz1Ox4nfEzU8vpnKs9E2LxgfCf0neDht
         5C5jXRCKmKZVKUfdTCYE3ST7yJ0FP65TAXxcLbFkLtRZinNaEtSML8zThh4Sc8ieuLZp
         NiAytEsjutWqujc45m8Dg43tC0/L5F794cBRg5/Pn+sWYk0eWs8v2fZBuWCTkFrkDWB0
         oKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=goOJzuLgIxMTCzBVVyjbxao2+sLkllMXvzNjggwwrGw=;
        b=reWNl7JiWVl7lvWaoRVPYM7KxRHASr8YaTRTmlO74IAH8KwKCUTujDUqhBfK/Z7KHg
         qg/ZM18PZHubBpxOqL4x23n1DpU5DswipjPArDgufjvmAydPK5n9brgTsBRr0T1Em3vG
         qlY6jk+S4Y7fscmbtCMDAH9uCWxMrdC4dHTRAijWU+il39Bd7JKKuZZIjD/85kY8jYgX
         gRdXDJUGkVu7xBEi60cHf2BHLK5M2Kz+yg+ECUEb535sy0RJXSeteEHKP+nfFRPW1qPK
         rrzZpBR2ygq2M6QoT1Wy21wA+u5BWd3F/BqdQe2KZ1FYo2xAvfNPbwQYCqydG4f3AAhM
         JeXA==
X-Gm-Message-State: AOAM532AEj6pRjXLz0KCMlCR+AiH//WFizKd5XjKGrcqmna0NFyQlJYg
        Fz0tqUMYcFjoEp1SjO+A8imijjj8APREYbdsIOg=
X-Google-Smtp-Source: ABdhPJzpVBwErRVKNOcnwnTBF5FKBHZlfjiUA5u3NgBu19LDyPf1+xebcFEbBoxBTyS/VMiX62u8Al15Xyi0hkaRkmY=
X-Received: by 2002:a17:902:a502:b0:151:8289:b19 with SMTP id
 s2-20020a170902a50200b0015182890b19mr17728818plq.149.1652709089947; Mon, 16
 May 2022 06:51:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:4d0e:0:0:0:0 with HTTP; Mon, 16 May 2022 06:51:29
 -0700 (PDT)
Reply-To: kofa19god73@gmail.com
From:   "Barr. God Kofi" <kofa90god73@gmail.com>
Date:   Mon, 16 May 2022 06:51:29 -0700
Message-ID: <CA+unpymssYs=bOTY0pB5gvSfHH8c4u3q1qEfgkwQ3A7yrOHkBA@mail.gmail.com>
Subject: Re;
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1036 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kofa90god73[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [kofa19god73[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [kofa90god73[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello' Greeting, my dear beloved friend.

How are you doing today? Hope, all is fine with your families. I
contacted you for more cooperative in my legal contact with your
positive respond.

And I have an important and legal detail form, which I have to advise
to you, to handle and share in benefit with you to discuss and share
with your love good sincere understanding mail.

Your, positive and hug respond for more legal procedures and apply
good conduct information.

Best, Regards...

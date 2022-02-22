Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310AE4BF820
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiBVMll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiBVMlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:41:40 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CC210CF33
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:41:15 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id q9so15476680vsg.2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=xVJHepNq93ePmAbCv1LHbdOWJcqWYQh8v11fr0KUdVw=;
        b=PXjAo8RxFH946aQr3yFxDcQGou/dh0qvlQVqNsvzFixiDKj4uGdeiG7WmDwuxv9tAf
         GCz90MLOWYyZ4O/6SW0oXE5pO7C/OFtPbwRVyFK5h+K+KuMZTRd9fVSGCXycLdK/EiaP
         kcn3MarN0JdNIuvuOXn8UoABdZAmqXZ+anaN+h1eTVjxo6AW3mbYbd7XGw0y1LfivPuX
         wQEYNF2MVL/Ke4WKC1bLeLsZ37pMPv9T1IFkebXlAls2wh192+yTfFptvM9YhzW6btdA
         AKRLXQah9brGCuSmOzNuZjPSSk1jDSp9E22KWS8wcVWF8rsiD+faEgtiGC/hBO37Qfpw
         PcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=xVJHepNq93ePmAbCv1LHbdOWJcqWYQh8v11fr0KUdVw=;
        b=LC0Bqza1grAlbzi3AHTvApIKLRFyLutshHw8DAceriN67pZ2lq7NKV4K0nBTaI9tUu
         Zr87B0J84lNYE9svbozoBewnO0OEuNm9JRxDH55F6w8wKYYQPlhx5meq/xecUIcE9SzV
         q6AQLu3pjlQxGYVurXmRkwB+FyY25HGJ+57eaIabeS/36HwH5kcAMBG5sibimYUzUxqh
         eHGL7iQeAluDVhRKnBa5xebQd7EycwdPxl4FplaQ/dmZ/hHj9bFcflfTYjITM9vLK7g1
         OD49foGHzRbDc6bQlSlcEBNtK3qsYv+lJZ/k55NKGbZonNZ+dCtEm9DT8umRUmr7uAJC
         NO/w==
X-Gm-Message-State: AOAM5334ChWrvKT0FcEZ6C6Otk9SUj/M7GxcPoJUerGw2S+lxhnspv8s
        QBTxB7tI6i6ffNk2wL4qzgcCrYkOOfRwp0sn+5Q=
X-Google-Smtp-Source: ABdhPJzOK3RXM+EjGqFroINskMvT0soUhoe+orvh9eWmk84emJUhJ0Xk0rWF8YYZCYoTJ1P0hRR62wLS7O/i0Pbz6t4=
X-Received: by 2002:a05:6102:3087:b0:31b:483e:d508 with SMTP id
 l7-20020a056102308700b0031b483ed508mr9698624vsb.44.1645533673503; Tue, 22 Feb
 2022 04:41:13 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:690d:0:0:0:0:0 with HTTP; Tue, 22 Feb 2022 04:41:11
 -0800 (PST)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <safiyatuhammajjulde@gmail.com>
Date:   Tue, 22 Feb 2022 04:41:11 -0800
Message-ID: <CAE_8quBk3mm5ynqr2AM4FwvM81H63ejXZnfWZtuOJ8FjFWvPoA@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4737]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lilywilliam989[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [safiyatuhammajjulde[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi Dear,

My name is Lily William, I am from the United States of America. It's my
pleasure to contact you for a new and special friendship. I will be glad to
see your reply so we can get to know each other better.

Yours
Lily

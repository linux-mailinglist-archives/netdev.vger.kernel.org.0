Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130A45BAC22
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiIPLPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiIPLPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 07:15:02 -0400
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E550A2F017
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 04:15:00 -0700 (PDT)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-3321c2a8d4cso255816117b3.5
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 04:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=NXQOMjASUDRmi+uu1tqKKn/W7wXdpQKgIoLNIi5MmvY=;
        b=UTO8xNmtdZ7JCIINazK2Q6vHhfjlhzvS7/SGj8DrTugy6ZMdqNN5MF8cKzVimRAVZ+
         pHB9SocsACwRYXuYCQHlBUgQnSPooc2XpfYEvtuWbRLglrko7YyJNHPthif2EN/T3eUt
         QcYB/uLYMHuJd1R79/frG0OusxuQ6RXZXGgxNeOUtSF92MTvyrZJCgUEIy5WYAX56xY+
         zJdw2u+W8sLVIMIjyWohR7KeQqztU7ByMTehCfwMjx/655BfkMevdH7R8DH6tc2cVp/C
         eCVXBJs1V3vzTOGeaaMYeSw8j15/3eolbLVou1h3zKyxLt7fBNeVcZEEbvzbmMaoD8w3
         yDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NXQOMjASUDRmi+uu1tqKKn/W7wXdpQKgIoLNIi5MmvY=;
        b=xep4CCDKQ8OntQp1RBsirwK1OxwdGjShfKWhO2BqdRG8fNMYI4xGG9/C92jhGbbSgm
         RzUye+EPvbfzYEcBvGXj0+7CZVszdaIbR2CGKUOD5ChLTntJ4iDBJpWT1NZoKoH4/xDX
         x66X8dofs55LZON5AKXioHILjUdb9/A2Inolx3RyMCYOTpuqTxR2MSMy0LKCftqQk3cL
         X4iRH2+eJH11nnlMxtpd6ocpQfKpBKbDucUs//rjlnvjEokQSkT/B06RY3UjPh7TkqxN
         5Py6ClrnAzHPsWn/rDCrmrl5dARbHHYRisMuqtv+4ckAo4DJph7iyxqo/74ukNihzY8Y
         4Sfw==
X-Gm-Message-State: ACrzQf0ibUume3XaQ0jxZ7ZzEsUR0PW4QifiBySMdzW7liMjlaVUbH93
        zN8CtTrK0oY+qb7bffN6MrUalrvPUXGiTgu/UKI=
X-Google-Smtp-Source: AMsMyM6Dj0y9YczMdzi4HSPqSCtueWq7dvUqya8VRYZ4G8SGhjIYnZ6C+cfO71G7kT8vXqD8YBVetjJefwhJxl/L4h0=
X-Received: by 2002:a0d:e946:0:b0:345:696:caaa with SMTP id
 s67-20020a0de946000000b003450696caaamr3835315ywe.507.1663326899638; Fri, 16
 Sep 2022 04:14:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: rkamara999@gmail.com
Sender: mn5562461@gmail.com
Received: by 2002:a05:7010:a521:b0:2ef:b330:88d6 with HTTP; Fri, 16 Sep 2022
 04:14:59 -0700 (PDT)
From:   Raphael Kamara <rkamara303@gmail.com>
Date:   Fri, 16 Sep 2022 13:14:59 +0200
X-Google-Sender-Auth: 0gwTzJ12S3cCtIMujEPdXyY5JTY
Message-ID: <CANW=vWBKxjU+tE36qaqJaQDWBfH2GxzxytMjq2SzStVL8gYLbQ@mail.gmail.com>
Subject: Regards.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1143 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mn5562461[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [rkamara999[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mn5562461[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello

Good day to you. Please, I have something important to discuss with you.

Response urgently for more details.

Regards.
Raphael Kamara

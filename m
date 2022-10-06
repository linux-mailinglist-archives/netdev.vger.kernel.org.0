Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4A45F61CE
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 09:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiJFHlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 03:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiJFHlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 03:41:06 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4232A8E475
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 00:41:04 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so454425wmb.0
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 00:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yuT2bQjVMYKIakcPwDE9EUAdiNrd5QJm9ZXzgA75P4k=;
        b=IMqQuOHCF8BymhO3Sm1M4J7c7uhsGvrmNCXZiQIJ/e+8XmunJmNKa+ZCgVsY0H+bpE
         MZykzrmeB5PauMX1AK30bDTHv7jfhIuAynIZmuPtociBRtM5L6ZWU7b+MIPwy3O6oGRy
         wc7RjdYONoB+YOQvVkM4t4C3miQ91N7IyqGpbdN6TFhheupIpFh3y0voyOP7auUnb3hc
         RpY9W/k6My6QxBCp9xPq3ra3CAspLai9xJZeXpQKJU8RKOkIcGvrKgmbJ7Hp5Trt7Df1
         IqvSAPo/8Xc4yOGeB9OYux95rD5DHl1O/T/hkPDHyPLWQTGI+uAgwP1Ctp1A8Dzuy+Zg
         Sz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuT2bQjVMYKIakcPwDE9EUAdiNrd5QJm9ZXzgA75P4k=;
        b=yKOsYpUK+v3ip/wMSnwO1HbIckWGABWygTAmacw2JrYScBSz0ObFpKI6u2PlvawA3r
         Ag+GBCgE71wJwIR+V1drxOQrV0FlNCNc4f9vYlQxaLF3l+cCK5tfVgbI96euodHGyGq6
         bLjHrniNnO3meRxn81nEwO83EdV+algHpRAJW0vzcKeb2y6yqyd3yK7MZKId1Em3Alvh
         c/LxDNMj73WsKEHcNZ12NpXOYmB/rarIiJkQHFx69kysKA9ZOwz9JPPOCwfDC9plpUNm
         aIk9wjYzv6087T+KRu1yb62gIZyZopMJnQo/5cBprdhxiCRNvIeTICci6px805XbOSP6
         QaJA==
X-Gm-Message-State: ACrzQf1rOhy/oBrk1bt8FG/2LPWW9WBWVV0RZegP22J13oqxf9lV+BGQ
        OU/23s/lN4zDps3l4EMkU5CF/0+YVRlugux9Luc=
X-Google-Smtp-Source: AMsMyM5XE/oikeNkRYScyCryb6zZhurjywkgEtPL2FfpRLZUKU8Ab7QOid40/U0NXXh6AS3n9yiRpBHpLDwOgJFvzto=
X-Received: by 2002:a05:600c:1e16:b0:3c2:192e:27fb with SMTP id
 ay22-20020a05600c1e1600b003c2192e27fbmr396025wmb.122.1665042062422; Thu, 06
 Oct 2022 00:41:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:fb84:0:0:0:0:0 with HTTP; Thu, 6 Oct 2022 00:41:01 -0700 (PDT)
Reply-To: jeffreymarkusimmigration773@gmail.com
From:   Jeffrey Mark <adamusani7044@gmail.com>
Date:   Thu, 6 Oct 2022 00:41:01 -0700
Message-ID: <CACiLxEXXcM1D7a-HnBREbSJM8wAy8P5vgLCKAatoD=MmowmWyA@mail.gmail.com>
Subject: Halo
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:331 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4994]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adamusani7044[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adamusani7044[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jeffreymarkusimmigration773[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
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
Halo, feuch, a bheil thu air WhatApp?

Hello,Please,are you on WhatApp?

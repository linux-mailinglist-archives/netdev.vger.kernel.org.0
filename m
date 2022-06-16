Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4242B54D631
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 02:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiFPAhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 20:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347264AbiFPAhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 20:37:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718DB57125
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 17:37:00 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 187so70199pfu.9
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 17:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=n4Os2HmcnmJkL5mGXYbYPBXS5jNOXOPyN8Qv70oNM1HRrUad4OyMTQ1V+WHOwmPhiL
         nBfbDHKTKRYQXRE9o9VFymiU6kaYY4CtHBG/+YTRZs0BwO91aLvafTbI9wyGUrqI1WM6
         ea/q8Pc0UfQTKoi4u3y29VwwlsPtxtVafj/XNOA7+NE3wlZuvl2oj9VpAtd3PEVjCQH1
         30SxC44czrp7d3Fu9FsfvkM4MFjwlv5CcYu1lbfLSKpOzkUuqUhM+z8WKmUtKDHQMdPH
         ibUIGzuZmJuuZmlhF4e7wEoBECX/a7H5Q8KYKgpQuYvFvqCqti64cAFt/i5+OvvpJh6b
         qDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=XLhbe6a4+StS4Ha23H6fUEXzLCn00txwNKP5ayKtJkHrIMow0u1Afv9cTkmfsCX7/g
         OcLr5xbwjL2gPTGRsJjxs3C0eKFtU5Rq8Lf+tz46BE3M+d+FmkeNgy26bZ9JT9Rzwxui
         omWYbXsuzj63dCK4R9mErlQ1v+p5ktbhPrr+IEDFL/D3voZo/lGlCE9zAE9vEqd2LJQW
         LgePqogAy6JRxMc3hlXBqng3sDTLCs4flMQRKEVnJ1uitF+QQjKogB8M74zKQXEQVbXq
         NHX/FkjW+Ka/URsttGOwV50Hc7AZG2hCbA5JtKdQj6J9FLvwEY+aAix2OZGs3phmYqYf
         SuRw==
X-Gm-Message-State: AJIora/G+gLCInl6IC4jHVIb5h5OSjdRDhyiaG61RR1yAik84fDrOcc+
        jLbNflOLOr1VwOl1fg2NY5Vs5jSAzbf9ywNp50s=
X-Google-Smtp-Source: AGRyM1svQ3eXeYgpNHrVp3orFp0gPQ9Z1SgOZu99czuK08tJXkZDFHWRHZA1dBWd7+4CEPsIkN0FGH+KiAcU0nxa6sM=
X-Received: by 2002:a63:8841:0:b0:3fc:6f1f:d11 with SMTP id
 l62-20020a638841000000b003fc6f1f0d11mr2163346pgd.498.1655339819662; Wed, 15
 Jun 2022 17:36:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a06:116:b0:4e2:207c:83df with HTTP; Wed, 15 Jun 2022
 17:36:58 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <tracywilliam26@gmail.com>
Date:   Wed, 15 Jun 2022 17:36:58 -0700
Message-ID: <CAKhG-80PNn958CAgqR=8bGm_gTO9w68yv4-nssL+g5G1RVPDOA@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava

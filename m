Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C0F58E2B4
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiHIWL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiHIWLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:11:02 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1812976975
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 15:07:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gj1so13032872pjb.0
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 15:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=GI1h58u9NHz7rI/vIwOU5DkUcoHPmL+b4tk5i/xxv5Y=;
        b=jRJyLb/AEWH8s7kE4z2AAZy2ayTphHJZak/EhYx6zVm8k9OWYaov8aH83ERLt4oDNq
         t1CeKHBxjluTmONbTtOO84RdzoJNiIH7V6yKGFdRV+eVVvrSocvrlKjgQsSgWgexYB5Z
         VfDPzDKT38QL56Z2W/XjbQT7a9He18E0Eor0RZplj6p/pCjSSYgYXDN9A/F7ilwaQWvy
         BupalnfN0GqQ5/E1JziZiXYMyFiKNu+3gY9klW/3gXOPlzT8p3r1/6Bcgkc3wWcGlLDC
         oJ04L+jojVPYyXn5lNVgtJfNbeuow8u576UCnl90agwPvFOvPYjiJNxXM3iD6I6XxRAE
         7T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=GI1h58u9NHz7rI/vIwOU5DkUcoHPmL+b4tk5i/xxv5Y=;
        b=hyND35uLopsOW4FqqzzafIvt7fSllkQSPBzP12JyQgHBnvtorWksFl7O2LLgS6iH6P
         wV50ws1WUiMTvx1lRkA/Z/iPeAe7/tNu6rR2XyOzU+wrAqLMSIHSWgNCLz9/CsgcOr3m
         dtB1Y/jZLBAkTTaUFCfpCzcaq2SgH2Qpr7tUN0+bGA7t4+kd+P5QKMxc6m+3rho5bN+R
         0i/bgPShZRMQZjDYVq1DQS0bvoqRZtPCbfIDv8qAxi6vUquB101LCERKzJPWSnSNmtxy
         Y9mLLwx1nnNLnAlwIH9KNKYMyaJ0xiKxjfPV6WeqJuCkof4JlIlZXoVAjxxfknI3irWu
         cShw==
X-Gm-Message-State: ACgBeo2nvirONwXKos2KsDZWGci4ud4X2QQK2E58m+MBy+hHCW4kkv6K
        pvTDFW3yXszvcteApiTA5/ci/IhcbPshYgC83V8=
X-Google-Smtp-Source: AA6agR5ckS0VtzdLIXezFJRRL/Dss/LwN39oEa8VjyyxxF2bH0VXcvm9EUSVhvd1MZNo+j2o4N2XgKOP+JRwVbEpm1g=
X-Received: by 2002:a17:902:e552:b0:16c:571d:fc08 with SMTP id
 n18-20020a170902e55200b0016c571dfc08mr25228210plf.151.1660082875606; Tue, 09
 Aug 2022 15:07:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:e8a6:b0:2d4:fb1c:cc5e with HTTP; Tue, 9 Aug 2022
 15:07:55 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Dr. Ali Moses" <alimoses07@gmail.com>
Date:   Tue, 9 Aug 2022 15:07:55 -0700
Message-ID: <CADWzZe6JP44i7h7TqDt8u6ng8nRUsyUZRX5xT2jNhPRaoXF-Zw@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alimoses07[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [alimoses07[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
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
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

My regards,
Dr. Ali Moses..

Sincerely,
Prof. Chin Guang

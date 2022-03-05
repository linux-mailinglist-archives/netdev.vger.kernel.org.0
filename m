Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4405B4CE280
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 04:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiCEDnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 22:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiCEDnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 22:43:40 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8910F22A286
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 19:42:49 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y11so12553709eda.12
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 19:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=c1jQsh4jqD10p5h52HILdSUOUqSMAqsQ1BwOSmRjoJc=;
        b=d2ASadFuwkwCmHGd/eteZXXAKqrpFi0VfFbdHWF4EC+RfE9EBGb03eMLcNZi47OBcn
         uLoFsJsUjVHF64CtoG6ZOpJVRD52vr1UhtGetUEZf7611KhW968V0AdcI1CfAN0UfWBL
         ixV/BGLQEDFvaYBrVb6pJg5dbObzxUn/S727ousrh+bXnlnDpS+mxULJRp2OkyZTFeDe
         4V2VF/hVuRU8o0n1cSeSMog8CVav62VS54zxuoEZItOe29noDshf4IbFWzDFCxrr6Uq1
         agpeP7NuzwDYjZMlUU4jqw+CNvgBM+XDvVcDiC90qCtsa4Si6wXFODdsFKkR402PRUPF
         6a6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=c1jQsh4jqD10p5h52HILdSUOUqSMAqsQ1BwOSmRjoJc=;
        b=E6Kom1bnoo8jqfsNo5G9O53Hypk8fxufQo7WwQxi8jF2wie4DxsDmGhjqwQLc007Ua
         ss1JI2tpmh+DVQ2J34H3/HEDIePA0Lm1+1iCCi9RWQOyO7JUidJKEsdsaHpvNIxIxQx/
         v/4YGxkLi80LRNAyXnzMn1KjDCKSphYXXzRuPry9dh/cg06Qd5PNTlFsFQgvbnxlh2dP
         IRrHJVH5loA1881s5wvZQOfbfN5/8qkSRD1wejj2IjwSS3yHuWkBJd16b5AKCn5MHnIo
         /mVILWd9rHIciJc6Y4aiU9BMXIhj5C6YNSeILr4W5j1zlxg6rrlp/GDAzd3IEgeFdnRq
         CVtw==
X-Gm-Message-State: AOAM532XCk5FjOgPXxQV6C/9apin7dZR1mIvMH8ubvv+VS7g+t8u8OMB
        a9aQ1CZJIb8/YOhSJa19bSjjps1219LANJoa3PM=
X-Google-Smtp-Source: ABdhPJwptudAzMtBu77BORmNJC6fHlt1U4zhgDIb0IMk/HNJxvuk3uy3vNIzjYLmkWtLm9c70cTl8YlpwS1KqHa6yHc=
X-Received: by 2002:a05:6402:268a:b0:410:a0cd:55a0 with SMTP id
 w10-20020a056402268a00b00410a0cd55a0mr1415361edd.339.1646451768039; Fri, 04
 Mar 2022 19:42:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:1612:0:0:0:0 with HTTP; Fri, 4 Mar 2022 19:42:47
 -0800 (PST)
Reply-To: howardnewell923@gmail.com
From:   Howard Newell <sylvesterdaniel619@gmail.com>
Date:   Sat, 5 Mar 2022 03:42:47 +0000
Message-ID: <CAF0aQhN00ccZNT7UFceNM25UB3NLiUU+-qbZuhAh7w7-bAm+VQ@mail.gmail.com>
Subject: re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4146]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sylvesterdaniel619[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [howardnewell923[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sylvesterdaniel619[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi

I want to know from you if you received my message concerning your
compensation file with United Nations Compensation Program. Please
confirm.

Kind regards!
Howard Newell
London WC2N 4JS, UK

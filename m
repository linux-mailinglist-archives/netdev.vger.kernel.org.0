Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F821539335
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbiEaOgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240546AbiEaOgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:36:47 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24CC2613
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:36:44 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id s188so17669277oie.4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=1Br/N6WhyVMlujnGsxiPG2oa5QW+rtf7KlXAbdHBbwA=;
        b=P2nRh0pgB8JklGzPmXdJusJqD/mKkVdOZQyh7bUo82BI7aD+KII10M85Omue8eyJc2
         0L0EyvFyKND+iVfpF61jBVwse396m4m3THBP01M/3h9NFz1t+TG3AUQE2eql7aRe8R44
         KlTf8+aaf2X9hkh+HXsAaguW/k00bKgRybLUcsaI8JDQYO6YAe6tHPADmi3F1OLvsJDv
         EUcXNIYFfGzsJXunnB1tNuZdjT0uC7aqWlXkvlOf4jtJMNSqQaNf9yO7InuOShK71Z4s
         cQg3Sby+vDcnqhMPw+wvQIeN+IBpmIVBxWnrn07VD/NN5vKaQIqfmpKHGDyghd3D0lYB
         18WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=1Br/N6WhyVMlujnGsxiPG2oa5QW+rtf7KlXAbdHBbwA=;
        b=ug9a6szXKUBzOxtBcpgEmEZytD49kW3/T2TlshzWEUrJpcnN5KY40F6WJugQre7A1C
         R5hZNen3IxE97YPPrT+lcwaEv8kSPpSzeGyR65hLE1bGTS9t3oBsx9rTasvi41TQJ/27
         pVNUJ7rwyBqgctq2q3unO3ncgCh5+XnJDjlYRdEPh14wq0s84xP1Tb0YsiWQ1Xgrb8Hi
         uTW+SLUQ8ePVbqAHsM0q7mEoOzd3lNi4z0p6vppJG3nKEgPxtfcDApt5Znf6q9kNsgV4
         79vVV4AcJuJfNo24g6U834oInSDyA2LspLGrKeUf1JjK79d0/8AJiZ5ErWZxs2bIaHOm
         wapg==
X-Gm-Message-State: AOAM533iVDHq4VGC7IAzJpPqG8oQYFlALgDETnFO421DVx2BFK2MMID4
        DjDpvxSiBGOA0CC6FwqeCOqzp5AefrEVNsRh3PQ=
X-Google-Smtp-Source: ABdhPJxmQIUGccTUjZTCEkuENB5q9+Ipkikzb/XieoYE+6Q2XQBTGRayFi8C17Rr3jDoaDfYNSfqv3xTXNRHrt54JQo=
X-Received: by 2002:aca:61c1:0:b0:2ec:d091:ff53 with SMTP id
 v184-20020aca61c1000000b002ecd091ff53mr12464308oib.235.1654007804015; Tue, 31
 May 2022 07:36:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:105:b0:a3:40cd:8525 with HTTP; Tue, 31 May 2022
 07:36:43 -0700 (PDT)
Reply-To: mrsbillchantallawrence58@gmail.com
From:   chantal <msrjutconpolamcompola888@gmail.com>
Date:   Tue, 31 May 2022 07:36:43 -0700
Message-ID: <CABt-Z7GTSxFpY12xFmYgOT1--TYxkzKdTMjRVw-gRaZ8+AJ9ZA@mail.gmail.com>
Subject: dear frinds incase my connession is not good
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:231 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7979]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [msrjutconpolamcompola888[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrsbillchantallawrence58[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [msrjutconpolamcompola888[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello....

You have been compensated with the sum of 5.5 million dollars in this
united nation the payment will be issue into atm visa card and send to
you from the santander bank we need your address and your  Whatsapp
this my email.ID (  mrsbillchantallawrence58@gmail.com)  contact  me

Thanks my

mrs chantal

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63124F9E26
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbiDHU3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiDHU3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:29:43 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024321A8C23
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:27:39 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id l14so17078356ybe.4
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ZOLspPWmc1KSmGfCxPulQw98AhVZT0pWgP290hFhzaE=;
        b=dJojkqwyKlNQtFoYthsAKSjXtBEohs33GqkOiSkvERiTZx7FKSM7uqr1Zs94H1htYu
         LUrJXfro0m0BtYTt3IpmU0R1armqAmg7K2Xit1GecnLnbHSPalqv4aEuMmsbNzjgz096
         EcWshExGF0NTePkYahRKNTRsOsyUyvd33s+Qkwth3pDcQZv8s1hnkpTLJrJpcUnR3vqP
         IySj2E5f+mFIE+3YUZgZIw0KGMP0AILa8I2IuKSNw6DJ7yXPrhrkJe1+ixgVgiY8YH2+
         XR0S6SveN39XONRhKQP01/OQds0MT0ALJbb0QwpNPFJ8rirrVHXGB9nO80zLMCFEBot7
         zQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ZOLspPWmc1KSmGfCxPulQw98AhVZT0pWgP290hFhzaE=;
        b=4gQGcwgNtuTyK2heJDRj92x6cyybhPFn2cFETvB2/1nHHdJP/fdq5CFxKUU5EF+GNq
         muCM5w9vpZclnF2qum7GlLjxZbxp+hynK7CoRMryKAzXN+dlCzIPZhQHWdrab6b8FAxN
         wpHVMmEJ7R0D7hIZYVijzCF2TGDHRRhOp0miKDhaQQBFcyu57kmOf3MHD1e5/m8QK/F8
         nonb+1Mi1QpiSmdNdICivZSuUrFQxx+TlivntOUrasN7Kr5gw8EYLfVc2pQMVQZqgmT8
         GjlqweNv1JGsWNb6A/cE3nXsq7X4mMiIyhz0//d3TAc7GAMUML1EajL4klmoj04n3ZN+
         M5bQ==
X-Gm-Message-State: AOAM533savzuONH/csd1ctjaPUpRlI60Q9XJiawCB2VWaIr4v83gvivw
        YrNZzQ3vpx6npSCCU1qaj7iNkHnOsGjU605vtg8=
X-Google-Smtp-Source: ABdhPJwZdBphSoLmU/aOaj4cQejGuf7grXq7zL0iVD0/t78vKIHrkjcvnNLTDIwwWtOuqKDmUf0xr9+LWPq27kI+Psc=
X-Received: by 2002:a25:3b8b:0:b0:63d:f010:ed04 with SMTP id
 i133-20020a253b8b000000b0063df010ed04mr14101257yba.591.1649449657967; Fri, 08
 Apr 2022 13:27:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:cd:b0:16f:f28b:eee0 with HTTP; Fri, 8 Apr 2022
 13:27:37 -0700 (PDT)
Reply-To: aishaqaddafi9@gmail.com
From:   Aisha Al-Qaddafi <mahasaliou0@gmail.com>
Date:   Fri, 8 Apr 2022 13:27:37 -0700
Message-ID: <CAD97iXOUtiGXNxuKK2nE8ksz4MLGPskZ3NETmE-Dtug-Vepxzw@mail.gmail.com>
Subject: i am contacting you, because I need your help
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2c listed in]
        [list.dnswl.org]
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3390]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mahasaliou0[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [aishaqaddafi9[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mahasaliou0[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 i am contacting you, because I need your help if you are

 interested Contact me For more details,

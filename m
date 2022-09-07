Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB065B0C87
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIGSfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiIGSfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:35:14 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6988641D23
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 11:35:13 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id y9so8407045qvo.4
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 11:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=9JgfdaIQvQZ9l5SmCOLciVHAQhMDxaoqktdhOO0g2kU=;
        b=PvXEiHrGsSLYxSoThCc0qqgSaFI7XkLBJewknGHhxnd05zRlYXq6YTV12mCirfKVZt
         4ua19760tIUr0eJjF3H431P9ZmU/V8a46on8llGSaWpUgAboy79a8ij2K951bGJGoTxo
         3tBAZvZCaPCileGObHjm1F3jZC9pJAXMxCXfdlX+p+ZV5+WJq5lxhfOaIYVPHbS1Lyy8
         bCDzA5Fi4gxxB4WBtsXN+VNu2RXIdXR4+aSwnwBmJV/J7r3ijf3XdDpKJNQgAYnw1Kt2
         HckH46o9B+tJHvlF80bAryyGsXUoDm3zxYoy3ETcYtl8Fu8P8kIr1/XbAu/gIK8d5GO8
         /RbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9JgfdaIQvQZ9l5SmCOLciVHAQhMDxaoqktdhOO0g2kU=;
        b=ZpJYsHTdKJjQDzi4zE20VN8nOD+Q6TQVINlVEYniL3UwGy76dP427EdsVORCHcV6Qu
         B7zBA6tEpnCB9bP2qnbkLXmzRdpTznxR10MIK5vl7l/xQFtwS6H4sbWO/NEntjFLszKq
         sPdSuPBdSvSQdo1Hu63Wjf/1W7Vb3RBXX6Mz1ndB8BzYcx67HDes0Mv67QPphwkshA60
         3BOZq6O/MvyWtK9vZyXpixkDIluHbQh0OTXA6IENQZyXy9+SlOXusmJMjA8Oei6OtA9r
         f+gwJMvjWu3vI4JWaVFzyqeourxfchJh0LEO0ZZvVfNg+XzA1RJSymzXU2LFphb+XCZ7
         RxdA==
X-Gm-Message-State: ACgBeo0WcQWJEiIY9TI4IMqkAH57PFUvLg//rFNq1cZpkl0O0fyuETcF
        w3INCWji7N1TLPgqbRnEj7CeInF6a/+wgE74aco=
X-Google-Smtp-Source: AA6agR5y/y0l3Iim7on5X1I+2SzDFIIM6yBHtId4XWbWkpln0KM4mVmkHdgzX+/GW04Jg5Za1gQ5TDJf3gKLnMfQxFM=
X-Received: by 2002:a05:6214:4102:b0:4a8:940b:b752 with SMTP id
 kc2-20020a056214410200b004a8940bb752mr4392113qvb.68.1662575712287; Wed, 07
 Sep 2022 11:35:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:20a8:0:0:0:0 with HTTP; Wed, 7 Sep 2022 11:35:11
 -0700 (PDT)
Reply-To: stefanopessina14@gmail.com
From:   Stefano Pessina <vincentdensondaviddenson@gmail.com>
Date:   Wed, 7 Sep 2022 11:35:11 -0700
Message-ID: <CAOO7C+3tij9R4wQ0C59fYoEZCLswz3_Fpdoq+1j15C6b6hWREQ@mail.gmail.com>
Subject: Donation
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:f42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [vincentdensondaviddenson[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stefanopessina14[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
I am Stefano Pessina, an Italian business tycoon, investor, and
philanthropist. the vice chairman, chief executive officer (CEO), and
the single largest shareholder of Walgreens Boots Alliance. I gave
away 25 percent of my personal wealth to charity. And I also pledged
to give away the rest of 25% this year 2022 to Individuals.. I have
decided to donate $2,200,000.00 to you. If you are interested in my
donation, do contact me for more details.......

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D535B617359
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 01:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiKCAWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 20:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiKCAWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 20:22:14 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183CEB7CF
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 17:22:13 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id d6so330460lfs.10
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 17:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqmwXDkW21SACvKcpdhhVFrPE7NWfgfEHOY6In7M3pw=;
        b=TFQVgXlcO80T/lZ4fnFqwhf3FgTLVLSQM3N03ieCqruFY1R8sF3vegh39OS3yEJGGJ
         dbXrYFH8WHPS3C486QnV8VeXIPX1lpXfW0M0+7VhPTdupikIorwpmPfJh5P/resV7tIp
         xdSD4MK2/mGrbB3jDSwazj3RbjR3HdCWUpxf2SjIa3LexUzmNjJzTpGydx60OiWg8x5A
         +M3OsIpMEPJ2xorIqjGX1F2uzdmavWcenlkkltw0IvFjDz51q23Fhl0/vorqyzufgIz7
         HZDMQgSZmCJMrCxdZmX7hmJTk3arAKPaetpyh+ev68mau0664rIr0y6TIrbEaJY6kj+B
         yzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqmwXDkW21SACvKcpdhhVFrPE7NWfgfEHOY6In7M3pw=;
        b=XkC7/VAS4tUodHY2t/EaL97fwsQAfIZ3es0dKGsGvL2E3KBtrNgKfxXJ4xblL9gAjb
         QAd2uJ4G+mYBY5D2IUB3eleuA310C21lSDNYgzbFdviaOwF/yjG+w+OIwnoRDW9uP+67
         EkQkKZC7aIZqMU0siU7+sjZjo6NcqX9PMl8h9yYBX2ospdzb8vVIw92/T/45xMOK902s
         P3okMDy56AXT9xzi2cXpyjGEz+Gt9MlixnmRaZFd8kHVfcjPMHT9Kiv6Mebs9Gio769W
         uczwobGHJEb/yiTU/XdV4ClvG6Own8y7mBimY9MuIQhp5h4ZjyHvQcVu2HUCNWZOPRNh
         OiAA==
X-Gm-Message-State: ACrzQf3h7zGsbywCxPeYaGA7IFnMjNxi4J/gji9Zv2+GPbBJbHP9tIB8
        2fhox0nNTM3FrPimmwzi5qSA5GE0d78XZCzw3MY=
X-Google-Smtp-Source: AMsMyM74c9w0PokXcasnTQdgqkc2XE3WYmaBQQZ5yp7azaJ9ntaKvieZYztnCW9zQO8PqZuGUczzEwxoF6cRLPpNcvM=
X-Received: by 2002:a05:6512:104d:b0:4a2:7d13:8579 with SMTP id
 c13-20020a056512104d00b004a27d138579mr10108549lfb.585.1667434931293; Wed, 02
 Nov 2022 17:22:11 -0700 (PDT)
MIME-Version: 1.0
Sender: ztechc989@gmail.com
Received: by 2002:ab2:704a:0:b0:16f:d9eb:fa9c with HTTP; Wed, 2 Nov 2022
 17:22:10 -0700 (PDT)
From:   Alassane Bala Sakande <alassanebalasakande98@gmail.com>
Date:   Wed, 2 Nov 2022 17:22:10 -0700
X-Google-Sender-Auth: IvWn3sf7UdwK8LalM2sKq7KXKPg
Message-ID: <CAHfDeE9mkm_Lu2PnT3wW+5nhMVZiz2GE11N3fMr2heO7nL7umQ@mail.gmail.com>
Subject: GREETINGS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.6 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,NA_DOLLARS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5003]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ztechc989[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alassanebalasakande98[at]gmail.com]
        *  0.0 NA_DOLLARS BODY: Talks about a million North American dollars
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 DEAR FRIEND

I am MR.Alassane Bala Sakande With the business proposal deal of US(US$18.5
million  US Dollars) to transfer into your account, if you are
interested get  back to me for more detail. at my Email
(alassanebalasakande98@gmail.com )

Best Regard

MR Alassane Bala Sakande

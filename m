Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE7652CBD2
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiESGNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiESGNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:13:43 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C2FFF
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:13:41 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u23so7344015lfc.1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=tDL1P1p5+i3sjlXSqCnMLNYuZt+Q6Nue7K/bM1eQCPs=;
        b=pxiRatKzwFoHW/HXuzjXv4FAXZERTH8ZkjoFTsYqPUXqeSvf4IlEoMiKxNXX3PlI5E
         ZO4jSG5e8GeeAU+M/T5nQTDAb/10ricdWJj9yJMR6jKEEJo3a2tJjPF62RA7nng8FyNr
         DedGZ8EVfvBM5kXGxcKH6GnTjyNpa/qsb6hS7x8pYt8O0/d+SwjWGxGR3Cf2zSSHBwmz
         gVvHvOngNMFc+MeaycDJgTd2hjfYs+AkcR+2OmAjFD/leAnDCAAMY3U5x9HeTyOp83er
         vCRYeDN0Nter5d5hVdTSFPhyY3sIj3HdY/++7WQX6GIc36cBkVKoApZI+Ezp9RCNjvIv
         uBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tDL1P1p5+i3sjlXSqCnMLNYuZt+Q6Nue7K/bM1eQCPs=;
        b=H3bsWQ/8wyUT6f2gMrOHkr6YX9uG53+1/OOImhUOXHQjNgBdNX9Ot+LLpmRyHLV3Tf
         gfU8b6FrrIxto/NkMoDcuVPfdA2iVmcQmmkEkMN/fO8ByV6Tu6KdQGNYFh3Tnqs3kZJg
         xcwC7sL6YTcQoVx2DrV3uPgfrEzroEamcwOdQKzJqbxEPbrzdv63eRFQKJ1RCtS/rnDJ
         rtH36zgjPgzoiZdm7JTNOVTS/lYy3IqYVajGwVJHH27RvYkCw0p9XtZxsflDaota0Fbx
         BjGGb8riWXRqoYiSoOgkqx9pBKdFgz8zDu3NabcZaDx1taD5OZAMdohTlG3Rz/0YNar2
         byNQ==
X-Gm-Message-State: AOAM533vUro0di6xo+ql5wPyJlbt0nrN+yH9c32Wyhc6GB2aazHWGuqk
        HN/TUJTRz3ZSR4YKycR4FFhuBXsuCIKdrhMXEVI=
X-Google-Smtp-Source: ABdhPJxVhSYM/hfbBWWAu2girRQXrijwnBWh+yoxlNCcZJRmlL6VXFPKHbQdY1ba9PTfPka+Hm3vMRLxDdaDonMHgJM=
X-Received: by 2002:a05:6512:220e:b0:473:cd23:2c3f with SMTP id
 h14-20020a056512220e00b00473cd232c3fmr2253555lfu.349.1652940819584; Wed, 18
 May 2022 23:13:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:aa6:c143:0:b0:1aa:fa70:38eb with HTTP; Wed, 18 May 2022
 23:13:38 -0700 (PDT)
From:   Aisha Gaddafi <mrsmariazongo20@gmail.com>
Date:   Thu, 19 May 2022 07:13:38 +0100
Message-ID: <CAE4eQ9hmP9eLBMjNucWCbNuHDNGPBahrOwcPgZpS8S0CuXcY_w@mail.gmail.com>
Subject: Dearest Friend,?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_2_NEW_MONEY,
        BAYES_99,BAYES_999,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:129 listed in]
        [list.dnswl.org]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrsmariazongo20[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsmariazongo20[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.0 ADVANCE_FEE_2_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dearest Friend,

In the name of God, Most Gracious, Most Merciful.

Peace be upon you and mercy be upon you and blessings be upon you.
I have the sum of $27.5 million USD for investment, I am interested in
you for investment project assistance in your country. My name is
Aisha  Gaddafi and presently living in Oman, I am a Widow and single
Mother with three Children, the only biological Daughter of late
Libyan President (Late Colonel Muammar Gaddafi) and presently I am
under political asylum protection by the Omani Government.

Kindly reply urgently for more details.

Thanks
Yours Truly Aisha

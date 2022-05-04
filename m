Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C367C51B436
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351345AbiEEADs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351822AbiEDX5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:57:49 -0400
Received: from mail-oa1-x42.google.com (mail-oa1-x42.google.com [IPv6:2001:4860:4864:20::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A96850E3B
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:54:09 -0700 (PDT)
Received: by mail-oa1-x42.google.com with SMTP id 586e51a60fabf-ed8a3962f8so2799716fac.4
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 16:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ampHH5WJLIBWSsxWwzVjbk5pO9UBFxn81pZ6QIDzZtY=;
        b=fejb4kRs5stnVxh6o3SZK8cIriBhE64YNRLDB2X9SQlvzFg2RgJ5H+/yYP/qyCS3vJ
         11pxEFbzP3nqQfOxjMw2mZHw9hKvjJkk48zoUoIoo+hhWm9PA8aURKIbVEbckIp4ExW8
         EyYrCZ9l4CV7f7TON4Dbe7X0oLmosdBIPKCMOit9lJvhuDk86EyC1hqXa9Cg8pppbLG7
         BV1nb3aiZBsstECX5wR0phpHK9rVTw5aYL8RPvdjeW45zmiXusY3hQrjm6gGh2hpPJi5
         soSqqPNPaZL70lSzUlk/vr6mF4bNx4jO7LToNH9hl1e4m7Pn0ESXWtjvPOrS2mb6AY6W
         2K4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ampHH5WJLIBWSsxWwzVjbk5pO9UBFxn81pZ6QIDzZtY=;
        b=wul2wSgBCUeul6d4mOZnFz7IQJxAI8yU00xZojKcwSmrqslFGNIodqjRdHgDENS0t3
         0kJS9NE+r6Kiwzle4i+NmpKpRUET4gXya7G8klhOHg0tlEnU/5d8jP6WdnGEMw4oVC3B
         jAPKA0RTWOSrTNBWokeyTYdYdpRz4rBBIWTeOomDd29i9QvrCdx3lL49RSnWovTYbSKV
         z6RRWVMikzwPMJP24dxvk35cLENkb8KMPWjZ0LTHvNUEAsTOV1Gk7Uswj8dkw1h7KPBG
         escMWJa8kdeqhIlgPnLMl7UV4O8esPyYBtK3e40FC4EjNzLZaPmWZ8HTocZJePLI1EaI
         m4Ig==
X-Gm-Message-State: AOAM531E5eUiXa+YyposDFgdzvcgUKgaoo7eeF0+vayeSQcuWKH50fPc
        yp8Kl7kHXDFTwBjeVxq656FCmUfy2ovr5GxZSYo=
X-Google-Smtp-Source: ABdhPJyZTlIVCXLLTRYw4tVziUhHBt5fKSedvUm243rCs0KCQrQKdcBF+mWmQMwIBKGfxFYKCRUOL4JdsiSkpE/6HW0=
X-Received: by 2002:a05:6870:6005:b0:e6:515c:da5a with SMTP id
 t5-20020a056870600500b000e6515cda5amr1024807oaa.183.1651708448405; Wed, 04
 May 2022 16:54:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6802:1a9:0:0:0:0 with HTTP; Wed, 4 May 2022 16:54:08
 -0700 (PDT)
Reply-To: ortegainvestmmentforrealinvest@gmail.com
From:   Info <joybhector64@gmail.com>
Date:   Thu, 5 May 2022 05:24:08 +0530
Message-ID: <CAP7KLYj22aGdQkwCfibh1Ur0VhO6tOs9i_uu6rm0ZynwOa7+9g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [joybhector64[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [joybhector64[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
I am an investor. I came from the USA and I have many investments all
over the world.

I want you to partner with me to invest in your country I am into many
investment such as real Estate or buying of properties i can also
invest money in any of existing business with equity royalty or by %
percentage so on,
Warm regards

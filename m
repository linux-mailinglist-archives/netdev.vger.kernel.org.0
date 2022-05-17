Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3993F529D2E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243966AbiEQJDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243986AbiEQJDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:03:42 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD30440A31
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:03:36 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id z2so33373188ejj.3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=WoHexTFIk6XvLoXULKjPGbTETCghLna08089veT2icXrfqMA1A90fkYUMxjEo62Gy0
         qqbmfyUrfC8Q3G2yVTYkjrXDU6KeRlcKVvzyQawQ5YkSfaITZeUSntxYqno5vmNI9KaL
         8/fZ7/sV8LbsQD0RLhwe2GW5ms2ISNlm74TANd5+vNsd7BV8uLg5Mw6WhyffNBlRUvBs
         NIAhzalNhSGTQK4dj4KfpuXsxdH40/ZQ2Vv3owFKTUtoc21cQhQpay3P0vy0wp8XhvSl
         KmYuJdlDymKnkinhxD4Y3qDVYgSrV6YCww+J8SP6/+zOcIvtBdMGTYcO/xMXoBDAEPil
         QY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=WFo6VOFZQw6NrSLj4XSUbMy/ks+C9Nv+ZzUwVAxaZBLMnE5zyZy8zxmffX+G6k/0qa
         zxPuZ96U1NIHfWke/pZwitZ1MfVvAPW2HTeu41MYMc8wdQ5BUsIuSJnkPzky0MCKxfLj
         L4v5R4ixZ4yqCP3JXR3RvbTf75joWDZAHTjk8/56mljqRp1jZOA4MbOwCdLzgCotQGU3
         QtRcQCzJBFJ1ICud3x/9vWys3rxOS2jhJ2rZAebTKsoG7WFo0Xftp+ycQme0Lsko0gsg
         KxEkD2pQzFYSw2LMMda2vxpozO+CBjb1f8g9Ha1g1bU9/xa8NG49rQWKUh7F30ExKaiF
         qXHg==
X-Gm-Message-State: AOAM5330yjHpvJq3lpsSDI5hE/UgHO6dtCal1aq/jnafn8pcyLTzf4E4
        K7j+njfH9i21uKW+vf7JqQNmP7Jxy3tJjZTrnrQ=
X-Google-Smtp-Source: ABdhPJzDNwdd77Y57XF98BrDNEPiLd0s9kELdiLD/I4Pl9IzamQ9m0V09cCrMmDAF2ttk0sGlPEgw7qGltsaNWnizcE=
X-Received: by 2002:a17:906:699:b0:6f3:a7a3:d3 with SMTP id
 u25-20020a170906069900b006f3a7a300d3mr19181990ejb.650.1652778215372; Tue, 17
 May 2022 02:03:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:924a:0:0:0:0:0 with HTTP; Tue, 17 May 2022 02:03:34
 -0700 (PDT)
Reply-To: jub47823@gmail.com
From:   Julian Bikram <kodjoadannou123@gmail.com>
Date:   Tue, 17 May 2022 09:03:34 +0000
Message-ID: <CAOtKoZ9fkz2=-8Y-8LCR0U+D14+oMm4qKfde-N4c=3+3toboOA@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:635 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4971]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kodjoadannou123[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [kodjoadannou123[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jub47823[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear ,


Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.

Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Julian

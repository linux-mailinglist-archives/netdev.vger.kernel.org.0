Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C32C4FB2D6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 06:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiDKEdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 00:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237387AbiDKEdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 00:33:44 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E392821C
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 21:31:31 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s18so5851198ejr.0
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 21:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=N7BylrP8tKv6Ig1EqbBXaZcnqQu0RpvAF5dMgpdPQJR2SwPxrpJfjnlmfsXlfDmp7V
         VlScdLndhgtwV/gFbBcCRviih6BVvCjpQccxuCPrkxdiuAzeWSuYqVyCJ0V6A2Bka2L3
         06cSLApjVZXiodjzrUYtJ9n/l6hqVJlJQU4mIpU7fv9AJuyMa3jdtsBoWfyD0n9UfzVp
         tWbYCe+eJuTIbwuXG80+jZ+vQHeZGUj9sLyhS1FTS4AaATbKBifPUlB53yk6C7OZMO2b
         STajT6PyGz/l16KgmlziD55rk2gvOxyzaZ+pHSF+tD6C6Q6z8akxRJ/J3htQmB10l38y
         3Rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=b32vnm2bEvoZw0lAYNgMdtsFyf+t1QQ4coYFE+gXrgcRvES+lkw/mkJhXQf+H76XJy
         JqSVrkf8DbYNqS+M9SN10ybE+/HVJkdw/8vEs4uDJjugMWtgJtXMy8bpPMTFzTcGH0J1
         S1ADeGcA3Z+ZMTpzvtvkisXQSz1m8YWmFnuhdhHVr+zTbESdCtlRvymwQmzhEsYFphuW
         ZSkfFQ1SNsRAVJiaB+4zDmzxEs4xIbjSXZowmc9Vlp+rK56dPn1eCx+oI2R5QeOobaTT
         cAzeErN2kbjzZ0R+miKUUvgp7n00F3rJHqtbABgPbCH4inC0oYNAtInmY3aaIO9CW693
         7niQ==
X-Gm-Message-State: AOAM531slOu/lVy/rjZzgSabtRk4fJ67qkD2EihyAYpSJ3IfQIK0wVdh
        nro7DpZXrkir29Hlmy+SZHu54vhqFJhDcg8OZlM=
X-Google-Smtp-Source: ABdhPJx0wVvsLBdPwP1mhCYyPpYV9RgGwKpaC9He/Pbk9qkJICOH3wjUsyKj1heIF981UVnsd2iGmLJBFG8hlLYq8Ac=
X-Received: by 2002:a17:907:c06:b0:6e0:9149:8047 with SMTP id
 ga6-20020a1709070c0600b006e091498047mr27898161ejc.765.1649651489727; Sun, 10
 Apr 2022 21:31:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:2891:0:0:0:0:0 with HTTP; Sun, 10 Apr 2022 21:31:29
 -0700 (PDT)
Reply-To: daniel.seyba@yahoo.com
From:   Seyba Daniel <lucien.dapelgo@gmail.com>
Date:   Mon, 11 Apr 2022 06:31:29 +0200
Message-ID: <CAFMiXw8GvAS34dT56FwsV-yD+qQmLFJe-jkRTK5zx8J+Uj=z+g@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:644 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lucien.dapelgo[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am so sorry contacting you in this means especially when we have never
met before. I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it.

My interest is in buying real estate, private schools or companies with
potentials for rapid growth in long terms.

So please confirm interest by responding back.

My dearest regards

Seyba Daniel

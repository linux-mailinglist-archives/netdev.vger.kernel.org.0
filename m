Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1D5277D0
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiEONYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 09:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiEONYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 09:24:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80397186C3
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 06:24:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m20so24039291ejj.10
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 06:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=wX4BMjOypo5d/OsLI8Sw4NpZ7scgBV3K3bt0u2CQOQc=;
        b=Nb9rKJ3APiCKBhBDroCBDjbB+pisJ/u380hoc/bf6HN0lS108z+ZtrXkGS4so8KcWq
         zBdXkEiG7Qf5ZwubSVEmw8vUNqfqq9bXviDUWe6N4qwWItvpw0P74eKa9qFzCi87zWcB
         i0UOcTpUT9SKPVHe0AlUxfCyWLa73fgPYDFbFbBaPbcqI0322oCRcyerKgCZYr01meZN
         Yvi0iYfJOtXtv9/7nvGyleto5S6F7OCLPY0rutLfG863U5GDZIrZXHRC7QlpZp/w9bAJ
         zKi4CI9VuwSIxoKsOfoyDiXtxL/dg0vsr+9ZWjUqOeZjF9rzmEJqn6MumL2GN8rTHHKL
         UvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wX4BMjOypo5d/OsLI8Sw4NpZ7scgBV3K3bt0u2CQOQc=;
        b=HNMzBqwpflzNN3u7jDt/7uRaNHLkyt4Xx+5WdYTD4hYKZV2rvmORIt8wM+nMo8RrCN
         dt/PkkM7tkBv9SwKHTk7NQKc9nLosnI4IjavLz/VX2vnbz+d5YkaBbFtEFzb/Fleqwzn
         +4WWFGrWlo8aW/pNmFmI35hTYmMb7XAyc6dieUmC2klleA3mD6XJsb3E5HLvjyPl0Ngs
         HTFH7hLXVVFCUGxHiYtdHxvstIynyo1Q5193LKQe+YbquTzVcO3cebR445FZ8/LVwU+P
         MR8bWFxof60KqyGl1hYl8ineAa/DAUb0SIlhsqhgwXWRnGJUqCR0h/dcl+WjqWKQ2fTV
         ENsQ==
X-Gm-Message-State: AOAM533WvauOPWQM3foJZCDM5RQs/B53azat36vianvobkslqVF1BjHV
        y491B1aDclojG0eQQuwoFQJe2suDr4NWGuJY3Pc=
X-Google-Smtp-Source: ABdhPJzJuh2xYSRUL2lIPsEzYuoUiG594NNXfudvZ+xPn+ahIEHF6DZrOiH2Pzd/PJ4vmBVwvvW8T7u/3uqyMW/GVUA=
X-Received: by 2002:a17:906:58cf:b0:6f4:4fe8:6092 with SMTP id
 e15-20020a17090658cf00b006f44fe86092mr11465312ejs.160.1652621092055; Sun, 15
 May 2022 06:24:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:4343:0:0:0:0 with HTTP; Sun, 15 May 2022 06:24:51
 -0700 (PDT)
From:   uago kabo <uagok2356@gmail.com>
Date:   Sun, 15 May 2022 13:24:51 +0000
Message-ID: <CAB8re48H0QmKj_DPo1cLa38aqhO7uyYayVoYtUPDvJg=9hJTKA@mail.gmail.com>
Subject: GOOD MORNING !
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_2_NEW_MONEY,
        BAYES_50,DEAR_FRIEND,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:630 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5334]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [uagok2356[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [uagok2356[at]gmail.com]
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.0 ADVANCE_FEE_2_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,
My name is Mr.Kabo Uago, I have an inheritance fund of $13.5 Million
Dollars for you, contact me  for more details.

Regards,
Mr.Kabo Uago

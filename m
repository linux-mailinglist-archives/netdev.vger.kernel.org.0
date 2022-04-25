Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB050E188
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiDYN0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235742AbiDYN0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:26:39 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928B93298D
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:23:35 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id v4so5657272ljd.10
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=NN4voGmhJlbeWKEdEs6UoFnGaed3+1d1ckkyqHQJfMw=;
        b=RdTwVJNwDDE8Ad3ZCAKZXtdZc42ybb/vSwYQYBzgP+Ztmxh2sPEFmNXP05733M7jKw
         R67ptHZ7AKCKl+pAZCcFGSaCt+8agYmviAB+ziepnId/5G2EMgbUtWxW9llWGEdXt3fM
         FK+CqbhdVf9Dt7QnFNBtDdQMOsj7AsxHuem5GVCiu8Swn174t2ftWrOhhFJEDW7GIpC/
         v/YXkh2Wbii5KdRSbyOeSeelivIh9Wsm3u5f9c3BYmeMaEa6XqwKJuK/kQIVHFm10doB
         D/uqflf9Vdxz+5YotHzUxe0CN+ueHdzABKF5ypcKg1e3ZPWgup74CyuPUbiG0WP0PHRc
         Ia7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=NN4voGmhJlbeWKEdEs6UoFnGaed3+1d1ckkyqHQJfMw=;
        b=pAnent2TIRz8Nk9FBJdqBPMfgwgGrUdprsQmGNNG7UjhHVnKCHmNEQP4iOACGunLMr
         QqanjzzOabowlJagZePYnMVN45ErG8wB5TeuaU6BXF3sYmDXXI+cYO5niZu178GKBYoB
         e7zNwFmFfGtka/PiMIGjqmOZOO8HVz5qMqJZr1BlNy8C6KEvJl9XEZOg9jhnGMqZDbQg
         2vKVPHHNfdK1i4IOPlzMW3dgEzMSIzP2/grEDpKVt0YCuR35bq7LSXPXovg6oIDZCObC
         EXaKWF95VOE8vZnUz+hfDqTq/rPekgpGy7kUnWZO+anbLamptP2cuq2sleYtvP7uh6QY
         TvkA==
X-Gm-Message-State: AOAM532WRJ8DGX9+VPABYLRQAbUSZ6u4QpKSS2rAmTsunIfxhF6yOIxW
        fjveCO44NzwdbBp0ejnRqbEV0CfiEw7sIbR1J4I=
X-Google-Smtp-Source: ABdhPJyJlowdWIwJW9fN2GrEAxiTxOx2pgLfqp3UzNcuSjwBEy+Rp0hbfGbicwGX29Nkkj/VD+hu0L3oa25uwHdZYqk=
X-Received: by 2002:a2e:5c81:0:b0:24b:7d:6ae7 with SMTP id q123-20020a2e5c81000000b0024b007d6ae7mr11449718ljb.76.1650893013910;
 Mon, 25 Apr 2022 06:23:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:1c1:b0:1be:8f54:b7f8 with HTTP; Mon, 25 Apr 2022
 06:23:33 -0700 (PDT)
Reply-To: kenl65871@gmail.com
From:   Ken Lawson <kenlawson1910@gmail.com>
Date:   Mon, 25 Apr 2022 06:23:33 -0700
Message-ID: <CALV6Y5JsydWgOqeJXv0t+WzPR_sXOJgM2ja4u4HyZw_LO8_9Hg@mail.gmail.com>
Subject: Re,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kenlawson1910[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [kenl65871[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [kenlawson1910[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Witam,

Wci=C4=85=C5=BC czekam na twoj=C4=85 odpowied=C5=BA, pragn=C4=99 poinformow=
a=C4=87, =C5=BCe rz=C4=85d
federalny poinstruowa=C5=82 Garanti bbva Bank Turkey, aby w trybie pilnym
upewni=C5=82 si=C4=99, =C5=BCe tw=C3=B3j fundusz spadkowy w wysoko=C5=9Bci =
10,5 miliona dolar=C3=B3w
zostanie przeniesiony na ciebie przed godzin=C4=85 7 bankowe dni robocze.
Z powa=C5=BCaniem,
Barr Ken Lawson,

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EFE603672
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJRXKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiJRXKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:10:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738A35FF70
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:10:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bk15so26215794wrb.13
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=je/sShRYz1bbKNKhVr/lBQaQQVxVxr9I3sZ5nd8wDN8=;
        b=moBL1fEqiHP3jPqYcQaz6xVDOGV6tjPWeNwIakzKLEX0Xxo5JC9pG9KWXyY8RjdXwU
         l39vH55cIm0Cmen6t/jZL5qgoSUyT6Fg7cgqwm1PcLYe+5SdP7gTv+acMXvI9LlcHmkM
         rmkgvTkj/Ig4zhjfgyt/oQXcP3gyKbropbPkHCBtwdFsuXkXfkWkpICK6XNdI8oB7Ku1
         yrd95gJLRoSvYzx531hswWN+3RP+7vWpVRwtX2PLBAk7F4YYUSrodzl8p9fnsaAyU5NS
         ZFljEaRM3BXjaNzBiBkEl2OVV8LW0rN0uzDcwYX2feWt/JJ9G1y83BCsC02PuaCUqONV
         IaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=je/sShRYz1bbKNKhVr/lBQaQQVxVxr9I3sZ5nd8wDN8=;
        b=JOC2EAB+iB97rJwKxnncW2n3dMUoPAKEpio+Wzx3ZNRu/r+8+xqurSVNsWIwgUY8GF
         mvzZQvLuGZ2od2zyoTkkeGzpZ6lndtFlhLpXYEQ3Hh3rdjFBmwKB/6UMD3QPFQi0N+nP
         qBVowq+IlKvh8NQA1C1rbXJr1hK8+hNvioTYa6U1TCxHzlfnxfdUqaPPMKNBbYNOGmv7
         9oy3bPmVN15p9sthgJi4kO5jJ0PzVHa8qnm20phoHf+69dBgEkP3cfEJ5dMC8wZaurrw
         6XbYwjB/14QFRNkXfEtfUB0Nd/RaWq5IDNoDSJUgt1V91puugmuP22clnuQqrBpNxtk8
         ab7Q==
X-Gm-Message-State: ACrzQf0uS+ee9JA2QZPDNmUF0LMzaQEahrhieRIZcCUIeVyyEr1BTGUM
        h1scWJNSon2nL0lV2t42uTXorsKoWYSauOdRwg780SYxm0yJ7Q==
X-Google-Smtp-Source: AMsMyM5354Zlkm5q4HIw9vvDgbNXEtE1ShnSfisxO63gCnXyanO3Ll/Efep9X7vkflj/g8/tuCk1wneqkCvbA6E4bfQ=
X-Received: by 2002:adf:fbc7:0:b0:220:6004:18ca with SMTP id
 d7-20020adffbc7000000b00220600418camr3148090wrs.632.1666134608158; Tue, 18
 Oct 2022 16:10:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6020:378f:b0:217:9264:65d1 with HTTP; Tue, 18 Oct 2022
 16:10:07 -0700 (PDT)
Reply-To: sarah883@mail.ru
From:   Manish Ved <manishved306@gmail.com>
Date:   Wed, 19 Oct 2022 07:10:07 +0800
Message-ID: <CAHGB904_J-+oOvOTCLKvHfNfxjBU3NtLiDFSpaTRbzowwZzu=w@mail.gmail.com>
Subject: new message
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [sarah883[at]mail.ru]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [manishved306[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [manishved306[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi, did you receive the email i sent to you yesterday?

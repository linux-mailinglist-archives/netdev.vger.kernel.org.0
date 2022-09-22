Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19335E6D63
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiIVUxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiIVUxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:53:00 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2885510AB23
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:52:59 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id h1so11619877vsr.11
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=/VLGmsMauVfG+enZTZu/ewj+085KfTugYFPfY4C++4U=;
        b=FKHuP3kx2dSmeS53qNFlBDDwPNgR+ULn8Tt6E9tycRj10FW37nqVHXGd26vfGCwutu
         zmdshTAGZdWvatcJO5A11DsnmJ+WKg681biAnDhm/b5bkJ1rAln6jax+48D8TCnIj6e6
         VRoQWFhpKw+CypaV6BcxEBWpnZAC3TsDf/93belIUxvzCeJZZbXdOyHGwNEB3py2yHpX
         hnPTGzUq5wHs6oMqcfTrKKK+talLdkIdLXQ0A7jReJwiB+daZPfWvH30u1FsMZ3ykWzX
         tjfJiQg7N+w0axj2jOpsWfPxIC+5rDeSCpS3wT0rElqF2YK8xCXV8cCyqwEIYv9zZfQj
         p4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/VLGmsMauVfG+enZTZu/ewj+085KfTugYFPfY4C++4U=;
        b=tJi3MbZ8YBUQmyzW5tC5goEi1+HYt1SZIW5GEdm/PfeMZJgiz47lMZ/b11s7dLXQ6a
         lVsHmTCTS1ammUMBEnTWGPRe/J1OEALQVmrjotOYwJg16HEd9pRzZcaaWcX+EXH96FaB
         OsaA1DcnuP4dDNJ0EVxn/9PVg7yk5bpyKk/vN8EHARSyqlhNowArexFNAmmo2hpSKJzU
         LtScxy0YGo5NJf80safBEFP2U8MgLOr45VPGLUjCTVq7tuabC9ul07ih6ExVzxSTwVBb
         Qvq86r7n8dwPY/2GBeM6jz7TbogUNTx6lSe37MTfU/ak/9Jifl/cye9vHy0tPHk8H0OT
         K9mw==
X-Gm-Message-State: ACrzQf0s3v51UU4cXypgr8ZIEaAA6QBqWo+2NklwDQrlQFqQ4t5a/oFD
        eyTcBc1855QC511jr2kjUpBSbKCzpN8xynNf0fY=
X-Google-Smtp-Source: AMsMyM70mpluaV/GdkqtBWAF0NNM3dq/STc6PPYFsKg1I8l4e5EoTyNwY4pngIxGXyFi772Pz6TwLCKbgjVCqQcVMGs=
X-Received: by 2002:a67:b80f:0:b0:398:9de6:2d6b with SMTP id
 i15-20020a67b80f000000b003989de62d6bmr2343627vsf.1.1663879978025; Thu, 22 Sep
 2022 13:52:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:dc0e:0:b0:2f8:b755:422 with HTTP; Thu, 22 Sep 2022
 13:52:57 -0700 (PDT)
Reply-To: jsmth8080@gmail.com
From:   Jan Smith <maureencabrera633@gmail.com>
Date:   Thu, 22 Sep 2022 22:52:57 +0200
Message-ID: <CALH0pJw6Coy3B51mmqKorai6yq621Ls1bstW8Sed+YpKm9P=hQ@mail.gmail.com>
Subject: Please Read
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9241]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jsmth8080[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [maureencabrera633[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [maureencabrera633[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I've viewed your profile on Linkedin regarding a proposal that has
something in common with you, kindly reply back for more details on my
private email: jsmth8080@gmail.com

Thanks,
Jan Smith,
jsmth8080@gmail.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCEA64FF56
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 16:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiLRPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 10:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLRPrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 10:47:12 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF9AA185
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 07:47:11 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w26so4719660pfj.6
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 07:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T9f0Ku46RA66RnD1s7kuU6MfXVLxET4cBAuDiB4K0jo=;
        b=SNvXj2jH+xBpXb3wcq7nWeCZhDXq2SmFyEUKBwDEa6gH7jOgUKlZ47pb8UGSry6HdP
         MeVhGk8A7BzTg0Pb2WLW/DNP+n3KZLa5K2JEatlB1zu4d3L6MsikaIVDsRxcoOhZHwW4
         yVsp+ZX8gIbUMyLeECAVoYXKW22ptbUv+o/uGZBpmwYeFf+lHkX2lsRJ6NqC3scjTwmD
         29FMrDysZmFZVpb4Cc1NsRuIrAIMOxmdMcuS9hWR//I7XUVP32RlFoAkNa8rRFPWYq8K
         n2dZp1SVaACPK2EWegJvlv+oUyrZMVk4lBfvPJkqlw/0vc2tY3/OUBCi+9Tju7/XcsTX
         lBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9f0Ku46RA66RnD1s7kuU6MfXVLxET4cBAuDiB4K0jo=;
        b=CNA/j7I6fkDsYs54QnkdMuWvaWfSUp542rzdny0AqKomQ1wRi5nxPBNIb3ICP1DtvP
         UVN6Xl4PUMCIZMMijSyBY4UASKqhsoZd97W98U7x9QCkRCUsLQ+8omtQclNnnsXBLJ1p
         uUPo4+oXGL5whwys+Lnhq1PN1UKz4OooJjtl8Vur9fAKFKDb9lEJGABYabPm7K+hOluP
         TZ/2pLSlS45FnfUN4NhXYOrEpta4a7n6NIHZ7vhtXXTK0fd4nwCYdOYZOmne59KpYa2F
         AI3/Lx9uH2egMJcfbWCwUU1ATAr0pka1BemEOE7+JLGvje6NJNXkEIUN4w6fge7Us7bv
         qnqg==
X-Gm-Message-State: AFqh2koTfyxTYCLuG9fvP4xptroPW9btFlZoTpt5sUjf95TPfXBagp5U
        cIiThqD8WEIEol7n8Y9qGyZCMXk4Z7UZXC9vYjg=
X-Google-Smtp-Source: AMrXdXtnSG/AtSyomholyXYX9GifJVebUvO6g3gW7b0AQz2+2GhCxvR/0jmF+OyiRb7Ek3NcVQlk0HKdqt0qLK8lS7k=
X-Received: by 2002:a63:4641:0:b0:481:5b48:9ea with SMTP id
 v1-20020a634641000000b004815b4809eamr1006424pgk.237.1671378430876; Sun, 18
 Dec 2022 07:47:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:ed12:b0:89:53d4:fc81 with HTTP; Sun, 18 Dec 2022
 07:47:10 -0800 (PST)
Reply-To: ab8111977@gmail.com
From:   MS NADAGE LASSOU <abubakarmusasani49@gmail.com>
Date:   Sun, 18 Dec 2022 16:47:10 +0100
Message-ID: <CAFo9wdTG92bmt0bJzfZiYGKn0OtGefyLaCLW=11XQ8R6RZ4tYg@mail.gmail.com>
Subject: REPLY TO HAVE DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4992]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:429 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [abubakarmusasani49[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [abubakarmusasani49[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ab8111977[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings.

I am Ms Nadage Lassou,I have important discussIon with you for your benefit=
.
Thanks for your time and =C2=A0Attention.
Regards.
Ms Nadage Lassou

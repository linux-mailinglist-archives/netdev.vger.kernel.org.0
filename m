Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE96F66007B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjAFMqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjAFMqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:46:17 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AC174580
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:46:16 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id t17so3257061eju.1
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8vxm9nlmqfcfK9RPJ/e/PtIJjgzKUGAWAwpPDcWlGVA=;
        b=pxwBwZzK8uYIfUb0JDTxRnUITAjwIShmosncekJ2NveCPjV9BRKnEbbovIkGk5m4/6
         lWwyVQ28solQ6L+ZMqcX3eeomZXHnH/sAY7DyxIeTYaLkNTbg+Esjou82uGQmvtV/OGu
         MT8s5jr3kPa3eYSGZ9GXbbN1Ps5YP6l2RZbIuq7U6u3SmEEkFeIaZQAvn3re7hLgsEbY
         2Y1jRNrUOT8DcgEDI5K2K2/SX0+5dKa3S46Lw57YxNThpjBNulvUxgtNFGxjzw5/pkXK
         hdoeiOT1KjnD3pTbEuR3tKa0qBSrgvMZ68gijw/Ajmr4tKHyIHX3TgCh9LjfsLylEV5V
         tK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8vxm9nlmqfcfK9RPJ/e/PtIJjgzKUGAWAwpPDcWlGVA=;
        b=AWDAV3ARe3yipYgNXXG98SpYVscY6D1AETAGXFfogvzORN/Pk3T82JWndzB94m1p43
         l6a6TbXl98fSXIpAaiWEA2Tbui98N1EgfhDCxyuu5MkKkGxYc25TNanBEoASOkHwXJRB
         6APIQNjx3NUHlaRhiu/HpJqZo4P1Y4HiL9UDlJz37f6w9ucTuhxvkTzmI10wLnkGo6wH
         Zmrq1LCrAIIY2i4WcPFbnNN+rjosbsmCHHiCR0Qw5bsFnorcK7DIRDWlpGtaMdgwI5pJ
         4a8xG01HxjMsys0xuM8bZxiY8edhk2Eu1DRzi+wOsi6zaNuAN2zmqozeh2+yaw74z80J
         K9rw==
X-Gm-Message-State: AFqh2kobwsF28aM+v6DuH0Ntuk1WprImH7tq5KeXvffi2ojVFSiMKmjw
        K49+DunLfvc2Md2SG6/jSm+vU7sXs8BAFq7FI20=
X-Google-Smtp-Source: AMrXdXuEX349ism00BoI0qMef6xfus9pgu4wd6/2MvIFdPHRvVGbOMkuEP7YN1JtJTULC5PO63OObDh9ueEAS5twHX8=
X-Received: by 2002:a17:907:d410:b0:84d:855:dd00 with SMTP id
 vi16-20020a170907d41000b0084d0855dd00mr539005ejc.438.1673009176065; Fri, 06
 Jan 2023 04:46:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:425:b0:45:bd40:f377 with HTTP; Fri, 6 Jan 2023
 04:46:15 -0800 (PST)
Reply-To: utbankutbank@gmail.com
From:   utbankut bank <haylagram653@gmail.com>
Date:   Fri, 6 Jan 2023 12:46:15 +0000
Message-ID: <CAHxAER5ApCME5rXxs-2ik6qLHLqo2iAhhZ-aJBEFgHvyX=jvtA@mail.gmail.com>
Subject: =?UTF-8?B?SEVKIEvDhlJF?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY,
        UPPERCASE_75_100 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:644 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [haylagram653[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [haylagram653[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 UPPERCASE_75_100 message body is 75-100% uppercase
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.4 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HEJ K=C3=86RE

DU ER BLIVER BEl=C3=B8nnet MED SUMMEN AF ($500.000,00 USD) TILSKUDSMIDLER
FRA INTERNATIONAL MONETARY FUND (IMF) EMPOWERMENT FUNDS-PROGRAM.

KONTAKT OS FOR FLERE DETALJER OM DIN BETALING.

MED VENLIG HILSEN
JENIA GREBENNIKOV
  WHATSAPP: +33605742762
BETALINGSAFDELELSE BNP PARIBAS
HALLO BANK PARIS FRANKRIG

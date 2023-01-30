Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9191A680858
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbjA3JRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbjA3JRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:17:52 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A490166D4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 01:17:49 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id n6so7625882edo.9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 01:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fsyHauj9EOBike+C7FSiVRVwoEoNyRE7eOJ4tqUZH+c=;
        b=I6hVgwuEb2qAtDRc86z56od1T+Rr+0NyR0JdBJIHf5sSP4kXLur6b77q5Z9QqSmKmA
         xRZUjlqFKB33w9zyKlri4YbC7b36Cu+GXwhhU7bNfVaL7WhGdeKWQtVWbCDUGcbYYeR1
         vPMAJI1Y+25PkoWeF0l9FLbW9yXwWP41OyjdWREk0DUZ9LAFgG5iuAGxZslPAY4EuQZU
         zJqnHzQbHwolrfTN+mriz1+LkAU11d7Bv6/fL5cK5cbSPWU0J0DtR7hHGvN4AhldSN1d
         FTqgUIQHX4BmAftwY+61++dc7762gTzE1rmYOU7ArEt4yjyI0HZ5qV5DZn/e3QstwZ/f
         khOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fsyHauj9EOBike+C7FSiVRVwoEoNyRE7eOJ4tqUZH+c=;
        b=yId/Qn6UXzs78tXU9qE5eZlejsJH5VL/vK1/8w+10i+gva1Z5q32c29Z2mFGdFDxQQ
         yxZhqazAO7bq5pAnDrm6QL5kLFNiudTsuJ9Oh9+764vuje5ejxzHfScs6yT1aj3zX1ns
         iNx+H+ho6ITGLve4xfBOfffLS0y4QcNHO3xWR+u3qMBYakXFxpJ5RFOU6oGDK8hHs32s
         po+tN/RLQOFDkuY4cZvVIuCrkaGX/G9C8qTJR4ZR+BiX6n5EwzKWGXxBiTF4DpISP25R
         VX9dmi+m92/Wfi3JVD9WanWi7VADV3L4GKLtsCtR1OE3QkjfmGdFvHws955MF4ktFHQR
         NMbQ==
X-Gm-Message-State: AO0yUKXexqxIpLjcr1BU+xB+VZsUsvnfTUjKz/8vhB7K8CEah2+FG4iC
        yhESCQtxfTSrLb9QEn2JmfQqveKbidBPxP/RkHw=
X-Google-Smtp-Source: AK7set9Y8+Q+T8LQGtEn5Yj+warU7MSGlB4pyIzNzhia07hUHkVU8hf3puloti/jrEBtFJWY06waWbJ0fCg2T3xEQuQ=
X-Received: by 2002:a05:6402:b63:b0:4a0:e4bd:6ea4 with SMTP id
 cb3-20020a0564020b6300b004a0e4bd6ea4mr3462397edb.35.1675070267620; Mon, 30
 Jan 2023 01:17:47 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7412:d08c:b0:8f:e183:fcc3 with HTTP; Mon, 30 Jan 2023
 01:17:47 -0800 (PST)
Reply-To: cristinacampel@outlook.com
From:   "Mrs. Cristina Campbell" <cristiinacampbell@gmail.com>
Date:   Mon, 30 Jan 2023 09:17:47 +0000
Message-ID: <CAKd_V8ad0ACojYC3jP-pOxJG+s+dKU5O6EZtJScSJOarekKXYA@mail.gmail.com>
Subject: me puedes ayudar
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:533 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cristiinacampbell[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querido amado,

Soy la Sra. Cristina Campbell de Londres, Reino Unido. Hay algo serio
de lo que debemos hablar. Si no est=C3=A1 demasiado ocupado, responda a mi
correo personal que es (cristinacampel@outlook.com) para que pueda
brindarle m=C3=A1s informaci=C3=B3n. este proyecto de caridad humanitaria e=
n su
pa=C3=ADs por valor de Seis Millones de D=C3=B3lares Estadounidenses
$6,000,000.00 usd.

Atentamente.
Sra. Cristina Campbell
Correo electr=C3=B3nico; cristinacampel@outlook.com

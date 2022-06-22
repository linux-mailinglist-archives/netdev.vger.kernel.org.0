Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0C0554882
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357317AbiFVJON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiFVJMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:12:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCDE2F034
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 02:10:40 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id g27so15799148wrb.10
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 02:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JjOjpc99NDX760QEnCLvwrwveLOaiPRbzlah8sRkfs4=;
        b=H0MvEEx4nv2731m1sxTWOBa0DG/vUofoKhmMlGpPJW4ek0EDoOq3VMzow08a9NeBc3
         hNbtNosx7zwn/J51Fd5D17ODE5IdnTMWN2iHOHFuTZ/oCqYw6cX5mDJN935dCUVYOPGk
         6GCO+AsM2/9bomImBmThVjl3FyUP9WzLU4un0xpQx/vylGd/F0PJCAW84WRzjdLJ10/4
         mNNJyXqzm6pl8spkNpp4br1elnjCU5DcXQrtp82Jz+8NzsgMroThq24wnlvG0Gngr8ES
         8VUYvG3A2k2xvXWo5IeKvFI0RFtdNj/J2526Sy8RXA+MXd/N3XY7vpS3D5WaNJzLJbqk
         +9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JjOjpc99NDX760QEnCLvwrwveLOaiPRbzlah8sRkfs4=;
        b=AteVbe9UFVUF95g2/D0pYXcHq46ptB4Mf2JphNySOnJs555IGpqkEf+cuKMy3+q8Ra
         GzEiDVCxXWCW19i5HDyYRCTyyN9o3uxL/oQJac0FGwv8SBaYPtI6xXIMcGNUFm86+pfZ
         E+A9fgDr9fEbxVq62yo5BLioKOnHKOKJ2CnVDaHPZgbyUGXZP7iiwXqB2RW4MpZBf8aN
         OgklKqu17ameGDMmR6B/twYNTL7fvpONwVFLIdcSek0pZ7UTwyPG2jKx3p5pWbNrrQwh
         DycM7v/+5KpnNQN5JJeEZjR/KYVnM0wl93WXxlwahxpDFmMt62fwpdKcIocULLebbNUb
         RVAw==
X-Gm-Message-State: AJIora+tAgFfun2DBQozeztwVaVXZNR07q3r7J/Gb/IZZHSWzmkPHiBq
        h/WNeyYmO+1CEQzIATbxSEhNkKIKbPOKFDnD1NU=
X-Google-Smtp-Source: AGRyM1sFeD9IuK1urDNXoAwJ7ENivg2G+k17pYT2EBw1lsxJrPhk4PcGWGJf/JPfaTKy2E3rJXkHysFIEFmff11EWj8=
X-Received: by 2002:adf:e6d2:0:b0:21b:9580:8d8b with SMTP id
 y18-20020adfe6d2000000b0021b95808d8bmr2262272wrm.120.1655889039046; Wed, 22
 Jun 2022 02:10:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64cd:0:0:0:0:0 with HTTP; Wed, 22 Jun 2022 02:10:38
 -0700 (PDT)
From:   nnani nawafo <nnadinawafo11@gmail.com>
Date:   Wed, 22 Jun 2022 09:10:38 +0000
Message-ID: <CAPhDfr1-0koOftG3Hwt=8PMP8nOXa0WmTn756bhztS4AvYi=ag@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,MONEY_FORM_SHORT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Herzliche Gl=C3=BCckw=C3=BCnsche!

Die Vereinten Nationen sind zu dem Schluss gekommen, die Zahlung eines
Entsch=C3=A4digungsfonds in H=C3=B6he von sechs Millionen US-Dollar
(6.000.000,00 USD) an gl=C3=BCckliche Beg=C3=BCnstigte auf der ganzen Welt =
mit
Hilfe des neu gew=C3=A4hlten Pr=C3=A4sidenten aufgrund von Covid-19
(Coronavirus), das zu einem wirtschaftlichen Zusammenbruch gef=C3=BChrt
hat, zu billigen verschiedenen L=C3=A4ndern und globale Gefahr f=C3=BCr so =
viele
Menschenleben.

 Die Vereinten Nationen haben die Schweizerische Weltbank angewiesen,
in Zusammenarbeit mit der IBE Bank in Gro=C3=9Fbritannien die Zahlung des
Entsch=C3=A4digungsfonds freizugeben.

Die Zahlung wird auf eine ATM-Visumkarte ausgestellt und an den
gl=C3=BCcklichen Beg=C3=BCnstigten gesendet, der sie =C3=BCber die IBE-Bank=
 im
Vereinigten K=C3=B6nigreich =C3=BCber ein diplomatisches Kurierdienstuntern=
ehmen
in der N=C3=A4he des beg=C3=BCnstigten Landes beantragt.

Dies sind die Informationen, die das Management des Vereinigten
K=C3=B6nigreichs ben=C3=B6tigt, um die Zahlung des Ausgleichsfonds an die
Haust=C3=BCr des beg=C3=BCnstigten Landes zu liefern.

1. Ihr Name:
2. Heimatadresse:
3. Stadt:
4. Land:
5. Beruf:
6. Geschlecht:
7. Familienstand:
8. Alter:
9. Reisepass / Personalausweis / F=C3=BChrerschein
10. Telefonnummer:
Kontaktieren Sie unsere Agenten-E-Mail-ID:
Name Solomo Brandy

EMIL-ADRESSE (solomonbrandyfiveone@gmail.com) f=C3=BCr Ihre Zahlung ohne Ve=
rz=C3=B6gerung,

Mit bestem Gru=C3=9F
Frau Mary J Robertson.

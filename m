Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE45A55098D
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 11:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiFSJxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 05:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiFSJxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 05:53:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24182389D
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 02:53:08 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id es26so9680764edb.4
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 02:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=nh3ZD65D32/fZ3N1YJgKsF6BbVrgL/cziKmiqymtAI4=;
        b=Uywi6jBeOis8UM4h/8ysgh76GyaTh8mQS3yWHgFyEC6zonoAMxwqY8e+TFh/SVONgF
         NFGdzJ8VsbYCop0XvtBk4a01AocfN7+ulCQS2kJjBv6GNd85VlS+MIHH81xAz+Y1X+Jv
         aoS1ECDuwsSvyoPOdjcaKGJCE86hxtk0/6qkYz08H1qJoNoOp4NCcGqh5rV7Kr7UOFIl
         v7RWSfnZ+Kaj+nVYZgoOZk/1k3pfYZ3R8fNL8waBtXuWWMlCdLPMZdwnsTxKU3dZnxAw
         vkmCqFJaSfcMMRoHk9pL/N2Knwh9Zwx8MtOxxy2yJLwXL1jHVDUNW7RrueQX5Mb8PIZy
         af9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=nh3ZD65D32/fZ3N1YJgKsF6BbVrgL/cziKmiqymtAI4=;
        b=GCoyXGDilSc6BjaOzTxH+BUnd5YMJWSVoPWGBYCtGsE6OarNsB+UOEKob8HEs6rYwh
         rYEWPN+iO8ng9cC8A/qcUGVGKAGduW5k0DZwlg+ur+SnfBGP8WjuYmffoTELT51wz+wu
         a5vLHyaM87jtfh4pY2Ndh8OKbu5F8jVwlaefdqxPMkzI1/JbjJkvVTLq+MbtXiTRBDLS
         3MmVQKN0TFTIAL5+KpBWG6jdZHlpDyFIon+HJg5rXscnkOuXp5jMkSeM19xdr4zzYU2o
         XkapCjKM8dS5v04ShGfJE2SseOe2uydJlSwkf7fwCWYR4S0U4Ubf/qbB6dSda2k2Qnao
         6b5A==
X-Gm-Message-State: AJIora/1njsLPntp8kpb1CsYrfA1olzhXt7b7S5/tJRf+SJB1jaFarzQ
        KG7ky82ObT5u5FVYkar7gjiQIIovygKXq0syCgg=
X-Google-Smtp-Source: AGRyM1uWGtqqHAMmKxX/IQAuW1M1vc5ds/sI6ggZDH92Gskm113ZFcDmVrrz/AFxQnUlR0MnJv3rNle6GLQrxxJe5K0=
X-Received: by 2002:a50:fb86:0:b0:435:7f5d:4cb5 with SMTP id
 e6-20020a50fb86000000b004357f5d4cb5mr1462697edq.163.1655632386754; Sun, 19
 Jun 2022 02:53:06 -0700 (PDT)
MIME-Version: 1.0
Sender: elizabeth.hoisington1@gmail.com
Received: by 2002:a05:6400:420c:0:0:0:0 with HTTP; Sun, 19 Jun 2022 02:53:06
 -0700 (PDT)
From:   Frances Patrick <francespatrick101@gmail.com>
Date:   Sun, 19 Jun 2022 02:53:06 -0700
X-Google-Sender-Auth: SblPgJQEDD3b-GwGKx6SjtabEME
Message-ID: <CANhm-9v=-0rzZFVUAST9T1Hb18Wjkp1A4Rahqp2rHDx0726h8Q@mail.gmail.com>
Subject: Donation to you
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hello, Dearest Friend,

Two Million Euros has been donated to you by Frances and Patrick
Connolly, we are from County Armagh in Northern Ireland, We won the
New Year's Day EuroMillions draw of  =C2=A3115 million Euros Lottery
jackpot which was drawn on New Year=E2=80=99s Day. Email for more details:
francespatrick101@gmail.com Looking forward to hearing from you soon,

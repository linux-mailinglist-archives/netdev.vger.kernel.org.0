Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3715BBE2E
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIRNte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 09:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiIRNtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 09:49:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87798DF1
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 06:49:29 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id l14so58965957eja.7
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 06:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=wa8SGrPfJuXDO9w5AD7vftmXEaA2f9MpXygj0s+i+Ek=;
        b=X28tpF7SCj9G1pwBPLaY4Ugx6SLF2gFhu0MzTPIwQeBE3GND90DEW+2CfKQnS8753P
         IWQF4SHzWSELlw9wH9Y36CqfjGaZ0choPGPWBZsHa1JnQZP2T+DCO3mZDBerHVxbIvso
         4lK+OOkUF3WDeBjTcIu7JMn37nEkD0vGa5AsMm6MnmPl5P+LpSImIy0rDdXuLN0OpDR/
         w3NVvin2xTtoppalm9ulYeGjouDzqSEko3pTyaMQuhydVSp5KmsUD9P1R/dG3u7Jbj1f
         o+NoIX1aNT34ka8wJ/KRmBfrZX0b1FKR7qn8PcCe8Aq8r7U58QOEE9Ru3p/Q4A7/7kfy
         wflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=wa8SGrPfJuXDO9w5AD7vftmXEaA2f9MpXygj0s+i+Ek=;
        b=OQYUBPdz/PprKOEOqbATLUibjkaH42z6gc6r905j1I4Kr6lKMQdkdPgXLVVXoI+HTL
         tn4+MQnJEaos22vScK+Pu3RXdCkW93HpWW0gn8+mW/VTT7TK42oJHe/ajhhKAJSLLQ05
         B1ZKb3wcDm56csi3EBp+51NqGtAAbmZF8vk63Ti+yHM9XYWtdOow5cuTdXUC9MIB9WJr
         W7g/1OXmYY3/bghhvuTmOw0IRYh+NqFU7MEgEM5l/E9U9QGCMgyRtQ+MWMpq3uYGDdWr
         SL//nsraavtPHFOh+REExUisNMRVxDcqwZmoKynux8ntK/tzX0jKVQv1ToJBhbqjpCRu
         3Huw==
X-Gm-Message-State: ACrzQf0lAttYEC/bMiVGrQzva/1/scbR94UhZ3SeoAxmT08Mw52lCAfK
        5w2MiNxSxWeZw+QynSE/xNkV+qvdrJU=
X-Google-Smtp-Source: AMsMyM5pYZ14o0AakF1Vy41QvbySQ+K6q1wfpH6msvxxJnI9faHHzwvGSTrRi/6RMRSqKepLqHRxXw==
X-Received: by 2002:a17:907:9495:b0:780:6ace:7a97 with SMTP id dm21-20020a170907949500b007806ace7a97mr10141236ejc.123.1663508968019;
        Sun, 18 Sep 2022 06:49:28 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id b17-20020a17090630d100b0077f15e98256sm10008517ejb.203.2022.09.18.06.49.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Sep 2022 06:49:27 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <YybvTYO2pCwlDr2f@kroah.com>
Date:   Sun, 18 Sep 2022 16:49:26 +0300
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>, pablo@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <91719698-62E7-4447-8220-CBA64F0BB5C9@gmail.com>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
 <YybvTYO2pCwlDr2f@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg

Yes still receive this message in dmesg this is kernel 5.19.9 :=20


[139332.936463] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139338.378022] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139343.751591] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139344.298109] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139346.316550] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139352.051963] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139357.313180] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139366.041831] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139369.392042] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139369.754771] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139370.671093] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139373.234022] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139379.207071] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139379.207071] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139390.159412] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139393.027810] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139394.111100] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139399.024882] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139428.527908] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139429.731192] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139432.777940] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139440.371972] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139441.533634] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139448.621347] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139465.020467] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139473.003938] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139477.078950] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139497.013588] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139512.774300] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139522.770475] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139535.346545] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[139540.973242] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?

any idea how to debug and find from where is come ?

Martin

> On 18 Sep 2022, at 13:13, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Sat, Sep 17, 2022 at 11:03:55AM +0300, Martin Zaharinov wrote:
>> HI team
>>=20
>> This is NAT server with 2gb/s traffic have 2x 10Gb 82599 in Bonding=20=

>>=20
>> one report if find any solution write me :
>=20
> Is this new?  If so, can you use 'git bisect' to find the problem?  Or
> has this always been there?
>=20
> thanks,
>=20
> greg k-h


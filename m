Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEF061466A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiKAJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKAJMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:12:15 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C6E6432
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 02:12:14 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i3so12900358pfc.11
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 02:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4WyfxtGfbWDpg3CPgwTXEAz7LkMFf4xGMQJBUuZZ/1Y=;
        b=dChRdim5xO6pFjfnlWCVabxkbWD8XMy5kpDmmEPcGOhjGcCUm6QuQp/83l2gKDM5rv
         N9SGCWIEM8LABDKg5wpOpERFPBMVig05EhckzRnDRpaytmlKX9hJbPzT8j/LpN7eDa+9
         6fWu/IdRXl+msTfZfMv7jTTdY5vpLxVQ4gkFEAf2Vav7DMhf5QOiEeZHTcPpveA0ZMU4
         WODTi/0HlHSn2hDnmyW4kF0f/rjd5KxOY2hGU4XwLtsoF7dBqY4Te896DzGVEFrfFqNZ
         3XTmiM0cMtjWr/SnkERPuC8rb4sbltvJPH6nlpH48hYLrs732O100adWhmMymP1/togE
         agPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4WyfxtGfbWDpg3CPgwTXEAz7LkMFf4xGMQJBUuZZ/1Y=;
        b=huPIfjGS/eA2vaJfE31W7c0dhpwsd3fONxOHPkyG4kcCsDV4Ca6CJuoq4iVvXMTpGs
         v4wa/WGPTiDxcxXTpl6ZRohfxz3To7ym/wGLVc7Uf/LCZwx3P34qSGPLlVyGW6xbhBpd
         S0cyRvYfEvFM2MfdIbsu+bqXaC6jr2W+oEmlXyh1jDdWStn4hIeqsjQtbEvc/Fun1/lV
         3DAcYzCmND1z06FULfQB/qS0iftAm45sVQCrEe8Rqe/KH7SM7TCbr6LkS4IX+VL6KyHQ
         tj8QY+/UpnR6R0Apm34kLkysGbG5F6rWcbGqVXvZMQrEfY5TNzJkeP2WrMsTXD4txZ26
         7DTQ==
X-Gm-Message-State: ACrzQf1oJ06M5DHDa7oCZHM3klZOiw3imGjJ8r5Laoee8h5ftKiptTtM
        T0xmgi3J8Wi0TmWhwX0ZLt019riFmSD9tL6v4EM=
X-Google-Smtp-Source: AMsMyM4Tk3P4wZuG11/Xjd8vAmCUU22WrjToGH6WFkHe6c+IVJNxOPEKQHN5w3/L9/MqvSUKzEgAoKJ27u9nsLYsopQ=
X-Received: by 2002:a65:4bc3:0:b0:439:103b:fc35 with SMTP id
 p3-20020a654bc3000000b00439103bfc35mr16306466pgr.248.1667293933937; Tue, 01
 Nov 2022 02:12:13 -0700 (PDT)
MIME-Version: 1.0
Sender: gaterefoyiuut@gmail.com
Received: by 2002:a05:7300:72c8:b0:7a:58ce:c095 with HTTP; Tue, 1 Nov 2022
 02:12:13 -0700 (PDT)
From:   Felix Joel <attorneyjoel4ever2021@gmail.com>
Date:   Tue, 1 Nov 2022 09:12:13 +0000
X-Google-Sender-Auth: oS9azPA4J9sjOVNFJqOqoaXVC4k
Message-ID: <CAGU9bY7ZqxCAFceu7gB9ohj4d9B-iZ6pMQptKzDw-nyks1ByFQ@mail.gmail.com>
Subject: =?UTF-8?B?xI1la8OhbSBuYSB2YcWhaSBvZHBvdsSbxI8=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Dobr=C3=A9 r=C3=A1no
Jsem advok=C3=A1t Felix Joel. Kontaktoval jsem v=C3=A1s ohledn=C4=9B tohoto=
 fondu 8,5
milion=C5=AF dolar=C5=AF, kter=C3=BD zde ulo=C5=BEil m=C5=AFj zesnul=C3=BD =
klient, kter=C3=BD nese stejn=C3=A9
jm=C3=A9no jako vy. odpov=C4=9Bzte na dal=C5=A1=C3=AD podrobnosti,
D=C4=9Bkuji Ti,
Advok=C3=A1t Felix Joel

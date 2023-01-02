Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88F65AE55
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 09:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjABIpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 03:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjABIpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 03:45:23 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86BA21BA
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 00:45:22 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id jo4so65287412ejb.7
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 00:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4ynmcCY0103cQS7shT8htJ05xNl57Tm24f0RGRNG57w=;
        b=SO+iX62QOho1h8L5mQFhsx1SSwU6axwQ9Rlc9OFctsoe8qHgNGPB8wTkChhkFbgk7K
         5+CPBzQS1FxVKgdbLsmE1F6PwkiL9z7o3Wy3wGjTjUEDhXVhi3cuNT3EBNQsZpUeUCuL
         jnCwISfskG7lkaNFjnIARbqjEsOgH6gF2Sxqftj/bAew6+XkdGPMz//2n5P4xNndFrsA
         flNcTkBtzL3G8zIT9bBICGvBcimwPsp8BIkOEyr6pRsX9wFHH3d0R9EOFMBde4v0OLLE
         DYOQDLCeWVjP8qHukekMQRjeKWpJSH8s7UnQbh9VNySe8uvMGjJkOVlZCH2omDDk3WU9
         NqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ynmcCY0103cQS7shT8htJ05xNl57Tm24f0RGRNG57w=;
        b=u+37y4YpLn0+7/DnhK5JVljtBLP0PUFCYbz5Qh7Nwl3tm2o1rVcMYVm/OpJr7pJjwN
         N8Zaqs3Zu/vmWl+qaz6yhJID4SN7zhJ5ndnr5Lw8pXKJEz/r9Url4yW6XyORjkeNVaCq
         FRA13KIQc7gk87fhKEDEBYrM3t45i9LdJBlW0ryaVY/O3zetbfg83G3mN0k2zQaK90O0
         YwHVk/paoIIH7CLOEyHoTAHyguqI5OepgGD44XqBKDCc/LLv5+UBBx62B2AlOjcPT3lc
         GIDBIBbjHzVmiZ6U98zGq0Ek2QFmhh6WRGKN0WNCXQAFZcqhXSDcstl15e6H4CUkQhTu
         OS0A==
X-Gm-Message-State: AFqh2kprNZN6ffF8dHc1UIsQjfhunmqfSatQ8FHcAYiqjWydLNLx+8PO
        AS8A7DWKG/BRsc8iExX1BWXYeJ1ugpv5v5Za7qY=
X-Google-Smtp-Source: AMrXdXsYB1qgdNLTW8QgUvtFgGdBYp9VyrFhE4giXPLf2QJ2chZz/V9h5I+w2i8KVHQY6NkjTJY/qerUfceZ8vA9h9k=
X-Received: by 2002:a17:906:7210:b0:7c0:9f04:1938 with SMTP id
 m16-20020a170906721000b007c09f041938mr4190476ejk.769.1672649121038; Mon, 02
 Jan 2023 00:45:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6408:2614:b0:1db:c553:c143 with HTTP; Mon, 2 Jan 2023
 00:45:20 -0800 (PST)
Reply-To: jodiedwilliamsnnn@gmail.com
From:   "Jodi D. William" <khigginsnn@gmail.com>
Date:   Mon, 2 Jan 2023 00:45:20 -0800
Message-ID: <CACdkXMhLWqoyJWapMFrGyWGNWPmj0ZngQ8p31E9h85TuCh_2-A@mail.gmail.com>
Subject: Proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R29vZMKgZGF5LA0KDQpJJ23CoEpvZGllLMKgScKgc2VuZMKgbXnCoGxvdmXCoGFuZMKgZ3JlZXRp
bmdzwqB0b8KgeW91LMKgSG9waW5nwqB0aGF0wqB5b3XCoGFyZQ0Kc2FmZcKgaW7CoHRoaXPCoENv
dmlkMTkuwqBQbGVhc2XCoHBhcmRvbsKgbWXCoGFzwqBJwqBhbcKgYXdhcmXCoHRoYXTCoHRoaXPC
oGlzwqBOb3QNCmHCoGNvbnZlbnRpb25hbMKgd2F5wqBvZsKgcmVsYXRpbmfCoHN1Y2jCoGFuwqBp
bXBvcnRhbnTCoG1lc3NhZ2XCoHRvwqB5b3UswqBJwqBkaWQNCnRyecKgd2l0aG91dMKgc3VjY2Vz
c8KgdG/CoGxvY2F0ZcKgZWl0aGVywqB5b3VywqBjb250YWN0wqBBZGRyZXNzwqBhbmTCoEkNCnJl
c29ydGVkwqBpbsKgY29udGFjdGluZ8KgeW91wqB2aWHCoGVtYWlsLsKgTm90wqB3aXRoc3RhbmRp
bmcswqBJwqBrbm93IHF1aXRlDQp3ZWxswqB0aGF0wqBSZWNlbnRseSzCoHRoZXJlwqBhcmXCoHNv
wqBtYW55wqAnJ0hPQVgnJ8KgZ29pbmfCoG9uwqB2aWHCoGludGVybmV0DQphbmTCoGl0wqBpc8Kg
ZGlmZmljdWx0wqB0b8KgdHJ1c3TCoGJ1dMKgacKgZG9uJ3TCoGtub3fCoHdoecKgbXnCoHNwaXJp
dMKgc3RpbGwNCmFjY2VwdGVkwqBtZcKgdG/CoHNlbmTCoHRoaXMgbWVzc2FnZcKgdG/CoHlvdcKg
b3V0wqBvZsKgZmV3wqBlbWFpbMKgYWRkcmVzc2VzwqBpDQpnb3TCoGZyb23CoHRoZcKgaW50ZXJu
ZXTCoGluwqBzZWFyY2jCoG9mwqB0cnVzdMKgYW5kwqB0cmFuc3BhcmVuY3kuwqBUaGlzwqBpc8Kg
YQ0KdHJ1ZcKgbGlmZcKgc2l0dWF0aW9uwqAmwqBpdMKgaGFwcGVuZWQgdG/CoG1lLg0KDQpIb3dl
dmVyLHRoaXPCoGNvbW11bmljYXRpb27CoHdpbGzCoGJlwqBhwqBncmVhdMKgYmVuZWZpdMKgdG/C
oHlvdcKgJsKgeW91cg0KZmFtaWx5LEnCoGtub3fCoHF1aXRlwqB3ZWxswqB0aGF0wqB3ZcKgaGF2
ZcKgbm90wqBtZXTCoGJlZm9yZSzCoGJ1dMKgR29kwqB3b3Jrcw0KTWlyYWN1bG91c2x5wqBhbmTC
oHJlLXVuaXRpbmfCoGhpc8KgcGVvcGxlwqB0aHJvdWdowqBoaXPCoG93bsKgd2lsbMKgYW5kwqBn
cmVhdA0KYXRvbmXCoG9mwqBmYWl0aC7CoEnCoHdpbGzCoHRlbGzCoHlvdcKgZXZlcnl0aGluZ8Kg
JsKgaG93wqBpdMKgaGFwcGVuZWTCoGFzIHNvb24NCmFzwqBpwqByZWNlaXZlwqB5b3VywqByZXNw
b25zZS4NCg0KSm9kaWUNCg==

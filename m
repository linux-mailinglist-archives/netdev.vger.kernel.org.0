Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD03A2FB3AA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbhASICj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731352AbhASIC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 03:02:26 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032F1C061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 00:01:46 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id c12so7557920qtv.5
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 00:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CseN3BiBpJYn6k+hUUx2TxuA3gS6VM1QHXLDLxQNUzc=;
        b=UBvG6hkUyLZjWy0hsjvaYTphAmqRC+H2orazmP6uGcRmssQudFcx/Gs4CQLKj0sAzp
         cV2h3Y7V9o7OkJKsXnbyDr9sa+7M5h72AD5Ezv90H/NoJjP9aEouqAD8aQcjxgqadasu
         BSvQ/RYUVhHok16P9QPmap6cK/14aBCvqnQzUU4MKXX2GykKUyXJYW8n+3fdV9weOf5R
         XG190147Bx2gdYJ0g8v9TBnaKl4xbYUvJgsEOPGDb97sRABBUi49f2sFZxdDkuQoRHk3
         zPvWPWm9f6/fLxS+qGGIsUAsjMIyb8h7/+7UjLlWUbmQF/zjX8sm2H1p5xteG4QcVcav
         XQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=CseN3BiBpJYn6k+hUUx2TxuA3gS6VM1QHXLDLxQNUzc=;
        b=s8UCxuniA56Ot0ceLSQwg9a4pfsd2gb4XnW61Ys9qagt8rVbBX23ttHUMZDNSZt+cN
         ybycgkIpMsaWnYfnwC72AQkZVMCGHUQe5ZyTl78UCO9L7we5ZAJ3MhlMLpDNCWYrQpJD
         Bfuka1rW3tTB6QRcXRjudOhzyI5rgeKBr0ODgYWOkmEStbwd4moMiBng1lVitNvjSWpz
         rCAx8ei4hM2IWwh9Srxi0pKwbK/sZYvWfta7s/3NPqYoqbcyzDvnRKGv0VGitsRIMYMJ
         SdQAQqFpTf+8+c+sszis5qIQvKzCYYl/pntQPR5bF78IInJSJt0lA75+SOgDIdnab982
         p2pw==
X-Gm-Message-State: AOAM531y+SV1yb0agqGt2rqO6ymc2WX9XQBkek2qwFrnweq9gkdSZBo9
        6Jorg1xDVXT0RNSWguE5XGAotw9yG87WkUUzQYw=
X-Google-Smtp-Source: ABdhPJyU1bpl9sx+z8D2DtmM2guP5aUHtk0DgtP+zJPwEgUJFaYnnB2ELTY7jl0GhQ7cIJc1nRdGH/udjkDcCtOakLo=
X-Received: by 2002:ac8:4c85:: with SMTP id j5mr3005251qtv.161.1611043305238;
 Tue, 19 Jan 2021 00:01:45 -0800 (PST)
MIME-Version: 1.0
Reply-To: paulwagne7@gmail.com
Sender: alimahdi687@gmail.com
Received: by 2002:a0c:f9d0:0:0:0:0:0 with HTTP; Tue, 19 Jan 2021 00:01:44
 -0800 (PST)
From:   Paul Wagner <pw9076424@gmail.com>
Date:   Tue, 19 Jan 2021 09:01:44 +0100
X-Google-Sender-Auth: AFtSmq4khbyz5DckuSEs2u6yDeU
Message-ID: <CAJR5xJdphR5nRuNbxtT_t7sSTa03AUwocaJBG4FwZoHFcns=zQ@mail.gmail.com>
Subject: =?UTF-8?B?U2Now7ZuZW4gVGFn?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo,

Mein Name ist Paul Wagner, ein Familienanwalt des verstorbenen Herrn
Thomas. Ich habe einen Vorschlag f=C3=BCr Sie bez=C3=BCglich meines verstor=
benen
Mandanten Thomas . Bitte schreiben Sie mir f=C3=BCr weitere Einzelheiten
zur=C3=BCck.

Gr=C3=BC=C3=9Fe
Paul Wagner

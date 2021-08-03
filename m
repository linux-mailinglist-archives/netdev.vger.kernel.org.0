Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347DD3DEE04
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHCMlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhHCMl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:41:29 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32904C06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 05:41:18 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id e14so2115473qkg.3
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 05:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=S0uekF9h3D7pZJovoHrYAJpvb9GPM07lWTxjMvDOXE0=;
        b=js7dZ5xV3quOtQibxErEWOSVpudLI6Ty1Gih1sD7U1eUgbEa/z8bpRHEI05nNEnPy2
         4qIkd6d/kQxlrtGtQhpkH0KqJMAqrndo1MVMxuLMoEl+HkoqKbeuJI1YggO6GsdGhUV/
         L6igvW8M4P3gpKJdutg9m0Zu1F1R0PJfMOC2PTFzgKRc1o/5HB1Pr6ED5axX6QkFV8St
         bWGORh4YOxuEHqLukUNwcT/Ucm1X9umO/50cB1FAhxu1iDb4NnnoHB1xOxV/0UZRFI3u
         0SkJ85tozXJU8CKEFJoH2pU5JmYPi1G0vyxhhzBu4hpm4+V2AsIGjORs9JAYK3YXhaV0
         /Bqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=S0uekF9h3D7pZJovoHrYAJpvb9GPM07lWTxjMvDOXE0=;
        b=dUT0Wc2QXURvcNsCi+v/GVnFXTyYS/WEXTlFQKcfEdJFn+4jyULe6n736kWe8qoYVa
         MPN8GLRMCgojh6iNDTaoqcCFYlP2hpbZ7VoXVwAMF3eDCClUeb4kAbWhS2deckFLxyEz
         2J4RVxuOma1W68+oJZ62RwM3n99z/1DVGCzRBA/Yff1TYWIUHWtn1WcPIeskFJIKplWp
         quFSoLs4MyCthKqnMUIjxFqAd31jEoOzv/uCGrD9kVuoXxg1d63jD2RHcbksRSkf5PYU
         KMUfi0NqeuEmPjyBlPGeBgvWaTxOXIrrmVhbv7wNtRjg5oRGbbqked8dBjNd/t9eCaRm
         t7UA==
X-Gm-Message-State: AOAM533y/j+DxF/2jSCU2d4CwqwfWgjfOCNBaTB020PBfHOPEGerDzLw
        UyxrGgkJ4t/d/6+3AyzRogaQktam+VDdP+M5yJ0=
X-Google-Smtp-Source: ABdhPJwjW3F/LwTTDR3CJfttDZwV5OYepx0YoNGU6iYP4xzj2sx3xuovWICfgmzBuuu+0LMKrXTaGMxJZHeusVFh/kg=
X-Received: by 2002:a05:620a:1399:: with SMTP id k25mr20109627qki.255.1627994476493;
 Tue, 03 Aug 2021 05:41:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:7f82:0:0:0:0:0 with HTTP; Tue, 3 Aug 2021 05:41:15 -0700 (PDT)
Reply-To: abdoulayehissenee2@gmail.com
From:   ABDOULAYE HISSENE <fabricegomey@gmail.com>
Date:   Tue, 3 Aug 2021 05:41:15 -0700
Message-ID: <CAJbyybjk50AQ-FtVN53w1_y6YvN4eiq8AW+MokDQu29cmkiX7g@mail.gmail.com>
Subject: Re:bonjour
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qm9uam91ciwNCkplwqBtJ2FwcGVsbGXCoEFiZG91bGF5ZcKgSGlzc2VuZcKgZXjCoE1pbmlzdHJl
wqBkZcKgbGHCoEpldW5lc3NlwqBldMKgZGVzDQpTcG9ydHPCoGVuwqBSw6lwdWJsaXF1ZQ0KwqBD
ZW50cmFmcmljYWluZcKgcMOocmXCoGRlwqAzwqBlbmZhbnRzwqBkb25jwqAywqBnYXLDp29uc8Kg
dW5lwqBmaWxsZcKgdG91c8KgZXhpbMOpcy4NCkplwqBkaXNwb3NlwqBkJ3VuwqB0csOoc8KgYm9u
wqBjYXBpdGFswqBhZmluwqBkJ2ludmVzdGlywqBkYW5zwqBwbHVzaWV1cnMNCmRvbWFpbmVzwqBy
ZW50YWJsZXPCoGV0wqBzdWlzwqDDoMKgbGENCsKgcmVjaGVyY2hlwqBkJ3VuwqBib27CoHBhcnRl
bmFpcmXCoGNlwqBxdWnCoG1lwqBwZXJtZXR0cmHCoGRlwqBtZcKgbGFuY2VywqBkYW5zDQpwbHVz
aWV1cnPCoGludmVzdGlzc2VtZW50cy4NClNlcmllei12b3VzwqBvdXZlcnTCoMOgwqB1bsKgw6lj
aGFuZ2XCoHTDqWzDqXBob25pcXVlwqBwb3VywqBtaWV1eMKgdm91c8KgcHLDqXNlbnRlcg0KbWHC
oHByb3Bvc2l0aW9uwqA/DQpTacKgdm91c8Kgw6p0ZXPCoGludMOpcmVzc8OpwqBkb25uZXotbW9p
wqB2b3PCoGNvb3Jkb25uw6llc8KgcXVpwqBzb250wqBsZXPCoHN1aXZhbnRzOg0KMcKgL8KgVm90
cmXCoG51bcOpcm/CoGRlwqB0w6lsw6lwaG9uZcKgcG9ydGFibGUNCjLCoC/CoFZvdHJlwqBub23C
oGV0wqBwcsOpbm9tDQpBdcKgcGxhaXNpcsKgZGXCoHZvdXPCoGxpcmUNCkNvcmRpYWxlbWVudA0K
TXLCoEFiZG91bGF5ZcKgSGlzc2VuZQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fDQoNCkhlbGxvLA0KTXnCoG5hbWXCoGlzwqBNcsKgQWJkb3VsYXll
wqBIaXNzZW5lwqBleMKgTWluaXN0ZXLCoG9mwqBZb3V0aMKgYW5kwqBTcG9ydHPCoGluwqB0aGUN
CkNlbnRyYWzCoEFmcmljYW7CoFJlcHVibGljwqBmYXRoZXLCoMKgb2bCoDPCoGNoaWxkcmVuwqBz
b8KgMsKgYm95c8KgYcKgZ2lybMKgYWxsDQpleGlsZWQuScKgaGF2ZcKgYcKgdmVyecKgZ29vZMKg
Y2FwaXRhbMKgZmluYWxsecKgdG/CoGludmVzdMKgaW7CoHNldmVyYWwNCnByb2ZpdGFibGXCoGFy
ZWFzwqBhbmTCoGFtwqBsb29raW5nwqBmb3LCoGHCoGdvb2TCoHBhcnRuZXLCoHdoaWNowqB3aWxs
wqBhbGxvd8KgbWUNCnRvwqBlbWJhcmvCoG9uwqBzZXZlcmFswqBpbnZlc3RtZW50cy4NCldvdWxk
wqB5b3XCoGJlwqBvcGVuwqB0b8KgYcKgdGVsZXBob25lwqBleGNoYW5nZcKgdG/CoGJldHRlcsKg
cHJlc2VudMKgbXnCoHByb3Bvc2FswqB0b8KgeW91Pw0KSWbCoHlvdcKgYXJlwqBpbnRlcmVzdGVk
wqBnaXZlwqBtZcKgeW91csKgY29udGFjdMKgZGV0YWlsc8Kgd2hpY2jCoGFyZcKgYXPCoGZvbGxv
d3M6DQoxwqAvwqBZb3VywqBtb2JpbGXCoHBob25lwqBudW1iZXINCjLCoC/CoFlvdXLCoGZpcnN0
wqBhbmTCoGxhc3TCoG5hbWUNCkxvb2tpbmfCoGZvcndhcmTCoHRvwqByZWFkaW5nwqB5b3UNCmNv
cmRpYWxseQ0KTXLCoEFiZG91bGF5ZcKgSGlzc2VuZQ0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E03622ADBE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgGWL27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgGWL27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:28:59 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3766FC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 04:28:59 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a1so5965472ejg.12
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 04:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=nnu0NRmUPcKn4fQa0wev1nnzODNwOYJZaD0Q5nkQ7Z4=;
        b=gfZ6PPtsLVzQNXU2S6KCU0rnhFfCd0ZJLwurMW3CfRqnID+9B+SXoQ4/CjuAgrxOpt
         dSIQ2A/j2w57u0Ke+3W7duIOFkcTTmqTeHcyEUSOK4sqxnS2brAOPHbvNllq3HcVUT7n
         1Dc9ytbxDy+T0jjOuyo9I/LxivHfhOyGBADHTJn/EtxUTO9WDEwHrXAZ0eJv2j4SjMuf
         lt/AlQZUagbz6XyI87syijk7XqeceZVCodl839xpWYry507jw4eBwMdZiOITjX6heb/c
         oDmiy4ghgBlDCiwqRrNgXBRCGWoz0/6mS6W7mMeSsKTnoVT+2KGgnwssrPpoOCDAEXWk
         TWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=nnu0NRmUPcKn4fQa0wev1nnzODNwOYJZaD0Q5nkQ7Z4=;
        b=WG/XZKFVy24AFqy3pdBKKw/fpFNwtAToOneU5JWohUsSTtfOQLxaYNs3xZDdutWVGU
         RejmSJJoCUKQWnlAJulSec6P1dB44AKUyAxP71j8uaynASN6o4EwGTHJAvxkCo+uBRSD
         yJ6vAg6kp326wdY8zrBlJ3zkGrG9dwPRP6WhcZQ8TogI5/HEnI9Jkr+26HLQUlC/YC5T
         H7scoxermRjNFuaI91yce79rDhWfVg5xMIvkHXO2HdZMqyG0qvel8n9ukSlFf720n9RK
         wXTZOcZb7Vzh9cKq4KesiPQ6ykpjm/touk1NuCiRqNJk9o4zhvgNSTb6UOciTMWIq8jb
         Qbag==
X-Gm-Message-State: AOAM532J+vd/gNFFb5DVLF56lmEAPtZ8j73BeEAbAgRbq5tPRl/mH1DM
        n48zrqOq4x/A2jL4c0PKixXU4AH+nUvUffLDOLM=
X-Google-Smtp-Source: ABdhPJyL5+4pR+EkeSeBEcNT6CSVNhu2OOhSfXy9mK5W424hXr5wN92+KdoDqmvRnUhU+kyBto4w8u4KffTFZcmpKrk=
X-Received: by 2002:a17:906:dbf4:: with SMTP id yd20mr1105201ejb.369.1595503737970;
 Thu, 23 Jul 2020 04:28:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:16c9:0:0:0:0 with HTTP; Thu, 23 Jul 2020 04:28:57
 -0700 (PDT)
Reply-To: web.1nfo@yandex.com
From:   "@Barrister Muhammed" <unupdatry@gmail.com>
Date:   Thu, 23 Jul 2020 13:28:57 +0200
Message-ID: <CA+43gu6L-tZD+gMdSihDqA5NMGvWkaja2OsX=VfomnqR1qJCtQ@mail.gmail.com>
Subject: =?UTF-8?B?TmFsw6loYXbDoSB6cHLDoXZhLA==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TmFsw6loYXbDoSB6cHLDoXZhLA0KDQpKYWsgb2JlY27Emz8gRG91ZsOhbSwgxb5lIHNlIHRhdG8g
enByw6F2YSBzIHbDoW1pIGRvYsWZZSBzZXRrw6F2w6EuDQpOZXphcG9tZcWIdGUgcHJvc8OtbSB0
dXRvIHpwcsOhdnUgbmEgcm96ZMOtbCBvZCBkxZnDrXbEm2rFocOtY2gsIHByb3Rvxb5lIHbDocWh
DQpkxJtkaWNrw70gZm9uZCB2ZSB2w73FoWkgOSwyIG1pbGlvbnUgVVNEIG55bsOtIG9kaGFsdWpl
IHZhxaFpIG9rYW3Fvml0b3UNCnBveml0aXZuw60gb2Rwb3bEm8SPLiBWeXrDvXbDoW0gdsOhcyB2
xaFhaywgYWJ5c3RlIGxhc2thdsSbIHDFmWVkYWxpIHN2w6kgY2Vsw6kNCmptw6lubzogWmVtxJs6
IEFkcmVzYTogUG92b2zDoW7DrTogUm9kaW5uw70gc3RhdjogUG9obGF2w606IFbEm2s6IFNvdWty
b23DqQ0KxI3DrXNsbzoga29uZcSNbsSbLCBQbGF0bsOhIGtvcGllIGlkZW50aXR5Og0KDQpTIMO6
Y3RvdSBWw6HFoS4NCkJhcnJpc3RlciBNdWhhbW1lZCBSYWhtYW4gQWxpIChFc3EpLg0K

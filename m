Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5B83F039A
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhHRMPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhHRMPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:15:10 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF8FC061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:14:36 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t1so2032902pgv.3
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=QK1h52QZFOmM3PHYtwCa8vQm9lyA5K3xyPeJfzFxn+Y=;
        b=L6B3b/u1nRCmb3CJhf5H0xKuRzCYmD4OxXWenVMm3MeoV7TKVWnPq6a2DYlGcXBB7T
         xw3rGbqgywYPiA6f85lWEDTi3rnSEwmcKku/kXOoafkaQBEwxTZzQcCgkaBie6Y2ywC+
         gJVn4DRRh2kGPemM3+FDvjbJ5PwWOqtRUFqJ357WZtoc+hIJRrAXh/m7xnwQrA84f9u2
         l0igK+13Puzt2zhaKH9VOtzKPKUG4Zs8uQ7xeA7WpFyouyrgmScvHo4u5a3oadn/ypl9
         E8BxDx6tXCYjyJ+wRaR8yKHxqzNy5+fbDHqKJkJu1m6/LUygGAf0UYGloyO0aFvDXRrm
         TXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=QK1h52QZFOmM3PHYtwCa8vQm9lyA5K3xyPeJfzFxn+Y=;
        b=KI4i4/j/puQe9dTFsIED+rINSHbAVmDeitTgG2xErRZnlXwq3yLtm9NSFQhsWDSSWq
         20SUISPW/LDMDRQGjkEpeSabvGnIxNdm8gu51Ku7Xq/om+mOaRh5IO2DGq3Epmu0b6j/
         nF0Pb4mYO7ydwE1RIDadnuOwWumPHRbshkQvzCjf2kzvg0CoTjkKv2ItaEQ9aEUwrXsP
         nXxlOEh51C+VXZ7J6OqYRAT5/pkTTGzAhEsHJTV1kqqQoV2yuXjdalMF8HdHB9UwkaaO
         U3rQ3gBUaPDgZizA17jeCFc0JviS8nrLjPIoaR3/qupdyhNMO4oCsPN3V/O3t+zfYZJe
         L6DQ==
X-Gm-Message-State: AOAM533hgqPnlq9NY6kfOeUjwFqIo5+o4cQnG8u/okr3qvBSoBaRGUwE
        N9nkBAlDjrW2cHBQ9Jqu9DyC5jPyTqplhcFMQkw=
X-Google-Smtp-Source: ABdhPJyBmiOMMIzxdwVnmAVlm5it2Nql8Ti0WsBXPYaoQm4p68rbgYi5rYq6wxBWMhEGEtEGwA2wPjHOJSFXwCiwM4I=
X-Received: by 2002:aa7:80d9:0:b029:2ed:49fa:6dc5 with SMTP id
 a25-20020aa780d90000b02902ed49fa6dc5mr8942900pfn.3.1629288875759; Wed, 18 Aug
 2021 05:14:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:a847:0:0:0:0 with HTTP; Wed, 18 Aug 2021 05:14:35
 -0700 (PDT)
Reply-To: xiauchanyu@gmail.com
From:   Mrs Xiau Chan Yu <lemotunde793@gmail.com>
Date:   Wed, 18 Aug 2021 05:14:35 -0700
Message-ID: <CAOWRAZzqXiwqOsOVcAW_0vFh8Z7qmc45rP-9We7SDenyL+85iw@mail.gmail.com>
Subject: =?UTF-8?Q?Sch=C3=B6nen_Tag=2E?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20


--=20
Sch=C3=B6ner Tag,

Ich bin Xiu Chan Yu, Kredit- und Marketingdirektor von Chong Hing
Bank, Hongkong, Chong Hing Bank Center, 24 Des Voeux Road Central,
Hongkong. Ich habe einen Gesch=C3=A4ftsvorschlag f=C3=BCr 13.991.674 DOLLAR=
S

Alle best=C3=A4tigbaren Dokumente zur Sicherung der Anspr=C3=BCche werden I=
hnen
ausgeh=C3=A4ndigt
vor Ihrer Annahme und sobald ich Ihre R=C3=BCcksendung erhalten habe
Unter der Voraussetzung.

Gr=C3=BC=C3=9Fe
Xiau Chan Yu

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6752F2571
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbhALBW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbhALBW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 20:22:26 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8D5C061575
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 17:21:46 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ga15so1147071ejb.4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 17:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=BDznPz9NBWU1W0oVUS1p1YG9zrN5ZPNIpTPRgYm6ufM=;
        b=Q5J19P0U+IKgbx37bOansKqETiDAQiUgmOgyhhJEPJvGL0wRg/lTQhT0rIz3Y0GLzN
         /y+B/agKm+55bzROO7xzXZ3xn9gQ/RcYUqhhTMbLiLVleHTopwWdduU3yCDWHCs/ibQb
         vvEDmbTIPRtgJzQIslOHDdX1MaVPrK18AaErEiI3Klqn6Tc7BE2wyA1DabSx9X4hx/pY
         40ASPY4X+aigi6nU6LgINmsvVFSG1Ky2+ukCsCLCryJ2cHRCgOlzxZeAuMPsAEY+Pyp/
         c7wvdGNHJY5qEc7tF8UHDSfJ560WSGNNx/y8S60abfb8EjiuB63UNoXZ4QyaSbhq7Hem
         Ysuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=BDznPz9NBWU1W0oVUS1p1YG9zrN5ZPNIpTPRgYm6ufM=;
        b=Oma2Fhx2hu5FYydYISdBI2aLML/RMmDT/xxW1u7wE6NNiKkC4zPvonkF9L1JVBpWv+
         84kwpDnNTm7KH/dku/3P8wH37/9khCQ+DRgrQ3Nm7nfxPruk+L8GPYkgkOCFeZ7b2WIE
         Sshu5TO/QL6+ujD0CE6yYQ6G9OtS75lKlDbTCuibDJK07DV8WSCHgy7s5OYSbbvYsGQc
         K5teKCl/s+lUlhzW9zgnGuIc5tFric/qjzFXbh7AX9zmiSuNcy4REFV9NvZkw5Dehtla
         nJrKvXT01VmIcKmZN8zKXLGGLqRtrYT/3KzOFjwmT3RezrWOkbjsaIEMofFFkux5d+TC
         ioTg==
X-Gm-Message-State: AOAM533717zw3T4yRSxt6KuKJqqGyYYpREvr2YzP+Ljpg8RfbPwp8DcK
        goxoj2EFHbJhA8EoyDxZAqdEUwLVvhs2x/4SYE0=
X-Google-Smtp-Source: ABdhPJzfs0c2LkNDTATMlMesmD5Q6CKgVV8sT0Zhq3aX0dbvArZBCpngaQdJiUwLfgA8Ceu80jd3Lx3pEdmRW8rL1qI=
X-Received: by 2002:a17:906:a951:: with SMTP id hh17mr1529382ejb.388.1610414505009;
 Mon, 11 Jan 2021 17:21:45 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab4:ab8d:0:0:0:0:0 with HTTP; Mon, 11 Jan 2021 17:21:44
 -0800 (PST)
Reply-To: mrs.isabellahelmreich@gmail.com
From:   "Mrs.Isabella .Helmreich" <ekon9169@gmail.com>
Date:   Tue, 12 Jan 2021 02:21:44 +0100
Message-ID: <CAH8kvD2gDq9CAGSwAj3mURBQYP-hx6Sy9yrhFpj=CO+PaZ9iMg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
N=C3=A3o sei se voc=C3=AA v=C3=AA minha mensagem?

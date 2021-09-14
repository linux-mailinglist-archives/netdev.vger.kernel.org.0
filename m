Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6368140BBD2
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 00:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhINWza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 18:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbhINWz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 18:55:29 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80468C061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 15:54:11 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d11so635547qtw.3
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 15:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=xDKWW0wlS6VLlsKzLR2FDKfbcgJ0ifXQjP96vwvjHWU=;
        b=pAOP0DRh3wpXljjsXBVUZyeXgVKw7XCLmGFA77PhITzkfkIYCgyoy7mFeW2LU8T+In
         FXRAaFrRq1klKByF+uTrOMNR4ADTUCsAOwVK/zEYqiExcg/UXnDJEhvLW2SdTSVvi2wX
         P4UWSenPCfdg8wuA54kZXkiro6COeuVel82e1yk81bwX+c0SiOsxadXiYtkZs/NoE0z3
         23RMo0+C6OXnZz8LHiYuJmZGkhXa9USemoP3RimwxtjqfGLR9/TvV70pT47j5AbHVDck
         NJ/35Bmph2rvRqs4hFyC7nGAMXoZb16pSXdFrI950iOhq7puWsB/za7QuT89AYi+wC9l
         vSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=xDKWW0wlS6VLlsKzLR2FDKfbcgJ0ifXQjP96vwvjHWU=;
        b=iSBFk8+BPnA7hSxYn3zHNPlPdf4LHZ1XoV97wG5O4Mnb2ADZwegBxK5Xhvv8sm2Fgw
         4a4QyUBdZQO3oS0POaSrf2GT8DJF09YmKDQzM3am/JMBWjIA1SxjogxrBI+G5op1UdPd
         e5vXxh3ypxO+U7BPaOwcer9z9mq1RfXi9Dqt6JSHP+08BpPUR5UTGFfgJUxdzC67kat7
         qHIeIq9CypwRYQr1BrHnj4dRH6D4GnG1LNlOEJki9HQqAK/JgPUz6oxQ4ux9KWTb78Z/
         UVgFjP0x31Mcpyu7CmQUjyg1AKcH0hJRsruUPZUmOf6K6O2S2m0urye+OjzME7/MhcCc
         Wxzw==
X-Gm-Message-State: AOAM532RgRNmotTmc6zCZ0CRD+xvDNvbptSZ5Uja8UJB3rmCh+VGN/9h
        ED2IwpBjgBluQMG93x4coBAFKffCAc4sFQ+37dQ=
X-Google-Smtp-Source: ABdhPJyWpFA8SHpD/TrBWfM+VhCeleI7DQoD0jGZXYY9zmLE+cZ95C3JfMpBwS64Fdl+R8kTU7Ij9VccV66Zx8ZrtXA=
X-Received: by 2002:ac8:5ec8:: with SMTP id s8mr7429997qtx.26.1631660050247;
 Tue, 14 Sep 2021 15:54:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrsmariagraceboyi532@gmail.com
Sender: mrmarcoalbarran@gmail.com
Received: by 2002:ad4:5e8d:0:0:0:0:0 with HTTP; Tue, 14 Sep 2021 15:54:09
 -0700 (PDT)
From:   Mrs Maria Grace Boyi <graceboyimaria@gmail.com>
Date:   Tue, 14 Sep 2021 15:54:09 -0700
X-Google-Sender-Auth: PxJ9YujP6noGw6Gzuu0BLX_GxyA
Message-ID: <CAJNQQ2v-gqpDzaD7bKr_0-jMBvbGizaweABwDxnMp41eXvWacg@mail.gmail.com>
Subject: =?UTF-8?Q?Por_favor=2C_perd=C3=B3name_por_estresarte_con_mis_apuros=2E?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Saludos,

Me complace estar en contacto con usted, tengo una discusi=C3=B3n privada
con usted. perm=C3=ADtame escribirle con m=C3=A1s detalle.

Qu=C3=A9 tengas un lindo d=C3=ADa.

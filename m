Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8D8458AA3
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 09:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbhKVIs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 03:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238841AbhKVIs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 03:48:27 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA65C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 00:45:21 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso7201917ota.5
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 00:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=KAbhMQt4nCgWni6Pt6IcGkUBR1XzjBlAXekRoPKEnOo=;
        b=mrMWBR+U7TBoSZP62rluad5TrSG1lvq2lxQXzEQS1QDAviR6cFK6dyj3QhdDQ5jC5c
         KvPKCdG7sleCynKKoIjoWe3S1TT4RHU2ecwAexclzJmeA4vvLabxBmAoPRLgSgJZwkms
         ZKf6qiijIWSsf9dQ/qPWQdjm/zm6o7QOo8fLlLCRy/pbXf7tQPOCMaqWILYWRiV2uIm1
         pS22Av4EhHXmgqfwqLToK6XOISuC4F4SMvZiJyY3rtTjJwz5frTK5dmlplQ2OmOmcxcq
         AqUGGZfJNWrvs7vw3ABu5Qh8pnBGQE/M7ZCHAbXUN13x0BIo2k+UL4Gs2xDv0/nfoJQT
         F7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=KAbhMQt4nCgWni6Pt6IcGkUBR1XzjBlAXekRoPKEnOo=;
        b=ULfrBOISmk8tccaJyXPsQ1JxZLZI3EqqKZpVT5wpqaxhld/+rJHR0jr+z/Ojq+Q9Cr
         jIjPRUfAZwmfiE8aEFCfHL7oyyQOSgD5sEAHKsppaAuEWuGiZv03cHyjaIU/VA3e32UU
         1FieMRIGaGixomO4FddYCX7gQKvjeNZX8URM1OkxKFXbPgaEmxr/zCCPJJJo6rFupMNQ
         jffSuyfCnGgr1z/nDZXHsOsHkNZX/zDy0zs27c52wrm/Hr6panJk5g6OtHJyIghyPsVm
         iTH3gvcxZYTNj3Y7K6hr+rDiQuHmx5mCS1f2TubRrG06hrFis6Y/0s+qUy/sNtfDzpPc
         jnlA==
X-Gm-Message-State: AOAM530HfkU4K+4esccUoPPjU+E7l+NUiB/1Fp1d5Tg25mnmPZbSa12o
        qbuvK6XKjqf40uSEPDf5yNcnhUszsgOefLzcx8s=
X-Google-Smtp-Source: ABdhPJyjjrD+3CHwgE5/sFG+lqIV4E9FYEYsvG15phOWSffzW9zH1no5XVJt+GgSILY2u3plSq2c9ir4diyH8heAtfs=
X-Received: by 2002:a05:6830:90f:: with SMTP id v15mr22085356ott.62.1637570720979;
 Mon, 22 Nov 2021 00:45:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a4a:7a49:0:0:0:0:0 with HTTP; Mon, 22 Nov 2021 00:45:20
 -0800 (PST)
Reply-To: justinseydou@gmail.com
From:   Justin Seydou <hamidfaith031@gmail.com>
Date:   Mon, 22 Nov 2021 09:45:20 +0100
Message-ID: <CAFepVPrfpv-GEp9FiMd6uOPKFnvDBNRGWVupBzJhvV0CVnfH4A@mail.gmail.com>
Subject: Proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Estimado amigo,

Con mucha sinceridad de coraz=C3=B3n les escribo para informarles sobre un =
negocio
propuesta que tengo que me gustar=C3=ADa manejar con ustedes.

Indique amablemente su inter=C3=A9s para habilitar
Yo les doy m=C3=A1s detalles de la propuesta.

Esperando por tu respuesta.

Atentamente,

Se=C3=B1or Justin Seydou.




Dear friend,

With much sincerity of heart I write to inform you about a business
proposal I have which I would like to handle with you.

Kindly indicate your interest so as to enable
me give you more details of the proposal.

Waiting for your response.

Yours faithfully,

Mr.Justin Seydou.

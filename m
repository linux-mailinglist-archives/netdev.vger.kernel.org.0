Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E023ACF3A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhFRPhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRPhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 11:37:39 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B351C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 08:35:28 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 102-20020a9d0eef0000b02903fccc5b733fso10068130otj.4
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 08:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GzEJLjKJj22EBbwIr2+JFM5ocbMgHlXybw3Hu9NpJQM=;
        b=uevKCOSRgkYQcOrPo6Jid2+JlNuXZrt7Fj8Kggr1wLSvrOTXCXGZd90ew4v/rdmCKm
         NTRYCUf3P5NV8Y7EmON3F/Kv8eZ0jXwZ91YfAvhCTe79K7i8VpbfZ4wyIxGoMnGEpfAD
         G41MXu7wGrmwa3+fnIfp2a4vQ2SMZlO3FRqVLjLc1x7Y3354Vpj4pZM2fCgQZEPlBCTN
         Y6PEnmdHBHiBd43RMWetqJzMGfNsHulelGsUzvWwq3I0SWSDBHra4IehgCR/n7id8Njz
         qFm+D/o4ZRypsfW+PxKpbDIcKq+xiXsK62DxaaVfxbSuf/4ozkax37nN7Vz2rjqQCnsU
         fM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=GzEJLjKJj22EBbwIr2+JFM5ocbMgHlXybw3Hu9NpJQM=;
        b=FGo08mDz7eJ9dkmyX/ICylz5YnvvyBnvxxyRFaOvyte4ioVi2zrIFjtqQjXMOl8u5e
         EfO38qplrgUYd/8yoQkY8wf9z0+0HD9RQAydxNhqsw7Mu4yLJFtm7omgSJgaeGUvtnsY
         C1pRF3HrkV6s+rP8fS9WbvOqnv7fxnj4RaNhbGO3BpjNNkpkoYrsMSdLpnd4ZbyMiuvx
         GMvvTyBHZCyDzBwXOLNhG+Zns5OVcaOJyXFHboULbNWgTTED3OjKMII9NYGx2tPKsOkT
         ZN2kBQ7qzaHnL3K6u9KhBsjISMHOigMT5Tvpg3IlzRnUWZz4xFuo5FdGAhYJTM1wWyLL
         9rUw==
X-Gm-Message-State: AOAM532toG3xT9GvFWZcgKiPfsUYw6DJLejq5b2IJxgvDSy5BoLsV/8S
        9C21/ggSWr7c9mXAtJKq1V1SXIIQUjoSNFd35Ms=
X-Google-Smtp-Source: ABdhPJyiKwYtCNJwYUO4gb1QBHqd2e0QdevvaD4TkFW/9CbtPDVL48X/aUpyJKYJWSWQXFk7RoVuWmLGcr/qbZM8VAw=
X-Received: by 2002:a9d:4b98:: with SMTP id k24mr10186775otf.359.1624030527877;
 Fri, 18 Jun 2021 08:35:27 -0700 (PDT)
MIME-Version: 1.0
Sender: lila.lucas1112@gmail.com
Received: by 2002:a4a:8c65:0:0:0:0:0 with HTTP; Fri, 18 Jun 2021 08:35:27
 -0700 (PDT)
From:   Lila Lucas <lila.luca112@gmail.com>
Date:   Fri, 18 Jun 2021 17:35:27 +0200
X-Google-Sender-Auth: _YdObZi3ff07nSf-JZQUbswYkgA
Message-ID: <CAOGpkt3xkbPD7SPDQt+y-TPzv_seh-_M2sz7ctZOPtkzztMgXQ@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HELLO

=C2=A0 I am glad to know you, but God knows you better and he knows why he
has directed me to you at this point in time so do not be surprised at
all. My name is Mrs.Lila Lucas, a widow, i have been suffering from
ovarian cancer disease. At this moment i am about to end the race like
this because the illness has gotten to a very bad stage, without any
family members and no child. I hope that you will not expose or betray
this trust and confidence that I am about to entrust to you for the
mutual benefit of the orphans and the less privileged ones. I have
some funds I inherited from my late husband,the sum of ($11.000.000
Eleven million dollars.) deposited in the Bank.=C2=A0 Having known my
present health status, I decided to entrust this fund to you believing
that you will utilize it the way i am going to instruct
herein.Therefore I need you to assist me and reclaim this money and
use it for Charity works, for orphanages and giving justice and help
to the poor, needy and to promote the words of God and the effort that
the house of God will be maintained says The Lord." Jeremiah
22:15-16.=E2=80=9C

It will be my great pleasure to compensate you with 35 % percent of
the total money for your personal use, 5 % percent for any expenses
that may occur during the international transfer process while 60% of
the money will go to the charity project. All I require from you is
sincerity and the ability to complete God's task without any failure.
It will be my pleasure to see that the bank has finally released and
transferred the fund into your bank account therein your country even
before I die here in the hospital, because of my present health status
everything needs to be processed rapidly as soon as possible. Please
kindly respond quickly. Thanks and God bless you,

May God Bless you for your kind help.
Yours sincerely sister Mrs. Lila Lucas.

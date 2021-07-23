Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1790F3D3882
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 12:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhGWJjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:39:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231760AbhGWJiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627035528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAtWjoPMs7b2mfoHjDz+Kbot8us4IZ8w5i6dg1usQ+I=;
        b=cGedKZH8NOY3MN9iBDCCpN8VchhRPeI50HT/wdbwzwxLNkMgZK1Q9sbK0Ycu6uytzavQtk
        qVKfGqoqqc5kGdie1u4yl9x/irnIiIHyzMfXMoWLCZbLVYq5Be9D+Zlhua/wcwxVozgcO5
        0w22G3i9EV1oSAAdTSowaR6PlreGIU0=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-V1azBk_mPz-9zNMMC63ZBA-1; Fri, 23 Jul 2021 06:18:44 -0400
X-MC-Unique: V1azBk_mPz-9zNMMC63ZBA-1
Received: by mail-io1-f70.google.com with SMTP id k24-20020a6bef180000b02904a03acf5d82so1259927ioh.23
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 03:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wAtWjoPMs7b2mfoHjDz+Kbot8us4IZ8w5i6dg1usQ+I=;
        b=eign+IE3HkGw1PfdD6AOyi6qO2z/VnkAId2KfFapbkQntVfifm94zvcsm4kASzA2WH
         qEh5ScFX9CyfiJjaePPr12SzASzT83YbwSSl92hWtUsWU4u+7s7bS+gNjJ9ocVTBkx8J
         Soi4ehBi+wVQV8tSdD9yIcbyc2bTKZZgON+LqNn+RmCgl1gnfeWXnayqLyRrPL54MHKo
         2IrrCyXdcDaLGUq3EV4bW39n/GGC1xGvXssvATzliLsVVvrrJf+JNqDp1hDqjzdVOMT+
         SagZ1vm+2BB+tb4jyNW9/0KFj3CpCMgZr9qs07w6Y1wZuG5TpmVKzO4mqFj6pP325+yy
         erUQ==
X-Gm-Message-State: AOAM532EzbTnxhWLKlksjr1PUPyv3OFErihXB4ZbuLcy0nv/PtrULWmo
        MMQYIqxm1P7VynqZsbLi6MpEgPzN1VFIl3/ODYlGCuK+AspdvWVxpY7JjUfUN37zYMuBovP7vp8
        c6pr1WJpRSrk/ermpiEpp68JPJa6j2aZJ
X-Received: by 2002:a92:8747:: with SMTP id d7mr3114540ilm.173.1627035524402;
        Fri, 23 Jul 2021 03:18:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnLBvtdojuHWZ+mNPTTTHfo9sbPOXAPakPJPZrby6KidLaTImlo80uTrFXXtrK0loo+mBtHtFm2LaSGMOgU7E=
X-Received: by 2002:a92:8747:: with SMTP id d7mr3114532ilm.173.1627035524289;
 Fri, 23 Jul 2021 03:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210723035721.531372-1-sashal@kernel.org> <20210723035721.531372-9-sashal@kernel.org>
 <CACT4oucVa5Lw538M2TEc1ZNU4mUZms+9fiTxw-p5-7J7xcM+kQ@mail.gmail.com>
In-Reply-To: <CACT4oucVa5Lw538M2TEc1ZNU4mUZms+9fiTxw-p5-7J7xcM+kQ@mail.gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 23 Jul 2021 12:18:33 +0200
Message-ID: <CACT4oudPRf=RjqxncVrWGpMNfYTUhHOEbydtTq1O-R70P47guA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.13 09/19] sfc: ensure correct number of XDP queues
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 12:12 PM =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com=
> wrote:
> This one can be applied too, but not really a must-have.

Sorry, I have to correct myself. Both must be applied:
58e3bb77bf1b sfc: ensure correct number of XDP queues
f43a24f446da sfc: fix lack of XDP TX queues - error XDP TX failed (-22)

Otherwise, if there are some left-over TXQs because of round up,
xdp_tx_queue_count coud be set to a wrong value, higher than it should
be.

Regards
--=20
=C3=8D=C3=B1igo Huguet


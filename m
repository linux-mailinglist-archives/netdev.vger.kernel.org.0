Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EC33AF1E7
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhFUR2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbhFUR1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:27:55 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385C7C0617AF
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:25:38 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id d19so20705450oic.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Nl+UATUG/ekcwj7+lbeC3lq97VrKeBhXiFoqjO/PoM=;
        b=ZtzZJVQIiktzwMhbckUEj/FSihpO/1RWyF2QAlXOSMKMLwYz2qMKBN98I5AgANFqVc
         IQChA9yq5zSYbUEZVhDym/IGTUjOOFfdCcY8CsltdJLqcaDvjBZbmL1FSeBG/ceO4kD2
         iThRqjQh4BBr2EJIQTTbgH+yjk/gP0KSFYyy/Rj8JAGUoVMUmJuJGbBG4QIWzerRMtuz
         Wi8blOC/XZShQv0fW1DPtvTn6/SMk7szm4Rxzr7YqRhVen7Joc1TDeG2HuA/tcCsiyR/
         w54Q9fwepWbIPmLIehU2/RpQo/1UIepba1ErkP5TY+UUUAwNnAqOcsKj4+oWEVQiJkKT
         5OgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Nl+UATUG/ekcwj7+lbeC3lq97VrKeBhXiFoqjO/PoM=;
        b=b/3M64M2QT1i00EOY+HnSt/HcchnQXX4hxEMyhjdrbDD4vyH9WCIJhg5amIvsuOfLI
         U9E1HKOJqQQyq098NlqdeHf10mdvWJCXBOWda54Vk0Gce/YFt4L+41SWXgrxQN8+DSPp
         xDq9nEbRevxSyooISM8iorNVOqQV8fXM4JTaqN6PEs5hkOnqru1n26Hu36vHZca1Uiiy
         Tp7+11PU/H0Z9+8RgQiQYBogTfwVI4+bkWq0GJzdoBNWlEHVWR+uADwjaX5x1WVpvQ6O
         hnxqynb26+j8WDBh3SMg5r5r8DIcAS7bDtbOFEgwJ1GX56/Q0xjgnBPK4vKX9UJzkrE3
         ke3g==
X-Gm-Message-State: AOAM530mHg7nH14k/oSdFMjX4GdWn8XRXGbGcRrHM09wdZEpzyCNmysB
        XeYV3+yLUVMZFnvuoZdUITeUgION1psrd95uI5YlOw==
X-Google-Smtp-Source: ABdhPJyopzV7pDlrYVX5eV/Fi7NWMvWgN1AYozmtcDSU6CyqoDJ+CXMCQ3Dt6qAgUPNI5GU++0ExZe1a/ltfasDu9zw=
X-Received: by 2002:aca:e0d6:: with SMTP id x205mr17927435oig.109.1624296337665;
 Mon, 21 Jun 2021 10:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-6-jiang.wang@bytedance.com> <20210618095409.q6s3knm2m4u7lezd@steredhat.lan>
In-Reply-To: <20210618095409.q6s3knm2m4u7lezd@steredhat.lan>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Mon, 21 Jun 2021 10:25:27 -0700
Message-ID: <CAP_N_Z8+-ObttNsk7YZSdFcRpso5YHJTVqgerPpB0TvMMtj7WA@mail.gmail.com>
Subject: Re: [External] Re: [RFC v1 5/6] vhost/vsock: add kconfig for vhost
 dgram support
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 2:54 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Wed, Jun 09, 2021 at 11:24:57PM +0000, Jiang Wang wrote:
> >Also change number of vqs according to the config
> >
> >Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> >---
> > drivers/vhost/Kconfig |  8 ++++++++
> > drivers/vhost/vsock.c | 11 ++++++++---
> > 2 files changed, 16 insertions(+), 3 deletions(-)
>
> As we already discussed, I think we don't need this patch.

Sure. will do

> Thanks,
> Stefano
>

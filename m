Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5821D27BED9
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgI2IHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgI2IHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:07:05 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C542C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:07:04 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o8so13677311ejb.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKUZCTImfjOR/eCFpUIhQQDoAr5/BSnFjk/PYyLLEwQ=;
        b=tKvYONgoxw23A5ClKktE+kVo/sCFq3snOh1FLDTs4ZwcIuvdhjsD8ZTlBj0NY3BIP6
         /aL63omXW8xWw8kDegYI7EG8JnCZ58sM56eGmIe1GrOn45CrJ7GYjFzSMVqsQuhG28ZW
         whmx0gmuGkbGPzHrAIX/aw7O+sEq7vK5Lb70BCZNX7n5YpJx9oXYjICOL04JGAuO90m8
         p+Uagie8O97x6JlcocVP+gFXGNFajM1I7fVrdwNdmVyTNaVfPLaZRzOC/hFt9TgI4YI7
         SLFK3tKvACq7aLVbK+T9Ay0rQMpf5bww37EvWuN0TDclcvYx3WQiF7KI8z0Wmv60DhQZ
         cC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKUZCTImfjOR/eCFpUIhQQDoAr5/BSnFjk/PYyLLEwQ=;
        b=nfHM3rvRpgAuhAqRE+zN/iOy8ImxuwPVLLoUqAEoJAiB2dyPFQk3HFqeIQ1UmBBmId
         HDdHut3V/yB+jexfMQ8vpvMCFvDaNZSBef7B75VNJbYf5wMJ/tuoY084wBjlCKyMEUpD
         aNBrPBXZBukQFea4tOUbSGaVZZnrw+gVmEe/1UfJ7loVGDR4fUHIBxnUAFIQqC06QHO+
         Ot4yv8lnKmC2J5X0QqdZVq1A29Y73VdN27l+SKFhOBoH/Pg62M5+sYwvbq1ajU4QrQb/
         EPOZO1+WgIsonRu/2qohcEIoDkNCd7WUHR5ewme7f7IlOoUpXp5y3HOwjuHjGBGwq0cL
         onJQ==
X-Gm-Message-State: AOAM533yOJL3pCee/JZpS+cboApD8iny15YmmLIFPDtKFVQ6s4UcqL04
        cwl0sEiJWcSax9fwNB0gyhGI28fEh7ZWJSNboa0=
X-Google-Smtp-Source: ABdhPJwwayGI9GutwxN+MWHVcC/c+y0GpciMYodRrApE4g0JLS3nckigvhb/RoPOjP/4rNANbIUVWeKPAaL0JLybaw0=
X-Received: by 2002:a17:906:c191:: with SMTP id g17mr2731475ejz.117.1601366823170;
 Tue, 29 Sep 2020 01:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
 <20200929022246-mutt-send-email-mst@kernel.org> <CAMDZJNWM7eBkrYk9nkEvPyHW7=kt_hTHGQCDB1CPRz=EV6vJcQ@mail.gmail.com>
 <20200929031754-mutt-send-email-mst@kernel.org> <CA+FuTScinzrURHx_jQge9jN0mJU7oM2d9AJ9ckkXm3SxBHGNvQ@mail.gmail.com>
In-Reply-To: <CA+FuTScinzrURHx_jQge9jN0mJU7oM2d9AJ9ckkXm3SxBHGNvQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 16:04:38 +0800
Message-ID: <CAMDZJNWLr1MK718DWzaZR1GRktQwcTpt8-B3xtAJn_qSiKc5AQ@mail.gmail.com>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 3:29 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 9:23 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 02:59:03PM +0800, Tonghao Zhang wrote:
> > > On Tue, Sep 29, 2020 at 2:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Sep 29, 2020 at 09:58:06AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > >
> > > > > Open vSwitch and Linux bridge will disable LRO of the interface
> > > > > when this interface added to them. Now when disable the LRO, the
> > > > > virtio-net csum is disable too. That drops the forwarding performance.
> > > > >
> > > > > Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > ---
> > > > > v2:
> > > > > * change the fix-tag
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 8 +++++++-
> > > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 7145c83c6c8c..21b71148c532 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
> > > > >       VIRTIO_NET_F_GUEST_CSUM
> > > > >  };
> > > > >
> > > > > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > > > > +                             (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > > > > +                             (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > > +                             (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > > +
> > > >
> > > > I think I'd rather we open-coded this, the macro is only
> > > > used in one place ...
> > > Yes, in this patch, it is used only in one place. But in next patch
> > > [1], we use it twice and that make the code look a bit nicer.
> > > Would we open-coded this in this patch ?
> > >
> > > [1] - http://patchwork.ozlabs.org/project/netdev/patch/20200928033915.82810-2-xiangxia.m.yue@gmail.com/
> >
> > OK then maybe keep this in a series like you did with v1.
>
> If this is a fix it has to target net, unlike the other patch.
Hi Willem, Michael
The first patch v2 is for -net, can we apply it?
and second patch will be sent for -net-next after discussion ? That is ok?

-- 
Best regards, Tonghao

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4176E35CD1C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245020AbhDLQdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:33:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244997AbhDLQba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618245072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ry8UOmE9xxjldEfstZ7cAn9yNx4EWrsHXZ/UlYipT5w=;
        b=cQXcR3KZvjy5N4y/RzdamCW7yycijENoKPXgaVgjkq8cU6lp+/IIh92zBqZdS8t/6HrVLf
        E+abXK9eld7M7fP8CdH93PI8UHPKZtlLjvCb5blDhBzewp0fUrqs25x5Vw6quSjG6m8t+m
        4D5lADnMuoafIhS1oBC4Zn/sLp8lwY8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-OjhHH59yMPGyvAmWW_HwrQ-1; Mon, 12 Apr 2021 12:31:08 -0400
X-MC-Unique: OjhHH59yMPGyvAmWW_HwrQ-1
Received: by mail-wr1-f70.google.com with SMTP id y4so1899891wrs.7
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ry8UOmE9xxjldEfstZ7cAn9yNx4EWrsHXZ/UlYipT5w=;
        b=I9Rn+jFMse4BY2F57kP84nGe08Gh+K8jyq680w9U++7KSYu0SZWxK2t1yKyBimzHQb
         QFbLir0iRb567TgouEwh2LtJwVjPX3lz+mSGnDTGYJPwd+9RK8X08SesLdajE7gcwbKa
         Yu5UnZjwx7kz+ph0mXhstd5PayADA8/2FhwLS+J2Nqr7yd0pb5aQxQCvxkaoWNQW4ByG
         zzicAqPUB2+0U6GPcVGXixSfpDQuTYmzUpGug1hk3yzOI/gHyVFoWCX/1Z+nLtkJ1+aO
         XUkRY15M770vWuGkVkR9JfpufEnIdlz+rv92D2BAnMrqeFAED1WKYY3z/jIVXVai2dxG
         Bfdw==
X-Gm-Message-State: AOAM532OFTS3Dj/NmUZFqMi3CKijP2AKorqPInV96JwUfSZXYRgw8guW
        YZrzBAWqxXVb8EVlzWtiNH5Ckgy8H9MpOppYP1o2dUuU46Gsbg1TiqkySguhuykOdFnrQxauFjs
        yKcce+a5QfjGDLNdp
X-Received: by 2002:a5d:4acf:: with SMTP id y15mr22094248wrs.245.1618245067510;
        Mon, 12 Apr 2021 09:31:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUBwHY6Sx2+M0+GnLNuOoMnUNcReuodJIrUaTcwaxJLupeaV8DduFcJ2+NZysOQmkqk3aepA==
X-Received: by 2002:a5d:4acf:: with SMTP id y15mr22094232wrs.245.1618245067379;
        Mon, 12 Apr 2021 09:31:07 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id a4sm17141491wrx.86.2021.04.12.09.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:31:05 -0700 (PDT)
Date:   Mon, 12 Apr 2021 12:31:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Linux 5.12-rc7
Message-ID: <20210412122951-mutt-send-email-mst@kernel.org>
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net>
 <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 09:28:28AM -0700, Linus Torvalds wrote:
> On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Qemu test results:
> >         total: 460 pass: 459 fail: 1
> > Failed tests:
> >         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> >
> > The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> > skb->head"). It is a spurious problem - the test passes roughly every other
> > time. When the failure is seen, udhcpc fails to get an IP address and aborts
> > with SIGTERM. So far I have only seen this with the "sh" architecture.
> 
> Hmm. Let's add in some more of the people involved in that commit, and
> also netdev.
> 
> Nothing in there looks like it should have any interaction with
> architecture, so that "it happens on sh" sounds odd, but maybe it's
> some particular interaction with the qemu environment.
> 
>              Linus

Yea Eric's been trying to debug this already. Let's give him a bit more time...

-- 
MST


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2B3DE991
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhHCJN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbhHCJNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:13:55 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A3BC061796
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 02:13:44 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d6so20470468edt.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 02:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TzdywkyaGO6eDzvYKvoBys7MoF5h7biikR9uQQ2v4KY=;
        b=DEM52txH8kmvAxsC/lp3YibL085f86KNaEqwdtqjBneskd0IwK0e82rXwYB9c8t9Tr
         ww3wmXWrMP+YvxKKT1uoX0D7YO1isLAI7ThWYluU0YqLEZfwyV3Now5FHhcsj9Cr4md2
         DZbBBbTbmK4BxlAzhBhpLgE8bQmmioK+cAe9+tZXxl+zmcGsylSDUZow3cip4f0fIcZu
         MERRn3uePPig17zL37ynIRKvdD/aR+949V8EqcMSPuQnAxFERSIirzW9KgUlD1mKDCqP
         30ZZw62oN0JD1lDOJ7F2XvxmIbwFaTw/pPYHnAPUzntV50gGc5kMQcteBHILZ55utDRZ
         Y5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TzdywkyaGO6eDzvYKvoBys7MoF5h7biikR9uQQ2v4KY=;
        b=D90wYd+fEYU5ndYzAtRJotyA/b+lvgwyNAhe9wVF/wu2pi9szz9DDIjTVLRMRIvHd7
         8yDPzJevaVBF9Yci+14vW2DEmtsAW+LXmHclBK8g40AFGjJhKSPLRjEZsFq2xLh3J7aN
         +R4y0ir7/KcVH3i4IpOe/LVQYRt2SH9nqOCkE4uqGv/OgehJZ7YCU5vLwU2mE/jv7nAV
         k0V93rNKJV8Xiigs+ALl2PhDntFOduCZKUFgAiqMOt/WN9KxFiGg4yU0FWTEoRsZIXIi
         2vZH/EJ/BdoGBYTANw219OPYCdySBi4+2FoKRrEpy9sq2lh7QTuG6r73im0fYQWQnN7m
         MQGA==
X-Gm-Message-State: AOAM5302ECbQJ7ny2dd4WOKQ/1VgIQaf730KrJe2hsVedX5aJX1lk0Ei
        SvQbq1DMvlyPE+z/XgD0GXq9pSNmekwP7HSCioqk
X-Google-Smtp-Source: ABdhPJzTcfFrmUvQ6VoEyuq0IwD//odDZyHHo9um9hSrSwgnp0TxB8fuvj0AdwM4682E0gxOiogSbfaYRhrBcwi+Smg=
X-Received: by 2002:a50:fb05:: with SMTP id d5mr23600055edq.5.1627982023010;
 Tue, 03 Aug 2021 02:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-4-xieyongji@bytedance.com>
 <aaf82d3f-05e3-13d5-3a63-52cd8045b4c6@redhat.com>
In-Reply-To: <aaf82d3f-05e3-13d5-3a63-52cd8045b4c6@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 3 Aug 2021 17:13:32 +0800
Message-ID: <CACycT3upc6-Sfo-68vg7aFR1zd8=ovg_-rR4UQaqgcVTG62USw@mail.gmail.com>
Subject: Re: [PATCH v10 03/17] vdpa: Fix code indentation
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 3:51 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=81=93=
:
> > Use tabs to indent the code instead of spaces.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   include/linux/vdpa.h | 29 ++++++++++++++---------------
> >   1 file changed, 14 insertions(+), 15 deletions(-)
>
>
> It looks to me not all the warnings are addressed.
>
> Or did you silent checkpatch.pl -f?
>

This patch only fixes the code indent issue. I will address all
warnings in the next version.

Thanks,
Yongji

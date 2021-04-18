Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01E13634F2
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhDRMBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:01:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhDRMBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618747252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qi9jeiTllPHfWYc0N7m5Md2AZieWKUkaSqUaZ+AG0qk=;
        b=PNRcvqEz13nAMdxY1Tc7AgUOZSJyYwH3ZbMo7SK5b78GWmawaybtWnI0fxod8ygUS2RW37
        t4ycBhz8Q0icRt9UrqOvIrHCc9EThVSxi8Mb4sCtJsLgUSA2FCZQTgyYgv9PWJSQYXB1Px
        Qs12eFePCSKkI/3F5cjMczxHYoulnHc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-xkVM4YwpOYuhVvAjiULolg-1; Sun, 18 Apr 2021 08:00:50 -0400
X-MC-Unique: xkVM4YwpOYuhVvAjiULolg-1
Received: by mail-wr1-f71.google.com with SMTP id j4-20020adfe5040000b0290102bb319b87so7382344wrm.23
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:00:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qi9jeiTllPHfWYc0N7m5Md2AZieWKUkaSqUaZ+AG0qk=;
        b=QuA8TaXOMZ2bLSHhJBuSSl1g2B+88Gyslwsd33V/t2F01fmu7hcrAEPKJpbHqTsBRW
         NVyikz2MzOk5WHHvrIVIcid+RRr1md+PKycLdFTeyXdqZeos1YsJo865GdqBlYHvTDF7
         C1FrC0h0/Y67yzyhe2wegKdDSbLs1vZ59nhRmyGUfjT3loAr/VjcvPPVzG/V6KHY9FW8
         LV7pn0FuJdVoBy8+8fLdg7uF1XHNNmckgLFvho+IE6IQirEAdlw2vlKaximyHJHnpfZH
         NJX5Ey2bKb3G/WAWDg1kefoenWQvCn8rFshnKV2AvmY0Pez1K14BiHz9HBpImmQmvyCf
         8t7Q==
X-Gm-Message-State: AOAM5328tIpstI89BMhq28xrJV32dUOmPIe2M+CEM9kxO/S2Dowfx99y
        9Jhky7T4Yq/gdgjYPq7peqJee82y88FDlZekF0J5LCGTWZGNhCtSiqPMdOPFBYAcP0CqeejM0Hs
        zdi5H5sWy1r8eIVQQlq8CuDZKkwsZbOGi
X-Received: by 2002:a1c:b342:: with SMTP id c63mr16817244wmf.162.1618747249177;
        Sun, 18 Apr 2021 05:00:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0TQnvK+DlbSfY0wEWlm70oaQNUcWNXJbK92kTK95kQnRVns5Fgn2zNd2Rt7T4MfJJ4YCoK8KI45fXiLd8tiw=
X-Received: by 2002:a1c:b342:: with SMTP id c63mr16817235wmf.162.1618747248980;
 Sun, 18 Apr 2021 05:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <2b6d2d8c4fdcf53baea43c9fbe9f929d99257809.1618350667.git.aclaudi@redhat.com>
 <YHwS2pu/oSdC4qFt@unreal>
In-Reply-To: <YHwS2pu/oSdC4qFt@unreal>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Sun, 18 Apr 2021 14:00:38 +0200
Message-ID: <CAPpH65yk95Yg7wZiNLSebNJ8=hDPff7ixNzxuXzu0yjXYu=gCA@mail.gmail.com>
Subject: Re: [PATCH iproute2] rdma: stat: initialize ret in stat_qp_show_parse_cb()
To:     Leon Romanovsky <leon@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 1:07 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Apr 14, 2021 at 12:50:57AM +0200, Andrea Claudi wrote:
> > In the unlikely case in which the mnl_attr_for_each_nested() cycle is
> > not executed, this function return an uninitialized value.
> >
> > Fix this initializing ret to 0.
> >
> > Fixes: 5937552b42e4 ("rdma: Add "stat qp show" support")
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > ---
> >  rdma/stat.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/rdma/stat.c b/rdma/stat.c
> > index 75d45288..3abedae7 100644
> > --- a/rdma/stat.c
> > +++ b/rdma/stat.c
> > @@ -307,7 +307,7 @@ static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
> >       struct rd *rd = data;
> >       const char *name;
> >       uint32_t idx;
> > -     int ret;
> > +     int ret = 0;
>
> It should be MNL_CB_OK which is 1 and not 0.
>
> Thanks.
>

Hi Leon, and thanks for pointing this out.
As this is already merged, I'll submit a fix.

Regards,
Andrea

> >
> >       mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
> >       if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
> > --
> > 2.30.2
> >
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625E930F686
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhBDPiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237406AbhBDPg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:36:56 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC1EC061786;
        Thu,  4 Feb 2021 07:36:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id df22so4711293edb.1;
        Thu, 04 Feb 2021 07:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Apc5zhyVA0QX3lxOc0IBBanCOB57QvWUV3wpenXTIf0=;
        b=u/YwAtGxyWgGHi8bvWMpuF5DXWiuqvhW52n2oj2rcvRe1I0Z9TqVZ6b7MPv8oVLDzv
         M2DH4tR/dY62QFI9+QWnfMalsur63QLpT3XtzJh+R3vGr1SPnkv5/Q5TaqqfWyh1ajSI
         GjsozjEJIFFpPWFUYhnByJ8EjjUfJH60l0OVwNFE50l6a3nAOqq1gthsQOCrdECX0vha
         e7uKlli402rIEmLor6EO0AJ6zGpsizB/Xf4v9ucHKnc+yx8tFNe83apzAiS+hO7o5zBh
         EjihL4wZH3jd5rD93WOaalMz0ZPJnlWwNQmVSTjd21Eia9HOGVMLii7yIUmKJszVV4JQ
         ujpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Apc5zhyVA0QX3lxOc0IBBanCOB57QvWUV3wpenXTIf0=;
        b=N7JNpV2Yi9+0fZtJ4dHbGbmhjMAJVuej+I+MIxuAJNSdUAQUdfG5REftnGmQ3l5vO2
         SRrmjDg8Sm1mbB1QRNlPhxQo1SflRHDCM/IGPTOvdFrPg9J6ayzVOSc5tMSRoZwaAyYh
         teJG51Gr3tesCSaS8P4SE6g7svolScPMpTCiwDVel1HoWkOwGFGWP9BWXKdBIYMGlMs1
         mnVuAI9GHe3Xq8F7WOpUnki8YZk3wboGWnFsrTStcfsHPtjGe7dxT8JN+TyuBhfO8s/y
         p0og0V5FLwHZoHOdSYF/Ym6cf8BhqsRvAt6V4O+pBCArPR1xmSIYhScW6XM1T1wiVlbU
         hDrw==
X-Gm-Message-State: AOAM531kYb9cbdh5+ocmY7764CQYf7r/fXIic3OXxb8PE5wf25PuXwaw
        uGiKIy3C5MiF7OZt7t49T4Q=
X-Google-Smtp-Source: ABdhPJzWlZxKNpce/klndMz2fmdu5OZ8EbNS5lQWyITfVfisl2JroTKniOW02JkR6N7nmrzgj9Bnqw==
X-Received: by 2002:a05:6402:378:: with SMTP id s24mr8723062edw.376.1612452974040;
        Thu, 04 Feb 2021 07:36:14 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x21sm2591860eje.118.2021.02.04.07.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 07:36:13 -0800 (PST)
Date:   Thu, 4 Feb 2021 17:36:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210204153611.iqpok4ligorpujyo@skbuf>
References: <20210204123331.21e4598b@canb.auug.org.au>
 <CAMzD94RaWQM3J8LctNE_C1fHKYCW8WkbVMda4UV95YbYskQXZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMzD94RaWQM3J8LctNE_C1fHKYCW8WkbVMda4UV95YbYskQXZw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Brian,

On Wed, Feb 03, 2021 at 07:52:08PM -0800, Brian Vazquez wrote:
> Hi Stephen, thanks for the report. I'm having trouble trying to
> compile for ppc, but I believe this should fix the problem, could you
> test this patch, please? Thanks!

Could you please submit the patch formally to net-next? Thanks.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9188C43CF6F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbhJ0RGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238216AbhJ0RGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:06:43 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F731C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:04:18 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g8so13573469edb.2
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=1BOkXeOVxzSfmqAlV4EUONUzhRhDB3s2BcTgxafh1FE=;
        b=Kf+qbtYVI+umU/fCvtdFtgXGHx48YtmYtzogxzqGfI8x0E2HnuYzUwZlvv2AvcK88h
         msNgBczrH60MjfgzSicOkXOIqBRD2N/d/BRoH9CSbj9o66EgaI1J60vS7oyZYHVlyuyk
         pJInpvp2spJqIqASci2Yng+eumnkAFkRb1wYQuL9h5Cwbd5jUohWriNPJhAJACRCS759
         TbCNlpAuLRazjiQ03DmglYRX8CkvqH31D/CXJsNv6LXITVpcbCkGLDeKvhEN1QLFBFRi
         2llbB8fVTLzXP8boj8txbUUhzMFiQZC+KcAzfVzaJx76mSl2MOYmZhN1tzGOYi1XHLPi
         kBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=1BOkXeOVxzSfmqAlV4EUONUzhRhDB3s2BcTgxafh1FE=;
        b=1xkW8UU6Cg3R2GwFCADqXni/LLD6ybr6SLGORxiN+mKo5ZIVBEv28U5mWAm7qFigud
         9Bez6gunTVLMSigVL1DUfRc3iXGenqYrls/JAkBH3U68YZmZuFeaEEP4sPZmfYK5xBaI
         cYh97gWwU9cevtj2ibfpp86PrLkzFfXhDe0Gov2MtYm1+towqr7mUibQhzn88v83iUyL
         UWbaEbTX9uveOuQ7A1/N1CQYfA0br01QpehpyLazoxzmvFsWgVzR9qwBSh4GMuruSBvl
         zpS2GOYnj1N9PTeRLWIKY17fzUHULZCaZcM7GlE28z2HwIAfMdk1bYysrPt2++/9O8a8
         J85Q==
X-Gm-Message-State: AOAM5337O8wb4Zs462GAQAoKNirwtZnfx1DA5Q9vbTRgPPb5A/ZEyYUO
        prVST0c/MFEjx2bTlDhGFJqQ/jnpFqvWUohTKbc=
X-Google-Smtp-Source: ABdhPJzWA6JDRH4oiccmyWaNQMHEo2VTUc2QI4P0RNXOo35XuRfbCyCmnjKvOH5/sE7NyCNt681yiQ0TYEtq/Grcr00=
X-Received: by 2002:a17:906:c18c:: with SMTP id g12mr41141870ejz.458.1635354256866;
 Wed, 27 Oct 2021 10:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
 <1635330675-25592-3-git-send-email-sbhatta@marvell.com> <20211027083923.7312f11b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB46711B24C7305B8488266C8CA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB46711B24C7305B8488266C8CA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 27 Oct 2021 22:34:03 +0530
Message-ID: <CALHRZurkyB_sg4cQTi9_36OMS=7cgEXWoh4cTs4UJ+mu2-7SWg@mail.gmail.com>
Subject: Re: Fw: [EXT] Re: [net-next PATCH 2/2] devlink: add documentation for
 octeontx2 driver
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Oct 27, 2021 at 9:53 PM Subbaraya Sundeep Bhatta
<sbhatta@marvell.com> wrote:
>
>
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, October 27, 2021 9:09 PM
> To: Subbaraya Sundeep Bhatta
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Hariprasad Kelam; Geethasowjanya Akula; Sunil Kovvuri Goutham; Rakesh Babu Saladi
> Subject: [EXT] Re: [net-next PATCH 2/2] devlink: add documentation for octeontx2 driver
>
> On Wed, 27 Oct 2021 16:01:15 +0530 Subbaraya Sundeep wrote:
> > Add a file to document devlink support for octeontx2
> > driver. Driver-specific parameters implemented by
> > AF, PF and VF drivers are documented.
> >
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> Please resend just the docs for the existing params.
> No point keeping those hostage to the serdes change.

Sure will do that.

Thanks,
Sundeep

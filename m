Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7228EFAA54
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 07:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfKMGl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 01:41:59 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40273 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfKMGl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 01:41:59 -0500
Received: by mail-wm1-f68.google.com with SMTP id f3so674181wmc.5
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 22:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8MwhdB2cTBecnrrNgOyyNpRPGP6IGrKoBhPRW46ANi0=;
        b=UXBdz1xTu4XFejtkL4DKOewWgZhk1TD14Ea+SBBFDQCFrRuzqf5FRMNxxcx/LZE7I+
         g2YWWoSXka9Fpg2QAJ2BjSU6KB7XN6gGDPIzxhfwgmrZReOsJrDCKuN1iIvVFiRz/yEE
         E6MNJ9gnw/YtmiIMr63drYXQFwtb3viJshmAxgZxc6T8X/+Wx8GjfKD4MdVKPn3j6ni8
         lCqRsbxgvDc5zsdILneuzDtyhR9EOzTJSynltXRwXp03LPAjS6LI6umRwwwUHgxCG3QH
         mlUtimRVTal2srqweemSopu5zrjlfxw4RHBQlHBidV7vEQAdpf4pngOzyQJBuQsQrpWy
         +YuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8MwhdB2cTBecnrrNgOyyNpRPGP6IGrKoBhPRW46ANi0=;
        b=J4+2UTicxALNa2BSMbdvttpr9chPBmBvXfLqZsnqMZN+xgcXKwbVHv3GVQWk0vlEKI
         yjkAtrWvBe2muOXMEHhjzcs7H3GQs38eY8qPhYmC+9A+7KW/5DlNKEWXHg9/6NiVV/Ie
         p+xi5H5olMBoWSCLsK3XD312iZvf0YZUWmDZedlemT84eEBUSYgB+KdQg4ZJXF29JmBA
         CGocyr1CmzmJcTaeAV5piE8pR0CorHOQ7EL+zV2fGatlkZpmkfBx4M+tYq2NHWNRc1NG
         OJG4ougKWj6OwLtxab1CKWzc8RyxtOr2nxF81W2uFmg0TZbLCBXvQ06BTLEU3VNkHB8k
         LIcg==
X-Gm-Message-State: APjAAAXLGd29Ei1feY4CkxDGD/TyPcKTn8CqtV5lbzcVQYYBgNxl5lSj
        S5M1Iy3T3Jjj9mueZclvRf/LvP08+L60MTpv6AIlFSGj
X-Google-Smtp-Source: APXvYqzhkKoaGCTAzbViSg4X7rJpILJPhC/sJRx4oi8EWICXrXyf7isMuWSDp84jGeve/GVgV54K9cdt+6Pb00h0hpE=
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr1085976wmc.37.1573627317534;
 Tue, 12 Nov 2019 22:41:57 -0800 (PST)
MIME-Version: 1.0
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
 <1573497494-11468-7-git-send-email-sunil.kovvuri@gmail.com> <20191112.192735.432206863470625660.davem@davemloft.net>
In-Reply-To: <20191112.192735.432206863470625660.davem@davemloft.net>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 13 Nov 2019 12:11:46 +0530
Message-ID: <CA+sq2Ces4OdUcgEkxMXdmMyrOrDjETmA+U+nvmQtLUpoTj2-nw@mail.gmail.com>
Subject: Re: [PATCH 06/18] octeontx2-af: Add per CGX port level NIX Rx/Tx counters
To:     David Miller <davem@davemloft.net>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 8:57 AM David Miller <davem@davemloft.net> wrote:
>
> From: sunil.kovvuri@gmail.com
> Date: Tue, 12 Nov 2019 00:08:02 +0530
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> > index 7d7133c..10cd5da 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
>  ...
> > +static inline int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id)
>
> I know it's already happening in this file, but do not use the inline keyword
> in foo.c files please let the compiler decide.

Okay, will fix this in all patches and resubmit.

Thanks,
Sunil.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603D43F220C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 23:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhHSVDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 17:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236024AbhHSVDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 17:03:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FD7361028;
        Thu, 19 Aug 2021 21:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629406954;
        bh=Lt3nR1GcCVw2g3nxucPozAraluMprVdKiQGv4h0FyMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aYUC5dRmtbYIY/VTAkSPs5FVCWGYITJxvMypldM+2fVtbkBOxxueMCxyHG61qwHMQ
         Blf0DlOToLGczn9+Upe2o2LptmuQ//eoOFgRZbL74UAaLy0EbWWT3u2+hLTK5x3s3u
         cB+zlrQm2EDVji4g01iwRZ1whg0VSIZpQu7OD3iya5RyUqInnqd+7YSNPN3SbWKSAv
         qo1+ymVF9qrpK4dLjdT42G2yzKLrkgRDWQdV8Bj8V/eGkclnAlEUwZ1wOEq9PqzlkE
         80qhTK192NuM2kCka7DeRJXG+YtB2E0KMEp+p375Kwk+mEZV/WnfmdnP3EnSpKTUIt
         9RExB/Pdsg+CQ==
Date:   Thu, 19 Aug 2021 14:02:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        butt3rflyh4ck <butterflyhhuangxx@gmail.com>,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
Message-ID: <20210819140233.5f8d8cd1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <763a3f4d-9edc-bb0d-539c-c97309a4975d@gmail.com>
References: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
        <20210819121630.1223327f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a5aef93-fafb-5076-4133-690928b8644a@gmail.com>
        <CAFcO6XMTiEmAfVJ4rwdeB6QQ7s3B-1hx3LJpa-StCb-WJwasPg@mail.gmail.com>
        <763a3f4d-9edc-bb0d-539c-c97309a4975d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 23:24:39 +0300 Pavel Skripkin wrote:
> On 8/19/21 11:06 PM, butt3rflyh4ck wrote:
> > Yes, this bug can be triggered without your change. The reason why I
> > point to your commit is to make it easier for everyone to understand
> > this bug.
> 
> As I understand, purpose of Fixes: tag is to point to commit where the 
> bug was introduced. I could be wrong, so it's up to maintainer to decide 
> is this Fixes: tag is needed or not :)

You're right thanks for pointing that out. May it should actually be:

Fixes: 0baa99ee353c ("net: qrtr: Allow non-immediate node routing") ?


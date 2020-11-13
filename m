Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511772B1417
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKMCAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgKMCAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 21:00:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A191720791;
        Fri, 13 Nov 2020 02:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605232843;
        bh=YIVUXvugC/QL7FJcexfRD4j0yx08NvVB+thv/g8e9Hk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XA0+ulh6yK0/DK1hev15ITWu5k4w9sKcZphDrWLa11cKFfHL83A+VK7HUclVfs2qb
         to7a9jNiwJQ3EqNr3C8r/bA8wEpJlGbCS1xlsdrMEBhcABi2+fABH3FpSJsx6mU9/x
         Gs0WOhiv1KDqHQFvnuDpFgyj4tZwQm4sOKKwQtM0=
Date:   Thu, 12 Nov 2020 18:00:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>, nbd@nbd.name,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: ethernet: mtk-star-emac: fix error return code
 in mtk_star_enable()
Message-ID: <20201112180041.1f1f96b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMpxmJXy3upa=xMpuTzoNdgCUyuZ7YQ6kSHtuji8hj7xGo5KGQ@mail.gmail.com>
References: <1605180879-2573-1-git-send-email-zhangchangzhong@huawei.com>
        <CAMpxmJXy3upa=xMpuTzoNdgCUyuZ7YQ6kSHtuji8hj7xGo5KGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 12:41:26 +0100 Bartosz Golaszewski wrote:
> On Thu, Nov 12, 2020 at 12:33 PM Zhang Changzhong
> <zhangchangzhong@huawei.com> wrote:
> >
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Applied, thanks!

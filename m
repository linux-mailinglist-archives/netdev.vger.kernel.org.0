Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B715F2606AD
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgIGVxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgIGVxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 17:53:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E4B20768;
        Mon,  7 Sep 2020 21:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599515592;
        bh=5icKKjUk8PJfSKqhpHGrpIhkR6CvSIdHBvwG1AMhtPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fBAd7CV2Ztf4nkNNa5P99RGR3QvG3Gt1pPji3fdQ4yxKHVTeMndmoQl9y7nF3hOWW
         lsMrePtX2R/Vb++NymAc9V2XfZTJgQifHB7cZOgb1jk0tmZ/Yn27RylLBB07onk9xY
         ELpJwydht9ChKUKui0L/1pyQsYSL244AntmIK0RA=
Date:   Mon, 7 Sep 2020 14:53:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/6] sfc: remove phy_op indirection
Message-ID: <20200907145310.5f217d79@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5809ba4c-e2be-b3ab-7122-dee2241310d0@solarflare.com>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
        <9cc76465-9c1c-ec10-846a-b58f16d0d083@solarflare.com>
        <20200907122230.47ccfd55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5809ba4c-e2be-b3ab-7122-dee2241310d0@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 20:31:03 +0100 Edward Cree wrote:
> On 07/09/2020 20:22, Jakub Kicinski wrote:
> > On Mon, 7 Sep 2020 17:14:34 +0100 Edward Cree wrote: =20
> >>  drivers/net/ethernet/sfc/mcdi_port.c        | 593 +-------------------
> >>  drivers/net/ethernet/sfc/mcdi_port_common.c | 560 ++++++++++++++++++ =
=20
> > Would you mind improving variable ordering and addressing checkpatch
> > complaints while moving this code? The camel case and breaking up
> > case statements warning can definitely be ignored, but there are others=
. =20
> I'd prefer to do it as a separate follow-up patch, so that git tools
> =C2=A0can more reliably trace the history across the movement, per [1].
> If the series needs respinning then I'll add it in v2, otherwise I'll
> =C2=A0post it standalone after this goes in.

Okay, applied, thanks!

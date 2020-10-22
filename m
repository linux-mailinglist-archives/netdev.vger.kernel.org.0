Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774442967BC
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 01:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373559AbgJVXww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 19:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901066AbgJVXww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 19:52:52 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1EC2173E;
        Thu, 22 Oct 2020 23:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603410771;
        bh=9gAIxJL4MV+DJ7QNOAOCU6zMYw5ESLqP5vy1OgMaj+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gUyaE9FiJhe5aKayEyvos2Sb7cM1x/zGC8u54uk8HGcaBSRdYjDtkUPcI8CMCZJ+X
         vqXJgpnjwj2YTQ/vdUyV7Z8A1km0SL6ETztC2cXOLwOjomdrd7MyRe7pKsCjzq2T44
         p0hKQsuX0i2Mg41jr33aCR28CY87A8lz00DAsGgs=
Date:   Thu, 22 Oct 2020 16:52:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net 6/7] ch_ktls/cxgb4: handle partial tag alone SKBs
Message-ID: <20201022165249.0d8079ce@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022101019.7363-7-rohitm@chelsio.com>
References: <20201022101019.7363-1-rohitm@chelsio.com>
        <20201022101019.7363-7-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 15:40:18 +0530 Rohit Maheshwari wrote:
> If TCP congestion caused a very small packets which only has some
> part fo the TAG, and that too is not till the end. HW can't handle
> such case, so falling back to sw crypto in such cases.
>=20
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c: At top leve=
l:
drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1864:5: warn=
ing: no previous prototype for =E2=80=98chcr_ktls_sw_fallback=E2=80=99 [-Wm=
issing-prototypes]
 1864 | int chcr_ktls_sw_fallback(struct sk_buff *skb, struct chcr_ktls_inf=
o *tx_info,
      |     ^~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1864:5: warn=
ing: symbol 'chcr_ktls_sw_fallback' was not declared. Should it be static?

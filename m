Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CC53DDDD9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhHBQlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhHBQlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CDB260243;
        Mon,  2 Aug 2021 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627922455;
        bh=FHqihF2cbV3c9YzhELKZHwFZAdpBDscUi//6o9VpxWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hzYLbZ9Awkjme1NHP+IYtXaTzNdhl0o7W201WR3LzLndPpb+rCqa0Sa2crdM3aavS
         9eT0l880n+OXPbmVJGxdpINaj8EQCY/86eAoaFn2IPHyWP+GbRbAyWxKNBiE8ap/tl
         0mZ8ilf347aY426ZUTjQPI3LJN29SRNvTTN/iQaIe65KR2uFf9w53b78K+qiPdzT0E
         rJpfNz6Cw7ChN/OHB2eqFSOZF2TqDOz2oizv0j9S7FCxlpVVRvelLhY0Gg3CUXvDwA
         cTlgs44afXho2XMH6D9B64xGosCur+XAPsCd78TqxvHN8Ldxpun+T0nrbtgk81bXeM
         MT/invV5P8kCg==
Date:   Mon, 2 Aug 2021 09:40:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, johannes@sipsolutions.net,
        richard.laing@alliedtelesis.co.nz
Subject: Re: [PATCH net-next RESEND 1/2] net: wwan: Add MHI MBIM network
 driver
Message-ID: <20210802094054.7bc27154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1627890663-5851-2-git-send-email-loic.poulain@linaro.org>
References: <1627890663-5851-1-git-send-email-loic.poulain@linaro.org>
        <1627890663-5851-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Aug 2021 09:51:02 +0200 Loic Poulain wrote:
> Add new wwan driver for MBIM over MHI. MBIM is a transport protocol
> for IP packets, allowing packet aggregation and muxing. Initially
> designed for USB bus, it is also exposed through MHI bus for QCOM
> based PCIe wwan modems.
>=20
> This driver supports the new wwan rtnetlink interface for multi-link
> management and has been tested with Quectel EM120R-GL M2 module.

Let's make sure it builds cleanly with W=3D1 C=3D1 first.

drivers/net/wwan/mhi_wwan_mbim.c:83:23: warning: no previous prototype for =
=E2=80=98mhi_mbim_get_link=E2=80=99 [-Wmissing-prototypes]
   83 | struct mhi_mbim_link *mhi_mbim_get_link(struct mhi_mbim_context *mb=
im,
      |                       ^~~~~~~~~~~~~~~~~
drivers/net/wwan/mhi_wwan_mbim.c:83:22: warning: symbol 'mhi_mbim_get_link'=
 was not declared. Should it be static?

Also - please start putting someone in the To: header, preferably the
maintainer / mailing list thru which you expect the code to be merged.

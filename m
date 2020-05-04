Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D641C40B4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgEDRDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbgEDRDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 13:03:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A7B206D7;
        Mon,  4 May 2020 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588611782;
        bh=fU2OdBYZA3fWd3pNJxXMgGwZS3ICj4CFvix6NgOJKow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/DnChfyBjkZKibeB1+dx1O2X/yrkrgBjERDskR3UANYJfz/GyTxkY3IezZbsdsLf
         eoSWZx+p7q5T8eQtTwjXrZKm8sERrTl3cVWxEZIvc5l10loQRLzMixYkMqAGlZsOdP
         d0gTFQYOlpdepbZ7rsY2gwWogY5j8NxRmJtcm7mI=
Date:   Mon, 4 May 2020 10:03:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wu000273@umn.edu
Cc:     davem@davemloft.net, Markus.Elfring@web.de,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kjlu@umn.edu
Subject: Re: [PATCH v3] nfp: abm: Fix incomplete release of system resources
 in nfp_abm_vnic_set_mac()
Message-ID: <20200504100300.28438c70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200503204932.11167-1-wu000273@umn.edu>
References: <20200503204932.11167-1-wu000273@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 May 2020 15:49:32 -0500 wu000273@umn.edu wrote:
> From: Qiushi Wu <wu000273@umn.edu>
>=20
> In function nfp_abm_vnic_set_mac, pointer nsp is allocated by nfp_nsp_ope=
n.
> But when nfp_nsp_has_hwinfo_lookup fail, the pointer is not released,
> which can lead to a memory leak bug. Thus add a call of the function
> =E2=80=9Cnfp_nsp_close=E2=80=9D for the completion of the exception handl=
ing.
>=20
> Fixes: f6e71efdf9fb1 ("nfp: abm: look up MAC addresses via management FW")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>

This just makes the code longer. v1 was perfectly fine, thanks for the
fix.=20

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A831CE832
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEKWgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgEKWgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 18:36:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C83DB2070B;
        Mon, 11 May 2020 22:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589236598;
        bh=gHLiG+DSLpLJo5lP1j6NEzFrYlzPvs0mBsoXQjlJQKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zSeY9A+9wzXoyuDeogs28ZxENZR2AAGE831pLipTv5CSBQNvCV3NAns1pNXM4V+63
         lrXwFnT6wMA+TtaZmt6m5mBrH8e/vnMlh7ThSaKIpJODVWbbrOgfGyvbIZgnGHDguw
         Uj19zogPrr7g++kSOyaRNCCB6Q/J9ItsG8GIehOc=
Date:   Mon, 11 May 2020 15:36:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/8] sfc: make capability checking a nic_type
 function
Message-ID: <20200511153636.0f9cd385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
        <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 May 2020 13:28:40 +0100 Edward Cree wrote:
> From: Tom Zhao <tzhao@solarflare.com>
>=20
> Various MCDI functions (especially in filter handling) need to check the
>  datapath caps, but those live in nic_data (since they don't exist on
>  Siena).  Decouple from ef10-specific data structures by adding check_caps
>  to the nic_type, to allow using these functions from non-ef10 drivers.
>=20
> Also add a convenience macro efx_has_cap() to reduce the amount of
>  boilerplate involved in calling it.
>=20
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Commit 66119f0b0358 ("sfc: make capability checking a nic_type function")
	author Signed-off-by missing
	author email:    tzhao@solarflare.com
	committer email: kuba@kernel.org
	Signed-off-by: Edward Cree <ecree@solarflare.com>

Errors in tree with Signed-off-by, please fix!

Also with W=3D1:

 ../drivers/net/ethernet/sfc/siena.c:951:14: warning: symbol 'siena_check_c=
aps' was not declared. Should it be static?
1a3,5
 ../drivers/net/ethernet/sfc/siena.c:951:14: warning: no previous prototype=
 for =C3=A2=E2=82=AC=CB=9Csiena_check_caps=C3=A2=E2=82=AC=E2=84=A2 [-Wmissi=
ng-prototypes]
   951 | unsigned int siena_check_caps(const struct efx_nic *efx,
       |              ^~~~~~~~~~~~~~~~

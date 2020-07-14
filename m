Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2604621F764
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgGNQdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgGNQdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:33:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF4122464;
        Tue, 14 Jul 2020 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594744390;
        bh=IL/q2MikxWSOCHkTue3ZRfLBYvGD19b9OpRaKqZN4HE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aBVNtA92jLN1dzeOkKemXhxadHbEzUZ2eZQ+DKMaB4hnTHe1lAanPjZSKd32VVfl7
         ihmRRaV1w1vMG9UGMiodLeDtekzPAEmnOQgI2Ke18Hr3Ve9Qkn9pWp74K5rXaCfAfo
         mEcHTjOxe6f1Lya8oUOKdaDH6WEbyMSC0fnieO3E=
Date:   Tue, 14 Jul 2020 09:33:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>,
        "leon@kernel.org" <leon@kernel.org>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
Message-ID: <20200714093308.584d69d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <88664bf2-a0c9-4cb1-b50c-2a5e592fe235@solarflare.com>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
        <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
        <20200713160200.681db7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <88664bf2-a0c9-4cb1-b50c-2a5e592fe235@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 10:02:05 +0100 Edward Cree wrote:
> On 14/07/2020 00:02, Jakub Kicinski wrote:
> > On Mon, 13 Jul 2020 12:32:16 +0100 Edward Cree wrote: =20
> >> +MODULE_VERSION(EFX_DRIVER_VERSION); =20
> > We got rid of driver versions upstream, no? =20
> The sfc driver still has a MODULE_VERSION(), I just made this do
> =C2=A0the same.=C2=A0 Should I instead remove the one from sfc as well?

Yes, please.

Leon, I see there's a bunch of MODULE_VERSIONS() still left - are you
planning to take care of those? Perhaps removing them is a good "intern
task"?

> I assumed there was some reason why it hadn't been included in
> =C2=A0the versionectomy so far.

versionectomy :)

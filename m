Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EF9429FC4
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhJLI3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234687AbhJLI3I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 04:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFECD60E97;
        Tue, 12 Oct 2021 08:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634027227;
        bh=aIJacovCewbr7k3+VzVTXI7bdt6hKizFNEjnGT86weA=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=h8fCrRhkaObQsku/sBzZhk/rfYWZTHxzndIBaT50cWeDX58Xa1J+ziSFXio9foOHS
         C1srk3O7wUOXUtPAyDOFQ5E5Mt7uhfN2rfQ2jGYWPFcms/zUKKd4tSWhWMnhDH9B3C
         Fh9Vw46vL92zRnseGMs5EuQrd+UIjE2revd6yQoG3+F1OfujLAaUNtnDIrc4svBJR8
         MPWtddhsGr+F/lNZw4AZNo4Xf1TCYpTlYwtDKjYUpXUaCgGaJWyBTKULAole42RmbB
         Ga7zMJSh8ES8euvaAK5NPUMdviWF4TkdADUtLRaRD8+V+8uVevgAFArpIU4SUEltqR
         lqOvobGpwfT/A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211011171759.2b59eb29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com> <20211011165517.2857893-2-sean.anderson@seco.com> <20211011171759.2b59eb29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2 2/2] net: macb: Allow SGMII only if we are a GEM in mac_validate
Message-ID: <163402722393.4280.13825891236036678146@kwain>
Date:   Tue, 12 Oct 2021 10:27:03 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sean,

Quoting Jakub Kicinski (2021-10-12 02:17:59)
> On Mon, 11 Oct 2021 12:55:17 -0400 Sean Anderson wrote:
> > This aligns mac_validate with mac_config. In mac_config, SGMII is only
> > enabled if macb_is_gem. Validate should care if the mac is a gem as
> > well. This also simplifies the logic now that all gigabit modes depend
> > on the mac being a GEM.

This looks correct.

> > Fixes: 7897b071ac3b ("net: macb: convert to phylink")

If this is a fix, the patch has to be first in the series as it is
depending on the first one which is not a fix.

Thanks,
Antoine

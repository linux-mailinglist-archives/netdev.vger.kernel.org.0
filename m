Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFD13083DE
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhA2Ce2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhA2CeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:34:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 043C564DBD;
        Fri, 29 Jan 2021 02:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611887624;
        bh=KLQefFFQ5pcFGhFE5flj1il6GX5Wea1PhTE94Uz6hYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZ+co7AvQk6qveAR4nht7gM/Y/c82FD1tJUeaK33QfEdXfJOsceC4kIO2gcamZAfr
         ZxvWE5GasPZ7fOiCZK3QqocokNq+XEQTyM6CeM1Sb54B0s6w4bSKWX0HUkGw5FkuNE
         +CT61naj4Uml/97JOXO7DSauiIVPeh/IbVarrsdnaxWp4Yhpzgn5sUZBn6cJVj4qTp
         orHgeVjKIXuBd1D7Lj2DmNyBSTK8cAf2xtHm6uz+woDx+BWO2xyGKG42NkvV1VwS9m
         EPkcJppVEC9AhKK2lUuPaxPwF20jxEzB/juxgWTqfQ6pNeCO871oOL4Lq9uwcJ3ByI
         0NEI8asrYSKlA==
Date:   Thu, 28 Jan 2021 18:33:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH resend] e100: switch from 'pci_' to 'dma_' API
Message-ID: <20210128183343.06762fc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <268fcfd4dbd929948e8cdb58457ede1efa3898c6.camel@intel.com>
References: <20210128210736.749724-1-christophe.jaillet@wanadoo.fr>
        <268fcfd4dbd929948e8cdb58457ede1efa3898c6.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 21:45:02 +0000 Nguyen, Anthony L wrote:
> >  drivers/net/ethernet/intel/e100.c | 92 ++++++++++++++++-------------
> 
> My apologies, this patch slipped through the cracks for me. I will send
> it in my next net-next 1GbE series or Jakub you can take it directly if
> you'd like.

No preference but since I have to type a response either way let me say:

Applied, thanks!

;)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3818F2EEB9C
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbhAHDDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbhAHDDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 22:03:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42E923603;
        Fri,  8 Jan 2021 03:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610074957;
        bh=aNaccHooz895cvPQG8Y/8/YroLDS2+Tb7Wl1w8sJwCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eiuUEIx/HPzQ0qStr+5y72sVd5lx+1tS/vT5rRz9SIzq+eSgrEdsWkfuClXDaX9bq
         xJEhRHqNIjxfvq3hNH/U/FDgOT+/OezgMsF1w6u5BTi+RRHQDHnCA7bIVI7mkGHAv+
         xkP5uZMGDssVgBDauknWkFApqZCleoMrBTXuEpfluHlL5d6MVwtu1agncas6/Tt+oM
         zasQNyC6ljfDiyhgjvWQ1QcmWzRlDXvTQfdnZU/jjvvGme2EF2E5Q92YoH7WwAiJte
         oUnlwANQKobfxlgBJ8bjnZB5rZi+3WUa5pAmRCkdXKYALTe5Fhw6dMieWGOYxCq47N
         j7vkliHX2Txrw==
Date:   Thu, 7 Jan 2021 19:02:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lantiq_gswip: Exclude RMII from modes that
 report 1 GbE
Message-ID: <20210107190236.1a3889fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <896cea47-c612-5559-d3dc-c66d86e48a39@gmail.com>
References: <20210107195818.3878-1-olek2@wp.pl>
        <896cea47-c612-5559-d3dc-c66d86e48a39@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 12:00:44 -0800 Florian Fainelli wrote:
> On 1/7/21 11:58 AM, Aleksander Jan Bajkowski wrote:
> > Exclude RMII from modes that report 1 GbE support. Reduced MII supports
> > up to 100 MbE.
> > 
> > Fixes: 14fceff ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")

Please make sure that the hash is at least 12 chars in the future.

> > Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>  
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!

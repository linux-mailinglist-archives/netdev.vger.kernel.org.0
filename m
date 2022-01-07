Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C667F487B64
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348557AbiAGR2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiAGR2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:28:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3F9C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 09:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF9DE61584
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 17:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0540FC36AEB;
        Fri,  7 Jan 2022 17:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641576524;
        bh=fFsFZ59YCyo0ZO7xxcXMvoiIDryTF66IFReHcnZmlAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SIVdr775uyw769hRGBVGeAmV1bJtbkjaL4PWNd2n74MAdaREuTr8YYtgPMMP7yb2P
         mQtEcQvGZb3Ey6XTaD7B/OEQ8dlSOmwTqhm05q7z6FttY1sRbnx/IOH2kRrDwtCTm/
         +O9Kyoi+nBlGBANu4twhFwgWp/soEknp5S5uKTyXC+Hht6sB6SUuxBClaOL5Vc/Dqc
         H8ytOMWDHG83SfzAG8R0GQHyfeLUJM3QElcPfZK5Dl/hBcnrADFDYBj10+Vq/Ra8i9
         sx5INLpA2EYoQ8Wgx0dpW29azqOcrc8ondA7A7oJcxzq8mT+Q3pZGpcpu4sA5FC9V2
         YSHKHeU0SxhPQ==
Date:   Fri, 7 Jan 2022 09:28:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Sornek, Karen" <karen.sornek@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Patynowski, PrzemyslawX" <przemyslawx.patynowski@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 2/7] i40e: Add placeholder for ndo set VLANs
Message-ID: <20220107092842.61631642@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9f5f4b4521194293714afab1d69dbcea9cd07030.camel@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
        <20220106213301.11392-3-anthony.l.nguyen@intel.com>
        <20220106203254.1c6159fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9f5f4b4521194293714afab1d69dbcea9cd07030.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 17:16:33 +0000 Nguyen, Anthony L wrote:
> On Thu, 2022-01-06 at 20:32 -0800, Jakub Kicinski wrote:
> > On Thu,=C2=A0 6 Jan 2022 13:32:56 -0800 Tony Nguyen wrote: =20
> > > From: Karen Sornek <karen.sornek@intel.com>
> > >=20
> > > VLANs set by ndo, were not accounted.
> > > Implement placeholder, by which driver can account VLANs set by
> > > ndo. Ensure that once PF changes trunk, every guest filter
> > > is removed from the list 'vm_vlan_list'.
> > > Implement logic for deletion/addition of guest(from VM) filters. =20
> >=20
> > I could not understand what this change is achieving from reading
> > this.
> >  =20
> The author is currently out on holiday. I'm going to drop this from the
> series so the other patches can make it before net-next closes. She'll
> respond and/or make changes when she returns.

SG! The rest of the patches LGTM, thanks!

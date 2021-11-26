Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8481F45F50C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhKZTSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhKZTQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:16:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9945C0619F6
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 10:37:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E229CB82876
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 18:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B621C93056;
        Fri, 26 Nov 2021 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637951847;
        bh=NDVImURTM0EtfnxkSvjDQmpEOs3wTkpsqhkQfuYE/a0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JHRbKjB4hDh8MUNeQMtS16jZsUQ8d2RNOkerZerk+2fAiDjux2ZYJlbs3S9WlMdeZ
         wpeCHCfBVCAG3bBYm6ovO3wV1D1MRJKD6sDHo7O95cbjIAZ9to1y0mWYEpGUsk94v5
         lypc4Gj7+rnMpOI5PqdjbI8R1EwwWyj68NBJ+5bSlFy7qArxT/rBd2Xy/9BFsa7Szr
         Q6+wxZogrRrfN1kEx3p8dQ0lbn47s/uJUx8SCM3ShkI7DxUCQUjtCsyer4OCLOKxSO
         VNWghWLQS+kI6WIVVpADqqc/Khib46WwuFw4gjfhk8xTXioMeKUC3LPFN/IqCic387
         mGFdvsBUOYjjw==
Date:   Fri, 26 Nov 2021 10:37:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Message-ID: <20211126103726.6f3976a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 16:42:48 +0100 Holger Brunck wrote:
> This can be configured from the device tree. Add this property to the
> documentation accordingly.
> The eight different values added in the dt-bindings file correspond to
> the values we can configure on 88E6352, 88E6240 and 88E6176 switches
> according to the datasheet.
> 
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>

Not sure why but FWIW your patches did not show up in patchwork on in
lore. We can see Andrew's review but not the patches themselves:

https://lore.kernel.org/all/YaEIVQ6gKOSD1Vf%2F@lunn.ch/

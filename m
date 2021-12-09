Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFC846E03D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhLIBb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:31:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38748 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbhLIBb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:31:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8593AB82317;
        Thu,  9 Dec 2021 01:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEA8C00446;
        Thu,  9 Dec 2021 01:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639013302;
        bh=/FtNUG/WWkxltTH8Nk4Hg0EZ5zdeoQUehhw/YuKjDe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=meHP4qR7eJ1h2pUXGK66UVw7o8IEZjcQaCNbqcMYxHGWb9oO3MLUR3tLkAoQV6Gua
         052V6VDPtFTeIxSeKP9Npe/hrcI5q8wO4r33Ec/k0s8k+Q3PpfbwpViZzmcDRknRsH
         kQJQkhlMAMHrWRVa4QSFneOxmedcRSIH6D760sZXzJJR6pj3eC0IRO5q1Zc6Akm8gY
         g6p1A0Z6OnR5P1rmazA/oZEukZtVA6ovrlkucMwiK9qEv/fIDLTJz0FAUliNIrOHJv
         0fGB+0fELbtYaammYbUV3R+Q8v4eaG1tuxQGYFzxuulU1oMVZrAMP8CWbq2gbAKP+I
         h9axFJBcB3/kQ==
Date:   Wed, 8 Dec 2021 17:28:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     kabel@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: error handling for serdes_power
 functions
Message-ID: <20211208172820.1f273b3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208155809.103089-1-amhamza.mgc@gmail.com>
References: <20211208164042.6fbcddb1@thinkpad>
        <20211208155809.103089-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Dec 2021 20:58:09 +0500 Ameer Hamza wrote:
> @@ -1507,7 +1510,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  			    bool on)
>  {
>  	u8 cmode = chip->ports[port].cmode;
> -	int err = 0;
> +	int err;
>  
>  	if (port != 0 && port != 9 && port != 10)
>  		return -EOPNOTSUPP;

This is on top of v1? It doesn't seem to apply, v1 was not merged.

Also can you please add Fixes tags?

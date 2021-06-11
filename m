Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA5F3A3A3C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhFKD2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:28:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhFKD2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 23:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fSnwROAFLm7Q7uOls0Q2WAjyN5fsoEmLVk3kc7F/XUU=; b=AAjyVQMwM1w3eKz9N/56QpxQ3K
        8aNSx2EA0iaMyJEEkNqhFfI/Dghbw4oitqdx5NpNqTgXqIP4t4Oni5iS2wEvuhjQu8rAaCmdt9wo0
        RMlnALf2c/AqS5ye+OC1tcDbyfV23HyUnSQJq0czf1jNobwGZFKQ7qSUWdmp6SQ3DZEE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrXo2-008mVT-06; Fri, 11 Jun 2021 05:26:02 +0200
Date:   Fri, 11 Jun 2021 05:26:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, richardcochran@gmail.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v2 net-next 00/10] DSA tagging driver for NXP SJA1110
Message-ID: <YMLXyf5g/PLSYpj7@lunn.ch>
References: <20210610232629.1948053-1-olteanv@gmail.com>
 <20210610.165050.1024675046668459735.davem@davemloft.net>
 <20210611000915.ufp2db4qtv2vsjqb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611000915.ufp2db4qtv2vsjqb@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 03:09:15AM +0300, Vladimir Oltean wrote:
> On Thu, Jun 10, 2021 at 04:50:50PM -0700, David Miller wrote:
> > 
> > Patch 9 no longer applies cleanly.
> > 
> > Thank you.
> 
> Ah, that is because I also have the "Port the SJA1105 DSA driver to XPCS"
> patches in my tree, and they are photobombing this series. With git rebase -i
> they apply both ways, but git rebase has more context when applying than
> git am, so I'm not in fact surprised that it fails, now that you mention it.
> 
> I could probably dodge that by moving some lines of code here and there
> so they aren't near the XPCS changes

Hi Vladimir

git am is very pedantic. It does not use fuzz. So just moving lines
within the same line is unlikely to work, you need to make the changes
in non intersecting sets of files.

Your best bet is to be patient and wait for one patchset to get
merged, and then submit the second patchset.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FDB27483B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIVSf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVSf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 14:35:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D812065D;
        Tue, 22 Sep 2020 18:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600799759;
        bh=jaCf4zip5swAI+S2TMkjFoRd/HDKVe1ywnXGlHM6tu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wDv7z04Gs+mB/qvO+x+mZBwLe0FzIDYysnbMGuCCA7KSemiT6EE81giV1vFMu3KWe
         jHgbXg3WFOBJxDGIP+l8JT5CYoOJiUbczT6FWIQuKd0BVar8cjcmmWW6IE7gqJ8Vdl
         rVIreXtoxwidqPpn9eXmu+7bVaJYh1JbXMVbMNhA=
Date:   Tue, 22 Sep 2020 11:35:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Brown, Aaron F" <aaron.f.brown@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a
 test for shared UDP tunnel info tables
Message-ID: <20200922113557.15a95bf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR11MB289053EE6E23D53BD4D2126BBC3B0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
        <20200722012716.2814777-5-kuba@kernel.org>
        <SN6PR11MB2896F5ACC5A59F7F330183FFBC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
        <20200921144408.19624164@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM6PR11MB289053EE6E23D53BD4D2126BBC3B0@DM6PR11MB2890.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 17:34:41 +0000 Brown, Aaron F wrote:
> I should have tunneling enabled as modules, config I was using in
> it's entirety (started with a `make localmodconfig` on a Red Hat
> EL8.x box then started adding modules as needed, so I expect I am
> missing something :)  config follows:

No luck :(

# ./udp_tunnel_nic.sh 
PASSED all 435 checks

Since your failures are on port 1 - which is the config where the
driver sleeps I wonder if this is not a race condition of some sort.

Could you try poking at the values in function check_tables?
The sleep lengths and the retries?

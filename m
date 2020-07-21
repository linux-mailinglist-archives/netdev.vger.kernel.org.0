Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3372286CE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgGURJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:09:41 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:46726 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729497AbgGURJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:09:40 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 43D70200CA;
        Tue, 21 Jul 2020 17:09:39 +0000 (UTC)
Received: from us4-mdac16-29.at1.mdlocal (unknown [10.110.49.213])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 414A3600A1;
        Tue, 21 Jul 2020 17:09:39 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CD548220070;
        Tue, 21 Jul 2020 17:09:38 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8B11498008C;
        Tue, 21 Jul 2020 17:09:38 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 18:09:17 +0100
Subject: Re: [PATCH v3 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        "kernel test robot" <lkp@intel.com>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>
References: <f1a206ef-23a0-1d3e-9668-0ec33454c2a1@solarflare.com>
 <202007170155.nhtIpp5L%lkp@intel.com>
 <aa134db3-a860-534c-9ee2-d68cded37061@solarflare.com>
 <20200721094535.15df7245@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <699dfdba-558b-7068-8ea7-d10d80369b6b@solarflare.com>
Date:   Tue, 21 Jul 2020 18:09:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200721094535.15df7245@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25554.003
X-TM-AS-Result: No-5.111800-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHmLzc6AOD8DfHkpkyUphL9amDMhjMSdnnvxOQTFF5KDfl4
        wHjhjOcWj6zhwHrR3g0Up3oAL1uc5iisv8eH5y9RR1V06KT3qb9bD9LQcHt6g3tTo0P1ssT+eNr
        Nec/7iLg2UZkqo1rM+z+K9ujtXo2PW8sQMvPj/Xx9Lo7PocodAF7OZ6hrwwnzIlxOowKJvsWdW2
        C/Ex2sgyoS4lFW7r3/7yQyt4P8YJnW6cYShI3V/OIfK/Jd5eHmfS0Ip2eEHnzWRN8STJpl3PoLR
        4+zsDTtiPbfA0kXryHoqOSc4Vjd9DfD7hsb9YmYi87123Y709X8HixsWDYOPlZca9RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.111800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25554.003
X-MDID: 1595351379-MyAvoCvfvnuB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/07/2020 17:45, Jakub Kicinski wrote:
> On Tue, 21 Jul 2020 15:48:00 +0100 Edward Cree wrote:
>> Aaaaargh; does anyone have any bright ideas?
> No bright ideas. Why do you want the driver to be modular in the first
> place?
Well, 'sfc' already is, and I'm not sure changing that is an option
 (wouldn't it break users' scripts?).  And I find development is a lot
 easier if you can just rebuild a module and reload it rather than
 having to wait for LD to put together a whole new vmlinux.

> Maybe I'm wrong, but I've never seen a reason to break up vendor drivers
> for high performance NICs into multiple modules.
So, what are you suggesting?
1) both drivers are builtin-only
2) a single module containing both drivers
3) something else?

Both (1) and (2) would allow replacing the linker trick with an if()
 on efx->revision or an efx->type-> function with INDIRECT_CALLABLE.

I don't know for sure but I suspect we made the drivers separate
 modules simply because we could (or so we thought) and we didn't
 know for certain no-one would ever want the extra flexibility.

I'll ask around and see if there's any reason we can't do (2).

-ed

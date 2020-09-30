Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A1C27E882
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgI3MZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:25:31 -0400
Received: from mailomta22-re.btinternet.com ([213.120.69.115]:57744 "EHLO
        re-prd-fep-046.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727997AbgI3MZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 08:25:31 -0400
Received: from re-prd-rgout-005.btmx-prd.synchronoss.net ([10.2.54.8])
          by re-prd-fep-046.btinternet.com with ESMTP
          id <20200930122528.LKFI4657.re-prd-fep-046.btinternet.com@re-prd-rgout-005.btmx-prd.synchronoss.net>;
          Wed, 30 Sep 2020 13:25:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1601468728; 
        bh=He3ZtxOHYvntd/R39t6Gn9zL395jrRUUUHVz9mi1hac=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:MIME-Version;
        b=eH9wjcha8BwbeVvRIfr8Lao8j0me5TljlX59UK2B0WBBD6MJ2tYLUQpBYl0z4tJVOky3YtI10bFEeAIwK/UI16m7oSZq9CrRdX2U4IF4+NIWytefqk+BBo7pMhqhzXbZbEGrIOfwKq5PYmxHH11Agzw8L7isEA8z+zJaELANxxlx4UNVUU9gnWoNE8F4p0tIVYheUzAypjMnyaIV+OkrlbQ1FXDYosrmQysvOnmHzBeEynMuZcoFn4jr1Zt28HjSSytgAWlO6vgZXUj2hXCS/lHR/ojFeCF7HTsRbiGX+7Ghkrxx8x2d3ZC9xueCzot4g2FazP2i5Bp/S7zpDCwCFg==
Authentication-Results: btinternet.com;
    auth=pass (LOGIN) smtp.auth=richard_c_haines@btinternet.com
X-Originating-IP: [81.141.56.129]
X-OWM-Source-IP: 81.141.56.129 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgdeglecutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceutffkvffkuffjvffgnffgvefqofdpqfgfvfenuceurghilhhouhhtmecufedtudenucenucfjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpeftihgthhgrrhguucfjrghinhgvshcuoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqeenucggtffrrghtthgvrhhnpeekgeeftdffkeeikedugedvkeejheeiffevveelgedtleduteevudelffdugffgieenucfkphepkedurddugedurdehiedruddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepkedurddugedurdehiedruddvledpmhgrihhlfhhrohhmpeeorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoehjmhhorhhrihhssehnrghmvghirdhorhhgqedprhgtphhtthhopeeolhgrfhhorhhgvgesghhnuhhmohhnkhhsrdhorhhgqedprhgtphhtthhopeeolhhinhhugidqshgvtghurhhithihqdhmohguuhhlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgheqpdhrtghpthhtohep
        oehoshhmohgtohhmqdhnvghtqdhgphhrsheslhhishhtshdrohhsmhhotghomhdrohhrgheqpdhrtghpthhtohepoehprggslhhosehnvghtfhhilhhtvghrrdhorhhgqedprhgtphhtthhopeeophgruhhlsehprghulhdqmhhoohhrvgdrtghomheqpdhrtghpthhtohepoehsvghlihhnuhigsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeoshhtvghphhgvnhdrshhmrghllhgvhidrfihorhhksehgmhgrihhlrdgtohhmqe
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-SNCR-hdrdom: btinternet.com
Received: from localhost.localdomain (81.141.56.129) by re-prd-rgout-005.btmx-prd.synchronoss.net (5.8.340) (authenticated as richard_c_haines@btinternet.com)
        id 5ED9C74D136677D7; Wed, 30 Sep 2020 13:25:28 +0100
Message-ID: <33cf57c9599842247c45c92aa22468ec89f7ba64.camel@btinternet.com>
Subject: Re: [PATCH 3/3] selinux: Add SELinux GTP support
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     Harald Welte <laforge@gnumonks.org>
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        stephen.smalley.work@gmail.com, paul@paul-moore.com,
        pablo@netfilter.org, jmorris@namei.org
Date:   Wed, 30 Sep 2020 13:25:27 +0100
In-Reply-To: <20200930110153.GT3871@nataraja>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
         <20200930094934.32144-4-richard_c_haines@btinternet.com>
         <20200930110153.GT3871@nataraja>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 13:01 +0200, Harald Welte wrote:
> Hi Richard,
> 
> I don't fully understand in which context you need / use those
> SELinux GTP hooks,

As in the reply to Pablo, I did it for no particular reason other than
idle curiosity, and given the attempted move to Open 5G I thought
adding MAC support might be useful somewhere along the line.

> however one comment from the point of view of somebody who is working
> on GGSN/P-GW
> software using the GTP kernel module:
> 
> On Wed, Sep 30, 2020 at 10:49:34AM +0100, Richard Haines wrote:
> > +selinux_gtp_dev_cmd()
> > +~~~~~~~~~~~~~~~~~~~~~
> > +Validate if the caller (current SID) and the GTP device SID have
> > the required
> > +permission to perform the operation. The GTP/SELinux permission
> > map is
> > +as follow::
> > +
> > +    GTP_CMD_NEWPDP = gtp { add }
> > +    GTP_CMD_DELPDP = gtp { del }
> > +    GTP_CMD_GETPDP = gtp { get }
> 
> Wouldn't it make sense to differentiate between:
> 
> a) add/del/get on the GTP netdev
> b) add/del/get on the indivudual PDP wihin the GTP netdev
> 
> 'a' is typically only created once at startup of a GGSN/P-GW
> software, or is
> done even at system stat-up time.
> 
> 'b' is performed frequently during runtime as the GGSN/P-GW function
> runs, as
> subscribers attach to / detach from the cellular network.
> 
> By differentiating between those two, one could further constrain the
> permissions
> required at runtime.

Yes, at first I did separate them (add_dev, del_dev, add_pkt, del_pkt,
get_pkt), so if this patchset goes anywhere then I can change it no
problem. I guess the '*_pkt' permissions would cover PDP for 3G and PDR
& FAR for 5G ?.
I didn't implement 'get_dev' but thought it could be useful for
retrieving the security context of a device, but that requires passing
it back via netlink so thought I would leave it until later.

> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02CF28D25A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 18:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgJMQi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 12:38:28 -0400
Received: from mailomta13-sa.btinternet.com ([213.120.69.19]:49493 "EHLO
        sa-prd-fep-047.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726942AbgJMQi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 12:38:27 -0400
Received: from sa-prd-rgout-004.btmx-prd.synchronoss.net ([10.2.38.7])
          by sa-prd-fep-047.btinternet.com with ESMTP
          id <20201013163824.GNHU4609.sa-prd-fep-047.btinternet.com@sa-prd-rgout-004.btmx-prd.synchronoss.net>;
          Tue, 13 Oct 2020 17:38:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1602607104; 
        bh=wACf3Mpnrb86ay9KbtonDAJZf/90XXOvVorm3FbySaE=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:MIME-Version;
        b=RKTqQ+oOwL2NjtW18VBTcqLkuibQyXNmit/VqWooqgrxDhlXqqR9HB16m5ApYY6/p3NWlrhrJQZ7cafem+mRbGty2Mgm+tdakbKjU5EJWx3TBsuxKk5sasRL9ktyzUKSzP+s3iToVhgrAgx5xWwfNqx5NwAuLgnZWmj1u7hYh1zMwPmxnwoMbfYxHZl12GyIZq7pYtnZsHYqUKySdjUm+1m5NRabDC1qoL+1lfL6Ef9mCEic6FnIrfzD/scYIHmShqf/ubz41UPPmR7/gjei/kBd8lSNmvw8Z2Yqaf24W8ltPY98rM5C8AKlX1WZcfKbwsggFkJih+BepUdWNuiZBg==
Authentication-Results: btinternet.com;
    auth=pass (LOGIN) smtp.auth=richard_c_haines@btinternet.com
X-Originating-IP: [81.147.56.93]
X-OWM-Source-IP: 81.147.56.93 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedujedrheelgddutdegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuueftkffvkffujffvgffngfevqffopdfqfgfvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpeftihgthhgrrhguucfjrghinhgvshcuoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqeenucggtffrrghtthgvrhhnpeetteevgeehveeiieefkedvieehjeevtdeileffffefveelieejvedvjedvuddugeenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeekuddrudegjedrheeirdelfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepkedurddugeejrdehiedrleefpdhmrghilhhfrhhomhepoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeojhhmohhrrhhishesnhgrmhgvihdrohhrgheqpdhrtghpthhtohepoehlrghfohhrghgvsehgnhhumhhonhhkshdrohhrgheqpdhrtghpthhtohepoehlihhnuhigqdhsvggtuhhrihhthidqmhhoughulhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgt
        phhtthhopeeonhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeoohhsmhhotghomhdqnhgvthdqghhprhhssehlihhsthhsrdhoshhmohgtohhmrdhorhhgqedprhgtphhtthhopeeophgrsghlohesnhgvthhfihhlthgvrhdrohhrgheqpdhrtghpthhtohepoehprghulhesphgruhhlqdhmohhorhgvrdgtohhmqedprhgtphhtthhopeeoshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehsthgvphhhvghnrdhsmhgrlhhlvgihrdifohhrkhesghhmrghilhdrtghomheq
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-SNCR-hdrdom: btinternet.com
Received: from localhost.localdomain (81.147.56.93) by sa-prd-rgout-004.btmx-prd.synchronoss.net (5.8.340) (authenticated as richard_c_haines@btinternet.com)
        id 5ED9B66115DDE5BF; Tue, 13 Oct 2020 17:38:24 +0100
Message-ID: <77226ae9dc60113d1953c1f957849d6460c5096f.camel@btinternet.com>
Subject: Re: [PATCH 3/3] selinux: Add SELinux GTP support
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     Paul Moore <paul@paul-moore.com>,
        Harald Welte <laforge@gnumonks.org>
Cc:     pablo@netfilter.org, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        James Morris <jmorris@namei.org>
Date:   Tue, 13 Oct 2020 17:38:16 +0100
In-Reply-To: <CAHC9VhTrSBsm-qVh95J2SzUq5=_pESwTUBRmVSjXOoyG+97jYA@mail.gmail.com>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
         <20200930094934.32144-4-richard_c_haines@btinternet.com>
         <20200930110153.GT3871@nataraja>
         <33cf57c9599842247c45c92aa22468ec89f7ba64.camel@btinternet.com>
         <20200930133847.GD238904@nataraja>
         <CAHC9VhT5HahBhow0RzWHs1yAh5qQw2dZ-3vgJv5GuyFWrXau1A@mail.gmail.com>
         <20201012093851.GF947663@nataraja>
         <CAHC9VhTrSBsm-qVh95J2SzUq5=_pESwTUBRmVSjXOoyG+97jYA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-13 at 09:55 -0400, Paul Moore wrote:
> On Mon, Oct 12, 2020 at 5:40 AM Harald Welte <laforge@gnumonks.org>
> wrote:
> > Hi Paul,
> > 
> > On Sun, Oct 11, 2020 at 10:09:11PM -0400, Paul Moore wrote:
> > > Harald, Pablo - I know you both suggested taking a slow iterative
> > > approach to merging functionality, perhaps you could also help
> > > those
> > > of us on the SELinux side better understand some of the common
> > > GTP use
> > > cases?
> > 
> > There really only is one use case for this code:  The GGSN or P-GW
> > function
> > in the 3GPP network architecture ...
> > 
> > Hope this helps,
> >         Harald
> 
> It does, thank you.
> 
> It looks like this patchset is not really a candidate for merging in
> its current form, but I didn't want to lose this information (both
> the
> patches and Harald's comments) so I created a GH issue to track this
> at the URL below.
> 
> * https://github.com/SELinuxProject/selinux-kernel/issues/54
> 

While I was not expecting these patches to be excepted for the current
version, the main aim was to see what LSM security services could be
implemented on possible 5G components, bearing in mind the DARPA Open
Programmable Secure 5G (OPS-5G) initiative (probably 'jumping the gun'
here a bit though). 

There is in development a 5G version of GTP at [1]. I have added the
enhanced hooks to this (plus retrieve contexts via call-backs etc.),
and have it running on 5.9, passing their tests. I'm not sure how far
this development will go, but a starter ??.

The other component that seems to be widely used in these systems is
SCTP that I added hooks to a few years ago, also TCP/UDP etc. that are
already well catered for. Also there would be a large amount of
userspace code ....

Anyway food for thought.

[1] https://github.com/PrinzOwO/gtp5g



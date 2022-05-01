Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DD6516448
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346232AbiEAMAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 08:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244686AbiEAMAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 08:00:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DF73A5C2;
        Sun,  1 May 2022 04:56:39 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651406196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UTkNrwweHZr+0aXzQk7nw4w8NBjBSLJQgZ0pO2XGpzc=;
        b=gvlLfZYhgsMljlQRQO65MFQBVsjuXjnEjCJD6jDz5TWmxTfoivRnIX18KKBdt97MscMU3V
        Ori378uR3EHO3GIYLJYwdpZPyMeq4xvNn1sK0tlhmiXayxSKLbHXsVYaf4OIDwPQ3KoRDS
        7Wn32t/sK7wwXPd0NBveCmlsy9UyBFKFZCchnGJyYvftfXNfUX3a1oMMVjVLlKEk/1hS45
        EwVRg0wKz8qT4YTb7sgddDqYrsHfwVvP43Gc4+nPj+f569tVJyjLeKWCakZNua5ELuIueE
        oXRXx2OznAPPAmI4RbJ6sGF2Jxm2snAe3MCeLVQ2eL8NTnVZ3f6h1MZiYMvMHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651406196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UTkNrwweHZr+0aXzQk7nw4w8NBjBSLJQgZ0pO2XGpzc=;
        b=teo3yVW54PUDDp96KIyb2h9qsqEPeClR+fUAVXmKF7mcpzBWgzRP2qJ51mr2HMJGAkLZc7
        Y/FhA6tBUGxw7pAQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
In-Reply-To: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
Date:   Sun, 01 May 2022 13:56:34 +0200
Message-ID: <87o80h1n65.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun May 01 2022, Vladimir Oltean wrote:
> The Felix VSC9959 switch in NXP LS1028A supports the tc-gate action
> which enforced time-based access control per stream. A stream as seen by
> this switch is identified by {MAC DA, VID}.
>
> We use the standard forwarding selftest topology with 2 host interfaces
> and 2 switch interfaces. The host ports must require timestamping non-IP
> packets and supporting tc-etf offload, for isochron to work. The
> isochron program monitors network sync status (ptp4l, phc2sys) and
> deterministically transmits packets to the switch such that the tc-gate
> action either (a) always accepts them based on its schedule, or
> (b) always drops them.
>
> I tried to keep as much of the logic that isn't specific to the NXP
> LS1028A in a new tsn_lib.sh, for future reuse. This covers
> synchronization using ptp4l and phc2sys, and isochron.
>
> The cycle-time chosen for this selftest isn't particularly impressive
> (and the focus is the functionality of the switch), but I didn't really
> know what to do better, considering that it will mostly be run during
> debugging sessions, various kernel bloatware would be enabled, like
> lockdep, KASAN, etc, and we certainly can't run any races with those on.
>
> I tried to look through the kselftest framework for other real time
> applications and didn't really find any, so I'm not sure how better to
> prepare the environment in case we want to go for a lower cycle time.
> At the moment, the only thing the selftest is ensuring is that dynamic
> frequency scaling is disabled on the CPU that isochron runs on. It would
> probably be useful to have a blacklist of kernel config options (checked
> through zcat /proc/config.gz) and some cyclictest scripts to run
> beforehand, but I saw none of those.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmJudXITHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgkwHEACKsj21rjV2zkoqM5LfT7dcYIGZJ9wo
6IcmJpDlRtm9ZfTkujal0g2W7ygbTUIGrpzcQg/BHeQ2LAp0AevXv8ynWoB8tY0w
CZ56pcaLAWBsProG7qhm7qvHkrVV4cJhIv8MRNFBPTlOV9fXNXfhqbyfOsrthngE
zbAWU79+yaNMsmI8+ahpgKfHQfSKIfDJacpyJrkLMHB/GM5xQKpflRVozXRso+nn
jUNYsxqL+UvU58mQ1Ybco9gTaw3tFXaCmlUfwfV5kZTMXVzjU9JuZy2MEjdpNm6D
4IkqvPc4kOVz4xvnSgD0sh6IEKXiQp/9l4zgekhqENyY4TCTrlMH/TTP0KJoJ8q/
/P8Y7MNhk1NRS577EbuDR/Od+YDElpyKc2LLh2R3PmuQSUl48hxAstAuGbOOOcfC
5osThCz3sdLyzNmmlsm2hHfUte/6Xy0VPzqw5if5xlx5Kypo7NbyAwJGdxJ5MVFy
MO+cxLZX6G0IdLnriFpKQhdqu1jsFQ6vxwSB6gli7IYCr4qlRswqAEj+E7x9m/Ju
truC8ft9V/CGBI77XgJCB8hFFiib02gMci7fDOhKxrSYipER5H4F3h0xKhDRT+Yz
1V60QtTRvEd6+OkxGR8BkRb7QsAW1Eq5ITk7b/n2BL6npUmpOTd1+Z1ypJb9wSyO
GlLUBT9/GGmsYA==
=Jk4P
-----END PGP SIGNATURE-----
--=-=-=--

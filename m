Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC8BBE31E
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502204AbfIYRKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 13:10:54 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:38614 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437796AbfIYRKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 13:10:54 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2019 13:10:54 EDT
Received: from dispatchb-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatchb-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B65E744F31
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 17:02:23 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1DF9180093;
        Wed, 25 Sep 2019 17:02:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 25 Sep
 2019 10:02:15 -0700
Subject: Re: CONFIG_NET_TC_SKB_EXT
To:     Paul Blakey <paulb@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
 <1569153104-17875-1-git-send-email-paulb@mellanox.com>
 <20190922144715.37f71fbf@cakuba.netronome.com>
 <68c6668c-f316-2ceb-31b0-8197d22990ae@mellanox.com>
 <d6867e6c-2b81-5fcd-1d88-46663bed6e26@solarflare.com>
 <4f99e2b6-0f09-9d2c-6300-dfc884d501a8@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <3c09871f-a367-56ca-0d25-f0699a7b79d0@solarflare.com>
Date:   Wed, 25 Sep 2019 18:01:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4f99e2b6-0f09-9d2c-6300-dfc884d501a8@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24932.005
X-TM-AS-Result: No-5.704900-4.000000-10
X-TMASE-MatchedRID: VfovoVrt/obmLzc6AOD8DfHkpkyUphL9Fp4YCwpWQx5jyv+d0Z0OxXPW
        WDY7hSSVqTeGETgeQw7EpfjJwJxqaiRUxBx2BTapN19PjPJahlIO9z+P2gwiBXu4ox6u4PaGR5T
        vx+kKh7Ct700WmVSI6aP/Z9MZQbU6Jda7ktb7ayUl05wGZISn5QRsBMbTTgAPRJts9OIxqBNU7b
        LqnQz/DD13b4yr2upHb1pcDq6t/kGuvRGkf1eL4aMY62qeQBkLp2Uv2mII687i7ECA5q90ucQXU
        FJOVf8+Ke+181Qu1SqmvurnuvPUoQzyMxeMEX6wgxsfzkNRlfLdB/CxWTRRu25FeHtsUoHubfJn
        5kFXO0HClTZvfrgUuV7btSfoZ6PGKTvnqX6XSTa+68HqACCvKA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.704900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24932.005
X-MDID: 1569430943-dsnnO1dsNsWV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/09/2019 12:48, Paul Blakey wrote:
> The 'miss' for all or nothing is easy, but the hard part is combining 
> all the paths a packet can take in software to a single 'all or nothing' 
> rule in hardware.
But you don't combine them to a single rule in hardware, because you
 have multiple sequential tables.  (I just spent the last few weeks
 telling our hardware guys that no, they can't just give us one big
 table and expect the driver to do all that combining, because as you
 say, it's 'the hard part'.)

> What if you 'miss' on the match for the tuple? You already did some 
> processing in hardware, so either you revert those, or you continue in 
> software where you left off  (the action ct).
But the only processing you did was to match stuff and generate metadata
 in the form of lookup keys (e.g. a ct_zone) for the next round of
 matching.  There's nothing to "revert" unless you've actually modified
 the packet before sending it to CT, and as I said I don't believe that's
 worth supporting.

> The all or nothing approach will require changing the software model to 
> allow
>
> merging the ct zone table matches into the hardware rules
I don't know how much more clearly I can say this: all-or-nothing does not
 require merging.  It just requires any actions that come before a matching
 stage (and that the hw doesn't have the capability to revert) to put a
 rule straight in the 'nothing' bucket.
So if you write
  chain 0 dst_mac aa:bb:cc:dd:ee:ff ct_state -trk  action vlan push blah action ct action goto chain X
 the driver can say -EOPNOTSUPP because you pushed a VLAN and might still
 miss in chain X.  But if you write
  chain 0 dst_mac aa:bb:cc:dd:ee:ff ct_state -trk  action ct action goto chain X
 then the driver will happily offload that because if you miss in the later
 lookups you've not altered the packet — the chain0-rule is *idempotent* so
 it doesn't matter if HW and SW both perform it.  (Or even all three of HW,
 tc and OvS.)

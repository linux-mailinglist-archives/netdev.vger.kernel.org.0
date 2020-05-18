Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54871D7F14
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgERQs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:48:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49132 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgERQs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:48:59 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1EDF3200F7;
        Mon, 18 May 2020 16:48:58 +0000 (UTC)
Received: from us4-mdac16-62.at1.mdlocal (unknown [10.110.50.155])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1AE67800A3;
        Mon, 18 May 2020 16:48:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.7])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8325610007E;
        Mon, 18 May 2020 16:48:57 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CBC004C0077;
        Mon, 18 May 2020 16:48:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 18 May
 2020 17:48:49 +0100
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
To:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@resnulli.us>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
 <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
 <20200514144938.GD2676@nanopsycho>
 <9f68872f-fe3f-e86a-4c74-8b33cd9ee433@solarflare.com>
 <f7236849-420d-558f-8e66-2501e221ca1b@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <64db5b99-2c67-750c-e5bd-79c7e426aaa2@solarflare.com>
Date:   Mon, 18 May 2020 17:48:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f7236849-420d-558f-8e66-2501e221ca1b@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25426.003
X-TM-AS-Result: No-4.226400-8.000000-10
X-TMASE-MatchedRID: O/y65JfDwwvmLzc6AOD8DfHkpkyUphL9h4A8KRmrGe1XPwnnY5XL5Eh4
        FFTKCL9hSxogTdxY9kZND/OqIKPwWXtQf2I7ph75jC3EAqt365Y1X1Ls767cpmKWkc3vEp/1iZT
        IEGltZs3b2VJ5zpbgoQJiLXklE+PQmKDn0aga+lVgqbvjZaUg3n0tCKdnhB58O5QxsrU10s/6C0
        ePs7A07Y6HM5rqDwqt8XlxtjU+eYbVsrZqRWT12tI7EgMVu7/VR2Eq/gkt96ArzAlCkeHGLdvCq
        Qa6TYXMv4TG6BRnNzzVqa3Ce37kAxVVrrWUEF664vn0zMfSmjYrbLOj1GuP3A+hgLflG6KEo9Qj
        uF9BKnl4IFxQIbVomJRMZUCEHkRt
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.226400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25426.003
X-MDID: 1589820538-X0FZl2witwuj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2020 17:17, Paul Blakey wrote:
> But we think, as you pointed out, explicit as here is better, there is just no API to configure the flow table currently so we suggested this.
> Do you have any suggestion for an API that would be better?
I see two possible approaches.  We could either say "conntrack is
 part of netfilter, so this should be an nftnetlink API", or we
 could say "this is about configuring TC offload (of conntracks),
 so it belongs in a TC command".  I lean towards the latter mainly
 so that I don't have to install & learn netfilter commands (the
 current conntrack offload can be enabled without touching them).
So it'd be something like "tc ct add zone 1 timeout 120 pkts 10",
 and if a 'tc filter add' or 'tc action add' references a ct zone
 that hasn't been 'tc ct add'ed, it gets automatically added with
 the default policy (and if you come along later and try to 'tc ct
 add' it you get an EBUSY or EEXIST or something).

WDYT?

-ed

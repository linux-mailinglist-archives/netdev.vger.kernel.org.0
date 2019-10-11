Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29DBD3C29
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfJKJUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:20:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60222 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726585AbfJKJUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:20:14 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B9FD2400082;
        Fri, 11 Oct 2019 09:20:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 11 Oct
 2019 02:20:07 -0700
Subject: Re: [PATCH net-next1/2] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
To:     Alexander Lobakin <alobakin@dlink.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191010144226.4115-2-alobakin@dlink.ru>
 <bb454c3c-1d86-f81e-a03e-86f8de3e9822@solarflare.com>
 <e7eaf0a1d236dda43f5cd73887ecfb9d@dlink.ru>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b6d30f87-88b4-f009-bc7f-dcf2ed9a9d67@solarflare.com>
Date:   Fri, 11 Oct 2019 10:20:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e7eaf0a1d236dda43f5cd73887ecfb9d@dlink.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24968.005
X-TM-AS-Result: No-1.301100-4.000000-10
X-TMASE-MatchedRID: 5+1rHnqhWUT4ECMHJTM/ufHkpkyUphL9+D+zbdY8EikZFDQxUvPcmL6Y
        VRYkPkYCSCF6HRRH3gIN25tj8sME0kHGTQqAQaePelGHXZKLL2tfz6dKxk6eNJsoi2XrUn/JyeM
        tMD9QOgADpAZ2/B/BlgJTU9F/2jaz3QfwsVk0UbuZ/dgf3Hl0lQdcXOftadZZanKxcCqKqviyuT
        4uqwSyJobVjstzILx+/ULPDpIN9LRKW7e49HWSFTC7+o0dCT3gG5LP5SWKhyqq4UVeuXo1MKKAQ
        fLsnhLrKWSt4DmvbhpicKLmK2TeKmsPn5C6nWpTiTSgm8kJVKRDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.301100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24968.005
X-MDID: 1570785613-jXSkVprpQDO2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> On 10/10/2019 15:42, Alexander Lobakin wrote:
>>> Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
>>> skbs") made use of listified skb processing for the users of
>>> napi_gro_frags().
>>> The same technique can be used in a way more common napi_gro_receive()
>>> to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers,
>>> including gro_cells and mac80211 users.
>>>
>>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Acked-by: Edward Cree <ecree@solarflare.com>
but I think this needs review from the socionext folks as well.

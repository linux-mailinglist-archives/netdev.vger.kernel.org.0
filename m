Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B2913BA4D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 08:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgAOHZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 02:25:02 -0500
Received: from mail.dlink.ru ([178.170.168.18]:43540 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgAOHZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 02:25:01 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id AE5E11B2010A; Wed, 15 Jan 2020 10:24:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru AE5E11B2010A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579073098; bh=9BpX60oTC+OJffotL5YslGLjv5z+sH4Lz+acJSFb43Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=rUTU0sASFGg+onSvMq/HOSMe/x/A09rwA+xpRP8HIyFGoziDMjEEiRWopY8cHrf/j
         OPges88lZPP6KtMcrD0PvlaWYY1GxCgts/cynhy4+d2ET/4da0td/DCRfQrQAluqG1
         G1IvfgFx0fjLFQaeu06OUSlYbaZ0KdeWEteCYENQ=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 381B21B2010A;
        Wed, 15 Jan 2020 10:24:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 381B21B2010A
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id AC6BF1B20AE9;
        Wed, 15 Jan 2020 10:24:45 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 15 Jan 2020 10:24:45 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 15 Jan 2020 10:24:45 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 06/19] net: dsa: tag_gswip: fix typo in tag
 name
In-Reply-To: <0edda44f-7a75-e6c9-eec3-48259630bb3d@gmail.com>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-7-alobakin@dlink.ru> <20191230172209.GE13569@lunn.ch>
 <0edda44f-7a75-e6c9-eec3-48259630bb3d@gmail.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <69c888adea30f35fe36da37d76ee604e@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Fainelli wrote 15.01.2020 00:57:
> On 12/30/19 9:22 AM, Andrew Lunn wrote:
>> On Mon, Dec 30, 2019 at 05:30:14PM +0300, Alexander Lobakin wrote:
>>> "gwsip" -> "gswip".
>>> 
>>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
>> 
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Likewise, this is a bug fix that should be extracted out of this GRO
> series and a Fixes: tag be put since this has an user-visible impact
> through /sys/class/net/*/dsa/tagging.

Sure, I'll pull some really important fixes (like this one and doubled
Tx stats in tag_qca) out of this series and submit them as separate
patches, maybe even in net-fixes tree?

> Thanks

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

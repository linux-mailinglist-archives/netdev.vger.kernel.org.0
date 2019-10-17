Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B3CDB560
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436842AbfJQSBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:01:44 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55918 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727241AbfJQSBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:01:43 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CC95C340090;
        Thu, 17 Oct 2019 18:01:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 17 Oct
 2019 11:01:37 -0700
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at byte
 level
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>,
        <saeedm@mellanox.com>, <vishal@chelsio.com>, <vladbu@mellanox.com>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-4-pablo@netfilter.org>
 <20191016163651.230b60e1@cakuba.netronome.com>
 <20191017161157.rr4lrolsjbnmk3ke@salvia>
 <20191017103059.3b7ff828@cakuba.netronome.com>
 <20191017174603.m3riooywbgy2r5hr@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <4ec50937-1880-bac0-5495-c36f7e60584f@solarflare.com>
Date:   Thu, 17 Oct 2019 19:01:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191017174603.m3riooywbgy2r5hr@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24982.005
X-TM-AS-Result: No-2.932800-4.000000-10
X-TMASE-MatchedRID: u1zqiMeMcrobF9xF7zzuNfZvT2zYoYOwt3aeg7g/usBol1CJjLeIsyEM
        HbfBYjoUTe1Il/oI/C1jlnT1p15FzfVimO8vZqd3oVlWrngWU219LQinZ4QefDuUMbK1NdLP+gt
        Hj7OwNO2OhzOa6g8KrWLG6bZOc2fOuPO21p2T0f2QQUiVmU2ClfOebldNojUOSBR0gBbf41yHzG
        THoCwyHhlNKSp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.932800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24982.005
X-MDID: 1571335302-0E8NiW5Nr48b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/10/2019 18:46, Pablo Neira Ayuso wrote:
> Making this opt-in will just leave things as bad as they are right
> now, with drivers that are very much hard to read.
Again, there are two driver developers in this conversation, and they
 both disagree with you.  Reflect on that fact.

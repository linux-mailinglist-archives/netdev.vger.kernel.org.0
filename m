Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B270829859
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391064AbfEXM4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 08:56:34 -0400
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:9861
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390781AbfEXM4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 08:56:34 -0400
X-Sender-Id: dreamhost|x-authsender|wcarlson@wkks.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 568A4501C6C;
        Fri, 24 May 2019 12:56:32 +0000 (UTC)
Received: from pdx1-sub0-mail-a79.g.dreamhost.com (100-96-38-146.trex.outbound.svc.cluster.local [100.96.38.146])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id CF0C6501467;
        Fri, 24 May 2019 12:56:29 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|wcarlson@wkks.org
Received: from pdx1-sub0-mail-a79.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.2);
        Fri, 24 May 2019 12:56:32 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|wcarlson@wkks.org
X-MailChannels-Auth-Id: dreamhost
X-Stupid-Absorbed: 5bc9ea9920103c28_1558702592175_1739823950
X-MC-Loop-Signature: 1558702592175:4136276158
X-MC-Ingress-Time: 1558702592175
Received: from pdx1-sub0-mail-a79.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a79.g.dreamhost.com (Postfix) with ESMTP id 68729806C2;
        Fri, 24 May 2019 05:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=wkks.org; h=reply-to
        :subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=wkks.org;
         bh=7LRP3IXESVJycAKWiULRWrAzp38=; b=X8fv8Jxs2Qrt80Az1F60cpubXDPF
        yY5TWC9uW1qHEm5q0Rom7RMFT93whpvKgH/AEt7hD3B2D0wvhMdhXTKow5CHdZgk
        RakTERUNylFh5Lwao9PAVRWjku1vymhnS0OpfiL7UMMSstCaAZ1x3N7fpVgtiaXw
        0stlCm2pkFMhiAk=
Received: from blade.c.c (173-21-244-129.client.mchsi.com [173.21.244.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcarlson@wkks.org)
        by pdx1-sub0-mail-a79.g.dreamhost.com (Postfix) with ESMTPSA id 9115B806C5;
        Fri, 24 May 2019 05:56:23 -0700 (PDT)
Reply-To: billcarlson@wkks.org
Subject: Re: bonding-devel mail list?
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <3428f1e4-e9e9-49c6-8ca8-1ea5e9fdd7ed@wkks.org>
 <18472.1558629973@famine> <ec7a86ec-56e0-7846-ed02-337850fc8478@wkks.org>
 <32364.1558650716@famine>
X-DH-BACKEND: pdx1-sub0-mail-a79
From:   Bill Carlson <billcarlson@wkks.org>
Message-ID: <5f1a3342-a4dd-0555-8cf9-922b1acc3d8e@wkks.org>
Date:   Fri, 24 May 2019 07:56:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <32364.1558650716@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudduiedgheelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurheprhfuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeeuihhllhcuvegrrhhlshhonhcuoegsihhllhgtrghrlhhsohhnseifkhhkshdrohhrgheqnecukfhppedujeefrddvuddrvdeggedruddvleenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepsghlrgguvgdrtgdrtgdpihhnvghtpedujeefrddvuddrvdeggedruddvledprhgvthhurhhnqdhprghthhepuehilhhlucevrghrlhhsohhnuceosghilhhltggrrhhlshhonhesfihkkhhsrdhorhhgqedpmhgrihhlfhhrohhmpegsihhllhgtrghrlhhsohhnseifkhhkshdrohhrghdpnhhrtghpthhtohepjhgrhidrvhhoshgsuhhrghhhsegtrghnohhnihgtrghlrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/19 5:31 PM, Jay Vosburgh wrote:
>
> 	However, the logic in LACP will attach every slave of the bond
> to an aggregator.  If one or more slaves are connected to a specific
> LACP peer, they will aggregate together.  If any slave is connected to a
> non-LACP peer, it will aggregate as an "individual" port.
>
> 	When bonding's LACP mode selects the best aggregator to use,
> "non-individual" (i.e., connected to a LACP peer) ports are preferred,
> but if no such ports are available, an individual port is selected as
> the active aggregator.  The precise logic is found in the
> ad_agg_selection_test() function [1].
>
> 	If what you've got works for you, then that's great, but I
> suspect it would still work if all of the interfaces were in a single
> 802.3ad bond without the nesting.
>
> 	-J
Ah, hadn't considered LACP mode would accept non-LACP interfaces. I'll 
chase this.
Thanks.

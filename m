Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2A724676A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgHQNgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgHQNf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 09:35:59 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B380C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 06:35:59 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 07HDZdht017376
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 17 Aug 2020 15:35:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1597671339; bh=BNq9CJTGRTFMT1lObPrCJUSkmDJn6crINo1uuxFU4b0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=XrsCWJBNvNL9b1DmD3AxQjc9nLE01+xCc5/6j1RYxGn70uVRNhFDEZDexTfITEPU4
         mRoSItYuj9+y+ywq9uw3koXWvR7Ns1Eh3+Mlg8L5XLemunjHGy5lPjCPAssowSVrbR
         G+jVNSgNYsVqydXHI1FVE5H9srXFWwcoRl/u9G7M=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1k7fIY-001DbE-Lp; Mon, 17 Aug 2020 15:35:38 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     gluon@luebeck.freifunk.net,
        Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [gluon] Re: [RFC PATCH net-next] bridge: Implement MLD Querier wake-up calls / Android bug workaround
Organization: m
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
        <87zh6t650b.fsf@miraculix.mork.no> <1830568.o5y0iYavLQ@sven-edge>
Date:   Mon, 17 Aug 2020 15:35:38 +0200
In-Reply-To: <1830568.o5y0iYavLQ@sven-edge> (Sven Eckelmann's message of "Mon,
        17 Aug 2020 15:17:37 +0200")
Message-ID: <87blj95r9x.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sven Eckelmann <sven@narfation.org> writes:
> On Monday, 17 August 2020 10:39:00 CEST Bj=C3=B8rn Mork wrote:
>> Linus L=C3=BCssing <linus.luessing@c0d3.blue> writes:
> [...]
>> This is not a bug.  They are deliberately breaking IPv6 because they
>> consider this a feature.  You should not try to work around such issues.
>> It is a fight you cannot win.  Any workaround will only encourage them
>> to come up with new ways to break IPv6.
>
> Who are "they" and

Google.

> where is this information coming from?

I made it up.

> And what do they gain from breaking IPv6?

Battery time.

> Wouldn't it be easier for them just to disable IPv6=20
> than adding random looking bugs?

You would think so.

If it isn't clear, I am hoping to provoke them to re-classify the
"feature" as a bug and fix it.  That's what it takes to prove I am wrong.
Should be easy-peasy.



Bj=C3=B8rn

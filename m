Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1A524606B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHQIjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHQIjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:39:53 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E768C061388
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 01:39:53 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 07H8d1J3030318
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 17 Aug 2020 10:39:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1597653542; bh=C95bbW+7kVubfEbltvr0JMBVnM229YdJIYgB0IKch3U=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=VxX7anktq06S5xmTlfzi/rr01Q++/cCS/cHmPzjvLhkAPtxJw24wGCkdy2oO1mf8c
         KH9dQ/nzmoku1bVNeTYPuzWfBJpjNpAX4f7/7zEyI/v57hekWq+GR93w4dGJaKqusz
         l7Qj7Z0QMZ9Oy4azQdyEUsZsypudV/igvysXABhc=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1k7afU-0018j8-RL; Mon, 17 Aug 2020 10:39:00 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     netdev@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, gluon@luebeck.freifunk.net,
        openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next] bridge: Implement MLD Querier wake-up calls / Android bug workaround
Organization: m
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
Date:   Mon, 17 Aug 2020 10:39:00 +0200
In-Reply-To: <20200816202424.3526-1-linus.luessing@c0d3.blue> ("Linus
        =?utf-8?Q?L=C3=BCssing=22's?= message of "Sun, 16 Aug 2020 22:24:24 +0200")
Message-ID: <87zh6t650b.fsf@miraculix.mork.no>
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

Linus L=C3=BCssing <linus.luessing@c0d3.blue> writes:

> Currently there are mobile devices (e.g. Android) which are not able
> to receive and respond to MLD Queries reliably because the Wifi driver
> filters a lot of ICMPv6 when the device is asleep - including
> MLD. This in turn breaks IPv6 communication when MLD Snooping is
> enabled. However there is one ICMPv6 type which is allowed to pass and
> which can be used to wake up the mobile device: ICMPv6 Echo Requests.

This is not a bug.  They are deliberately breaking IPv6 because they
consider this a feature.  You should not try to work around such issues.
It is a fight you cannot win.  Any workaround will only encourage them
to come up with new ways to break IPv6.


Bj=C3=B8rn

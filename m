Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FD828B40
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbfEWUGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:06:21 -0400
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:46413 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387504AbfEWUGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:06:21 -0400
X-Sender-Id: dreamhost|x-authsender|wcarlson@wkks.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8BE962C31BE;
        Thu, 23 May 2019 20:06:15 +0000 (UTC)
Received: from pdx1-sub0-mail-a91.g.dreamhost.com (100-96-91-22.trex.outbound.svc.cluster.local [100.96.91.22])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id D331F2C28DF;
        Thu, 23 May 2019 20:06:14 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|wcarlson@wkks.org
Received: from pdx1-sub0-mail-a91.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.17.2);
        Thu, 23 May 2019 20:06:15 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|wcarlson@wkks.org
X-MailChannels-Auth-Id: dreamhost
X-Attack-Tank: 08baf4fb6a121ff5_1558641975415_3380961848
X-MC-Loop-Signature: 1558641975415:3564474585
X-MC-Ingress-Time: 1558641975414
Received: from pdx1-sub0-mail-a91.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a91.g.dreamhost.com (Postfix) with ESMTP id C3E2680251;
        Thu, 23 May 2019 13:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=wkks.org; h=reply-to
        :subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=wkks.org;
         bh=xxJ5kwn95N82L1Dg5g1mjMY7u9U=; b=NuTVLviWA29Chv7qTFUsFCQ1RXZQ
        nPEwK5mj4BMvw8J68e6Z45Wg15k3iRvAGG9lh8KKNLztiL/+sQaAcIrLMLKpgAnf
        /36qYQJO78mgxTNu9DC1Il0MBeK7H2INstp3xlI/422rT8Cisb4Q7drIEdfri+ep
        en6lXWSDhkBKnIY=
Received: from blade.c.c (173-21-244-129.client.mchsi.com [173.21.244.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wcarlson@wkks.org)
        by pdx1-sub0-mail-a91.g.dreamhost.com (Postfix) with ESMTPSA id 1FECC8024E;
        Thu, 23 May 2019 13:06:12 -0700 (PDT)
Reply-To: billcarlson@wkks.org
Subject: Re: bonding-devel mail list?
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <3428f1e4-e9e9-49c6-8ca8-1ea5e9fdd7ed@wkks.org>
 <18472.1558629973@famine>
X-DH-BACKEND: pdx1-sub0-mail-a91
From:   Bill Carlson <billcarlson@wkks.org>
Message-ID: <ec7a86ec-56e0-7846-ed02-337850fc8478@wkks.org>
Date:   Thu, 23 May 2019 15:06:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <18472.1558629973@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgudeglecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpehruffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepuehilhhlucevrghrlhhsohhnuceosghilhhltggrrhhlshhonhesfihkkhhsrdhorhhgqeenucfkphepudejfedrvddurddvgeegrdduvdelnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopegslhgruggvrdgtrdgtpdhinhgvthepudejfedrvddurddvgeegrdduvdelpdhrvghtuhhrnhdqphgrthhhpeeuihhllhcuvegrrhhlshhonhcuoegsihhllhgtrghrlhhsohhnseifkhhkshdrohhrgheqpdhmrghilhhfrhhomhepsghilhhltggrrhhlshhonhesfihkkhhsrdhorhhgpdhnrhgtphhtthhopehjrgihrdhvohhssghurhhghhestggrnhhonhhitggrlhdrtghomhenucevlhhushhtvghrufhiiigvpedt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/19 11:46 AM, Jay Vosburgh wrote:
> As far as I'm aware, nesting bonds has no practical benefit; do
> you have a use case for doing so?
>
>
Use case is very specific, but needed in my situation until some 
switches are stabilized.

Switches A1..Ax provide LACP, 40G. These are unstable, lose link on one 
or more interfaces or drop completely. A single bond to the A switches 
was acceptable at first, including when one interface was down for quite 
a while. Then all A switches dropped.

Switches B1..Bx provide no LACP, 10G. These are sitting and connected 
anyway, already in place for backup.

All are on the same layer two, as in any MAC is visible on any switch.

Goal is to use A switches primarily, and drop back to B _IF_ A are 
completely down. As long as one interface is active on A, that will be used.

I assume LACP and active-passive can't be used in the same bond, 
interested to hear if I'm wrong.

My setup I achieved:

bond0 -> switches B, multiple interfaces, active-passive
bond1 -> switches A, multiple interfaces, LACP
bond10 -> slaves bond0 and bond1, active-passive
Various VLANs are using bond10.

Options to bonding:

bond0: mode=1 fail_over_mac=none miimon=100
bond1: mode=4 lacp_rate=1 miimon=100
bond10: mode=1 fail_over_mac=1 primary=bond1 updelay=10000 miimon=100
(I should probably change to arp monitoring, I know.)

updelay in place because LACP takes a long time to link.
Making sure the MACs switched was the key.

Network performance tests via iperf3 look good, including when dropping 
bond1. Unfortunately, target test system was on bond0, as its A switches 
were down.

The only, critical, test I haven't been able to perform is physically 
dropping A links, can't reach that far. :)

-- 

Bill Carlson

Anything is possible, given Time and Money.


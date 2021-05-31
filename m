Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A0C395A04
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhEaMF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:05:58 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:41920 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhEaMFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 08:05:55 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 30CC9200BBBF;
        Mon, 31 May 2021 14:04:14 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 30CC9200BBBF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622462654;
        bh=oBMvi5LXFH8jmfuLZrnygosixJKiUuvq9ERtrgVvdSw=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=cO6MZCHTv+hLYA8kbbBVjvfAail6zGKvgGtc2UEQeOBklpQymM74S/gjMwaut3wW5
         bVgaJQ0mV8u7Sdc/kI9yisJ/99JdZVQ8WX/53viZN4DMdLrCod2QJqXvGM60J9JdJj
         varCV0WiXqNQ7DUnnfJCZHlRYVPt1UQL4z0+5AbuMucJWvR3EHeoK8SvSHL4UqvjC5
         Pqp4I8IOIYA0wI42DPsQV4qyd9Ab8kd7v8cahymQonoqSuzIrCy1oRTiGPliacYDM+
         r3oLbvNlH2EP5conFUEZyxN3/1XnZ+d1p4zfBgnhNdDcB1GE0t1NqqyWCG4sqkYrpX
         Ho1zDXJxwlFBg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 27AD16008D58E;
        Mon, 31 May 2021 14:04:14 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id elLTnSQnqr9Z; Mon, 31 May 2021 14:04:14 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 112346008D55E;
        Mon, 31 May 2021 14:04:14 +0200 (CEST)
Date:   Mon, 31 May 2021 14:04:14 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tom@herbertland.com
Message-ID: <1439349685.35359322.1622462654030.JavaMail.zimbra@uliege.be>
In-Reply-To: <cc16923b-74bc-7681-92c7-19e84a44c0e1@gmail.com>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <85a22702-da46-30c2-46c9-66d293d510ff@gmail.com> <1049853171.33683948.1622305441066.JavaMail.zimbra@uliege.be> <cc16923b-74bc-7681-92c7-19e84a44c0e1@gmail.com>
Subject: Re: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated
 Trace with IPv6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: Support for the IOAM Pre-allocated Trace with IPv6
Thread-Index: canxdIAORlXtsVJJiW/0LnB5yhrk1A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Actually, February 2021 is the last update. The main draft
>> (draft-ietf-ippm-ioam-data) has already come a long way (version 12) and has
>> already been Submitted to IESG for Publication. I don't think it would hurt
> 
> when the expected decision on publication?

Hard to tell precisely, a couple weeks probably. There are still some comment/discuss to clear and our next IETF working group meeting is in July. However, it shouldn't be a concern (see below).

> that much to have it in the kernel as we're talking about a stable
> draft (the other one is just a wrapper to define the encapsulation of
> IOAM with IPv6) and something useful. And, if you think about Segment
> Routing for IPv6, it was merged in the kernel when it was still a draft.
> 
> The harm is if there are any changes to the uapi.

Definitely agree. But, I can assure you there won't be any uapi change at this stage. None of the comment/discuss I mentioned above are about this at all. Headers definition and IANA codes are defined for a long time now and won't change anymore.

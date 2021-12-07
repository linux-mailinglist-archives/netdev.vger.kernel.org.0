Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4EA46C250
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbhLGSIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:08:45 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:60182 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbhLGSIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:08:45 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 3C4A0200C240;
        Tue,  7 Dec 2021 19:05:13 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 3C4A0200C240
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1638900313;
        bh=VUfPrqsw7NnJaT0s1QoAK7lGXTXsEYQ+89QyQla87xU=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=OBpRkJFq9E9QodcROAt93C59iAmnMPaCouzQob4gbrrHHqFnFT+pN4o70C751ZBY+
         1vlNae41LfjixaKC8OE8tEm18qhwRspisOOBXeorAK/VMWCCvKLtGoiQIa28gzA0Ij
         N4DQaxHfPXkMol2jntdx8HgMkUUgBHJtwAUsHSXbtonue/0B8pqQ8n8wewUb8KlUCg
         MfjzJJ91uB5nkFXhHfwVdDS2x7WQoxW1OxJdc38I1WqH82A+g/UlOe7t9eiUm2CJB6
         WeyoJwFF5QLt5dt62kiIKSMjPnUWYeSSMuCEEnDCUTd0wHbhBH4Ujc7QzVEH9Ie0Eu
         zd7qbRnDv9+ug==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 2E4556030A30D;
        Tue,  7 Dec 2021 19:05:13 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HL55OgoFF9-L; Tue,  7 Dec 2021 19:05:13 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 0F618600DD86E;
        Tue,  7 Dec 2021 19:05:13 +0100 (CET)
Date:   Tue, 7 Dec 2021 19:05:13 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Message-ID: <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206211758.19057-1-justin.iurman@uliege.be> <20211206211758.19057-3-justin.iurman@uliege.be> <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be> <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be> <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF94 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Buffer occupancy data field
Thread-Index: 2LfZ0yfJCPx54/jkaM+gvemGs75L/g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 7, 2021, at 6:07 PM, Jakub Kicinski kuba@kernel.org wrote:
> Hm, reading thru the quoted portion of the standard from the commit
> message the semantics of the field are indeed pretty disappointing.
> What's the value of defining a field in a standard if it's entirely
> implementation specific? Eh.

True. But keep also in mind the scope of IOAM which is not to be
deployed widely on the Internet. It is deployed on limited (aka private)
domains where each node is therefore managed by the operator. So, I'm
not really sure why you think that the implementation specific thing is
a problem here. Context of "unit" is provided by the IOAM Namespace-ID
attached to the trace, as well as each Node-ID if included. Again, it's
up to the operator to interpret values accordingly, depending on each
node (i.e., the operator has a large and detailed view of his domain; he
knows if the buffer occupancy value "X" is abnormal or not for a
specific node, he knows which unit is used for a specific node, etc).

>> We probably want the metadata included for accuracy as well (e.g.,
>> kmem_cache_size vs new function kmem_cache_full_size).
> 
> Does the standard support carrying arbitrary metadata?

It says:

  "This field indicates the current status of the occupancy of the
   common buffer pool used by a set of queues."

So, as long as metadata are part of it, I'd say yes it does, since bytes
are allocated for that too. Does it make sense?

> Anyway, in general I personally don't have a good feeling about
> implementing this field. Would be good to have a clear user who
> can justify the choice of slab vs something else. Wouldn't modern
> deployments use some form of streaming telemetry for nodes within
> the same domain of control? I'm not sure I understand the value
> of limited slab info in OAM when there's probably a more powerful
> metric collection going on.

Do you believe this patch does not provide what is defined in the spec?
If so, I'm open to any suggestions.

> Patch 1 makes perfect sense, FWIW.

Thanks for (all) the feedback, Jakub, I appreciate it.

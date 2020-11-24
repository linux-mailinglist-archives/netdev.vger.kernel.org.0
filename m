Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8B2C2348
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbgKXKvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:51:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732047AbgKXKvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 05:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606215108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QR0hwxfJBFbTcikY7jKHx2SjONRnEHHp9y8eP6Nt/Rs=;
        b=CgggYpcaNIyTE0JoMUaUJopFwrJgPDjql2+Rb5IFtWd+9K6/sbxAK+6I8VFKBMRRHaRZjV
        36TGqImIJdR7TDr21rEXQKQemMfK4s/gPwF7OA6+xeiGOl1VIzCUmqWLtVv04fcvJH3RMo
        QHjg+JRN9Ca9tB93PKvygf68eof4flc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-lVfLYPZHNE-APTlxM1R_oA-1; Tue, 24 Nov 2020 05:51:45 -0500
X-MC-Unique: lVfLYPZHNE-APTlxM1R_oA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7D821006C87;
        Tue, 24 Nov 2020 10:51:43 +0000 (UTC)
Received: from [10.36.113.14] (ovpn-113-14.ams2.redhat.com [10.36.113.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38C9960864;
        Tue, 24 Nov 2020 10:51:42 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Pravin Shelar" <pravin.ovn@gmail.com>
Cc:     "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "ovs dev" <dev@openvswitch.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Bindiya Kurle" <bindiyakurle@gmail.com>,
        "Ilya Maximets" <i.maximets@ovn.org>, mcroce@linux.microsoft.com
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
Date:   Tue, 24 Nov 2020 11:51:40 +0100
Message-ID: <FBF56C40-90B7-4BAF-9AE3-B8304283E2D8@redhat.com>
In-Reply-To: <CAOrHB_Be-B8oLwx-zYXpwhjpQAWdkw1NrYh36S8e6bRH8X0cqg@mail.gmail.com>
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <CAOrHB_Be-B8oLwx-zYXpwhjpQAWdkw1NrYh36S8e6bRH8X0cqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Nov 2020, at 23:16, Pravin Shelar wrote:

> On Thu, Nov 19, 2020 at 1:04 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> Currently, the openvswitch module is not accepting the correctly 
>> formated
>> netlink message for the TTL decrement action. For both setting and 
>> getting
>> the dec_ttl action, the actions should be nested in the
>> OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h 
>> uapi.
>>
>> Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Thanks for working on this. can you share OVS kmod unit test for this 
> action?

Hi Pravin,

I did add a self-test, however, my previous plan was to send out the 
updated OVS patch after this change got accepted. But due to all the 
comments, I sent it out anyway, so here it is with a datapath test:

https://mail.openvswitch.org/pipermail/ovs-dev/2020-November/377795.html

//Eelco


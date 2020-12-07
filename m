Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2952E2D0D55
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgLGJrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:47:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgLGJrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 04:47:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607334337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TFr0hyDMQmXX49qB8uqDnZ06BMTO3ulnoLgu5+hmPNM=;
        b=hjv/nKMuIvpmVoIy6R7c39YLvgVpMXQEhw9g4S0uluCUIYXl6ax4TfYOp+7CeStR8KjzKO
        JEB3wOgDyjdiR0swB1InXbKKQj/63mk3prjo6VwG7VSVA5uJRAIOK/Inkucnd3/sKdN9Qp
        3aUAaqJ7CWJShhw5ieWkU+VDvbygttI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-Vw5W1wZnOJ-60VrxhOr9pw-1; Mon, 07 Dec 2020 04:45:33 -0500
X-MC-Unique: Vw5W1wZnOJ-60VrxhOr9pw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49CF8107ACF7;
        Mon,  7 Dec 2020 09:45:31 +0000 (UTC)
Received: from [10.36.112.153] (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 979FD646DC;
        Mon,  7 Dec 2020 09:45:29 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, mcroce@linux.microsoft.com
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement exception action
 execution
Date:   Mon, 07 Dec 2020 10:45:27 +0100
Message-ID: <448E9944-DAF8-4B52-9752-5F06132E1690@redhat.com>
In-Reply-To: <20201204163005.10ab9c53@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <160708417520.39389.4157710029285521561.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <20201204163005.10ab9c53@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5 Dec 2020, at 1:30, Jakub Kicinski wrote:

> On Fri,  4 Dec 2020 07:16:23 -0500 Eelco Chaudron wrote:
>> Currently, the exception actions are not processed correctly as the 
>> wrong
>> dataset is passed. This change fixes this, including the misleading
>> comment.
>>
>> In addition, a check was added to make sure we work on an IPv4 
>> packet,
>> and not just assume if it's not IPv6 it's IPv4.
>>
>> Small cleanup which removes an unsessesaty parameter from the
>> dec_ttl_exception_handler() function.
>
> No cleanups in fixes, please. Especially when we're at -rc6..
>
> You can clean this up in net-next within a week after trees merge.

Ack, will undo the parameter removal, and sent out a v2.

>> Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action 
>> netlink message format")
>
> :(
> and please add some info on how these changes are tested.

Will add the details to v2.


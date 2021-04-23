Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DA73691C4
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbhDWMMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242235AbhDWMMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 08:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619179887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=smDxvNTY8YNlFlAJqKVnzmYcgvAze7hQWWN+9lrlaVA=;
        b=gutQpqgnUaYgG3/dUh8Cun5fT8CpbeoTiC861DiLrMOzbOekop7jgZkxqgBmRM76mA/NkA
        aT+znjMqJuNAz42NdtS8XJ6gq04ccegEtiao9e6yjLfgsRnfbKcHLiv1eqvSsILM7b93gc
        0NnxeNIMDiZhzr7d68bu8uikBktHGWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-3xAp2z51OFm3UAB8OTn3rA-1; Fri, 23 Apr 2021 08:11:25 -0400
X-MC-Unique: 3xAp2z51OFm3UAB8OTn3rA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 990028026AD;
        Fri, 23 Apr 2021 12:11:24 +0000 (UTC)
Received: from [10.40.195.0] (unknown [10.40.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DE78608BA;
        Fri, 23 Apr 2021 12:11:23 +0000 (UTC)
Message-ID: <38922dcdc29d567aa8dcca365d5c4f61d22a9e57.camel@redhat.com>
Subject: Re: [PATCH net 0/2] fix stack OOB read while fragmenting IPv4
 packets
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
In-Reply-To: <cover.1618844973.git.dcaratti@redhat.com>
References: <cover.1618844973.git.dcaratti@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 23 Apr 2021 14:11:22 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-19 at 17:22 +0200, Davide Caratti wrote:
> - patch 1/2 fixes openvswitch IPv4 fragmentation, that does a stack OOB
> read after commit d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received
> PMTU < net.ipv4.route.min_pmt")
> - patch 2/2 fixes the same issue in TC 'sch_frag' code
> 

hello Dave and Jakub,

I see that patches in this series [1][2] are marked with 'Changes
Requested' in patchwork, but in my understanding no further changes are
requested for the moment.

do I need to re-send the series, or you can manage to change the status
inside patchwork?

thanks,

-- 
davide

[1] https://patchwork.kernel.org/project/netdevbpf/patch/94839fa9e7995afa6139b4f65c12ac15c1a8dc2f.1618844973.git.dcaratti@redhat.com/
[2] https://patchwork.kernel.org/project/netdevbpf/patch/80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com/






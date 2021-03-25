Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ADB349AFC
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 21:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhCYU2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 16:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhCYU2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 16:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616704105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzd7N7glHdCdA+MLUC2WowC34WAEzmgYDTepXDCp7BQ=;
        b=dYkgRzozPuInvS9FhoGuQ6u2iLiN02bvdj6jjThI76iw2t+Gn2eNWxiOTufWrS15IKkxNk
        ZLv92ajjVyCBt/I/GWp7gfSw/5Cy3iNpIcuvGAKXCfO3DIZduE+74zSJCdCBcZmYOwmIjf
        KXYfEFBqM79x2LQT7/Q8LZ4eoa5zWLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-Uh2U5tAOPzWJkE-VPdWjRA-1; Thu, 25 Mar 2021 16:28:21 -0400
X-MC-Unique: Uh2U5tAOPzWJkE-VPdWjRA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 117D1CC621;
        Thu, 25 Mar 2021 20:28:20 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7A6C60939;
        Thu, 25 Mar 2021 20:28:19 +0000 (UTC)
Received: from elisabeth (032-140-100-005.ip-addr.inexio.net [5.100.140.32])
        by maya.cloud.tilaa.com (Postfix) with ESMTPSA id 24B2440098;
        Thu, 25 Mar 2021 21:28:17 +0100 (CET)
Date:   Thu, 25 Mar 2021 21:28:14 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, echaudro@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: do not modify the shared tunnel info when
 PMTU triggers an ICMP reply
Message-ID: <20210325212806.1ae8fec5@elisabeth>
In-Reply-To: <20210325153533.770125-1-atenart@kernel.org>
References: <20210325153533.770125-1-atenart@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 16:35:31 +0100
Antoine Tenart <atenart@kernel.org> wrote:

> Hi,
> 
> The series fixes an issue were a shared ip_tunnel_info is modified when
> PMTU triggers an ICMP reply in vxlan and geneve, making following
> packets in that flow to have a wrong destination address if the flow
> isn't updated. A detailled information is given in each of the two
> commits.
> 
> This was tested manually with OVS and I ran the PTMU selftests with
> kmemleak enabled (all OK, none was skipped).
> 
> Thanks!
> Antoine
> 
> Antoine Tenart (2):
>   vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP
>     reply
>   geneve: do not modify the shared tunnel info when PMTU triggers an
>     ICMP reply

For the series,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Thanks for fixing this!

-- 
Stefano


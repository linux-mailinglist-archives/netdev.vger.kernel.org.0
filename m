Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E7313CB22
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAORii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:38:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42550 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726418AbgAORii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:38:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579109917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXI8VnOMf2O4lphef1G2NpSuVhxy2I19PiuH4dWJp+0=;
        b=GUeAipwM/cNd/0LH19uwx6HtiLNz64NT49eMlruqi8ZzQBTIp7oXt3iBJ7KR7lkq9GmfSf
        sn8J/FoHkTxVY9JQPga5frxZhfIKSjEtn440rgX5W0bzCW4KMUcDtgz6MPV5r3dlLFzydE
        WjODtMgZxIj72Y7CeODoc0PYJu8/bls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-4tK_vS23POOZy6uu-1IeSA-1; Wed, 15 Jan 2020 12:38:34 -0500
X-MC-Unique: 4tK_vS23POOZy6uu-1IeSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C92368E47B6;
        Wed, 15 Jan 2020 17:38:32 +0000 (UTC)
Received: from ovpn-205-91.brq.redhat.com (ovpn-205-91.brq.redhat.com [10.40.205.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 432BB60C63;
        Wed, 15 Jan 2020 17:38:31 +0000 (UTC)
Message-ID: <5961acad0fa4ee00e00ad3773f39c9cb44df6929.camel@redhat.com>
Subject: Re: [PATCH v3 net] net/sched: act_ife: initalize ife->metalist
 earlier
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
In-Reply-To: <20200115162039.113706-1-edumazet@google.com>
References: <20200115162039.113706-1-edumazet@google.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 15 Jan 2020 18:38:30 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-01-15 at 08:20 -0800, Eric Dumazet wrote:
> It seems better to init ife->metalist earlier in tcf_ife_init()
> to avoid the following crash :

hello Eric, LGTM now, thanks!

[...]

> Fixes: 11a94d7fd80f ("net/sched: act_ife: validate the control action inside init()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Davide Caratti <dcaratti@redhat.com>
> ---
> v2,v3: addressed Davide feedbacks.

Reviewed-by: Davide Caratti <dcaratti@redhat.com>



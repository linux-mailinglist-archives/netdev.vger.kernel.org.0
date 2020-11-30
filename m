Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8906A2C812B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgK3JkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 04:40:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbgK3JkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 04:40:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606729130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4yBhvR6zvsu5dSQHovsMYq8UNeU25HVpk173jv35ETo=;
        b=Ave4JTGEVxkZbf8EwdqeWrW83nXJJNwfGZnIGmNnPUeOecbRFoM+MVovPd0+IM1LxsRm58
        XSCiEsFlWwdiAWISPMHAP3ljNWy4fdjJW5foJinKeAKiSIKaW4g4oUj/t1xxAkKG3Qkjt2
        eLTlaCJ4aOETfdZemhaLjPidSaEBwgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-936JH9WOMsyj47I0Fdf0UQ-1; Mon, 30 Nov 2020 04:38:45 -0500
X-MC-Unique: 936JH9WOMsyj47I0Fdf0UQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F057100C600;
        Mon, 30 Nov 2020 09:38:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-159.rdu2.redhat.com [10.10.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E247B5D720;
        Mon, 30 Nov 2020 09:38:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201129200550.2433401-1-vladimir.oltean@nxp.com>
References: <20201129200550.2433401-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     dhowells@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net: delete __dev_getfirstbyhwtype
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3095162.1606729122.1@warthog.procyon.org.uk>
Date:   Mon, 30 Nov 2020 09:38:42 +0000
Message-ID: <3095163.1606729122@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> The last user of the RTNL brother of dev_getfirstbyhwtype (the latter
> being synchronized under RCU) has been deleted in commit b4db2b35fc44
> ("afs: Use core kernel UUID generation").
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Fine by me.  I thought it had already been removed.

David


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125511BF393
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgD3Ix2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:53:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34419 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726412AbgD3Ix1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588236806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Wl0zAScIaAdS1eu6SW24t+laJBR/E/yL2GgT+DzceA=;
        b=arfP5LDZ/EtI+MqFoAvf4u9gif1iaFzYrQyBXKBHVYv78GnWhRH+kK2X4sZ7+KyJkXRL62
        paws9Y/Or0MWF56G/DacXqnUufDRLFOOgnqJHlzzUCjeX/5zfqx6ATfvBlnIzdgFrlVyCd
        n5R4vADbjXsr8Ol1NytVREsK3o5XkDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-_3tEntzPOGOt613sqDpJwA-1; Thu, 30 Apr 2020 04:53:22 -0400
X-MC-Unique: _3tEntzPOGOt613sqDpJwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CFB01054F8F;
        Thu, 30 Apr 2020 08:53:21 +0000 (UTC)
Received: from ovpn-114-219.ams2.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2FDF605DD;
        Thu, 30 Apr 2020 08:53:18 +0000 (UTC)
Message-ID: <7f50648241eddfbc2062b6edf88b16db0e60787f.camel@redhat.com>
Subject: Re: [PATCH net 2/5] mptcp: move option parsing into
 mptcp_incoming_options()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Date:   Thu, 30 Apr 2020 10:53:17 +0200
In-Reply-To: <alpine.OSX.2.22.394.2004291151040.42484@jdfowle1-mobl1.amr.corp.intel.com>
References: <cover.1588156257.git.pabeni@redhat.com>
         <aa86653cfe250462144b5635e235a92279eaf288.1588156257.git.pabeni@redhat.com>
         <alpine.OSX.2.22.394.2004291151040.42484@jdfowle1-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-29 at 11:54 -0700, Mat Martineau wrote:
> On Wed, 29 Apr 2020, Paolo Abeni wrote:
[...]

> > Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> 
> Hi Paolo -
> 
> This doesn't apply cleanly to the net tree.

I'm sorry, I had local unrelated changes that caused fuzzy. I'll rebase
in v2.

Thank you for checking!

Cheers,

Paolo


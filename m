Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E065F1B21D4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgDUIih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:38:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32400 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUIig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:38:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587458315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OK6qYuByoFv5/7Xc9brNny50E++JaILi1ivdrTp3evM=;
        b=fHBViVBmFwuLqrUg0bsv5RJkH7h7VflJF++zGiJglOE+4vdeH8vgqJ0QwZXvDtB9NmzTjE
        PvfCH8PUPtDCBns4UbB1y+12VMhNDMjxY/QjYq4QF01zcNh+OI3bMSEai443ibhtJqeQFb
        +asxSzO3bJYw6acKuxGRKp2mNn7QVQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-Av7wbNAsO6GwIKEL3WTIqg-1; Tue, 21 Apr 2020 04:38:33 -0400
X-MC-Unique: Av7wbNAsO6GwIKEL3WTIqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE1BD190B2A1;
        Tue, 21 Apr 2020 08:38:31 +0000 (UTC)
Received: from ovpn-115-18.ams2.redhat.com (ovpn-115-18.ams2.redhat.com [10.36.115.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC75DA18A5;
        Tue, 21 Apr 2020 08:38:29 +0000 (UTC)
Message-ID: <a708ac7ff0119d07c2a0873d05f840982179441b.camel@redhat.com>
Subject: Re: [PATCH net 0/3] mptcp: fix races on accept()
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, kuba@kernel.org, cpaasch@apple.com,
        fw@strlen.de
Date:   Tue, 21 Apr 2020 10:38:28 +0200
In-Reply-To: <20200420.130215.721617466987117194.davem@davemloft.net>
References: <cover.1587389294.git.pabeni@redhat.com>
         <20200420.130215.721617466987117194.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-20 at 13:02 -0700, David Miller wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Mon, 20 Apr 2020 16:25:03 +0200
> 
> > This series includes some fixes for accept() races which may cause inconsistent
> > MPTCP socket status and oops. Please see the individual patches for the
> > technical details.
> 
> Series applied, thanks.
> 
> It seems like patch #3 might be relevant for v5.6 -stable, what's the
> story here?

Yes, it addresses a race condition present since cc7972ea1932 ("mptcp:
parse and emit MP_CAPABLE option according to v1 spec"). I see now that
the changelog is probably a bit too vague, I'm sorry.

Cheers,

Paolo


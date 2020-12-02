Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC32CC312
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgLBRJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgLBRJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606928902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFnQHrNZCj1bb44xxVvcyZr/hZ3PqaBCWBHKBJdXXi4=;
        b=L/L+sIiXgCY+obTk9CIRJY0+UhDWSk78FKSxfdxyDQpHbj6vHUjCR99aTo3Vp9ZfP7WW7e
        /Qch7890fIv5wBpswZY/k7b6cFDi1T+uAvLRVRzIKn575FaDCMr3HmglraJB7x8potzx7u
        17Vx9H0tZ5xzsqTBwe7F90wQWEOo9lY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-u9H9kSDmPAq0pCUW7y8tig-1; Wed, 02 Dec 2020 12:08:18 -0500
X-MC-Unique: u9H9kSDmPAq0pCUW7y8tig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E524100C661;
        Wed,  2 Dec 2020 17:08:17 +0000 (UTC)
Received: from ovpn-112-254.ams2.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA9A310013C0;
        Wed,  2 Dec 2020 17:08:15 +0000 (UTC)
Message-ID: <9d40955d2d33dd36f8bc38067868c19dd8cb5173.camel@redhat.com>
Subject: Re: [MPTCP] Re: [PATCH net-next v2] mptcp: be careful on
 MPTCP-level ack.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Date:   Wed, 02 Dec 2020 18:08:11 +0100
In-Reply-To: <0c400986125dfdd42990ee4203a60d9b309d29c8.camel@redhat.com>
References: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
         <fdad2c0e-e84e-4a82-7855-fc5a083bb055@gmail.com>
         <665bb3a603afebdcc85878f6b45bcf0313607994.camel@redhat.com>
         <2ac90c38-c82a-8aeb-2c01-b44a6de1bf57@gmail.com>
         <d05ac8b9-3522-e4fc-d3ce-4bea74a6dfbf@gmail.com>
         <ca50540b-f305-7519-6039-f3beced5e5d8@gmail.com>
         <e2e9500c-f2cc-2e08-6ecc-68ed50e64cd1@gmail.com>
         <0c400986125dfdd42990ee4203a60d9b309d29c8.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-02 at 17:51 +0100, Paolo Abeni wrote:
> On Wed, 2020-12-02 at 17:45 +0100, Eric Dumazet wrote:
> > Packetdrill recvmsg syntax would be something like
> > 
> >    +0	recvmsg(3, {msg_name(...)=...,
> > 		    msg_iov(1)=[{..., 0}],
> > 		    msg_flags=0
> > 		    }, 0) = 0
> 
> Thank you very much for all the effort!
> 
> Yes, with recvmsg() the packet drill hangs. I agree your proposed fix
> is correct.
> 
> I can test it explicitly later today.

The proposed fix passes successfully the pktdrill test and there are no
regressions in the other self-tests.

Feel free to add:

Tested-by: Paolo Abeni <pabeni@redhat.com>

thanks!

Paolo


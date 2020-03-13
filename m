Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C948184CC4
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgCMQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:45:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727024AbgCMQpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584117950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NGcze98cXWYCmagpEsgCSEsYGqJZVyFshEV55Z7Gjs=;
        b=fRMBVFMVpdIShFmMGmp/IJ/b0TNZGj3lH1OZ4/EYAgrE8aCutCRmAErU94sZFkLpmoopXl
        NWHLIWzWE/eQx0Ygm6pQ0Xl6N9gOTdhdsZl3aPI8Qjyaxj8DqFurrVQDwHP9rbdYNwBJyn
        Mb3Gcsrrim1G6pQ/yBruV28q6BDqtCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-CzQAHedQM_2jEHV0CsdCFg-1; Fri, 13 Mar 2020 12:45:42 -0400
X-MC-Unique: CzQAHedQM_2jEHV0CsdCFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61380101FC68;
        Fri, 13 Mar 2020 16:45:40 +0000 (UTC)
Received: from x2.localnet (ovpn-117-60.phx2.redhat.com [10.3.117.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1C565C1BB;
        Fri, 13 Mar 2020 16:45:30 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling the audit daemon
Date:   Fri, 13 Mar 2020 12:45:29 -0400
Message-ID: <2588582.z15pWOfGEt@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca> <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, March 13, 2020 12:42:15 PM EDT Paul Moore wrote:
> > I think more and more, that more complete isolation is being done,
> > taking advantage of each type of namespace as they become available, but
> > I know a nuber of them didn't find it important yet to use IPC, PID or
> > user namespaces which would be the only namespaces I can think of that
> > would provide that isolation.
> > 
> > It isn't entirely clear to me which side you fall on this issue, Paul.
> 
> That's mostly because I was hoping for some clarification in the
> discussion, especially the relevant certification requirements, but it
> looks like there is still plenty of room for interpretation there (as
> usual).  I'd much rather us arrive at decisions based on requirements
> and not gut feelings, which is where I think we are at right now.

Certification rquirements are that we need the identity of anyone attempting 
to modify the audit configuration including shutting it down.

-Steve



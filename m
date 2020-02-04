Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3BC1151D9B
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 16:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgBDPrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 10:47:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37069 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727331AbgBDPrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 10:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580831260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k5j3ObvOODL75kJLhay5/4twRQnCsNc1II2lP04Cwzc=;
        b=EXFvQTntXUNXt7svOP1my7rv8MJb2pHJklxfIyioWzthFzHE16TIwHX0pajDYMq/2QCBkv
        rqNa+mcP8/BKtf01LV/cTX/GXrMf6o5+ba6bZsbuPOk/sijKwJS5g3biZfQTn7RlwSomL5
        KO+5uBg9yYwHfZL2FQuvv4+C2P86u70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-6f651S_0N52lsFSFMHrBKg-1; Tue, 04 Feb 2020 10:47:39 -0500
X-MC-Unique: 6f651S_0N52lsFSFMHrBKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3F7A19251A6;
        Tue,  4 Feb 2020 15:47:36 +0000 (UTC)
Received: from x2.localnet (ovpn-116-11.phx2.redhat.com [10.3.116.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFF115C1B5;
        Tue,  4 Feb 2020 15:47:23 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Date:   Tue, 04 Feb 2020 10:47:22 -0500
Message-ID: <3665686.i1MIc9PeWa@x2>
Organization: Red Hat
In-Reply-To: <20200204131944.esnzcqvnecfnqgbi@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com> <5238532.OiMyN8JqPO@x2> <20200204131944.esnzcqvnecfnqgbi@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, February 4, 2020 8:19:44 AM EST Richard Guy Briggs wrote:
> > The established pattern is that we print -1 when its unset and "?" when
> > its totalling missing. So, how could this be invalid? It should be set
> > or not. That is unless its totally missing just like when we do not run
> > with selinux enabled and a context just doesn't exist.
> 
> Ok, so in this case it is clearly unset, so should be -1, which will be a
> 20-digit number when represented as an unsigned long long int.
> 
> Thank you for that clarification Steve.

It is literally a  -1.  ( 2 characters)

-Steve



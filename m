Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062C0151063
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 20:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBCTjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 14:39:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60437 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726287AbgBCTjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 14:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580758740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=deBqCvYs3KYzR5/P5FdSKrFW2W30N3hhxjCn43gcuGQ=;
        b=ZbisDZw0UyzOI1TXJxbHeDF4AFib+vY+eyHNl0Lg01uUgXDDf0EhCGk3GDTXGKNBwr0HMi
        nrlG0guxl2lzovhQJF5y9zz6b8SddxOfzmh8iuRjv3iDCGrOwAvuH+gTV2XakRkx44NSLK
        x4rUBWqLFZOPOJpp7f4L2Qb2+Pboxm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-bVef1RD8MZ2RY_h7reHVsQ-1; Mon, 03 Feb 2020 14:38:57 -0500
X-MC-Unique: bVef1RD8MZ2RY_h7reHVsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F38201005502;
        Mon,  3 Feb 2020 19:38:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-218.rdu2.redhat.com [10.10.120.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0669E19481;
        Mon,  3 Feb 2020 19:38:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200203103914.4b038cb7@cakuba.hsd1.ca.comcast.net>
References: <20200203103914.4b038cb7@cakuba.hsd1.ca.comcast.net> <158072584492.743488.4616022353630142921.stgit@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/4] rxrpc: Fixes ver #2
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1004692.1580758734.1@warthog.procyon.org.uk>
Date:   Mon, 03 Feb 2020 19:38:54 +0000
Message-ID: <1004693.1580758734@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> I pulled rxrpc-fixes-20200202 since that tag seems to correspond to 
> the patches on the mailing list.

Sorry, yes - I forgot to change that.

> Should I queue these for stable? There are some fixes to fixes here, 
> so AFAIK we need:
> 
> 5273a191dca65a675dc0bcf3909e59c6933e2831   4.9+
> 04d36d748fac349b068ef621611f454010054c58   4.19+
> f71dbf2fb28489a79bde0dca1c8adfb9cdb20a6b   4.9+
> fac20b9e738523fc884ee3ea5be360a321cd8bad   4.19+

Yes, please.  DaveM asked me not to put stable tags in my net patches, IIRC,
as his scripts do that automagically.

David


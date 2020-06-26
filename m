Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9093020AD95
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 09:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgFZHyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 03:54:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24018 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728635AbgFZHyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 03:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593158082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Of86hWoKfykJ98r7Ce/eFA7ToVfIKZIjXFa/mRKy90k=;
        b=SuOlQbJZMs6Kr3P+a4K2JO9gJ5QLgSBMN9PZUDX+VWn7bdSmtvUOfptrP/6c1g7QgvO8bF
        IMZrxpzuKfW44BDTqQwjBdfLnwfiNLjJEiDW1m+OHV8uVOfwl6w4VJksric08QgWoKKn+m
        K/SpbRVBMCCwko4FtzS61fg3BznOYJA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-ikly6Z4jN5S_ds1ejVUbDA-1; Fri, 26 Jun 2020 03:54:39 -0400
X-MC-Unique: ikly6Z4jN5S_ds1ejVUbDA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A7071005512;
        Fri, 26 Jun 2020 07:54:38 +0000 (UTC)
Received: from ovpn-114-92.ams2.redhat.com (ovpn-114-92.ams2.redhat.com [10.36.114.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC1C31002395;
        Fri, 26 Jun 2020 07:54:37 +0000 (UTC)
Message-ID: <5a02a0196dd07f57d9449e1723e20a40910f79d5.camel@redhat.com>
Subject: Re: Request for net merge into net-next
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Date:   Fri, 26 Jun 2020 09:54:36 +0200
In-Reply-To: <20200625.194008.791920953816892666.davem@davemloft.net>
References: <74156b9ad8529a3228658165396fd5adb2ccd972.camel@redhat.com>
         <20200625.122137.190059934175313682.davem@davemloft.net>
         <20200625.194008.791920953816892666.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-25 at 19:40 -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 25 Jun 2020 12:21:37 -0700 (PDT)
> 
> > From: Paolo Abeni <pabeni@redhat.com>
> > Date: Thu, 25 Jun 2020 11:16:47 +0200
> > 
> >> We have a few net-next MPTCP changes depending on:
> >> 
> >> commit 9e365ff576b7c1623bbc5ef31ec652c533e2f65e
> >> mptcp: drop MP_JOIN request sock on syn cookies
> >>     
> >> commit 8fd4de1275580a1befa1456d1070eaf6489fb48f
> >> mptcp: cache msk on MP_JOIN init_req
> >> 
> >> Could you please merge net into net-next so that we can post without
> >> causing later conflicts?
> > 
> > I'm going to send a pull request for 'net' to Linus and once he takes that
> > I'll sync everything.
> 
> This is now done.
> 
Thank you!

I will spam the ML with patches soon ;)

/P


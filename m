Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B479A4A6D87
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245303AbiBBJIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:08:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229918AbiBBJII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:08:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643792887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TpJy/tBp9lc5tCxU+y/I62v/5aTLk3/cw9CBHeYsYGU=;
        b=dm272+vNxttm8d2s75sxKVYuoVdu89mUGroADwCbDDnNi4JL0VIyGXC1tuu/ql4CULucBa
        FElE9qtNsGTPe6VpnI+/7iAg+b9QHO+qFYWpBrlRcPXDbT23owGyXhYDyfQkgGsCMDcSTE
        LCjjtbTlG4aiivaEI7Fu+KrQIK1A3Ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-C0lDBTKYMyC-UV6-VSVu0w-1; Wed, 02 Feb 2022 04:08:02 -0500
X-MC-Unique: C0lDBTKYMyC-UV6-VSVu0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DC9C1091DA0;
        Wed,  2 Feb 2022 09:08:01 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B91C97D3C9;
        Wed,  2 Feb 2022 09:08:00 +0000 (UTC)
Date:   Wed, 2 Feb 2022 10:07:59 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 5/5] ptp: start virtual clocks at current system
 time.
Message-ID: <YfpJ7zEO/CfxbLDA@localhost>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-6-mlichvar@redhat.com>
 <20220127220116.GB26514@hoboy.vegasvil.org>
 <Yfe4FPHbFjc6FoTa@localhost>
 <20220201190351.GA7009@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201190351.GA7009@hoboy.vegasvil.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 11:03:51AM -0800, Richard Cochran wrote:
> On Mon, Jan 31, 2022 at 11:21:08AM +0100, Miroslav Lichvar wrote:
> > On Thu, Jan 27, 2022 at 02:01:16PM -0800, Richard Cochran wrote:
> > > I think we agreed that, going forward, new PHC drivers should start at
> > > zero (1970) instead of TAI - 37.
> > 
> > I tried to find the discussion around this decision, but failed. Do
> > you have a link?
> 
> Here is one of the discussions.  It didn't lay down a law or anything,
> but my arguments still stand.
> 
>    https://lore.kernel.org/all/20180815175040.3736548-1-arnd@arndb.de/

I don't see strong arguments for either option (0, UTC, TAI) and would
prefer consistency among drivers.

It would be nice if the drivers called a common function to get the
initial time, so it could be changed for all in one place if
necessary. Anyway, I'll leave this for another time and drop the patch
from the series.

Thanks,

-- 
Miroslav Lichvar


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4C375565
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhEFOKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:10:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234002AbhEFOKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620310164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9h6o9ctEHc8iY8TpOG1bBkRBecU/A/rUbR2Rl7sVlc=;
        b=UoRZ/IqBoypFakqovrQqm3swdSyJvGlAQIBZp706LSK2asqqwFAQwOIkZZvmjFIYRcXaig
        obQ2BVCUwX5BfYY6x9rd+UT514Cv0JHwlVU5/5RqM7Eil7OfFyY4LsXiInOBZpoaf8++7U
        yVm78qBPkIrLWz5nyC7rPuZ52fWMvAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-lKQauTevPp6sFzeJ1LyBoA-1; Thu, 06 May 2021 10:09:21 -0400
X-MC-Unique: lKQauTevPp6sFzeJ1LyBoA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B388C73A3;
        Thu,  6 May 2021 14:09:20 +0000 (UTC)
Received: from [10.10.110.34] (unknown [10.10.110.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC71610016FD;
        Thu,  6 May 2021 14:09:18 +0000 (UTC)
Message-ID: <24356aa7737d5d0bbf9481bbba89b4248811ebce.camel@gapps.redhat.com>
Subject: Re: [PATCH V2 07/16] net: iosm: mbim control device
From:   Dan Williams <dcbw@gapps.redhat.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>
Date:   Thu, 06 May 2021 09:09:18 -0500
In-Reply-To: <fd6b57f1e3b1444383ad5387de36e1cc@intel.com>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
         <20210420161310.16189-8-m.chetan.kumar@intel.com>
         <CAMZdPi8h7ubOvUBaF2wh87UBwzJz3GpQ3gZwSXy0miV7Aw2NXw@mail.gmail.com>
         <fd6b57f1e3b1444383ad5387de36e1cc@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-05-06 at 10:44 +0000, Kumar, M Chetan wrote:
> Hi Loic,
> 
> > > 
> > > Implements a char device for MBIM protocol communication &
> > > provides a
> > > simple IOCTL for max transfer buffer size configuration.
> > > 
> > > Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
> > 
> > Now that the initial wwan framework support landed, could you
> > migrate to it
> > for creating the MBIM 'WWAN port' instead of creating yet another
> > char
> > driver? I see you introduced an IOCTL for packet size, I see no
> > objection to
> > add that in the wwan core.
> > 
> 
> Sure, we have started the migration to MBIM 'WWAN port'. The next
> version of patch
> would contain these adaptations.
> 
> If wwan core supports IOCTL for packet size, then we shall remove
> that piece of
> implementation in driver code.

There has got to be a better way to do that than an ioctl. ioctls are
not looked on favorably these days. Usually it's sysfs files or netlink
config instead.

Dan


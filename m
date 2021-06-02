Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78E3992DE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhFBSxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhFBSxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622659910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LDW4VKY3FpjoAR8jIQ6HiHISKQVZaj+Z7o4ggTxUMMg=;
        b=Aps+QpoEoXaa/0GF6HjMjay11MPRPkAQwsBOW/weyci9ztdfq5kHANmhuF+TB1a84eecVV
        yQDQngVYS41kToW4/C3iY1i5xA7AUGLYqROg9dhFCZbSkjx+IWELdigXEMkdTVQsNS0+oD
        uH3SPBhZDS7Dt49GfzkKIbHvMJX9hTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-SHDYIP_UO8aD7WiY2DmOdA-1; Wed, 02 Jun 2021 14:51:48 -0400
X-MC-Unique: SHDYIP_UO8aD7WiY2DmOdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8422F107ACE3;
        Wed,  2 Jun 2021 18:51:47 +0000 (UTC)
Received: from oldenburg.str.redhat.com (ovpn-113-228.ams2.redhat.com [10.36.113.228])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5EF35D6DC;
        Wed,  2 Jun 2021 18:51:45 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next V6 1/6] icmp: add support for RFC 8335 PROBE
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
        <ba81dcf8097c4d3cc43f4e2ed5cc6f5a7a4c33b6.1617067968.git.andreas.a.roeseler@gmail.com>
        <87im2wup0m.fsf@oldenburg.str.redhat.com>
        <48ff14c5fff0af909519619caa26d20fcda5159c.camel@gmail.com>
Date:   Wed, 02 Jun 2021 20:51:43 +0200
In-Reply-To: <48ff14c5fff0af909519619caa26d20fcda5159c.camel@gmail.com>
        (Andreas Roeseler's message of "Wed, 02 Jun 2021 13:46:32 -0500")
Message-ID: <87r1hkt800.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Andreas Roeseler:

> Are <netinet/in.h> and <linux/in.h> the only conflicting files?
> <linux/in.h> is only included to gain use of the in_addr struct, but
> that can be easily substituted out of the code in favor of __be32.
> Therefore we would no longer need to include <linux/in.h> and would
> remove the conflict.

I'm not 100% sure, but it looks this way.  I can include <netinet/in.h>
and both <linux/in6.h> and <linux/if.h> in the same translation unit.

Thanks,
Florian


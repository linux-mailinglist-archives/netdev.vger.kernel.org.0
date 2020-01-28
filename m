Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD5514B2BF
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 11:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgA1KgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jan 2020 05:36:14 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41164 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726072AbgA1KgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 05:36:14 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-6sJlTvjbP6qyhaBBWqYHUQ-1; Tue, 28 Jan 2020 05:36:10 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 205AA18C43C0;
        Tue, 28 Jan 2020 10:36:09 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-117-110.ams2.redhat.com [10.36.117.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4164319C58;
        Tue, 28 Jan 2020 10:36:08 +0000 (UTC)
Date:   Tue, 28 Jan 2020 11:36:06 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 0/2] macsec: add offloading support
Message-ID: <20200128103606.GA635664@bistromath.localdomain>
References: <20200120201823.887937-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
In-Reply-To: <20200120201823.887937-1-antoine.tenart@bootlin.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 6sJlTvjbP6qyhaBBWqYHUQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-01-20, 21:18:21 +0100, Antoine Tenart wrote:
> If a mode isn't supported, `ip macsec offload` will report an issue
> (-EOPNOTSUPP).
> 
> One thing not supported in this series would be the ability to list all
> supported modes (for now 'off' and 'phy') depending on the h/w interface
> capabilities. This can come up in a later patch, as this is not critical
> to get the feature used, but I would like this to be compatible with the
> current series. I can think of 2 possibilities: either through
> `ip macsec show` or through `ip macsec offload` (for example when no
> argument is given). What are your thoughts on this?

I don't think that's really helpful. The device could change between
listing available modes and enabling offloading. The failure of "ip
macsec offload blah" (or whatever the command ends up being) will do
the same job anyway.

-- 
Sabrina


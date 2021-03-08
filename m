Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FCD330C6A
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 12:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCHLa6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Mar 2021 06:30:58 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:53576 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231902AbhCHLaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 06:30:35 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167--XqPluZjPA6Pn30-2BFS7g-1; Mon, 08 Mar 2021 06:30:32 -0500
X-MC-Unique: -XqPluZjPA6Pn30-2BFS7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 493EE801814;
        Mon,  8 Mar 2021 11:30:31 +0000 (UTC)
Received: from hog (unknown [10.40.194.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AD0C59470;
        Mon,  8 Mar 2021 11:30:29 +0000 (UTC)
Date:   Mon, 8 Mar 2021 12:30:28 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        Paul Wouters <pwouters@redhat.com>
Subject: Re: [PATCH iproute2] ip: xfrm: add NUL character to security context
 name before printing
Message-ID: <YEYK1IlIo39aZLT4@hog>
References: <11af39932b3896cf1a560059bcbd24194e7f33bd.1613473397.git.sd@queasysnail.net>
MIME-Version: 1.0
In-Reply-To: <11af39932b3896cf1a560059bcbd24194e7f33bd.1613473397.git.sd@queasysnail.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen/David,

2021-02-16, 17:50:58 +0100, Sabrina Dubroca wrote:
> Security context names are not guaranteed to be NUL-terminated by the
> kernel, so we can't just print them using %s directly. The length of
> the string is capped by the size of the netlink attribute (u16), so it
> will always fit within 65535 bytes.
> 
> While at it, factor that out to a separate function, since the exact
> same code is used to print the security context for both policies and
> states.

This patch ended up with "Changes Requested" in patchwork [1], even though
there has been no reply to it. Do I need to resend it?

[1] https://patchwork.kernel.org/project/netdevbpf/patch/11af39932b3896cf1a560059bcbd24194e7f33bd.1613473397.git.sd@queasysnail.net/

Thanks,

-- 
Sabrina


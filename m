Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2A3431859
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhJRMCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:02:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231443AbhJRMCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634558427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rTnr5zPOE6Vt0ELSKSyMIl02NPqdwlgVr4MsL4umZmQ=;
        b=SdFSeyG8BwDQcsBIroTdz7VnaQoMeK3mhL0c61+AJtUTjbVEmpTuMDY+59ovuZ8SwJUW9E
        8sj2oLNnUAD1Q93BJ6m3jXbehTAJPNkPXqBpCiTRZQUe0rtvYU4DpnFD6vFa889RCBe8nm
        MtZGHBs3iPP4vBt5SNaYOJAR5Qa3RAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-jMdoA0UhMCKhQTtlHxoazA-1; Mon, 18 Oct 2021 08:00:21 -0400
X-MC-Unique: jMdoA0UhMCKhQTtlHxoazA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D59759F92C;
        Mon, 18 Oct 2021 12:00:19 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EB9F196E5;
        Mon, 18 Oct 2021 12:00:16 +0000 (UTC)
Date:   Mon, 18 Oct 2021 14:00:14 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH net 1/2] mctp: unify sockaddr_mctp types
Message-ID: <20211018120014.GB22725@asgard.redhat.com>
References: <20211018032935.2092613-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018032935.2092613-1-jk@codeconstruct.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:29:34AM +0800, Jeremy Kerr wrote:
> Use the more precise __kernel_sa_family_t for smctp_family, to match
> struct sockaddr.
> 
> Also, use an unsigned int for the network member; negative networks
> don't make much sense. We're already using unsigned for mctp_dev and
> mctp_skb_cb, but need to change mctp_sock to suit.
> 
> Fixes: 60fc63981693 ("mctp: Add sockaddr_mctp to uapi")
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

Acked-by: Eugene Syromiatnikov <esyr@redhat.com>


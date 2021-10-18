Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B0D431A16
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhJRMxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:53:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231799AbhJRMxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634561497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/yPuqxFa+Tr8CEs47WYHOUJwPZ/wif1rOLyki9r4qZM=;
        b=W8ydZ+Ub/C4C5qbb5aFWMSi2xeuTAfOyzRp6D87yNhFskUMG4ERVVMr4Je6QSW6eu2KsBD
        ZYMwOQMdOHN72I80LaljRa7co9RnKnC2wyHd8hONlB5FK36VFxsl7nGjcXA9fqW+kcAPWD
        CYB9qjPz1ycdiqD1g2aDiLAKY1Yqxnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-mZKa-H1XMU-Cyk5vpOPDyQ-1; Mon, 18 Oct 2021 08:51:34 -0400
X-MC-Unique: mZKa-H1XMU-Cyk5vpOPDyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1ADD1800685;
        Mon, 18 Oct 2021 12:51:33 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E139360CA0;
        Mon, 18 Oct 2021 12:51:30 +0000 (UTC)
Date:   Mon, 18 Oct 2021 14:51:27 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH net 2/2] mctp: Be explicit about struct sockaddr_mctp
 padding
Message-ID: <20211018125127.GC22725@asgard.redhat.com>
References: <20211018032935.2092613-1-jk@codeconstruct.com.au>
 <20211018032935.2092613-2-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018032935.2092613-2-jk@codeconstruct.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:29:35AM +0800, Jeremy Kerr wrote:
> We currently have some implicit padding in struct sockaddr_mctp. This
> patch makes this padding explicit, and ensures we have consistent
> layout on platforms with <32bit alignmnent.
> 
> Fixes: 60fc63981693 ("mctp: Add sockaddr_mctp to uapi")
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

Acked-by: Eugene Syromiatnikov <esyr@redhat.com>


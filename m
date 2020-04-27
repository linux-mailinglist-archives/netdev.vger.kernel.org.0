Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810E71BA5A9
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgD0OE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:04:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgD0OE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587996296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vQX0R1AZbaienuZ4mjJVfx3Fkgw7tSWAE9INms0EHiA=;
        b=KiCEQAka2Kug7Mm/AQSaaOWRQSvTLQCsKGguNIdbG8dUPFhum8XjXXHYcAwIArszzI+PmH
        gy8jKHEkvir5cOdv+Va8F/1XpCIO5A3fySgP2SwBak6dAcQqHqRo/pJAbPsG5XoLvK4hdJ
        qOJOeYaE3nxz8Qhz/L9um6xB9X0BGTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-pfTXZERAPU6D5-DiuuAAdg-1; Mon, 27 Apr 2020 10:04:54 -0400
X-MC-Unique: pfTXZERAPU6D5-DiuuAAdg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9214018765B6;
        Mon, 27 Apr 2020 14:04:53 +0000 (UTC)
Received: from ovpn-114-189.ams2.redhat.com (ovpn-114-189.ams2.redhat.com [10.36.114.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 365546062C;
        Mon, 27 Apr 2020 14:04:52 +0000 (UTC)
Message-ID: <e6c0df38518ecc2b213bc140dc74fa89188f84e5.camel@redhat.com>
Subject: Re: [PATCH iproute2-next 0/4] iproute: mptcp support
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     dcaratti@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org
Date:   Mon, 27 Apr 2020 16:04:50 +0200
In-Reply-To: <cover.1587572928.git.pabeni@redhat.com>
References: <cover.1587572928.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, 2020-04-23 at 15:37 +0200, Paolo Abeni wrote:
> This introduces support for the MPTCP PM netlink interface, allowing admins
> to configure several aspects of the MPTCP path manager. The subcommand is
> documented with a newly added man-page.
> 
> This series also includes support for MPTCP subflow diag.
> 
> Davide Caratti (1):
>   ss: allow dumping MPTCP subflow information
> 
> Paolo Abeni (3):
>   uapi: update linux/mptcp.h
>   add support for mptcp netlink interface
>   man: mptcp man page

Due to PEBKAC, I did not include your email address in the recipient
list. Do you prefer I'll re-submit this including you, or are you still
fine with it?

Thank you!

Paolo


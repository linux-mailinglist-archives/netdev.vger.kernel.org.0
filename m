Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2940C2F67E4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbhANRgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:36:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727497AbhANRgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610645710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOHAdlgqauRBwXPD9c71qFXJvfD2MycfcJmzwTSg5/w=;
        b=MtrPISixWaNQKhg9/nvE5VSzxAVfhLUTEiOdZqc1iFLtzAGAGyb6CMYmXMCjQpBQF1XxhX
        Ysz8GbUTRDkJ5Xj/ovAY6+caGsRp6fri8eN2J7uxC0vvVNRfwgpHok+kcESWGgB65oTVvn
        DxSUpFkA6CNBSRkzUJ9fCz1UmPxj/dQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-FPnpFKJAPS6bUN3TEsWgUQ-1; Thu, 14 Jan 2021 12:35:08 -0500
X-MC-Unique: FPnpFKJAPS6bUN3TEsWgUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BCEA8CA3CA;
        Thu, 14 Jan 2021 17:34:30 +0000 (UTC)
Received: from ovpn-115-2.ams2.redhat.com (ovpn-115-2.ams2.redhat.com [10.36.115.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73BF15D748;
        Thu, 14 Jan 2021 17:34:29 +0000 (UTC)
Message-ID: <3c6852e30a1a7202ea0fba662dfef369d4d2851d.camel@redhat.com>
Subject: Re: iproute2 ss "RTNETLINK answers: Invalid argument" with 5.4
 kernel
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "dsahern@kernel.org" <dsahern@kernel.org>
Date:   Thu, 14 Jan 2021 18:34:28 +0100
In-Reply-To: <a94ad61d28b69cdaac3b524e4f837e8d63ba65b0.camel@nokia.com>
References: <a94ad61d28b69cdaac3b524e4f837e8d63ba65b0.camel@nokia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-14 at 13:17 +0000, Rantala, Tommi T. (Nokia - FI/Espoo)
wrote:
> Hi,
> 
> Since iproute2 v5.9.0, running ss on LTS kernels (for example 5.4.y)
> produces error message in stderr (it's working otherwise fine, just printing
> this extra error):
> 
>   $ ss
>   RTNETLINK answers: Invalid argument
>   ...
> 
> Bisected to:
> 
> commit 9c3be2c0eee01be7832b7900a8be798a19c659a5
> Author: Paolo Abeni <pabeni@redhat.com>
> Date:   Fri Jul 10 15:52:35 2020 +0200
> 
>     ss: mptcp: add msk diag interface support
> 
> 
> As 5.4 does not have any mptcp support, it's not surprising that there is
> some EINVAL error. Any nice way to get rid of the error for LTS kernel
> users?

Thank you for reporting this! I'll try to have a look ASAP -
unfortunatelly can't be before next week.

Cheers,

Paolo


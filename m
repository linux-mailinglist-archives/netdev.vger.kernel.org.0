Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69F9284F99
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJFQM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbgJFQM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 12:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602000778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKb7sZVPybPTfbA/gFJsTXmJHS4tONXKkrgyfpj9y48=;
        b=E8s4QB9/RsYlfOUVQ11RNs8i7JL0KIEfenk3CQu2ae2Dhf+xvyCnnQrb9y83c1GJcsc9wn
        HQcpo7lEfLeC3ZK4VobxonJOsis7ZVd9WDTMNUqSKU3BGJixlOlAQDo6HB3qLWTD0EJjLo
        7lFT5UP0LM0V2UIWUD0i11wdY50PutA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-53J22Gl_PPu2IF5lEv0o2g-1; Tue, 06 Oct 2020 12:12:54 -0400
X-MC-Unique: 53J22Gl_PPu2IF5lEv0o2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 516D2425D4;
        Tue,  6 Oct 2020 16:12:52 +0000 (UTC)
Received: from ovpn-112-231.ams2.redhat.com (ovpn-112-231.ams2.redhat.com [10.36.112.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6CC15C1C4;
        Tue,  6 Oct 2020 16:12:47 +0000 (UTC)
Message-ID: <c750c3256bec4ceab91a95f2725e4bc026f4b5dc.camel@redhat.com>
Subject: Re: [PATCH net-next] selftests: mptcp: interpret \n as a new line
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Oct 2020 18:12:45 +0200
In-Reply-To: <20201006160631.3987766-1-matthieu.baerts@tessares.net>
References: <20201006160631.3987766-1-matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-06 at 18:06 +0200, Matthieu Baerts wrote:
> In case of errors, this message was printed:
> 
>   (...)
>   balanced bwidth with unbalanced delay       5233 max 5005  [ fail ]
>   client exit code 0, server 0
>   \nnetns ns3-0-EwnkPH socket stat for 10003:
>   (...)
> 
> Obviously, the idea was to add a new line before the socket stat and not
> print "\nnetns".
> 
> The commit 8b974778f998 ("selftests: mptcp: interpret \n as a new line")
> is very similar to this one. But the modification in simult_flows.sh was
> missed because this commit above was done in parallel to one here below.
> 
> Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Acked-by: Paolo Abeni <pabeni@redhat.com>


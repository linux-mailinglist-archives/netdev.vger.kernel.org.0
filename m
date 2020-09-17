Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A0226D661
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgIQIYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:24:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbgIQIYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:24:05 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:24:04 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600331043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LYKzEuRLnXn1tFjbAdxREws6PF3YO56THLfLneD1eRo=;
        b=ZwuqY+4aFJDy1spStnXc6KOgJ/WfNENbcpx2Re7IN5jE3+Fe6bO3O6FIQYJsUv1guKAfvl
        59b/JU4+uXth8ei9pWl4zuOquwKk5Pfdhe6wQcZ5c12eadFXekVrO94kNFvxNw3ok9uUpT
        eJBmNHvw8sg8eV4xc5oxBueLFOCJFdg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-jnj7EB0KMA-AvKDpH3WMaQ-1; Thu, 17 Sep 2020 04:17:42 -0400
X-MC-Unique: jnj7EB0KMA-AvKDpH3WMaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CB9F1017DC1;
        Thu, 17 Sep 2020 08:17:40 +0000 (UTC)
Received: from ovpn-114-192.ams2.redhat.com (ovpn-114-192.ams2.redhat.com [10.36.114.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFA0D7880C;
        Thu, 17 Sep 2020 08:17:36 +0000 (UTC)
Message-ID: <1cb1ca491d7ea2fb8a928c14a56e3a2a5c5e7917.camel@redhat.com>
Subject: Re: [PATCH net-next] selftests: mptcp: interpret \n as a new line
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 17 Sep 2020 10:17:35 +0200
In-Reply-To: <20200916131352.3072764-1-matthieu.baerts@tessares.net>
References: <20200916131352.3072764-1-matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-16 at 15:13 +0200, Matthieu Baerts wrote:
> In case of errors, this message was printed:
> 
>   (...)
>   # read: Resource temporarily unavailable
>   #  client exit code 0, server 3
>   # \nnetns ns1-0-BJlt5D socket stat for 10003:
>   (...)
> 
> Obviously, the idea was to add a new line before the socket stat and not
> print "\nnetns".
> 
> Fixes: b08fbf241064 ("selftests: add test-cases for MPTCP MP_JOIN")
> Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Acked-by: Paolo Abeni <pabeni@redhat.com>


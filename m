Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0331B18CF95
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCTN4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:56:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38034 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgCTN4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584712610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aBKKCxuGzKiLvrrqPPRyma9kDDTtMDjNgcj+HYwHhTs=;
        b=R5aulqqHutbJXeuhOGBj92E+UT18Hx/7fzRYMpvh2uIZM/euas2YVxhNUiTDGFnZR3ETQY
        AFy0cSw37xYj10ikdXMZo271iFysm11/XPanSTUQK6pJ9L97a2dc4CS3FsipDycIDWMokY
        04ZfUdW+FYBEAqVg+by58/6C92nKy+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-uCxcpSM7P_e66dxWVrksMQ-1; Fri, 20 Mar 2020 09:56:48 -0400
X-MC-Unique: uCxcpSM7P_e66dxWVrksMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FD92477;
        Fri, 20 Mar 2020 13:56:46 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-190.rdu2.redhat.com [10.10.118.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0641C62937;
        Fri, 20 Mar 2020 13:56:42 +0000 (UTC)
Subject: Re: [PATCH v5 1/2] KEYS: Don't write out to userspace while holding
 key semaphore
To:     David Howells <dhowells@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
References: <20200318221457.1330-2-longman@redhat.com>
 <20200318221457.1330-1-longman@redhat.com>
 <3251035.1584692419@warthog.procyon.org.uk>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <69678e1c-dfbe-7484-85ad-601ebe23c90d@redhat.com>
Date:   Fri, 20 Mar 2020 09:56:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <3251035.1584692419@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 4:20 AM, David Howells wrote:
> Waiman Long <longman@redhat.com> wrote:
>
>> +		if ((ret > 0) && (ret <= buflen)) {
> That's a bit excessive on the bracketage, btw, but don't worry about it unless
> you respin the patches.

Got it.

Thanks,
Longman


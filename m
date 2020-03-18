Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29F9189DE1
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgCROc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:32:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:55075 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727021AbgCROc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 10:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584541946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4Lls9UoDb9uKTNqm5ZPP3fEFfUNHwPy6zZuzCAlNcw=;
        b=W8IcQYeoKGniWZ+xVNtxREbpKz4mw0VF+HX84ejIYX1AL78EbHzm3s+e3LdMe8tctBn7nA
        +9OvvYtfbfu45uzSbxs67eIV4+1gMjxsVPLoBgJvsaqaU6bK3dDGXwF8A93oD7/8e0Bdp2
        PkD3hlwWrfQrdQ3fgmp4eJdCexZAvD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-ftqBYlSBOgiVh8uJpfOpng-1; Wed, 18 Mar 2020 10:32:25 -0400
X-MC-Unique: ftqBYlSBOgiVh8uJpfOpng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78E1E800D50;
        Wed, 18 Mar 2020 14:32:22 +0000 (UTC)
Received: from llong.remote.csb (ovpn-120-114.rdu2.redhat.com [10.10.120.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D818B5C1D8;
        Wed, 18 Mar 2020 14:32:19 +0000 (UTC)
Subject: Re: [PATCH v4 2/4] KEYS: Remove __user annotation from rxrpc_read()
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
References: <20200317194140.6031-3-longman@redhat.com>
 <20200317194140.6031-1-longman@redhat.com>
 <2831786.1584519784@warthog.procyon.org.uk>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <fc537b1b-36f5-eac7-111b-e50f41fd01ff@redhat.com>
Date:   Wed, 18 Mar 2020 10:32:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2831786.1584519784@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/20 4:23 AM, David Howells wrote:
> Patch 2 and 3 need to be rolled into patch 1 otherwise sparse will give
> warnings about mismatches in address spaces on patch 1.
>
> Thanks,
> David

I separated them because they spans different domain. Sure, I will
repost it to merge the first three.

Cheers,
Longman


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3422919462F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCZSMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:12:46 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49839 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgCZSMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585246365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xSpHtNBxLLhtF34YSYaO2d4Hbj2Yy2CbluzS9RwRxJk=;
        b=is3ceE0TZHdPSbLXQr2AkZBNeZgRyngtVTo6ksVNnKw+40QltL031SwqAPeBg1n22mkRkS
        Eeb0iHxqemJKMtN6iFGzWrdg5g49cXZYfyCc9gJQ8eTUnlii2ce0TmvtI8+TsGzU+cxhrM
        35zC2gTI8MaSzzIFJTG4cKF3YK6XUFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-LYKPwtB9OVaVDStq5YqjMQ-1; Thu, 26 Mar 2020 14:12:43 -0400
X-MC-Unique: LYKPwtB9OVaVDStq5YqjMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCD2B100550D;
        Thu, 26 Mar 2020 18:12:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-126.rdu2.redhat.com [10.10.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4E5960BF3;
        Thu, 26 Mar 2020 18:12:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200325.193056.1153970692429454819.davem@davemloft.net>
References: <20200325.193056.1153970692429454819.davem@davemloft.net> <20200322011125.24327-1-longman@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     dhowells@redhat.com, longman@redhat.com,
        jarkko.sakkinen@linux.intel.com, jmorris@namei.org,
        serge@hallyn.com, zohar@linux.ibm.com, kuba@kernel.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, sumit.garg@linaro.org,
        jsnitsel@redhat.com, roberto.sassu@huawei.com, ebiggers@google.com,
        crecklin@redhat.com
Subject: Re: [PATCH v8 0/2] KEYS: Read keys to internal buffer & then copy to userspace
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <996367.1585246352.1@warthog.procyon.org.uk>
Date:   Thu, 26 Mar 2020 18:12:32 +0000
Message-ID: <996368.1585246352@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> Who will integrate these changes?

I'll do it unless Jarkko wants to push it through his tree.

David


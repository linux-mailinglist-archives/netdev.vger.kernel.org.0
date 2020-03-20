Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B7418C8E1
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgCTIUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:20:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23191 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbgCTIUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 04:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584692431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VVZY6TeI0YOm1FYG0w30u2dqA8tug6BHP6KzUJXch3w=;
        b=a4kjuSEhnlV+sxVU67goBK717V+x8qLwYKvKdTd+2hWPjGHaN8vFRalFb5P/1SYdqAmzKC
        FV+CDPFk/57hZ5yg/UMIJMjcJT9zo25O6QDsRWagCObcWw/HdUn/6qMSS3ZNjWwxitAh4O
        uimRD7pr1zmHc0jhRy5jQMvU8gTS50A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-Nm9VmDiBOxqeGfERJwsHVA-1; Fri, 20 Mar 2020 04:20:27 -0400
X-MC-Unique: Nm9VmDiBOxqeGfERJwsHVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B69A7800D5A;
        Fri, 20 Mar 2020 08:20:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-126.rdu2.redhat.com [10.10.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E2B85D9CA;
        Fri, 20 Mar 2020 08:20:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200318221457.1330-2-longman@redhat.com>
References: <20200318221457.1330-2-longman@redhat.com> <20200318221457.1330-1-longman@redhat.com>
To:     Waiman Long <longman@redhat.com>
Cc:     dhowells@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Subject: Re: [PATCH v5 1/2] KEYS: Don't write out to userspace while holding key semaphore
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3251034.1584692419.1@warthog.procyon.org.uk>
Date:   Fri, 20 Mar 2020 08:20:19 +0000
Message-ID: <3251035.1584692419@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Waiman Long <longman@redhat.com> wrote:

> +		if ((ret > 0) && (ret <= buflen)) {

That's a bit excessive on the bracketage, btw, but don't worry about it unless
you respin the patches.

David


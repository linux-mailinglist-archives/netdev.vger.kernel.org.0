Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68C316409
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhBJKi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:38:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231321AbhBJKfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:35:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612953258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GI3rbNAdH36TQqo8FgrJ07VfNDA7oBtRyuezCgR2++U=;
        b=HXyhfCEB0CkJRjzvYouXNGMvEun7wX86ZNmN3et0s/SqQ8Y+88EY9dkjJl3+0dWhjenP46
        T8yrNxSnV95fKCM+4G5om6yYoS/ez1sKMb398jaGHPHqQEow9jhwxHdX8MDqsmoWJstFnM
        u+ZiV93JRU5A3sJwXtCX2VF58GrCnFA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-hK8CpayiN4SFNXS17nPMvg-1; Wed, 10 Feb 2021 05:34:14 -0500
X-MC-Unique: hK8CpayiN4SFNXS17nPMvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D02080196C;
        Wed, 10 Feb 2021 10:34:11 +0000 (UTC)
Received: from ovpn-115-79.ams2.redhat.com (ovpn-115-79.ams2.redhat.com [10.36.115.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7264B10013D7;
        Wed, 10 Feb 2021 10:34:09 +0000 (UTC)
Message-ID: <c02040902f51f0cf3aa3fc701005cea970ce0ff8.camel@redhat.com>
Subject: Re: [PATCH net-next v11 0/3] implement kthread based napi poll
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Felix Fietkau <nbd@nbd.name>
Date:   Wed, 10 Feb 2021 11:34:08 +0100
In-Reply-To: <20210208193410.3859094-1-weiwan@google.com>
References: <20210208193410.3859094-1-weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2021-02-08 at 11:34 -0800, Wei Wang wrote:
> The idea of moving the napi poll process out of softirq context to a
> kernel thread based context is not new.
> Paolo Abeni and Hannes Frederic Sowa have proposed patches to move napi
> poll to kthread back in 2016. And Felix Fietkau has also proposed
> patches of similar ideas to use workqueue to process napi poll just a
> few weeks ago.

I'd like to explicitly thank Wei and the reviewers for all the effort
done to get this merged!

Nice and huge work, kudos on you!

Thanks!

Paolo


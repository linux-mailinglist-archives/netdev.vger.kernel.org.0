Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16588118C24
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLJPLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:11:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727420AbfLJPLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 10:11:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575990691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p1RI05YDO3xv3RHAZCLLmGhe5psa/UZ4CXFErvuRwsQ=;
        b=cItN5ZqviSu9VFpX0uWFqKhoochPZzf/gkzblz8l49Q9TSjU9mdQLIbr3diapsRdDqSd4b
        e+yscMUkrB4Rbuc65Aq0B3VEAaMElbiUuDwUc0UBkMX/xJynJJQstLRr62PCeLDTlaepAy
        TI0bQIwhla1bagZ4Y5C1beASuPEgtUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-RVYiFS6bObOCm8eESHagJA-1; Tue, 10 Dec 2019 10:11:28 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D369107BA9B;
        Tue, 10 Dec 2019 15:11:26 +0000 (UTC)
Received: from localhost (ovpn-204-105.brq.redhat.com [10.40.204.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC3705DA76;
        Tue, 10 Dec 2019 15:11:24 +0000 (UTC)
Date:   Tue, 10 Dec 2019 16:11:22 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, martin.varghese@nokia.com
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2
 tunnelling
Message-ID: <20191210161122.0c329d9b@redhat.com>
In-Reply-To: <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
References: <cover.1575964218.git.martin.varghese@nokia.com>
        <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: RVYiFS6bObOCm8eESHagJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 13:46:41 +0530, Martin Varghese wrote:
> +static int push_ptap_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> +static int ptap_pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,

The names are inconsistent (*_ptap_mpls vs. ptap_*_mpls). Otherwise,
this looks good to me.

 Jiri


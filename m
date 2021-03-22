Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780C8344D1E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhCVRTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:19:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231613AbhCVRTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616433541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cHFKi+fHX0SEO9SuLFO9X9MUQm7LZ0E0Oiw445TggAw=;
        b=IiNHXzqhiH2I32sHPtMt2bJQASwcihDi8vbdOrw0LYb4AZ0yMtcT8MhqEQDtNF5lNj8a1i
        U87oDINoJZ2p9CdLLtPQ2R27douti38oVR4kRnkvqZBnEYvx5lUfGEYJ8mMVEqZLivXvH5
        MRyeDHpswIU9EE7Gkh8EVw01OPYn4jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-6_D0YezCPVigYSu3pPbpRw-1; Mon, 22 Mar 2021 13:18:57 -0400
X-MC-Unique: 6_D0YezCPVigYSu3pPbpRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AC98CC636;
        Mon, 22 Mar 2021 17:18:55 +0000 (UTC)
Received: from ovpn-115-44.ams2.redhat.com (ovpn-115-44.ams2.redhat.com [10.36.115.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDD1C1F45A;
        Mon, 22 Mar 2021 17:18:53 +0000 (UTC)
Message-ID: <1021d3529e0390d91f6fc51cbed1e97aa9c60ab7.camel@redhat.com>
Subject: Re: [PATCH net-next 8/8] selftests: net: add UDP GRO forwarding
 self-tests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 22 Mar 2021 18:18:52 +0100
In-Reply-To: <CA+FuTSc6u_YfhTzoHPtzJSkLGMhSsDW5mWvR4-o=YB8e6ieYKQ@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <a9791dcc26e3f70858eee5d14506f8b36e747960.1616345643.git.pabeni@redhat.com>
         <CA+FuTSc6u_YfhTzoHPtzJSkLGMhSsDW5mWvR4-o=YB8e6ieYKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-22 at 09:44 -0400, Willem de Bruijn wrote:
> On Sun, Mar 21, 2021 at 1:02 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > create a bunch of virtual topology and verify that
> > GRO_FRAG_LIST and GRO_FWD aggregate the ingress
> 
> what are these constants? Aliases for SKB_GSO_FRAGLIST and ?

Well, I was inaccurate in many ways :(

I was speaking about device features, so it's really:

NETIF_F_GSO_FRAGLIST and NETIF_F_GRO_UDP_FWD

I really would love a commit message "compiler" to clarify this sort of
thing before submission;)

Thanks,

Paolo


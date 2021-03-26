Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8616E34A49A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCZJgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:36:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230372AbhCZJgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 05:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616751374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w8duIT5e1rk48mI9nnfv53pxppSc02hA2rIN3iywONM=;
        b=E3wbesbg3uv8QhI5eJGJwEyc6RKAgC+r78nFNjkirQpbCPQ5Mucb6iTI5AWFsYTLi6Mjyx
        0fVqw49jWjlptepYef9PwVcZknHm0RrzVi/HfvIALUxyXVt26TFUCMKrMUwfLfVC/o+udW
        PogJEP3zVXYv0Gh9SEAKpotdF+4iHxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-n_pU--P2P12wUI6VC2Svxg-1; Fri, 26 Mar 2021 05:36:10 -0400
X-MC-Unique: n_pU--P2P12wUI6VC2Svxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE7B107BF00;
        Fri, 26 Mar 2021 09:36:09 +0000 (UTC)
Received: from ovpn-115-44.ams2.redhat.com (ovpn-115-44.ams2.redhat.com [10.36.115.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 168E518AAB;
        Fri, 26 Mar 2021 09:36:07 +0000 (UTC)
Message-ID: <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
From:   Paolo Abeni <pabeni@redhat.com>
To:     Norman Maurer <norman.maurer@googlemail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Cc:     Norman Maurer <norman_maurer@apple.com>
Date:   Fri, 26 Mar 2021 10:36:06 +0100
In-Reply-To: <20210325195614.800687-1-norman_maurer@apple.com>
References: <20210325195614.800687-1-norman_maurer@apple.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2021-03-25 at 20:56 +0100, Norman Maurer wrote:
> From: Norman Maurer <norman_maurer@apple.com>
> 
> Support for UDP_GRO was added in the past but the implementation for
> getsockopt was missed which did lead to an error when we tried to
> retrieve the setting for UDP_GRO. This patch adds the missing switch
> case for UDP_GRO
> 
> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> Signed-off-by: Norman Maurer <norman_maurer@apple.com>

The patch LGTM, but please cc the blamed commit author in when you add
a 'Fixes' tag (me in this case ;)

Also please specify a target tree, either 'net' or 'net-next', in the
patch subj. Being declared as a fix, this should target 'net'.

One thing you can do to simplifies the maintainer's life, would be post
a v2 with the correct tag (and ev. obsolete this patch in patchwork).

Side note: I personally think this is more a new feature (is adds
getsockopt support for UDP_GRO) than a fix, so I would not have added
the 'Fixes' tag and I would have targeted net-next, but it's just my
opinion.

Cheers,

Paolo


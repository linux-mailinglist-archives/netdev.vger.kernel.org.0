Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAF627E7AE
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 13:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgI3Lbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 07:31:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgI3Lbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 07:31:52 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601465511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vJh9cm5CxoBPiw5NCAA09lqq5Wv41qFggnwj8fqtY5g=;
        b=PkGTR7AflhCzSKZdZjFf4ccXRH6heWJTEGCaWVYEY4vlS04CbMhOQd7Q+skvTnbi6TWRyl
        BrCfQtCuei6EueLcqXghgPx4kAripWIfL7Md6yPFyjTlzXBIbnU+QrOPhCiCwO8Mg8Ybb8
        1vZF1wNHH5MjD+t5RHmg0cZ61z+g3ic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-6aDlDck-Pg2yQubN2wFNCw-1; Wed, 30 Sep 2020 07:31:49 -0400
X-MC-Unique: 6aDlDck-Pg2yQubN2wFNCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 321A780BD66;
        Wed, 30 Sep 2020 11:31:48 +0000 (UTC)
Received: from ceranb (unknown [10.40.195.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2CB37FB89;
        Wed, 30 Sep 2020 11:31:46 +0000 (UTC)
Date:   Wed, 30 Sep 2020 13:31:45 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH iproute2-next 0/2] Implement filter terse dump
 mode support
Message-ID: <20200930133145.373cb94d@ceranb>
In-Reply-To: <20200930073651.31247-1-vladbu@nvidia.com>
References: <20200930073651.31247-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 10:36:49 +0300
Vlad Buslov <vladbu@nvidia.com> wrote:

> Implement support for terse dump mode which provides only essential
> classifier/action info (handle, stats, cookie, etc.). Use new
> TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
> kernel.
> 
> Vlad Buslov (2):
>   tc: skip actions that don't have options attribute when printing
>   tc: implement support for terse dump
> 
>  tc/m_bpf.c        |  2 +-
>  tc/m_connmark.c   |  2 +-
>  tc/m_csum.c       |  2 +-
>  tc/m_ct.c         |  2 +-
>  tc/m_ctinfo.c     |  2 +-
>  tc/m_gact.c       |  2 +-
>  tc/m_ife.c        |  2 +-
>  tc/m_ipt.c        |  2 +-
>  tc/m_mirred.c     |  2 +-
>  tc/m_mpls.c       |  2 +-
>  tc/m_nat.c        |  2 +-
>  tc/m_pedit.c      |  2 +-
>  tc/m_sample.c     |  2 +-
>  tc/m_simple.c     |  2 +-
>  tc/m_skbedit.c    |  2 +-
>  tc/m_skbmod.c     |  2 +-
>  tc/m_tunnel_key.c |  2 +-
>  tc/m_vlan.c       |  2 +-
>  tc/m_xt.c         |  2 +-
>  tc/m_xt_old.c     |  2 +-
>  tc/tc_filter.c    | 12 ++++++++++++
>  21 files changed, 32 insertions(+), 20 deletions(-)
> 

Tested-by: Ivan Vecera <ivecera@redhat.com>


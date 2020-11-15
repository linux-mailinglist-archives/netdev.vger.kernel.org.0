Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43562B35DB
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 16:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbgKOPqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 10:46:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726749AbgKOPqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 10:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605455211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFuIGn+EWD8tBZb3eRcFR5XzaCltuxUu20nCzvAbiCM=;
        b=AjRYM0xaUpFUfqWDFYZrlTBwX+lEzMnEL0KGMmk3eQvHqYdp9zBQknKHP/ChrRzqtVyXgS
        B9n5Xuefjq+wg55nmeenKMqFHOG/Q4ZE4kIO4kq2zX/dP9BnlcW2PFPUjLi5aUaCKWRI8H
        ONle33bxF6C8Yx3+aF6TgDbmxlE35PI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-pWhhvOW0M8aUgoTumxTb4A-1; Sun, 15 Nov 2020 10:46:47 -0500
X-MC-Unique: pWhhvOW0M8aUgoTumxTb4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C099F1868424;
        Sun, 15 Nov 2020 15:46:46 +0000 (UTC)
Received: from ovpn-112-26.ams2.redhat.com (ovpn-112-26.ams2.redhat.com [10.36.112.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1AAE21E9F;
        Sun, 15 Nov 2020 15:46:44 +0000 (UTC)
Message-ID: <19f4f533db68a3449c7f7f13734c6f776f01235f.camel@redhat.com>
Subject: Re: [PATCH net-next v2 00/13] mptcp: improve multiple xmit streams
 support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Date:   Sun, 15 Nov 2020 16:46:43 +0100
In-Reply-To: <20201114130543.426c5a60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1605199807.git.pabeni@redhat.com>
         <20201114130543.426c5a60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-14 at 13:05 -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 18:45:20 +0100 Paolo Abeni wrote:
> > This series improves MPTCP handling of multiple concurrent
> > xmit streams.
> 
> Umpf, looks like it no longer applies after the net->net-next merge.
> Please respin.

Strange: I just rebased by local tree git did not complain here. Anyhow
I'll post a v3, including the checkpatch fix on patch 1/13.

Thanks,

Paolo


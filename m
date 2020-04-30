Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1F61BF34F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgD3IqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:46:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726474AbgD3IqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588236382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XknEgfoQSOgBfAMc3h/cfEHJB9gbs/+ftzdiOAf0+6M=;
        b=OSOf6YWssxlGvnKouCNSRsDMwIo8L9fq3xyUvQvmsNrEIi/bmVjaM/JzGYYH5bPz8MM/ja
        fMj+PF3Ug1+hZm1vTyAJCl/fTZt2uW6aLpNpGzH+YPCprHeyPBrL+rcpdtyv7TUNgi6mzF
        2vq4XHMR9lywF6J2YQV/oX1e06fEr/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-QVwqdOvINKS7op3r9Sgf8A-1; Thu, 30 Apr 2020 04:46:20 -0400
X-MC-Unique: QVwqdOvINKS7op3r9Sgf8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BAFB800D24;
        Thu, 30 Apr 2020 08:46:19 +0000 (UTC)
Received: from ovpn-114-219.ams2.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38D726607E;
        Thu, 30 Apr 2020 08:46:16 +0000 (UTC)
Message-ID: <9fafae0798a3e85c161d11c87c8ddf2862f2f201.camel@redhat.com>
Subject: Re: [PATCH net] mptcp: fix uninitialized value access
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, kuba@kernel.org, mptcp@lists.01.org
Date:   Thu, 30 Apr 2020 10:46:15 +0200
In-Reply-To: <20200429.115602.466970698181251524.davem@davemloft.net>
References: <c2b96b3751ccf64357d2c6f0e7d23908dda8a601.1588157274.git.pabeni@redhat.com>
         <20200429.115602.466970698181251524.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

On Wed, 2020-04-29 at 11:56 -0700, David Miller wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Wed, 29 Apr 2020 12:50:37 +0200
> 
> > Fixes: 20882e2cb904 ("mptcp: avoid flipping mp_capable field in syn_recv_sock()")
> 
> [davem@localhost net]$ git describe 20882e2cb904
> fatal: Not a valid object name 20882e2cb904
> [davem@localhost net]$ 
> 
> Please fix this.

Thank you for double checking! 

I'm sorry, I dumbly used my local hash instead of the the '-net' one
I'll send a v2!

Cheers,

Paolo


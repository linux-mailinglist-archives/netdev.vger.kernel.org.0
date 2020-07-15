Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC98220E3D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731908AbgGONey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:34:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24103 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731785AbgGONex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594820092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aTwTLW4lRF7rnmYKZq+JqoSh+krPnIQntfpICzy4iMc=;
        b=c+Jy9LIMmskTi0TAMZPWX2vAn+xXAvHFcckMJucqKqwOgh40Sv8BR7+DnStIGcmxSEOwxy
        N2jXC9nJ4XSo7z9GAKc3sQelymZOddKuWpltoqdJB0EBygm4i/CqOw87/emr02BLXLoHQ7
        aBqETSq5scBwErzrBndXlf5/AHQ3Owg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-DoZSdfGFM3-ImZHLemk0nA-1; Wed, 15 Jul 2020 09:34:48 -0400
X-MC-Unique: DoZSdfGFM3-ImZHLemk0nA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8672F800C64;
        Wed, 15 Jul 2020 13:34:46 +0000 (UTC)
Received: from ovpn-114-12.ams2.redhat.com (ovpn-114-12.ams2.redhat.com [10.36.114.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1738572E53;
        Wed, 15 Jul 2020 13:34:43 +0000 (UTC)
Message-ID: <1fd0d82ef5e89e18c669f789a8649ea672bace31.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: Remove unused inline function
 mptcp_rcv_synsent()
From:   Paolo Abeni <pabeni@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 15 Jul 2020 15:34:42 +0200
In-Reply-To: <20200715023613.9492-1-yuehaibing@huawei.com>
References: <20200715023613.9492-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 10:36 +0800, YueHaibing wrote:
> commit 263e1201a2c3 ("mptcp: consolidate synack processing.")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

Thank you for the clean-up!

/P


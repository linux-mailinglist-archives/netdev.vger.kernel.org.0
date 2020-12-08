Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638692D2C5D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgLHN40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:56:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729572AbgLHN40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607435700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r4QSOmAtZQRXzBlAkmbOjJY9qdaS64wrTUPOrqsxjNI=;
        b=culNn5J9cRSKecYEmWbvGd2i3aj8c7cdWAcX2Owu6Nl11JFFT1xLeJBO7xjBVTxozUzUjx
        w52yI3wcB/tm81r8OTYpZw9dwPAJ9Y51S9RGsJj6WHDzdwQLdSQCQPKHYLAfGq0rU1hVig
        5ldAg1/O6jpyr3jmR+lAwfNLZfVjTLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-FaFOAWEJMa2G44VElC4VBQ-1; Tue, 08 Dec 2020 08:54:56 -0500
X-MC-Unique: FaFOAWEJMa2G44VElC4VBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 181CE107ACF6;
        Tue,  8 Dec 2020 13:54:51 +0000 (UTC)
Received: from [10.36.112.92] (ovpn-112-92.ams2.redhat.com [10.36.112.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B454060C05;
        Tue,  8 Dec 2020 13:54:49 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Zheng Yongjun" <zhengyongjun3@huawei.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: openvswitch: conntrack: simplify the return
 expression of ovs_ct_limit_get_default_limit()
Date:   Tue, 08 Dec 2020 14:54:33 +0100
Message-ID: <41DC90CB-BCB4-4F3B-9487-9ADB6DE9676F@redhat.com>
In-Reply-To: <20201208121353.9353-1-zhengyongjun3@huawei.com>
References: <20201208121353.9353-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Dec 2020, at 13:13, Zheng Yongjun wrote:

> Simplify the return expression.
>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Change looks good to me.

Reviewed-by: Eelco Chaudron <echaudro@redhat.com>


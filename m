Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88461F8860
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLGGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:06:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20288 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725795AbfKLGGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:06:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573538797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0WwqQ/IksJpRqxiZnf3aZRaAS2J4IX0Q+uD6jg8DSTI=;
        b=HzZbYRMKxzjyuhMx4jJUm/SXh/fCHlIsjEJRvdrGXWFWTu4qHQftU+pNpoaR9wLU6OBtGe
        o6ImXUJ0S5J3C6Wv1EDC0D3dYn+8t+LbOsKTlQ7Gzknz/hGjJqJWuEzEzVWh+dKk+8cFRv
        dUZ7ZOfVOkJjn3unDfEPvf+wzxt9cgg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-1Yayxy40Mr2UFHUHTmWj0g-1; Tue, 12 Nov 2019 01:06:36 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE7EB477;
        Tue, 12 Nov 2019 06:06:35 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A835B60852;
        Tue, 12 Nov 2019 06:06:34 +0000 (UTC)
Date:   Mon, 11 Nov 2019 22:06:33 -0800 (PST)
Message-Id: <20191111.220633.559233112634144943.davem@redhat.com>
To:     zhengbin13@huawei.com
Cc:     irusskikh@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: atlantic: make some symbol & function static
From:   David Miller <davem@redhat.com>
In-Reply-To: <1573478357-71751-1-git-send-email-zhengbin13@huawei.com>
References: <1573478357-71751-1-git-send-email-zhengbin13@huawei.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 1Yayxy40Mr2UFHUHTmWj0g-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You need to start properly marking your Subject lines with the target
tree your changes are indended to go into.

In this case, the code you are patching only exists in "net-next".

How in the world is a maintainer supposed to know this when reading
your changes?  You don't even bother providing Fixes: tags which
mark the commit that introduced the code being marked static either.


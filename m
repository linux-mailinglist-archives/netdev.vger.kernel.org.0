Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE2131A65
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgAFV2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:28:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59651 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726721AbgAFV23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:28:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPWlBd6wa6yfcngsHJK6kDnKQ4onnE8u9vv03fPfzuE=;
        b=G9dRUgIzm9OnGHYbF2oLJ9axryvf5kMjQS8RFXz0ry3lxDGX9U1ga5KSuEZw+BoKVB15E+
        ajfeZJCXxiLVcXhaNpuMMiK9oKBe7LsEHyDxCXdlEWAwT6YPKYbhopEMBqrlwF5MIbXUYC
        BNayw6yeykhsbhwY5EUU43/tR4jSnhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-TBZwFsWpMpa_araEL6Cqnw-1; Mon, 06 Jan 2020 16:28:25 -0500
X-MC-Unique: TBZwFsWpMpa_araEL6Cqnw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7ABB91155;
        Mon,  6 Jan 2020 21:28:23 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DC6685882;
        Mon,  6 Jan 2020 21:28:20 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:28:19 -0800 (PST)
Message-Id: <20200106.132819.1587682616661487083.davem@redhat.com>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/8] net: hns3: misc updates for -net-next
From:   David Miller <davem@redhat.com>
In-Reply-To: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
References: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sat, 4 Jan 2020 10:49:23 +0800

> This series includes some misc updates for the HNS3 ethernet driver.
> 
> [patch 1] adds trace events support.
> [patch 2] re-organizes TQP's vector handling.
> [patch 3] renames the name of TQP vector.
> [patch 4] rewrites a log in the hclge_map_ring_to_vector().
> [patch 5] modifies the name of misc IRQ vector.
> [patch 6] handles the unexpected speed 0 return from HW.
> [patch 7] replaces an unsuitable variable type.
> [patch 8] modifies an unsuitable reset level for HW error.

Series applied.


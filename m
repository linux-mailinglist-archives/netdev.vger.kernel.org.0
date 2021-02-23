Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B23322A4E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhBWMJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232814AbhBWMHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614081978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AXmk2+mTUg4QIqeN+TN2EsC2ZXa179Ma6dlqRN8DCGA=;
        b=FPBXxIBzdxk/0eE1dlNpQWcimlMXRuQBjlBa+iibs5gz8Mh49r/KucpSg+6mLT+wf/yc+2
        nC5bq+ARb2DJ64nDvAnf5hWGRZyMs2MmZ6Szk/jfF7M/W9a04e2CcQuW0+fnI5/CDOS4aH
        YM2SwyKEfzDVKOSOVh92OvPXiOi8O9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-pBLCEu-kNfG8BaaxpK_dNA-1; Tue, 23 Feb 2021 07:05:50 -0500
X-MC-Unique: pBLCEu-kNfG8BaaxpK_dNA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7423480196C;
        Tue, 23 Feb 2021 12:05:49 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-140.rdu2.redhat.com [10.10.113.140])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E876360CDE;
        Tue, 23 Feb 2021 12:05:48 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 1BF38C008C; Tue, 23 Feb 2021 09:05:47 -0300 (-03)
Date:   Tue, 23 Feb 2021 09:05:47 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net-next v2] net/sched: cls_flower: validate ct_state for
 invalid and reply flags
Message-ID: <20210223120547.GT2953@horizon.localdomain>
References: <1614064315-364-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614064315-364-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 03:11:55PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add invalid and reply flags validate in the fl_validate_ct_state.
> This makes the checking complete if compared to ovs'
> validate_ct_state().
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>


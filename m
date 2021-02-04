Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77030F6E0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhBDPxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:53:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237612AbhBDPwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 10:52:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612453866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CMqAW4f0jFDOwbsOzxUzXJ4trluBioUFTVK0D7WjA74=;
        b=Mi97tfFAiYh0nDyCm0jG6QTNZfG+6YBX134qsDDbgVhRLoGfrAI3NhbXrYn50qcLq9ej4c
        UxzoQX1RaBEVlUWaI3kGSaq0gd9ZljAt7z/D5tLJBGkURQugk9YcO0WHMNJYqjoSMS593w
        F0HG4CwFkJAejE3XbKx93DLb9PnYw9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-8vlnf59-Phu7RyeoKwEXPw-1; Thu, 04 Feb 2021 10:51:05 -0500
X-MC-Unique: 8vlnf59-Phu7RyeoKwEXPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBD96801962;
        Thu,  4 Feb 2021 15:51:03 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-166.rdu2.redhat.com [10.10.113.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8573260C16;
        Thu,  4 Feb 2021 15:51:03 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 30895C2CDA; Thu,  4 Feb 2021 12:51:01 -0300 (-03)
Date:   Thu, 4 Feb 2021 12:51:01 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     jhs@mojatatu.com, kuba@kernel.org, netdev@vger.kernel.org,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net v2] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210204155101.GK3399@horizon.localdomain>
References: <1612453571-3645-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612453571-3645-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 11:46:11PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Reject the unsupported and invalid ct_state flags of cls flower rules.
> 
> Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
> 

Hopefully Jakub can strip the blank line above.

> Signed-off-by: wenxu <wenxu@ucloud.cn>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>


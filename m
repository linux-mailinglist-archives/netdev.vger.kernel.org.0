Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD0433DC9D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240026AbhCPSd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236992AbhCPSdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615919626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ITpbXu7gO5vrUfWU7u8BFeFZf8esp0f5SO3c0eSUhOs=;
        b=VTgAp2d6EL5/dXHI74teFDbhLMI/95QZXbOFtUoRCbG4IrZyJckSX6vSUETLZgxRkoqVJ2
        zikZeRGxcsWT/CP3/4v9OEHg9/UBegGNIyYvhJskcvr06zy0ZHPkiOj16Gq4E6XZD9Dzct
        GdbDcC9SlzOQvlVUcscGCfpwkb+6SVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-S0dIh7aOMMuLZ4e775D_Pg-1; Tue, 16 Mar 2021 14:33:43 -0400
X-MC-Unique: S0dIh7aOMMuLZ4e775D_Pg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D5C9107ACCA;
        Tue, 16 Mar 2021 18:33:42 +0000 (UTC)
Received: from horizon.localdomain (ovpn-120-13.rdu2.redhat.com [10.10.120.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E7AC60875;
        Tue, 16 Mar 2021 18:33:41 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id DFA0EC0081; Tue, 16 Mar 2021 15:33:38 -0300 (-03)
Date:   Tue, 16 Mar 2021 15:33:38 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        davem@davemloft.net
Subject: Re: [PATCH net] net/sched: act_api: fix miss set post_ct for ovs
 after do conntrack in act_ct
Message-ID: <YFD6AqYbpVvaEifG@horizon.localdomain>
References: <1615883634-11064-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615883634-11064-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:33:54PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> When openvswitch conntrack offload with act_ct action. The first rule
> do conntrack in the act_ct in tc subsystem. And miss the next rule in
> the tc and fallback to the ovs datapath but miss set post_ct flag
> which will lead the ct_state_key with -trk flag.
> 
> Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Thanks for the quick fix.

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>


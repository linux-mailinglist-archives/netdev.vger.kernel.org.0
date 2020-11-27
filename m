Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543E32C6D49
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbgK0WjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732220AbgK0Who (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:37:44 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9D422228;
        Fri, 27 Nov 2020 22:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606516664;
        bh=bGrZ5KE0J1XmhQTcqOUnk3j9nFnijeXy0kJ6UuQF/2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lrzs05KLoxhDGH5VUCUodE00IuR5V8xB4JVhodO/b0V1XWkcxFT+m20wLpvfccvUE
         cBVHY5+Kq7dqReInzdONC/x2l+oXuav5SV04cIUeiJgkduOcpZoD//tp1Sc9FCnnKR
         6k35MVvUR815H2nxjK9MrC3juUwJTDtUF96LX2MI=
Date:   Fri, 27 Nov 2020 14:37:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH v4 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
Message-ID: <20201127143742.1d7a6873@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <efda6acc-0e9c-7686-40ca-4d906e585e0b@mojatatu.com>
References: <1606276883-6825-1-git-send-email-wenxu@ucloud.cn>
        <1606276883-6825-4-git-send-email-wenxu@ucloud.cn>
        <20201125111109.547c6426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpWO=vvw_iK9KaQAzEULXzUmmQWxs8xzNsXhTj3i4WcnbQ@mail.gmail.com>
        <efda6acc-0e9c-7686-40ca-4d906e585e0b@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 08:26:37 -0500 Jamal Hadi Salim wrote:
> On 2020-11-26 12:03 a.m., Cong Wang wrote:
> > On Wed, Nov 25, 2020 at 11:11 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> >>
> >> On Wed, 25 Nov 2020 12:01:23 +0800 wenxu@ucloud.cn wrote:  
> >>> From: wenxu <wenxu@ucloud.cn>
> >>>
> >>> Currently kernel tc subsystem can do conntrack in cat_ct. But when several
> >>> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> >>> will defrag the packets to a big one. But the last action will redirect
> >>> mirred to a device which maybe lead the reassembly big packet over the mtu
> >>> of target device.
> >>>
> >>> This patch add support for a xmit hook to mirred, that gets executed before
> >>> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> >>> The frag xmit hook maybe reused by other modules.
> >>>
> >>> Signed-off-by: wenxu <wenxu@ucloud.cn>  
> >>
> >> LGMT. Cong, Jamal still fine by you guys?  
> > 
> > Yes, I do not look much into detail, but overall it definitely looks good.
> > This is targeting net-next, so it is fine to fix anything we miss later.
> > 
> > Acked-by: Cong Wang <cong.wang@bytedance.com>  
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Alright, applied, thanks everyone!

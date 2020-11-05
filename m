Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B44E2A73E9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbgKEAjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387455AbgKEAjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 19:39:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9039208C7;
        Thu,  5 Nov 2020 00:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604536758;
        bh=HKfUrwCOOm+YVMDb9DwB3aatIM5qcNG7TWSKI5Ec/1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x+thY4fHcdVIPXWEIP8oytoXYaq9rpbmn5SS5BTy0RG+9tjC3jEBGbgnqPlzX0Ulu
         NSAv9/BxkgnEL7JtTzN1b/q2NQjTVcrVogMQY93e5LBMNh2b2VkwfZ7ob5GUuTjHEj
         +EK9AITKyyC04dD79OLpo6LzP6hbgbnV+TtGnfhg=
Date:   Wed, 4 Nov 2020 16:39:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     jhs@mojatatu.com, netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v2] net: sched: implement action-specific terse
 dump
Message-ID: <20201104163916.4cf9b2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102201243.287486-1-vlad@buslov.dev>
References: <20201102201243.287486-1-vlad@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 22:12:43 +0200 Vlad Buslov wrote:
> Allow user to request action terse dump with new flag value
> TCA_FLAG_TERSE_DUMP. Only output essential action info in terse dump (kind,
> stats, index and cookie, if set by the user when creating the action). This
> is different from filter terse dump where index is excluded (filter can be
> identified by its own handle).
> 
> Move tcf_action_dump_terse() function to the beginning of source file in
> order to call it from tcf_dump_walker().
> 
> Signed-off-by: Vlad Buslov <vlad@buslov.dev>
> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>

Jiri, Cong, can I get an ack?

The previous terse dump made sense because it fulfilled the need of 
an important user (OvS). IDK if this is as clear-cut, and I haven't
followed the iproute2 thread closely enough, so please weigh in.

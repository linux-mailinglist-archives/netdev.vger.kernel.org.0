Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4166423D108
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgHETzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgHEQqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:46:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354132067D;
        Wed,  5 Aug 2020 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596645955;
        bh=zvxkvbProKzS3ojSUN+j1pDyWv3dNJCflwa7fsRi/jM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oBTMLkURgOB62LoQyDUhytvO1JIrnpZ767YhFXVLJeer3ALwFMGPBdYlzzJlJtsy3
         cNq1aQdYy4BhCm7juTetlPAud1t4/xrhoEhKwRLDr3MSowW97TcVPUrcPASwm0WI8O
         NyhiRUEE1HzEnUh6F5sk5CgfMZdq+H6n48L3jqlM=
Date:   Wed, 5 Aug 2020 09:45:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     satish dhote <sdhote926@gmail.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, <daniel@iogearbox.net>
Subject: Re: Question about TC filter
Message-ID: <20200805094553.69c2c91f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
References: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Aug 2020 11:08:08 +0530 satish dhote wrote:
> Hi Team,
> 
> I have a question regarding tc filter behavior. I tried to look
> for the answer over the web and netdev FAQ but didn't get the
> answer. Hence I'm looking for your help.
> 
> I added ingress qdisc for interface enp0s25 and then configured the
> tc filter as shown below, but after adding filters I realize that
> rule is reflected as a result of both ingress and egress filter
> command?  Is this the expected behaviour? or a bug? Why should the
> same filter be reflected in both ingress and egress path?
> 
> I understand that policy is always configured for ingress traffic,
> so I believe that filters should not be reflected with egress.
> Behaviour is same when I offloaded ovs flow to the tc software
> datapath.

I feel like this was discussed and perhaps fixed by:

a7df4870d79b ("net_sched: fix tcm_parent in tc filter dump")

What's your kernel version?

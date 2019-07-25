Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A21474B77
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfGYKWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 06:22:19 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43856 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727404AbfGYKWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 06:22:19 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hqat7-0001Nt-0n; Thu, 25 Jul 2019 12:22:17 +0200
Date:   Thu, 25 Jul 2019 12:22:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190725102217.zmkpmsnyt7xnz2vu@breakpoint.cc>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> move tc indirect block to flow_offload.c. The nf_tables
> can use the indr block architecture.

... to do what?  Can you please illustrate how this is going to be
used/useful?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3384B74B7B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfGYKYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 06:24:37 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43862 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726347AbfGYKYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 06:24:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hqavK-0001OB-Oz; Thu, 25 Jul 2019 12:24:34 +0200
Date:   Thu, 25 Jul 2019 12:24:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] flow_offload: Support get tcf block
 immediately
Message-ID: <20190725102434.c72m32tpsjwf7nff@breakpoint.cc>
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
 <1564048533-27283-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564048533-27283-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> It provide a callback to find the tcf block in
> the flow_indr_block_dev_get

Can you explain why you're making this change?
This will help us understand the concept/idea of your series.

The above describes what the patch does, but it should
explain why this is callback is added.

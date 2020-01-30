Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA2E14E566
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 23:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgA3WOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgA3WOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:14:50 -0500
Received: from cakuba (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9273620707;
        Thu, 30 Jan 2020 22:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580422489;
        bh=Hh04uXBi7OcIx5ozha/taPqwFRcX5aRWOqzIboXiuHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s9ACRgpQmFHVWcx5jc0K+lNdf539SserYwTzfbdVUaTUnC72bjHFmygCrnuZfE5YA
         Fq2wn2udDI8nOuRa0iIxQqUBuI0H5aIv4+vAlGbBnR5UQ41+QE7ALfD8/n9YpQb9oa
         yxbZaXU5dQF8EM3PF6N4Qp57ZJ8F5vD3Mrf60/Ok=
Date:   Thu, 30 Jan 2020 14:14:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flowtable: fix documentation
Message-ID: <20200130141448.27fa32aa@cakuba>
In-Reply-To: <20200130191019.19440-1-mcroce@redhat.com>
References: <20200130191019.19440-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 20:10:19 +0100, Matteo Croce wrote:
> In the flowtable documentation there is a missing semicolon, the command
> as is would give this error:
> 
>     nftables.conf:5:27-33: Error: syntax error, unexpected devices, expecting newline or semicolon
>                     hook ingress priority 0 devices = { br0, pppoe-data };
>                                             ^^^^^^^
>     nftables.conf:4:12-13: Error: invalid hook (null)
>             flowtable ft {
>                       ^^
> 
> Fixes: 19b351f16fd9 ("netfilter: add flowtable documentation")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

This is netfilter so even though it's tagged as net, I'm expecting
Pablo (or Jon) to take it. Please LMK if I'm wrong.

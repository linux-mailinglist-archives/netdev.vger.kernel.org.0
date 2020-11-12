Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075EA2AFC25
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgKLBdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:33:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgKLBXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 20:23:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BF12067D;
        Thu, 12 Nov 2020 01:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605144223;
        bh=3Ucyj7rb8tFOkJkWcR1agU1q5vvYAjZ5w96QTUSQNFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iV0IydiI7qDMLHa0uv7wM5pQ3nPPoqBHQEJi2f/NuGQ+X2P1DPmTqcAzOR88sY86h
         9WbKFAJ/e7d46f6xufXtSg6aqXbl2f04ykyJiAIjqQpPHIXDa+Lm6q8eZcd/Zn6u70
         QzbJaYcAt5N9GOQEfk1XlbNJoJJKQLDJLZrKvdAw=
Date:   Wed, 11 Nov 2020 17:23:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] net: switch to the kernel.org patchwork instance
Message-ID: <20201111172342.2846c7ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110035120.642746-1-kuba@kernel.org>
References: <20201110035120.642746-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 19:51:20 -0800 Jakub Kicinski wrote:
> Move to the kernel.org patchwork instance, it has significantly
> lower latency for accessing from Europe and the US. Other quirks
> include the reply bot.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> We were in process of transitioning already before Dave had to step
> away, so after double checking with him let's complete the process.
> 
> Some patches are still pending review on ozlabs, but state of new
> ones will be updated on kernel.org.

Applied and switched over.

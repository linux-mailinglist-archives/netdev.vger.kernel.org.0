Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AFC24765A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgHQTgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730023AbgHQP2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73FB23BCD;
        Mon, 17 Aug 2020 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678124;
        bh=9Iqyaymz+Lo0omu0Cis0HQcDRg+S1yfx89/HzMiRthM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WyVA0ClVBqIXQNsVg3XMoBYW3OBlj/rRdm/v4ljIOiiFaCeoSk/Nz7EJ2CTfyaXNP
         jqdFxYNJJvFZy2RJuJTeShyXxYpZvPyO6h5/rJDjKLnJdKT5Cd2PVg8yJQhAzEusLg
         emhySQyf3DTDPDacRwvLsS9Szn8+e+NJXtGFrW0w=
Date:   Mon, 17 Aug 2020 08:28:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH net] mptcp: sendmsg: reset iter on error redux
Message-ID: <20200817082842.64aa3c36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200816211420.7337-1-fw@strlen.de>
References: <20200816211420.7337-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Aug 2020 23:14:20 +0200 Florian Westphal wrote:
> This fix wasn't correct: When this function is invoked from the
> retransmission worker, the iterator contains garbage and resetting
> it causes a crash.
> 
> As the work queue should not be performance critical also zero the
> msghdr struct.
> 
> Fixes: 35759383133f64d "(mptcp: sendmsg: reset iter on error)"
> Signed-off-by: Florian Westphal <fw@strlen.de>

Fixes tag: Fixes: 35759383133f64d "(mptcp: sendmsg: reset iter on error)"
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'

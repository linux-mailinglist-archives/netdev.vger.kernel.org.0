Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4439E221775
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 00:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGOWDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 18:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgGOWDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 18:03:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ACAC20657;
        Wed, 15 Jul 2020 22:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594850618;
        bh=fXB7l0f6ZWFmzfoL9BzAn5mG2HBQawkBRn3CF/kBjYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJcPhYXeuRWwXwftXOPSc9GNSm7M35GZRjr5Gkz0iGPkHxJzLAzHXhf/HvzPiOakH
         42cvxsahDTIUU78y/zjnhoczujYNt+ua7sxXLFAQNbegGy+KI3L98xB1n6QfIqkN4Z
         0lb5D5ZxdW+N35l12UJl7pR/c9L49IB4Y0H0bJz0=
Date:   Wed, 15 Jul 2020 15:03:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhouxudong199 <zhouxudong8@huawei.com>
Cc:     <wensong@linux-vs.org>, <horms@verge.net.au>,
        <netdev@vger.kernel.org>, <lvs-devel@vger.kernel.org>,
        <rose.chen@huawei.com>
Subject: Re: [PATCH] ipvs:clean code for ip_vs_sync.c
Message-ID: <20200715150336.711be40a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594815519-37044-1-git-send-email-zhouxudong8@huawei.com>
References: <1594815519-37044-1-git-send-email-zhouxudong8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:18:39 +0000 zhouxudong199 wrote:
> Signed-off-by:zhouxudong199 <zhouxudong8@huawei.com>

Thank you for the patch.

Please describe the changes you're making in the commit message, as far
as I can tell you're adding missing spaces?

Please read this: https://kernelnewbies.org/KernelJanitors
and make sure to CC kernel-janitors@vger.kernel.org

Please add a space after ipvs: in the subject and after Signed-off-by:

If you repost please make sure to mark the patch as v2.

> @@ -1232,7 +1232,7 @@ static void ip_vs_process_message(struct netns_ipvs *ipvs, __u8 *buffer,
>  		msg_end = buffer + sizeof(struct ip_vs_sync_mesg);
>  		nr_conns = m2->nr_conns;
>  
> -		for (i=0; i<nr_conns; i++) {
> +		for (i=0; i < nr_conns; i++) {

you should probably replace i=0 with i = 0.

>  			union ip_vs_sync_conn *s;
>  			unsigned int size;
>  			int retc;

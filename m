Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACCC483C32
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiADHYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:24:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36260 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiADHYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:24:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D745B81125;
        Tue,  4 Jan 2022 07:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EECEC36AED;
        Tue,  4 Jan 2022 07:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641281054;
        bh=CExcfHqPr4EO+0TkF9lRajV/MGP8IkIBhKsioRKlgJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LwtEYeuTK2ZpxkytTOKRUaqWkpMMM4o+NbnJg+fgvE5RMsk0De9MgjuRP3U5svnmK
         lZHifn+9L91ncs0v9SXohuIwSZyxAYKeSer+V2Ng7lnyRUel1zwci7tEqMKBwH7naI
         rdVVawrNaLtLor+PCiWtn1l7bqbmVaqBt7rpKa6IdXngDyhdrQKFqkxPQkg2uzIki0
         tf+hy7AYXg1TTs9Hhccdr/jRiHCEtD3TkbQHVqJxsgBb0N4ufXPkVq8UbWwqZ689cB
         gEnHc8nIyVO1VhY2qGPCYLCm7HHlHdV9kbCjt2tecXqlJcsBZDiG04tQH4zZFSihA5
         sgW77KGR0bIGQ==
Date:   Mon, 3 Jan 2022 23:24:11 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, leon@kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: fixup build after bpf header changes
Message-ID: <20220104072411.esukmdx7sy3milmx@sx1>
References: <20220104034827.1564167-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220104034827.1564167-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 07:48:27PM -0800, Jakub Kicinski wrote:
>Recent bpf-next merge brought in header changes which uncovered
>includes missing in net-next which were not present in bpf-next.
>Build problems happen only on less-popular arches like hppa,
>sparc, alpha etc.
>
>I could repro the build problem with ice but not the mlx5 problem
>Abdul was reporting. mlx5 does look like it should include filter.h,
>anyway.
>

I got an internal report on the same thing also, but I couldn't repro
myself neither, I will ask them to test your patch.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01E72945B2
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406118AbgJTXzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393837AbgJTXzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:55:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FFD320727;
        Tue, 20 Oct 2020 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603238137;
        bh=ZkGnD56HkbmOWraweinjEo8gVKMj5T9XMF/smRSaKp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=upmMvzm0tVOo62kOHlxppz1MtpPt6kFW2HOHjvWGUfJqhwkPfsXA34rjrPNVWIFf8
         A8tM4beIR+hWfCmuntSwZrQOL1x/cHjf5QdVOfVDWjh47STAhxcFcornJ3NhKTq5Y/
         OH9T4L4oay8k2/+MKinC35VdJI/Z4x9pXUi1J3zI=
Date:   Tue, 20 Oct 2020 16:55:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead
 of selecting it
Message-ID: <20201020165533.367acc4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1968b7a6-a553-c882-c386-4b4fde2d7a87@tessares.net>
References: <20201019113240.11516-1-geert@linux-m68k.org>
        <1968b7a6-a553-c882-c386-4b4fde2d7a87@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 17:47:20 +0200 Matthieu Baerts wrote:
> On 19/10/2020 13:32, Geert Uytterhoeven wrote:
> > MPTCP_KUNIT_TESTS selects MPTCP, thus enabling an optional feature the
> > user may not want to enable.  Fix this by making the test depend on
> > MPTCP instead.  
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thanks!

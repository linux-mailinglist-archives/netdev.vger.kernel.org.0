Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80C12AC674
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKIU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:56:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKIU4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 15:56:15 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916AB2068D;
        Mon,  9 Nov 2020 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604955375;
        bh=eiArvSZCsQ7Zw77K5aqgK0DFDd2iquV9ZDGVMRJ2jjc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NhP84zoHz91cIAzroDEpzUt9gWiFAcw2mN3Xg8Ama4Xc7pTc9gQdDUNcQLQUdo8UM
         04gQG2VWY0E9/DNLuzlAChpL/6ZENjSt0svJF/QNly8d2dLRSRCxa29sBpbxFMM1vU
         cMnUvJMqo9y2l4GJCYTvVWWQGRUF/23mtibgEYg4=
Date:   Mon, 9 Nov 2020 12:56:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net 1/2] mptcp: fix static checker warnings in
 mptcp_pm_add_timer
Message-ID: <20201109125613.63a45016@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109183419.GQ18329@kadam>
References: <cover.1604930005.git.geliangtang@gmail.com>
        <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
        <009ea5da-8a44-3ea2-1b9f-a658a09f3396@tessares.net>
        <20201109183419.GQ18329@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 21:34:19 +0300 Dan Carpenter wrote:
> Generally, I like them to be in chronological order. 

+1

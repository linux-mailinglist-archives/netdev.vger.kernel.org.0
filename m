Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460D41CB979
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgEHVIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHVIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 17:08:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1AF6217BA;
        Fri,  8 May 2020 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588972096;
        bh=vWybyM3WYurn7pmnUq4fvFPYoJ4WNiSZDceFBEUhkEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VflBLEWNWXHI6MCCF3tbomIxCLMRvySvVY04dahIEdwOFU/iC5N3FXcNBlppiMr46
         0+CPuwuVTf8f4fAWlAMennXGG78AQ14hiHx6V9h6fZotfkuVXdIxatriY2H9ykn8IQ
         UCJIuTBmurYIEbmmw29kF5CcZoQoVGKHHOrHRVXk=
Date:   Fri, 8 May 2020 14:08:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v8 3/3] net: xen: select PAGE_POOL for
 xen-netfront
Message-ID: <20200508140814.1648724b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1588855241-29141-3-git-send-email-kda@linux-powerpc.org>
References: <1588855241-29141-1-git-send-email-kda@linux-powerpc.org>
        <1588855241-29141-3-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 May 2020 15:40:41 +0300 Denis Kirjanov wrote:
> xen-netfront uses page pool API so select it in Kconfig
> 
> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>

This needs to be a part of the patch that uses page pool otherwise
build may be broken between the two patches.

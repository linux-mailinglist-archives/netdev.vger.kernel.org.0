Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4770B14F1C9
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgAaSHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:04 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 966FF20CC7;
        Fri, 31 Jan 2020 18:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494023;
        bh=fnz1fDMVYueEynEnKQw6hQZzmraPE/L5eW1D83H/zcU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i0EWKkaQHnQUfnmhyv+I8dHL6Zeu/JjmIU7ZTjr7RW9f+DB+nzrLEsirN8t1QF3Yu
         2h2xfF6khx7lE295Yv6rl3MS7UHk91r+Akc/qvxH1e/W7rEbdggADNGjLPqZx7Y+tg
         TaLJbZYfTWfAOFrbOC+KEQUjFZOypnTejmvaUB+U=
Date:   Fri, 31 Jan 2020 10:07:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 01/15] devlink: prepare to support region operations
Message-ID: <20200131100702.15b43214@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-2-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:58:56 -0800, Jacob Keller wrote:
> Modify the devlink region code in preparation for adding new operations
> on regions.
> 
> Create a devlink_region_ops structure, and move the name pointer from
> within the devlink_region structure into the ops structure (similar to
> the devlink_health_reporter_ops).
> 
> This prepares the regions to enable support of additional operations in
> the future such as requesting snapshots, or accessing the region
> directly without a snapshot.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D3F2C2F70
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404064AbgKXR7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404030AbgKXR7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 12:59:52 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4B420757;
        Tue, 24 Nov 2020 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606240791;
        bh=vsdZSzqdVCoc+V/jEJ+Zh1zOjjOy89TE4HZ99927rY8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L9UJpBrmJpE2M1/bn5hS+4WRpVNG+HjYzJ9RfA4FvMp1G9ch8Ze5zok9VqGgHuJO/
         jKEftEdIig7hp/ijw/QhVk1fb7tTRVn0LT5wXFLGhEVhc1+0UeinUU1LM+2ZvLGJU8
         auAckdfieeNgC/0uiZW9XkKo0WNY33QYI/EsZHVo=
Date:   Tue, 24 Nov 2020 09:59:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH net-next v2 1/1] ibmvnic: add some debugs
Message-ID: <20201124095949.1828b419@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124043407.2127285-1-sukadev@linux.ibm.com>
References: <20201124043407.2127285-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 20:34:07 -0800 Sukadev Bhattiprolu wrote:
> We sometimes run into situations where a soft/hard reset of the adapter
> takes a long time or fails to complete. Having additional messages that
> include important adapter state info will hopefully help understand what
> is happening, reduce the guess work and minimize requests to reproduce
> problems with debug patches.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
> 
> Changelog[v2]
> 	[Jakub Kacinski] Change an netdev_err() to netdev_info()? Changed
> 	to netdev_dbg() instead. Also sending to net rather than net-next.
> 
> 	Note: this debug patch is based on following bug fixes and a feature
> 	from Dany Madden and Lijun Pan:

In which case you need to wait for these prerequisites to be in net-next
and then repost.

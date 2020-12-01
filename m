Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED12C947A
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbgLABNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:13:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgLABNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:13:31 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98FB420857;
        Tue,  1 Dec 2020 01:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606785171;
        bh=tp9F3B7fyRvH6VEIZo3A6vSljFPz8X8qTWx7C0ahHx8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W114iU4S84WxU8Gi/8cD6d5BzTY7plgIorqvYzHc2AkjirhR204+Sd4o6IsLKfhvH
         c6SwjonuXq77BDjHMO2udssLiLB/ABsa/PAqBCudqzkwxxPr1hSsvSAOP8jv4k5hHy
         rlh/5EKOdkb/SrDm1H9kfNTCwToMfcF5WZd/dsnU=
Date:   Mon, 30 Nov 2020 17:12:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     mpe@ellerman.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, cforno12@linux.ibm.com,
        ljp@linux.vnet.ibm.com, ricklind@linux.ibm.com,
        dnbanerg@us.ibm.com, drt@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com
Subject: Re: [PATCH net v2 0/2] ibmvnic: Bug fixes for queue descriptor
 processing
Message-ID: <20201130171249.2bc0d7ba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606763244-28111-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1606763244-28111-1-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 13:07:22 -0600 Thomas Falcon wrote:
> This series resolves a few issues in the ibmvnic driver's
> RX buffer and TX completion processing. The first patch
> includes memory barriers to synchronize queue descriptor
> reads. The second patch fixes a memory leak that could
> occur if the device returns a TX completion with an error
> code in the descriptor, in which case the respective socket
> buffer and other relevant data structures may not be freed
> or updated properly.
> 
> v2: Provide more detailed comments explaining specifically what
>     reads are being ordered, suggested by Michael Ellerman

The commit hashes on fixes tags need to be at least 12 characters long,
please fix and repost.

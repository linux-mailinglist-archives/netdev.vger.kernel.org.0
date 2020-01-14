Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6A4139F5E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgANCOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729402AbgANCOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 21:14:43 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE94214AF;
        Tue, 14 Jan 2020 02:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578968083;
        bh=chxZRMXVYBEkkE8Rjq9kD6aLmpgpfTS/L2MUex0Fd1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EMFoStdy/01++VJGDEZVRDCgzgcNKxo68P4yzyhJUemj3G0KTFoOFSO/rMaSqyTjz
         15wv8h4x5Q1k6VRaHd1jmFJ4kFPN8ZXb7YmjTZ4FC13RyFghlZp66LqK3ZYtgUVrE3
         /xPjt5Y6W7wJpy1kAdnkRDQ60vb6rNORDjhmhyXY=
Date:   Mon, 13 Jan 2020 18:14:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, brouer@redhat.com
Subject: Re: [PATCH] net: mvneta: change page pool nid to NUMA_NO_NODE
Message-ID: <20200113181442.340a0726@cakuba>
In-Reply-To: <70183613cb1a0253f25709e640d88cdd0584a813.1578907338.git.lorenzo@kernel.org>
References: <70183613cb1a0253f25709e640d88cdd0584a813.1578907338.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 10:28:12 +0100, Lorenzo Bianconi wrote:
> With 'commit 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE
> condition")' we can safely change nid to NUMA_NO_NODE and accommodate
> future NUMA aware hardware using mvneta network interface
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thank you!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CDE1297B0
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLWOsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:48:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfLWOsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 09:48:10 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374B3206B7;
        Mon, 23 Dec 2019 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577112489;
        bh=y/0myjdzzuQyj9IjaHTESTVCzakf8VZwCyHUWWiuM6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kc3hDWkYY6akmCdMV5M5uG+pgu0NrNhJhFJgrGGq5wvpiloiWVmLoQZt+YBWg7GAl
         x6aOWZLSgmW/uYFgoeLL7O5PWyo3UZWnrWIwDQ3qNhzgHesTyVUQBeysQZ7n8jrqqu
         IPLrdoubZpKzuKytkGgLLFniZW+8PE+KsACmZi4E=
Date:   Mon, 23 Dec 2019 16:48:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net,v2] dpaa_eth: fix DMA mapping leak
Message-ID: <20191223144806.GA120310@unreal>
References: <1577086762-11453-1-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577086762-11453-1-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 09:39:22AM +0200, Madalin Bucur wrote:
> On the error path some fragments remain DMA mapped. Adding a fix
> that unmaps all the fragments. Rework cleanup path to be simpler.
>
> Fixes: 8151ee88bad5 ("dpaa_eth: use page backed rx buffers")

Thanks

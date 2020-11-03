Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEB22A3A14
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgKCBxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgKCBxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:53:53 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B5A21D40;
        Tue,  3 Nov 2020 01:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604368433;
        bh=jY7LgBaX2wUAguDgfzDFPE8Ogs5xuQPo75qA278FPlk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qY775nRfW0FLOFCe16+Wmmd0BqcZ0xcKjHE8g9jEfyMV9CP0Rg64lKl2rvu8s2IkP
         5o7/g2a3TCfRbZ1DtWamsRAArYdf/LYz060hrENIvTlCC6aQvFRou2fz6stL7fDFPJ
         MDWtbCMAuNKu9LEosdaUczwWYBJH9Q9XCh8cf77E=
Date:   Mon, 2 Nov 2020 17:53:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     trix@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4_core : remove unneeded semicolon
Message-ID: <20201102175351.282b296c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <78cd4150-0040-44a7-81cf-02c17d61f463@gmail.com>
References: <20201101140528.2279424-1-trix@redhat.com>
        <78cd4150-0040-44a7-81cf-02c17d61f463@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 11:31:57 +0200 Tariq Toukan wrote:
> On 11/1/2020 4:05 PM, trix@redhat.com wrote:
> > From: Tom Rix <trix@redhat.com>
> > 
> > A semicolon is not needed after a switch statement.
> > 
> > Signed-off-by: Tom Rix <trix@redhat.com>
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Applied.

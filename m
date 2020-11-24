Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5891D2C31E4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgKXU0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgKXU0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 15:26:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00C22087C;
        Tue, 24 Nov 2020 20:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606249600;
        bh=sNFhTYXi8xYWFKlFWVL5zh6EgD1Q3GcA3uFXbln+Mgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QALLezbAkTMacLYWSj37t8CuyOhIw1Htq/pSkv+LToJCc/C0+D/JAVwkLdwp8G7ml
         SXQ0j/hfaWWYX3nXJOW+dpHYc590uh71B4Hz/xTJ7lvGtK6aw6zFQLtktbOIiv5IKT
         FfU5dyzA4UFkwmMl1Bku8pYawPDrA7vdVJZpKL+M=
Date:   Tue, 24 Nov 2020 12:26:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, brouer@redhat.com, echaudro@redhat.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH net-next 0/3] mvneta: access skb_shared_info only on
 last frag
Message-ID: <20201124122639.6fa91460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1605889258.git.lorenzo@kernel.org>
References: <cover.1605889258.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 18:05:41 +0100 Lorenzo Bianconi wrote:
> Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
> skb_shared_info area only on the last fragment.
> Avoid avoid unnecessary xdp_buff initialization in mvneta_rx_swbm routine.
> This a preliminary series to complete xdp multi-buff in mvneta driver.

Looks fine, but since you need this for XDP multi-buff it should
probably go via bpf-next, right?

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

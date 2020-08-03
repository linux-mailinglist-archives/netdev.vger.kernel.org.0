Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1489223A990
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgHCPlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgHCPlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 11:41:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3715D20678;
        Mon,  3 Aug 2020 15:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596469267;
        bh=vkBCBkF4ZAHZcMpJ+bypEWZ/AlvYl3GE+TSE47hokTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V9P5zt4ff0T42yNwHk8wtCra4wrhH7MXPoXCneEMvcRqvTodILCyBxC7DhzLcBvnv
         Cn3Heov+tA4GCb1UNZZcaO/2yQQ0v2PXksGl/AedOkvO7OTbRGTW2Oqy2vWuxIWAc+
         oh3VM2tE++tmS+iFM7HQIC0IDlz9l6vw6kfwetxA=
Date:   Mon, 3 Aug 2020 08:41:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, lrizzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] gve: Fix the size used in a 'dma_free_coherent()' call
Message-ID: <20200803084106.050eb7f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200802141523.691565-1-christophe.jaillet@wanadoo.fr>
References: <20200802141523.691565-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Aug 2020 16:15:23 +0200 Christophe JAILLET wrote:
> Update the size used in 'dma_free_coherent()' in order to match the one
> used in the corresponding 'dma_alloc_coherent()'.
> 
> Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Fixes tag: Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").

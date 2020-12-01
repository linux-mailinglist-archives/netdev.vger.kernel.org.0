Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC25B2C9580
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgLADCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 22:02:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgLADB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 22:01:59 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABF6120857;
        Tue,  1 Dec 2020 03:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606791679;
        bh=JqGptGp69T17HwomoiG+wzvRAQl9EtV+ESGRXS6dE+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LiQ3juTknsKP5Q21D/scQdUMAyjBG9t8OL6lBLxrQ7loHcyWFkP8zLPpCc6YcGS5i
         fgX6J4XKddOn0h5vy2fKFY/gRg8RbENa4DwadBmPVVBCQ5X505ZFHOJzSgXh5TBI9z
         Ee8snZ87LQy214MS34ogeDrskL1Pwt8XMt4dD23Y=
Date:   Mon, 30 Nov 2020 19:01:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     khc@pm.waw.pl, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wan: remove trailing semicolon in macro definition
Message-ID: <20201130190117.2762e042@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127165734.2694693-1-trix@redhat.com>
References: <20201127165734.2694693-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 08:57:34 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

This one looks fine, applied, thanks.

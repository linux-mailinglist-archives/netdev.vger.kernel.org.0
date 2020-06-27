Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E365D20BE07
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgF0EEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgF0EEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 00:04:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27D120857;
        Sat, 27 Jun 2020 04:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593230675;
        bh=mhpv+2eyAd6eOOcY23wvPIVn5InnEAq/21NGMISIfh8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3AFMrZjb8kR7JhIAeb9eDsC74GvpjnspU3Dr153LyVEp1+3BTzREdBZw2KrFxVli
         vxBlzR+gybleYn5OTvgwhqFe6tZaeb+ZkZhbUykGHoNQVloopEXbfNUCDXWtKmqG+Y
         7LL3ANBO7NM6ri0jLAaO9Z6dJzPmSyYlyLOtuNqQ=
Date:   Fri, 26 Jun 2020 21:04:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     dan carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        netdev@vger.kernel.org, lkp@intel.com, kbuild-all@lists.01.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next] Fix unchecked dereference
Message-ID: <20200626210433.221a4936@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1079923894.37655623.1593192201005.JavaMail.zimbra@uliege.be>
References: <20200625105237.GC2549@kadam>
        <20200626085435.6627-1-justin.iurman@uliege.be>
        <20200626090125.7ae41142@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1079923894.37655623.1593192201005.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 19:23:21 +0200 (CEST) Justin Iurman wrote:
> Hi Jakub,
> 
> It is an inline modification of the patch 4 of this series. The
> modification in itself cannot be a problem. Maybe I did send it the
> wrong way?

Ah, sorry I didn't notice the threading. Please don't tag fixups like
this with [PATCH $tree], the series would need a revision.

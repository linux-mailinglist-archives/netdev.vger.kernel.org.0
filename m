Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E811798AB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCDTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:10:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgCDTKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 14:10:11 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 536EB2146E;
        Wed,  4 Mar 2020 19:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583349010;
        bh=6fS4zsNnZBy5xztfhAvQV6wDOxNIHPzrOE4jVPzKmTY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b2S8rZKy5+bRC6O7Xf8bzw/tMfcq+ki/ttL0kBkW2wo9Bmgkpihdw3D1VILqkVzo3
         7DMb6hDmJPmioLECdjmFd/fg+z6dwJLDBxhOesB6ydO43CtXyfvQMha2ABkQnS6Dvn
         +A7cq8weLASDzboALNPKqdff/MLu47hqyO0daFdw=
Date:   Wed, 4 Mar 2020 11:10:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "'bruce.w.allan@intel.com'" <bruce.w.allan@intel.com>,
        "'jeffrey.e.pieper@intel.com'" <jeffrey.e.pieper@intel.com>
Subject: Re: [PATCH net 0/1] e1000e: Stop tx/rx setup spinning for upwards
 of 300us.
Message-ID: <20200304111008.2c85f386@kicinski-fedora-PC1C0HJN>
In-Reply-To: <32fd09495d86bb2800def5b19e782a6a91a74ed9.camel@intel.com>
References: <9e23756531794a5e8b3d7aa6e0a6e8b6@AcuMS.aculab.com>
 <32fd09495d86bb2800def5b19e782a6a91a74ed9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Mar 2020 10:02:08 -0800 Jeff Kirsher wrote:
> Adding the intel-wired-lan@lists.osuosl.org mailing list, so that the
> developers you want feedback from will actually see your
> patches/questions/comments.

Is that list still moderated? I was going to CC it yesterday but 
I don't want to subject people who respond to moderation messages..

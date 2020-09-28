Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9610527B297
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgI1QwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:52:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:55712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgI1QwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 12:52:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9E792AD63;
        Mon, 28 Sep 2020 16:52:17 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4A945603A9; Mon, 28 Sep 2020 18:52:17 +0200 (CEST)
Date:   Mon, 28 Sep 2020 18:52:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v3 1/3] Add missing 400000base modes for
 dump_link_caps
Message-ID: <20200928165217.x7q7u4snwyegpoug@lion.mk-sys.cz>
References: <20200928144403.19484-1-dmurphy@ti.com>
 <20200928163744.pjajgxgbnj6apf3b@lion.mk-sys.cz>
 <a963c44f-294b-baec-65a3-2d44ed3758c0@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a963c44f-294b-baec-65a3-2d44ed3758c0@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 11:43:59AM -0500, Dan Murphy wrote:
> Michal
> 
> On 9/28/20 11:37 AM, Michal Kubecek wrote:
> > On Mon, Sep 28, 2020 at 09:44:01AM -0500, Dan Murphy wrote:
> > > Commit 63130d0b00040 ("update link mode tables") missed adding in the
> > > 400000base link_caps to the array.
> > > 
> > > Signed-off-by: Dan Murphy <dmurphy@ti.com>
> > > ---
> > I'm sorry, I only found these patches shortly after I pushed similar
> > update as I needed updated UAPI headers for new format descriptions.
> 
> Is there an action I need to take here?

I don't think so, I believe I have everything that was in your patches
(with minor diffrences) but you may want to check.

Michal

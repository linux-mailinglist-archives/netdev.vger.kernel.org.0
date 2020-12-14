Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AF32D918C
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 02:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437626AbgLNBVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 20:21:55 -0500
Received: from mail.kevlo.org ([220.134.220.36]:29088 "EHLO mail.kevlo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbgLNBVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 20:21:55 -0500
Received: from localhost (ns.kevlo.org [local])
        by ns.kevlo.org (OpenSMTPD) with ESMTPA id 9b0537a4;
        Mon, 14 Dec 2020 09:21:12 +0800 (CST)
Date:   Mon, 14 Dec 2020 09:21:12 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sasha Neftin <sasha.neftin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] igc: set the default return value to -IGC_ERR_NVM in
 igc_write_nvm_srwr
Message-ID: <20201214012112.GA84571@ns.kevlo.org>
References: <20201211143456.GA83809@ns.kevlo.org>
 <20201212140010.467d68bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212140010.467d68bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 02:00:10PM -0800, Jakub Kicinski wrote:
> 
> On Fri, 11 Dec 2020 22:34:56 +0800 Kevin Lo wrote:
> > This patch sets the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr.
> > Without this change it wouldn't lead to a shadow RAM write EEWR timeout.
> > 
> > Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> 
> This is a fix, please add a Fixes tag.
> 
> Please CC the maintainers:
> 
> M:	Jesse Brandeburg <jesse.brandeburg@intel.com>
> M:	Tony Nguyen <anthony.l.nguyen@intel.com>

I will update the Fixes tag and send V2, thanks.

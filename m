Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C37D2D8A3D
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395515AbgLLWAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLWAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:00:52 -0500
Date:   Sat, 12 Dec 2020 14:00:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607810411;
        bh=v2EUMV71aFOG8gyTFMekX+unLF26+FKKwVNwC4zsndI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=CpIlCTqH/HlPNcWID+GJtfDH3AbQY8zLjCTmFaomKO2AgG/aDYZGkoII5DT5c8LJy
         VYA2+8xHNnYa/wxJNiiuZ+Fwg2sahGzvXM7wnkFtgjZAhWCY72ae4TPwYB+mKJpMZ4
         7rhMbjax2p/sNCUK6ikFMHiEJ4MKhyyzI22OdfSJuNuoNEmK3uXLa8QPfYTeMzzXnI
         eql0mQ2Md9v9UcN89KeCRkY0PokqqKVhyIejzONhImqlHy+hz51CVFkvOTZpbP0ZIH
         /yJQSM8z42VUfH34j2A4DGupx4CtVb8CgcvwAT0ab6xduzd1J7e+m0zTHPTF4jd7zB
         9ruTPoHb8zWrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Lo <kevlo@kevlo.org>
Cc:     Sasha Neftin <sasha.neftin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] igc: set the default return value to -IGC_ERR_NVM in
 igc_write_nvm_srwr
Message-ID: <20201212140010.467d68bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211143456.GA83809@ns.kevlo.org>
References: <20201211143456.GA83809@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 22:34:56 +0800 Kevin Lo wrote:
> This patch sets the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr.
> Without this change it wouldn't lead to a shadow RAM write EEWR timeout.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

This is a fix, please add a Fixes tag.

Please CC the maintainers:

M:	Jesse Brandeburg <jesse.brandeburg@intel.com>
M:	Tony Nguyen <anthony.l.nguyen@intel.com>

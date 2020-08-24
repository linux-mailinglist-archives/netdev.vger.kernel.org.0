Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE75250A54
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgHXUzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:55:35 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58DFA2067C;
        Mon, 24 Aug 2020 20:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598302535;
        bh=wj9qWQNcGWSUCLh/edBMZ9SD7+PAOK0ViqG6Wxx+Tso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z3GKG44Flw2pGZfV6l5xZPkgsEfNSSLD1JNo2FlMEsB0y2s/uvhQy5cCFDuYVGhjI
         pUkr8Q9e0pVvns1Hq77CiXUMTZnSgByfJdUCvnocV6TO62WvJDJ3O6RjTUIASBdsax
         C3n9mHXrMzxdCth9NRwo0hUXe4CmVdjoYBuwrjS4=
Date:   Mon, 24 Aug 2020 13:55:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/7] mlxsw: Misc updates
Message-ID: <20200824135533.53e98ba0@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Aug 2020 11:06:21 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set includes various updates for mlxsw.
> 
> Patches #1-#4 adjust the default burst size of packet trap policers to
> conform to Spectrum-{2,3} requirements. The corresponding selftest is
> also adjusted so that it could reliably pass on these platforms.
> 
> Patch #5 adjusts a selftest so that it could pass with both old and new
> versions of mausezahn.
> 
> Patch #6 significantly reduces the runtime of tc-police scale test by
> changing the preference and masks of the used tc filters.
> 
> Patch #7 prevents the driver from trying to set invalid ethtool link
> modes.

LGTM, so FWIW:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

5 and 7 could have gone to net IMHO. Especially 7 - do I misinterpret
that it exposes speeds which are not in fact supported? The commit
message is not very clear on impact, and how the quoted error is
triggered.

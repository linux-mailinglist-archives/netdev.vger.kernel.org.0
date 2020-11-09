Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3472AB08D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 06:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgKIFPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 00:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgKIFPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 00:15:12 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6472120897;
        Mon,  9 Nov 2020 05:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604898912;
        bh=B+5LoD89zifUi6wF/rZ89OFlwvvrw6sY21Q9nHw4hAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vaBcXbbTiMMCta4dDaGiruGi+v9qY1kLjQdOuruqGkxA3M8o/3nBsLkpeYkuOlC4i
         eOySL5qDwbtFDz/y/+XfqqbmTFkeiY3ODAZOq73Py8xGGjqbk/E3b/xK3yyodgMk+Z
         B7r/g6mrVqEDZbLPCmCaSVM1uQgd99zYTcz5R3hA=
Date:   Mon, 9 Nov 2020 07:15:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v4 03/11] lib: json_print: Add
 print_on_off()
Message-ID: <20201109051508.GB4527@unreal>
References: <cover.1604869679.git.me@pmachata.org>
 <f9e1baac29bddcb406d41e06d8414a4b4d6bcf62.1604869679.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e1baac29bddcb406d41e06d8414a4b4d6bcf62.1604869679.git.me@pmachata.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 08, 2020 at 10:14:08PM +0100, Petr Machata wrote:
> The value of a number of booleans is shown as "on" and "off" in the plain
> output, and as an actual boolean in JSON mode. Add a function that does
> that.
>
> RDMA tool already uses a function named print_on_off(). This function
> always shows "on" and "off", even in JSON mode. Since there are probably
> very few if any consumers of this interface at this point, migrate it to
> the new central print_on_off() as well.
>
> Signed-off-by: Petr Machata <me@pmachata.org>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

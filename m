Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E1E48A6F3
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 05:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbiAKE56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 23:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiAKE55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 23:57:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF71C06173F;
        Mon, 10 Jan 2022 20:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CCA61466;
        Tue, 11 Jan 2022 04:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA32C36AEB;
        Tue, 11 Jan 2022 04:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641877076;
        bh=/BMgUbOLryFfXA/sQK2rPtkQxl8HFHbW+w7VpcQ5Yaw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FUI68OAKnflDgbKHYKZMVV6k5oc0zxdjodl61b5aNtvR7JmGL2F9CPVvaPhX13ZIf
         Lz/KpmeqSlqkgJwJvMsI/yACFeg00hhyJkUoSbS3Nk+wD5iAL95AbIAeiK+C8dAM9y
         sCpx/RIwUFEDjYOglkUVb3URaoiyDXtulI4J0AK9Q+NwbR5CV2v1Ufi4S1dbN5FlT2
         w1FlllNguEBoL0yJR8GdTiWJld2ng0fF7wU6Te/jm1cKoHHNDlrgjmoLORUSeEqAQt
         04SmIM0KpdUSdGojJOTmDCphXl+Fs60Oi8mM5f+22PaxDgCRkHZnKqXe/E+lCCW5U1
         /qOYSl5D85ybg==
Date:   Mon, 10 Jan 2022 20:57:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_tables: fix compile warnings
Message-ID: <20220110205755.5dd76c64@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110221419.60994-1-pablo@netfilter.org>
References: <20220110221419.60994-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 23:14:19 +0100 Pablo Neira Ayuso wrote:
> Remove unused variable and fix missing initialization.
> 
> >> net/netfilter/nf_tables_api.c:8266:6: warning: variable 'i' set but not used [-Wunused-but-set-variable]  
>            int i;
>                ^
> >> net/netfilter/nf_tables_api.c:8277:4: warning: variable 'data_size' is uninitialized when used here [-Wuninitialized]  
>                            data_size += sizeof(*prule) + rule->dlen;
>                            ^~~~~~~~~
>    net/netfilter/nf_tables_api.c:8262:30: note: initialize the variable 'data_size' to silence this warning
>            unsigned int size, data_size;
> 
> Fixes: 2c865a8a28a1 ("netfilter: nf_tables: add rule blob layout")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Please, directly apply to net-next, thanks. Otherwise let me know and
> I'll prepare a pull request with pending fixes once net-next gets merged
> into net.

As you have probably seen Linus fixed this up himself.

You can take the fix for the other warning thru your tree.

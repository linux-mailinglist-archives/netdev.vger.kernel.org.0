Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6812E49F5D7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiA1JCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiA1JCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:02:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3D7C061714;
        Fri, 28 Jan 2022 01:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CFA461DBD;
        Fri, 28 Jan 2022 09:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B82AC340E0;
        Fri, 28 Jan 2022 09:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643360521;
        bh=31fx5tHLJzU+vPN38r10In2ER25EqDfino7bwR2/XmQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=a7PvePT63NftL8k5FWO7EKdFJ8RTHHZCTaOZAUX4PKNCJRvnmfcwraxBYzEQ/AlC0
         N8ZgxSFEYClGxnQsX3rGbH722yPa3AaZ586WVc2gODL+Edn7dG3hErpDtWOXzL+bE5
         aBgH0d9WSd2Ni/GePyYeAx7lvNT5XYfui8KgxGfE69oCuyHeBQ8MaeoMJZYX/SZj9f
         HKhRjKu/p+sFpkT364DRGMYv2jzN7vzy0VgpwduTjP9rLhVfaeGtneo5ApEl3arqsz
         say5ThVDp1GP98YY73xdRYIFS4QX+gsK3byT0r2IrrgXzpcbpt4ib+oy1u1U/5jQFx
         +xnJyJNbZAgbQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     luciano.coelho@intel.com, davem@davemloft.net, kuba@kernel.org,
        trix@redhat.com, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] dvm: use struct_size over open coded arithmetic
References: <20220128080206.1211452-1-chi.minghao@zte.com.cn>
Date:   Fri, 28 Jan 2022 11:01:54 +0200
In-Reply-To: <20220128080206.1211452-1-chi.minghao@zte.com.cn> (cgel zte's
        message of "Fri, 28 Jan 2022 08:02:06 +0000")
Message-ID: <87o83wi67x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
>
> Replace zero-length array with flexible-array member and make use
> of the struct_size() helper in kmalloc(). For example:
>
> struct iwl_wipan_noa_data {
> 	...
> 	u8 data[];
> };
>
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
> ---
>  drivers/net/wireless/intel/iwlwifi/dvm/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

The prefix should be "iwlwifi: dvm:".

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

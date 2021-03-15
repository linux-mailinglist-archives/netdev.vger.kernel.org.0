Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4293A33C971
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCOWdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhCOWdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 18:33:12 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF13C06174A;
        Mon, 15 Mar 2021 15:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=6x00DFwVN2oFrJ92yfTSKid5GQ86PjCsN9u0Eqop0RU=; b=Z85sk+RkBTyNGShbvEZ2gdsSP/
        CXByVyWvzoZEu2Mw06d/llDZLm3f/CwJT2lVq8nFU2e1URa5NfMMEMcZrT+iNFwT/OfMHq6HP0xbG
        Rzc1523KKGkI8hCe7VDVHYBCsvW/Gahywp5BBW5ek73IkSocZ2cI1WrgPipaboUgZ7W4+LBSknvYY
        CMkpxtd5a2sDuCBsxP3JHOAzErQW+8l4D8WAeo96I982BIhcJNnzTY+Rp7fwawlckm+xOeV2j8K6e
        55GlukRdHzqEeOvNLU71jD+uDPgtBxTVHh6cWnQ0piPx2Evt8HAfoMlNL9RXQUiNtKgdLHC/e5kMk
        IE+m1JLg==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lLvlf-001NOE-Ug; Mon, 15 Mar 2021 22:33:04 +0000
Subject: Re: [PATCH v2] rsi: fix comment syntax in file headers
To:     Aditya Srivastava <yashsri421@gmail.com>, kvalo@codeaurora.org
Cc:     lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315173259.8757-1-yashsri421@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dd3c5da5-ec8e-1354-3ab9-bf4c4f90a378@infradead.org>
Date:   Mon, 15 Mar 2021 15:32:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210315173259.8757-1-yashsri421@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 10:32 AM, Aditya Srivastava wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> There are some files in drivers/net/wireless/rsi which follow this syntax
> in their file headers, i.e. start with '/**' like comments, which causes
> unexpected warnings from kernel-doc.
> 
> E.g., running scripts/kernel-doc -none on drivers/net/wireless/rsi/rsi_coex.h
> causes this warning:
> "warning: wrong kernel-doc identifier on line:
>  * Copyright (c) 2018 Redpine Signals Inc."
> 
> Similarly for other files too.
> 
> Provide a simple fix by replacing such occurrences with general comment
> format, i.e., "/*", to prevent kernel-doc from parsing it.
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> - Applies perfectly on next-20210312
> 
> Changes in v2:
> - Convert the patch series to a single patch as suggested by Lukas and Kalle
> 
>  drivers/net/wireless/rsi/rsi_boot_params.h | 2 +-
>  drivers/net/wireless/rsi/rsi_coex.h        | 2 +-
>  drivers/net/wireless/rsi/rsi_common.h      | 2 +-
>  drivers/net/wireless/rsi/rsi_debugfs.h     | 2 +-
>  drivers/net/wireless/rsi/rsi_hal.h         | 2 +-
>  drivers/net/wireless/rsi/rsi_main.h        | 2 +-
>  drivers/net/wireless/rsi/rsi_mgmt.h        | 2 +-
>  drivers/net/wireless/rsi/rsi_ps.h          | 2 +-
>  drivers/net/wireless/rsi/rsi_sdio.h        | 2 +-
>  drivers/net/wireless/rsi/rsi_usb.h         | 2 +-
>  10 files changed, 10 insertions(+), 10 deletions(-)
> 


-- 
~Randy


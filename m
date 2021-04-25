Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E821636A84A
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 18:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhDYQLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 12:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhDYQLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 12:11:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C536CC061574;
        Sun, 25 Apr 2021 09:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=l80BjQUd5fz5uENdDASp0UI526pBs9py8R3eB8Lkiqg=; b=BUW+IkJKvLhYYgAQXhetbzkmsE
        NZCjeq0MMzEy1dlKu0veAYZCaNz9KWlTbxbtzt2kDFnOp7qFCWp0NnM/LNgSoYoouiLI5OYhT2kH+
        pkojDtc/lvov2Q44QjSRi63cUxp0qyYVu2cgkI6i36RYoLc4/S4a0GLJBOUt/5mMGxbtO2V7bV5fU
        LaSsLakXiMn5tniI3fzjHIzLErno4MfbWYUsGuyrr9MnsHgG8XcGTFpJbps/Z+PwSuAWA8PJt09GZ
        gryvdXZLTMlKEYewCT6Z4ydMCqszNd/qXaWYUFHpTz42uhuDfT9GwqmV3YawJ7/xox0NLMPsuAZ0r
        /QpiDozQ==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lahKk-004Sdd-D4; Sun, 25 Apr 2021 16:10:21 +0000
Subject: Re: [PATCH v2] ipw2x00: Minor documentation update
To:     Souptick Joarder <jrdr.linux@gmail.com>, stas.yakovlev@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1619348088-6887-1-git-send-email-jrdr.linux@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <78f132c8-35f2-de23-ccd3-4f6a0ffe1052@infradead.org>
Date:   Sun, 25 Apr 2021 09:10:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1619348088-6887-1-git-send-email-jrdr.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/21 3:54 AM, Souptick Joarder wrote:
> Kernel test robot throws below warning ->
> 
> drivers/net/wireless/intel/ipw2x00/ipw2100.c:5359: warning: This comment
> starts with '/**', but isn't a kernel-doc comment. Refer
> Documentation/doc-guide/kernel-doc.rst
> 
> Minor update in documentation.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> v2:
> 	Updated docs.
> 
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> index 23fbddd..eeac9e3 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> @@ -5356,7 +5356,7 @@ struct ipw2100_wep_key {
>  #define WEP_STR_128(x) x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8],x[9],x[10]
>  
>  /**
> - * Set a the wep key
> + * ipw2100_set_key() - Set the wep key
>   *
>   * @priv: struct to work on
>   * @idx: index of the key we want to set
> 


-- 
~Randy


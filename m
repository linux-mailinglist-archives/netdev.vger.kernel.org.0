Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9465B435F77
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJUKqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhJUKqh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 06:46:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2DFF60F9E;
        Thu, 21 Oct 2021 10:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634813061;
        bh=vbuJpRdR1Y9ftvT+gumVNKtzmeeyTOR77o13lBPh1Zo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIQdI5fSnmNm/oXtI/D634OJwCxEZy07aT7JOpjQeLdwYTQdC+CXKuRXuhQRRld0K
         ILQTKYS4XaFkp6ENfDsK4NpvAbo94aopMN3z/SC0d8lPk86di5Ewkeshpq7SP+ksE3
         WBl6yH1F3ZhRgJnW/5qX1PRH3nsu0pDj9/56WO9LJYp4HZy2mySVbLW1mH9otm8ZnQ
         9mGcbU6ZyABFOrhire+dCcPu8ymC9bHXL9Yfapd+FUuXHwApsR0/sGtLdESIxWiMhM
         SKoPr2E+FR7bX5v2cxujH3IGW62mVBmhvurYsWv07Q7V6abG/adPbQr/9W7aA2Rpvp
         PKw1fmzwxEqiA==
Date:   Thu, 21 Oct 2021 12:44:17 +0200
From:   Simon Horman <horms@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] net/core: Remove unused assignment operations
 and variable
Message-ID: <20211021104412.GA26665@kernel.org>
References: <20211021064020.1047324-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021064020.1047324-1-luo.penghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 06:40:20AM +0000, luo penghao wrote:

I think the bracketed part of the subject of your emails should be:

[PATCH v2 net-next]

* IIRC this is v2 of the patch
* The patch is targeted at the net-next tree

> Although if_info_size is assigned, it has not been used. And the variable
> should also be deleted.
> 
> The clang_analyzer complains as follows:
> 
> net/core/rtnetlink.c:3806: warning:
> 
> Although the value stored to 'if_info_size' is used in the enclosing
> expression, the value is never actually read from 'if_info_size'.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>

The above not withstanding, this patch looks correct to me.

Reviewed-by: Simon Horman <horms@kernel.org>

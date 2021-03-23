Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B4F34576F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 06:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCWFn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 01:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCWFn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 01:43:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620A7C061574;
        Mon, 22 Mar 2021 22:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=KU5tJjg0JkuPFohvQIbZMhamjxuQWm3WSB+8Cf+PVgw=; b=hwej8jG8xcsaUz+VLPheFpyu8t
        yw0tCRxTW1CDjWyKg6kJFfM1wvVPktK7PavQCFZsEGen2RPLO1lAxCEwdIvw+XgwCY9YqoapyI++a
        9bqf5yq2iVZma/pBQll5IgbTSMLd+K9lFIiGRFbWbI9EYEHwO1TTCxSSqHLN1sIloxgIKGk2OPmMZ
        NX7UfniSj+t1V2yF/6TryFQ/HxsKRUYqxOd9CH37EBqEN9dk5Ha7EpgGQF/1YGd4fhNX6J/WAjz3C
        nabFdxjIZ8q3tqxxrJCrfPYS5L8mjVoxTRNmm7xLM3cwYjnd4ZooD1YwyRJ7hYeZ3p3Dhasb38Tp/
        k/1ccuSA==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOZpS-009bxj-Lh; Tue, 23 Mar 2021 05:43:49 +0000
Subject: Re: [PATCH] octeontx2-af: cn10k: Few mundane typos fixed
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210323042800.923096-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8af05747-c7c8-a0f5-cf9b-ea2326a9ceb7@infradead.org>
Date:   Mon, 22 Mar 2021 22:43:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323042800.923096-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 9:28 PM, Bhaskar Chowdhury wrote:
> 
> s/preceeds/precedes/  .....two different places
> s/rsponse/response/
> s/cetain/certain/
> s/precison/precision/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index ea456099b33c..14a184c3f6a4 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h

> @@ -277,7 +277,7 @@ struct msg_req {
>  	struct mbox_msghdr hdr;
>  };
> 
> -/* Generic rsponse msg used a ack or response for those mbox
> +/* Generic response msg used a ack or response for those mbox>   * messages which doesn't have a specific rsp msg format.
>   */

Nak, negative. ETOOMANYERRORS.
How about:

 /* Generic response msg used an ack or response for those mbox
  * messages which don't have a specific rsp msg format.
  */


The other changes look good.

-- 
~Randy


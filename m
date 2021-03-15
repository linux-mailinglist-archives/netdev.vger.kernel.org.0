Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EAB33A9AF
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 03:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhCOCmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 22:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhCOCmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 22:42:00 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4252C061574;
        Sun, 14 Mar 2021 19:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=rEfmK87HgUM3vC3FZ5xGyuF/KxJ7ferAtU0I7fgBHZY=; b=1p23JgggqbnsvT4MJOHHtgZyjy
        I6j2ZZ2K2SP434SbaoFutPYOUcgZIR5suLJDDVarpFV+rCw1T+EkSXr1P92Palp0nK9+T02OWPPoq
        y4zzbVy1yLHD5lz1aMeq/ijPvAJHjGKl3txa1EgL4Ok1QptvwzH9t49L2/0Ax8bW+wI8qpZtE9JZ9
        pIPB8toCuxgzDvuN9nh6YgnP4LSvKAS5E4R5+ccbDSrRHv4ZLAUq0fM+LkEyao1B2f+N5Szwsi7Mb
        3PQBOnqbWaOQtwMvJ/NDSQb2Bijp+FnXGJGIaj90Xk1rfFOg0CbImko6xufmR/HZHaXCnLTH2cfPc
        qk3LAdRw==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lLdAv-001FT1-65; Mon, 15 Mar 2021 02:41:53 +0000
Subject: Re: [PATCH] net: ethernet: intel: igb: Typo fix in the file
 igb_main.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20210315014847.1021209-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d397b00d-ec55-2216-3b69-776d664b4c3d@infradead.org>
Date:   Sun, 14 Mar 2021 19:41:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210315014847.1021209-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/21 6:48 PM, Bhaskar Chowdhury wrote:
> 
> s/structue/structure/
> 
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 03f78fdb0dcd..afc8ab9046a5 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3115,7 +3115,7 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
>  		return 0;
> 
>  	/* Initialize the i2c bus which is controlled by the registers.
> -	 * This bus will use the i2c_algo_bit structue that implements
> +	 * This bus will use the i2c_algo_bit structure that implements
>  	 * the protocol through toggling of the 4 bits in the register.
>  	 */
>  	adapter->i2c_adap.owner = THIS_MODULE;
> --


-- 
~Randy


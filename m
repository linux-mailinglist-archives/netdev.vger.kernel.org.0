Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E723C2EB427
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbhAEU2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbhAEU2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 15:28:11 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6E4C061574;
        Tue,  5 Jan 2021 12:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=KHPqyi/j67gzDXuYNn1fZrznHEOtYW1e4fRSuwpHiz4=; b=qQbAAkdylTZ9yi8iIaGhUZGP0N
        Ju9bESNVdh/1KvUjLE89xyAnHwVnJ3MeIl6He4w4WBgjuDzLk7y1VW2aB3oiyF356NJWH28NFV7eK
        eOo9SH9Q+/PcXrXUHI/0xol61M2NK+vuMFeBaIzP/BrY7OvPEeMpIh9CcAqiYNtdiGhj1Jm715/HL
        /L1Z86giLTic3PQTQqa0pj4jLQZIp0pMjaFqs2MPfJYrL8B0Ra5wMLV4d0IosVnu2kQ0CF8xIVrZi
        nXuTQ/9jfB8xTREYPcOXHn1ir8XpnpHcBIf8/cKjDwkr44LatMfnCMjx2nKM9P0/HX5H90GqOV7C3
        ZxgmqyWg==;
Received: from [2601:1c0:6280:3f0::64ea]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kwsvQ-0005DT-CQ; Tue, 05 Jan 2021 20:27:28 +0000
Subject: Re: [PATCH] docs: octeontx2: tune rst markup
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        George Cherian <george.cherian@marvell.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210105093553.31879-1-lukas.bulwahn@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0eb77133-947b-39c8-ee58-13b502c5ee71@infradead.org>
Date:   Tue, 5 Jan 2021 12:27:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210105093553.31879-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On 1/5/21 1:35 AM, Lukas Bulwahn wrote:
> Commit 80b9414832a1 ("docs: octeontx2: Add Documentation for NPA health
> reporters") added new documentation with improper formatting for rst, and
> caused a few new warnings for make htmldocs in octeontx2.rst:169--202.
> 
> Tune markup and formatting for better presentation in the HTML view.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> applies cleanly on current master (v5.11-rc2) and next-20201205
> 
> George, please ack.
> Jonathan, please pick this minor formatting clean-up patch.
> 
>  .../ethernet/marvell/octeontx2.rst            | 59 +++++++++++--------
>  1 file changed, 34 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> index d3fcf536d14e..00bdc10fe2b8 100644
> --- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> +++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> @@ -165,45 +165,54 @@ Devlink health reporters
>  NPA Reporters
>  -------------
>  The NPA reporters are responsible for reporting and recovering the following group of errors

Can we get a period or colon at the end of that line above, please.

> +
>  1. GENERAL events
> +
>     - Error due to operation of unmapped PF.
>     - Error due to disabled alloc/free for other HW blocks (NIX, SSO, TIM, DPI and AURA).
> +
>  2. ERROR events
> +
>     - Fault due to NPA_AQ_INST_S read or NPA_AQ_RES_S write.
>     - AQ Doorbell Error.
> +
>  3. RAS events
> +
>     - RAS Error Reporting for NPA_AQ_INST_S/NPA_AQ_RES_S.
> +
>  4. RVU events
> +
>     - Error due to unmapped slot.
>  
> -Sample Output
> --------------
> -~# devlink health
> -pci/0002:01:00.0:
> -  reporter hw_npa_intr
> -      state healthy error 2872 recover 2872 last_dump_date 2020-12-10 last_dump_time 09:39:09 grace_period 0 auto_recover true auto_dump true
> -  reporter hw_npa_gen
> -      state healthy error 2872 recover 2872 last_dump_date 2020-12-11 last_dump_time 04:43:04 grace_period 0 auto_recover true auto_dump true
> -  reporter hw_npa_err
> -      state healthy error 2871 recover 2871 last_dump_date 2020-12-10 last_dump_time 09:39:17 grace_period 0 auto_recover true auto_dump true
> -   reporter hw_npa_ras
> -      state healthy error 0 recover 0 last_dump_date 2020-12-10 last_dump_time 09:32:40 grace_period 0 auto_recover true auto_dump true
> +Sample Output::
> +
> +	~# devlink health
> +	pci/0002:01:00.0:
> +	  reporter hw_npa_intr
> +	      state healthy error 2872 recover 2872 last_dump_date 2020-12-10 last_dump_time 09:39:09 grace_period 0 auto_recover true auto_dump true
> +	  reporter hw_npa_gen
> +	      state healthy error 2872 recover 2872 last_dump_date 2020-12-11 last_dump_time 04:43:04 grace_period 0 auto_recover true auto_dump true
> +	  reporter hw_npa_err
> +	      state healthy error 2871 recover 2871 last_dump_date 2020-12-10 last_dump_time 09:39:17 grace_period 0 auto_recover true auto_dump true
> +	   reporter hw_npa_ras
> +	      state healthy error 0 recover 0 last_dump_date 2020-12-10 last_dump_time 09:32:40 grace_period 0 auto_recover true auto_dump true
>  
>  Each reporter dumps the
>   - Error Type
>   - Error Register value
>   - Reason in words
>  
> -For eg:
> -~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_gen
> - NPA_AF_GENERAL:
> -         NPA General Interrupt Reg : 1
> -         NIX0: free disabled RX
> -~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_intr
> - NPA_AF_RVU:
> -         NPA RVU Interrupt Reg : 1
> -         Unmap Slot Error
> -~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
> - NPA_AF_ERR:
> -        NPA Error Interrupt Reg : 4096
> -        AQ Doorbell Error
> +For eg::

   For example::
or
   E.g.::

> +
> +	~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_gen
> +	 NPA_AF_GENERAL:
> +	         NPA General Interrupt Reg : 1
> +	         NIX0: free disabled RX
> +	~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_intr
> +	 NPA_AF_RVU:
> +	         NPA RVU Interrupt Reg : 1
> +	         Unmap Slot Error
> +	~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
> +	 NPA_AF_ERR:
> +	        NPA Error Interrupt Reg : 4096
> +	        AQ Doorbell Error
> 


thanks.
-- 
~Randy


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339B969AF3F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjBQPOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBQPOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:14:10 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A9764B1B;
        Fri, 17 Feb 2023 07:14:05 -0800 (PST)
Received: from localhost ([103.210.49.131]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MiacR-1owAK71xRf-00flqz; Fri, 17
 Feb 2023 16:13:37 +0100
Date:   Fri, 17 Feb 2023 20:43:19 +0530
From:   Manank Patel <manank@gmx.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Message-ID: <20230217151319.ors62ekeke6gw4cy@archy>
Reply-To: 20230217102236.48789-1-alejandro.lucero-palau@amd.com
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
References: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
User-Agent: NeoMutt/20220429
X-Provags-ID: V03:K1:i0g1Tdw4sPJgoLd25Mn9fiCSDFhOa/AafFuQNMpR7ktzuKpQi+f
 xPJdvc3oeke5d/LSLQ8LtJBNAuysEzJgzSmXCVSAe6bgkhgahEYkaZ/yysPr1zTLYA5ApQ/
 Dn7til+wgzv+gHW+1gu6c1Cf1+iGAgC+Sw3Il274DTmOqB1e9ViFGnd8bW+ehaspxkSZVIx
 7mHOL+QFimKF7O1AlHA0g==
UI-OutboundReport: notjunk:1;M01:P0:C1veLkkzwOY=;H+wsqK79bFwSK7SXrN58l+sY/sz
 pK65r4p0TzBftV6bsjBZuzTH5a17JwjZVFxp7A/lKq8ZUV1J75in/EQjNFFkP60FD61/X6lpo
 rbx5HtAtWWiOwbZkMOey5dDmaDIpubBDLrEdsHHqPE+9hVTSM4Q0zUJI3Dx9vnYhwF4umlNmI
 JAMUevbcmVXCDrcdzzTz+rBrtd50ltWdz9pP5VRUTUVM89FIW/ggWycYf3f1A7bn17a3hy4Ya
 AyJIEkqErobiIJcHKhYMviZZrOVDMH69ZwSepidvq3mZ7b7nzrsfzE5aBm7C0f6BsMRYsxfW+
 7GH/i+klleaHMncGOxv9MuozoxvrCMB5poqECu2FgmDFi6xOlaJiuNldfJaPrq/kUNePnnQcc
 SIm8uMXn/jbj5fXt2WvtMo4SlRiw1xCdx5jBoGAS4/cPMGaa93g39TgIXCIKs2J10Zozve2Ea
 WyRbkpLzKO0Bo9jQcFQ3amX4Y06mRLJiM+3LAiQf4Be6uQJW5o3LvjNNmvjov7CEYypDfmYtj
 AO2YVVq3otzcyTMsS4R30XdykFIsR3cBZpkx5/5f5bV1O1y9L8mh7k1+T4+67vAep6C2p5imK
 qhVxmmE66/KTBJ6aUfAqqtVteso3lSytU7LTF6VYM96/w+ZV3feuG805G1IajV/MFk8ASk9nB
 kyQKYdnWjPYUclqQE2qc60T610rJ/eJeoOlY38TEYPkonW4I9Y3VI5xrq7ZtA2sgkiFX526rp
 AKQbDmBdezTo2ChND9wUpgsYhMnafLfZyKg4JBDBXw88UWam3Og2oLp5ZUSZtAKBs1LZSj5k/
 ARx1M0Kjw5a3xy9gT5HTKz8XGgWljAMrvEdGu4kEfRaSt5TgQKzlbRKQhURVe5t6Cvs6LWpKd
 gE9+ISfYAQP8dpYsBG+mtbi7RGR3CA3oEtKvNE+h/CfBi1+r9DWq3kpxUlf7j9rXcGgrj1+tl
 4G/VuBtg1gL0N32wLSdnuMP03wc=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/23 10:22AM, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Adding an embarrasing missing semicolon precluding kernel building
> in ia64 configs.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
> Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index d2eb6712ba35..3eb355fd4282 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_nic *efx,
>  				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
>  		rtc_time64_to_tm(tstamp, &build_date);
>  #else
> -		memset(&build_date, 0, sizeof(build_date)
> +		memset(&build_date, 0, sizeof(build_date);
                                                ^
                                It looks like there's a missing closing
                                parenthesis here.
>  #endif
>  		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
>  
> -- 
> 2.17.1
> 

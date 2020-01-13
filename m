Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB40413922D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgAMN3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:29:19 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47130 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbgAMN3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:29:19 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 22ECBB80069;
        Mon, 13 Jan 2020 13:29:18 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 13 Jan
 2020 13:29:14 +0000
Subject: Re: [PATCH] sfc/ethtool_common: Make some function to static
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        <linux-net-drivers@solarflare.com>, <ecree@solarflare.com>,
        <amaftei@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <20200113112411.28090-1-zhangxiaoxu5@huawei.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <a4e97682-1ac2-e563-af52-4889cb2e639f@solarflare.com>
Date:   Mon, 13 Jan 2020 13:29:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200113112411.28090-1-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25164.003
X-TM-AS-Result: No-13.220800-8.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTrmLzc6AOD8DfHkpkyUphL9V447DNvw38bjDtHs/gjS0siT
        Wug2C4DNl1M7KT9/aqAPkZFguLmKoUklPVZLbXaBGjzBgnFZvQ5vV3/OnMClWr2uIcc7lRe4oUx
        UliNwj582muOXUVATZi+wKzmu8Az8YlldA0POS1KKYdYQLbymTZlP7dABOvkyp7Qsc6Y097UY8Q
        zBHTnj3Hqo2Ku7FdvVWQRuvgDOtkNFTxw8RSoolRaon88GOG1auQvTYQ3D4RWXBXaJoB9JZzl/1
        fD/GopdWQy9YC5qGvz6APa9i04WGCq2rl3dzGQ1l3+bAt/YFVT5AWa3t90QZb8d4lqZQsKKGxCk
        rNw24E1MK4D2slH8hgkrYwrjkf4Y
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.220800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25164.003
X-MDID: 1578922158-uqIb8gwxvUWu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/01/2020 11:24, Zhang Xiaoxu wrote:
> Fix sparse warning:
> 
> drivers/net/ethernet/sfc/ethtool_common.c
>   warning: symbol 'efx_fill_test' was not declared. Should it be static?
>   warning: symbol 'efx_fill_loopback_test' was not declared.
>            Should it be static?
>   warning: symbol 'efx_describe_per_queue_stats' was not declared.
>            Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

Good catch. Thanks!

Reviewed-by: Martin Habets <mhabets@solarflare.com>

> ---
>  drivers/net/ethernet/sfc/ethtool_common.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
> index 3d7f75cc5cf0..b8d281ab6c7a 100644
> --- a/drivers/net/ethernet/sfc/ethtool_common.c
> +++ b/drivers/net/ethernet/sfc/ethtool_common.c
> @@ -147,9 +147,9 @@ void efx_ethtool_get_pauseparam(struct net_device *net_dev,
>   *
>   * Fill in an individual self-test entry.
>   */
> -void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
> -		   int *test, const char *unit_format, int unit_id,
> -		   const char *test_format, const char *test_id)
> +static void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
> +			  int *test, const char *unit_format, int unit_id,
> +			  const char *test_format, const char *test_id)
>  {
>  	char unit_str[ETH_GSTRING_LEN], test_str[ETH_GSTRING_LEN];
>  
> @@ -189,10 +189,11 @@ void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
>   * Fill in a block of loopback self-test entries.  Return new test
>   * index.
>   */
> -int efx_fill_loopback_test(struct efx_nic *efx,
> -			   struct efx_loopback_self_tests *lb_tests,
> -			   enum efx_loopback_mode mode,
> -			   unsigned int test_index, u8 *strings, u64 *data)
> +static int efx_fill_loopback_test(struct efx_nic *efx,
> +				  struct efx_loopback_self_tests *lb_tests,
> +				  enum efx_loopback_mode mode,
> +				  unsigned int test_index,
> +				  u8 *strings, u64 *data)
>  {
>  	struct efx_channel *channel =
>  		efx_get_channel(efx, efx->tx_channel_offset);
> @@ -293,7 +294,7 @@ int efx_ethtool_fill_self_tests(struct efx_nic *efx,
>  	return n;
>  }
>  
> -size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
> +static size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
>  {
>  	size_t n_stats = 0;
>  	struct efx_channel *channel;
> 

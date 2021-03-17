Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4133E8D2
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 06:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhCQFNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 01:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCQFNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 01:13:09 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B08C06174A;
        Tue, 16 Mar 2021 22:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=cZcEzHgW+4rcNDTh82K71mdBQTkdlVir75xxgpYjdxM=; b=NUiXTAcUBtZH434r5MP4HXE5uK
        wgEEKaMi9n3Fz1XnBkclBOkO+Sht50u9SJ4Vgr9HoXmMDnpa8xu+hI1CGvdHDJanzRo7H3Fhz8jLG
        KhKh7yMJr2vxr7r8qDRpCQAV1Eu7sPrHES/aXD6y/wfowsmv972SkrIhxWVGR0AKiCFk2CDxJTbsj
        n88YyRACAhlzF1JkbBwy0CcWy2RPzZ+9dQtrXdn2WRTX9PDbP9cAwMOVkHBznu/Qks7bN2FfGu1QA
        6KDZwhlfSX166TIyL+5+OeT4Wiyo1W0JeqMQOi9Jm0CIqrkZT1NFPCL8VLxGTcvndF19Pj00NDbAL
        HW+VrmGg==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMOUT-001bTB-6f; Wed, 17 Mar 2021 05:13:05 +0000
Subject: Re: [PATCH] wireless: intel: iwlwifi: fw: api: Absolute rudimentary
 typo fixes in the file power.h
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, gil.adam@intel.com,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317042540.4097078-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fd1ac68e-6285-582a-3b05-c11fddf8fd61@infradead.org>
Date:   Tue, 16 Mar 2021 22:13:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210317042540.4097078-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/21 9:25 PM, Bhaskar Chowdhury wrote:
> 
> s/folowing/following/
> s/Celsuis/Celsius/
> s/temerature/temperature/  ...twice
> 
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/wireless/intel/iwlwifi/fw/api/power.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
> index 798417182d54..f7c7852127d3 100644
> --- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
> +++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
> @@ -54,7 +54,7 @@ struct iwl_ltr_config_cmd_v1 {
>   * @flags: See &enum iwl_ltr_config_flags
>   * @static_long: static LTR Long register value.
>   * @static_short: static LTR Short register value.
> - * @ltr_cfg_values: LTR parameters table values (in usec) in folowing order:
> + * @ltr_cfg_values: LTR parameters table values (in usec) in following order:
>   *	TX, RX, Short Idle, Long Idle. Used only if %LTR_CFG_FLAG_UPDATE_VALUES
>   *	is set.
>   * @ltr_short_idle_timeout: LTR Short Idle timeout (in usec). Used only if
> @@ -493,7 +493,7 @@ union iwl_ppag_table_cmd {
>   *      Roaming Energy Delta Threshold, otherwise use normal Energy Delta
>   *      Threshold. Typical energy threshold is -72dBm.
>   * @bf_temp_threshold: This threshold determines the type of temperature
> - *	filtering (Slow or Fast) that is selected (Units are in Celsuis):
> + *	filtering (Slow or Fast) that is selected (Units are in Celsius):
>   *	If the current temperature is above this threshold - Fast filter
>   *	will be used, If the current temperature is below this threshold -
>   *	Slow filter will be used.
> @@ -501,12 +501,12 @@ union iwl_ppag_table_cmd {
>   *      calculated for this and the last passed beacon is greater than this
>   *      threshold. Zero value means that the temperature change is ignored for
>   *      beacon filtering; beacons will not be  forced to be sent to driver
> - *      regardless of whether its temerature has been changed.
> + *      regardless of whether its temperature has been changed.
>   * @bf_temp_slow_filter: Send Beacon to driver if delta in temperature values
>   *      calculated for this and the last passed beacon is greater than this
>   *      threshold. Zero value means that the temperature change is ignored for
>   *      beacon filtering; beacons will not be forced to be sent to driver
> - *      regardless of whether its temerature has been changed.
> + *      regardless of whether its temperature has been changed.
>   * @bf_enable_beacon_filter: 1, beacon filtering is enabled; 0, disabled.
>   * @bf_debug_flag: beacon filtering debug configuration
>   * @bf_escape_timer: Send beacons to to driver if no beacons were passed
> --


-- 
~Randy


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952194FE08B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353690AbiDLMlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356599AbiDLMkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:40:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB0F1EAD3;
        Tue, 12 Apr 2022 05:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649765081; x=1681301081;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=/eNV1t7Xj52ltUveI0mG/tPnMI4LjcEXK6Tqn8NZjBI=;
  b=BS3SkraVR4fiERYDG7R8oL6AZapqZSBPscvrJwMrrcQ0pgvV8tm6OMlQ
   dSL9KaRFw3gx1NZv6uolONGzbdffjGUxLxTD4ulF2j/SPDEIIlhd6uLMH
   lJJj2lWh5wASTEWy1+prwpY0VNaP6fGzmz0HyUEYVECywKKeh7FsLVSqf
   pdA1wCoOagfJyJtfbhG5QBMviIVYug5qwISXVGpgyZbPfrtVLKj3XDuEg
   zszLv/oGv832QJUTn5sbPkMtfH1KuW529GRwdyogOY0ULTQ8AJAO3o/Cv
   RTIZ0vF9FjEa+euqjWlyLKHKwPJWsD0z051yOXzMbUlgxJv7cxXyvW7wi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="261207431"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="261207431"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 05:04:40 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="572733083"
Received: from rsimofi-mobl1.ger.corp.intel.com ([10.252.45.1])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 05:04:34 -0700
Date:   Tue, 12 Apr 2022 15:04:31 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v6 05/13] net: wwan: t7xx: Add control port
In-Reply-To: <20220407223629.21487-6-ricardo.martinez@linux.intel.com>
Message-ID: <20ed7cce-6ba0-29fa-2cb0-89b02f31ce6f@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-6-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1937250698-1649765080=:1546"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1937250698-1649765080=:1546
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Control Port implements driver control messages such as modem-host
> handshaking, controls port enumeration, and handles exception messages.
> 
> The handshaking process between the driver and the modem happens during
> the init sequence. The process involves the exchange of a list of
> supported runtime features to make sure that modem and host are ready
> to provide proper feature lists including port enumeration. Further
> features can be enabled and controlled in this handshaking process.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

> +static int t7xx_prepare_device_rt_data(struct t7xx_sys_info *core, struct device *dev,
> +				       void *data)
> +{
> +	struct feature_query *md_feature = data;
> +	struct mtk_runtime_feature *rt_feature;
> +	unsigned int i, rt_data_len = 0;
> +	struct sk_buff *skb;
> +
> +	/* Parse MD runtime data query */
> +	if (le32_to_cpu(md_feature->head_pattern) != MD_FEATURE_QUERY_ID ||
> +	    le32_to_cpu(md_feature->tail_pattern) != MD_FEATURE_QUERY_ID) {
> +		dev_err(dev, "Invalid feature pattern: head 0x%x, tail 0x%x\n",
> +			le32_to_cpu(md_feature->head_pattern),
> +			le32_to_cpu(md_feature->tail_pattern));
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < FEATURE_COUNT; i++) {
> +		if (FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]) !=
> +		    MTK_FEATURE_MUST_BE_SUPPORTED)
> +			rt_data_len += sizeof(*rt_feature);
> +	}
> +
> +	skb = t7xx_ctrl_alloc_skb(rt_data_len);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	rt_feature  = skb_put(skb, rt_data_len);
> +	memset(rt_feature, 0, rt_data_len);
> +
> +	/* Fill runtime feature */
> +	for (i = 0; i < FEATURE_COUNT; i++) {
> +		u8 md_feature_mask = FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]);
> +
> +		if (md_feature_mask == MTK_FEATURE_MUST_BE_SUPPORTED)
> +			continue;
> +
> +		rt_feature->feature_id = i;
> +		if (md_feature_mask == MTK_FEATURE_DOES_NOT_EXIST)
> +			rt_feature->support_info = md_feature->feature_set[i];
> +
> +		rt_feature++;
> +	}
> +
> +	/* Send HS3 message to device */
> +	t7xx_port_send_ctl_skb(core->ctl_port, skb, CTL_ID_HS3_MSG, 0);
> +	return 0;
> +}
> +
> +static int t7xx_parse_host_rt_data(struct t7xx_fsm_ctl *ctl, struct t7xx_sys_info *core,
> +				   struct device *dev, void *data, int data_length)
> +{
> +	enum mtk_feature_support_type ft_spt_st, ft_spt_cfg;
> +	struct mtk_runtime_feature *rt_feature;
> +	int i, offset;
> +
> +	offset = sizeof(struct feature_query);
> +	for (i = 0; i < FEATURE_COUNT && offset < data_length; i++) {
> +		rt_feature = data + offset;
> +		offset += sizeof(*rt_feature) + le32_to_cpu(rt_feature->data_len);
> +
> +		ft_spt_cfg = FIELD_GET(FEATURE_MSK, core->feature_set[i]);
> +		if (ft_spt_cfg != MTK_FEATURE_MUST_BE_SUPPORTED)
> +			continue;

Do MTK_FEATURE_MUST_BE_SUPPORTED appear in the host rt_features
(unlike in the device rt_features)?


> +	port_count = FIELD_GET(PORT_MSG_PRT_CNT, le32_to_cpu(port_msg->info));
> +	for (i = 0; i < port_count; i++) {
> +		u32 port_info = le32_to_cpu(port_msg->data[i]);
> +		unsigned int ch_id;
> +		bool en_flag;
> +
> +		ch_id = FIELD_GET(PORT_INFO_CH_ID, port_info);
> +		en_flag = !!(port_info & PORT_INFO_ENFLG);

Unnecessary !!


-- 
 i.

--8323329-1937250698-1649765080=:1546--

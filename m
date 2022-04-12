Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A3B4FDFF9
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbiDLMOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353181AbiDLMNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:13:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F57BC5;
        Tue, 12 Apr 2022 04:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649762042; x=1681298042;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=HxLcpDKzYmNtgraWsTa61F0Kg8XuzE2JBK/xU3YbQ+U=;
  b=KyIqJt6Kb6XcNEC/XKH2OdiZgRe35yMiGsaLQ3LUddghY8U8DMqSYAn5
   j/D5ttLIoWJbGgKQYtq/qhTPgZzpZNGtbPkmc/GjdjK4GeRL2/iyVAawC
   ME2Z7pV2DxTDKkEOgwAJtyoc9uqdpwX3N1IdrwY3b/9Ka08bRjxs5Z6nm
   OAq2JaPvhuKDvyQDsQNmdOVBUlHNmdN+ZRnjsg5fFrPqYxD1RauXlSeLf
   CJ/mECsHHhZ+a3Bjk2pDn9d6BvSsmcT8LFVU883MR+nIHl8fRgWVO+exk
   FhiKEetUL0kEvBoM/1Twx3MRFeAJ+ulHiBAq/ghh93dVYi2pbLbgmjRAq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="262096760"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="262096760"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 04:14:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="572714478"
Received: from rsimofi-mobl1.ger.corp.intel.com ([10.252.45.1])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 04:13:55 -0700
Date:   Tue, 12 Apr 2022 14:13:49 +0300 (EEST)
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
Subject: Re: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy
 infrastructure
In-Reply-To: <20220407223629.21487-5-ricardo.martinez@linux.intel.com>
Message-ID: <d55b3f46-8a56-152-c934-8dae7e245a8f@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-5-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-741371815-1649762041=:1546"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-741371815-1649762041=:1546
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

This too seems fine. A few nits below.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


> +/* Reused for net TX, Data queue, same bit as RX_FULLED */
> +#define PORT_F_TX_DATA_FULLED	BIT(1)
> +#define PORT_F_TX_ACK_FULLED	BIT(8)

RX_FULLED is gone.

> +static u16 t7xx_port_next_rx_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
> +{
> +	u16 seq_num, next_seq_num;
> +	bool assert_bit;

I'd add this:
        u32 status = le32_to_cpu(ccci_h->status);

> +	seq_num = FIELD_GET(CCCI_H_SEQ_FLD, le32_to_cpu(ccci_h->status));
> +	next_seq_num = (seq_num + 1) & FIELD_MAX(CCCI_H_SEQ_FLD);
> +	assert_bit = !!(le32_to_cpu(ccci_h->status) & CCCI_H_AST_BIT);

No need for !! as assert_bit is boolean.

> +static int t7xx_proxy_alloc(struct t7xx_modem *md)
> +{
> +	unsigned int port_number = ARRAY_SIZE(t7xx_md_port_conf);

num_ports, port_count or something along those lines.

You might want to do the same rename for the port_prox->port_number too.


-- 
 i.

--8323329-741371815-1649762041=:1546--

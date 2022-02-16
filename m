Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55A04B8B8D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiBPOgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:36:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiBPOgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:36:39 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045001C904;
        Wed, 16 Feb 2022 06:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645022186; x=1676558186;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=XsD6zFAgvHDR4DIwMCXse6I94/Rx7zSk8Y2P++rWtak=;
  b=GA+kTl3j9Yrm8LAEscI9GvIBSKqRBIg66uVfBNOyT/pZdfALMRcDS9vz
   qLvD8o93oajpjeSWZD6deakEJhpXk2JOhndWQvyIXIpSfkfi3dhrU43Tx
   chzwWikhc8a/0JQcFWwm0Q0ryB0bvc6Z245GA4ygNeugZl0z8NTDTOgec
   u6wNMROEe/EZEPcylCzTDHz3S5rM/9SN5eCDYFPQCIJDahLsEnX/CU3IE
   WCYvlJoXlzUBf410iDMtv+FKFkzAC4CsWq936t7BGW/ZqCsb8qPMOlpyx
   8dzkFfSg9NeEv7aM/AeF33X87Z1/EnFIcuWVL6SAZzOYgnurXKePjj7G8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="249445136"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="249445136"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 06:36:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="529488930"
Received: from unknown (HELO ijarvine-MOBL2.mshome.net) ([10.237.66.33])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 06:36:19 -0800
Date:   Wed, 16 Feb 2022 16:36:16 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
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
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 08/13] net: wwan: t7xx: Add data path
 interface
In-Reply-To: <05b6a2dd-f485-ce4a-d508-e90f9304d016@linux.intel.com>
Message-ID: <92a244ef-eaf8-6e27-aa9-77e8f941b86@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-9-ricardo.martinez@linux.intel.com> <ca592f64-c581-56a8-8d90-5341ebd8932d@linux.intel.com> <05b6a2dd-f485-ce4a-d508-e90f9304d016@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1525069745-1645022185=:9418"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

--8323329-1525069745-1645022185=:9418
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 15 Feb 2022, Martinez, Ricardo wrote:
> On 2/8/2022 12:19 AM, Ilpo Järvinen wrote:
> > On Thu, 13 Jan 2022, Ricardo Martinez wrote:
> > 
> > > +/* SKB control buffer indexed values */
> > > +#define TX_CB_NETIF_IDX		0
> > > +#define TX_CB_QTYPE		1
> > > +#define TX_CB_DRB_CNT		2
> > The normal way of storing a struct to skb->cb area is:
> > 
> > struct t7xx_skb_cb {
> > 	u8	netif_idx;
> > 	u8	qtype;
> > 	u8	drb_cnt;
> > };
> > 
> > #define T7XX_SKB_CB(__skb)	((struct t7xx_skb_cb *)&((__skb)->cb[0]))
> > 
> > However, there's only a single txqt/qtype (TXQ_TYPE_DEFAULT) in the
> > patchset? And it seems to me that drb_cnt is a value that could be always
> > derived using t7xx_get_drb_cnt_per_skb() from the skb rather than
> > stored?
> 
> The next iteration will contain t7xx_tx_skb_cb and t7xx_rx_skb_cb structures.

Ah, I didn't even notice the other one. Why differentiate them? There's 
enough space in cb area and netif_idx is in both anyway. (union inside 
struct could be used if short on space and tx/rx differ but it is not 
needed here now.)

> Also, q_number is going to be used instead of qtype.
> 
> Only one queue is used but I think we can keep this code generic as it is
> straight forward (not like the drb_lack case), any thoughts?

I don't mind if you find it useful.


-- 
 i.

--8323329-1525069745-1645022185=:9418--

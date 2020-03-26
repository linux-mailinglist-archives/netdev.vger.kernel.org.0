Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CEA193A9A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 09:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgCZIQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 04:16:30 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:39990 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727919AbgCZIQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 04:16:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 74954182CED5B;
        Thu, 26 Mar 2020 08:16:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3865:3866:3868:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:7688:8957:9025:10004:10400:10471:10848:11026:11232:11658:11914:12043:12296:12297:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:14775:21080:21627:30054:30055:30060:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: cart64_548b3b72c1009
X-Filterd-Recvd-Size: 1972
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Thu, 26 Mar 2020 08:16:20 +0000 (UTC)
Message-ID: <0cb96a93000c02e4c4816c64492afef10bc76fd9.camel@perches.com>
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Joe Perches <joe@perches.com>
To:     Miao-chen Chou <mcchou@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 26 Mar 2020 01:14:29 -0700
In-Reply-To: <20200326005931.v3.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
References: <20200326075938.65053-1-mcchou@chromium.org>
         <20200326005931.v3.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-26 at 00:59 -0700, Miao-chen Chou wrote:
> This adds a bit mask of driver_info for Microsoft vendor extension and
> indicates the support for Intel 9460/9560 and 9160/9260. See
> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> microsoft-defined-bluetooth-hci-commands-and-events for more information
> about the extension. This was verified with Intel ThunderPeak BT controller
> where msft_vnd_ext_opcode is 0xFC1E.
[]
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
[]
> @@ -414,6 +414,8 @@ struct hci_dev {
>  	void			*smp_data;
>  	void			*smp_bredr_data;
>  
> +	void			*msft_ext;

Why should this be a void * and not a msft_vnd_ext * ?



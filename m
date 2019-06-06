Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F4D37F54
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfFFVP7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 17:15:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:61371 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbfFFVP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:15:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 14:15:58 -0700
X-ExtLoop1: 1
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2019 14:15:57 -0700
Received: from orsmsx160.amr.corp.intel.com (10.22.226.43) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 6 Jun 2019 14:15:57 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.229]) by
 ORSMSX160.amr.corp.intel.com ([169.254.13.124]) with mapi id 14.03.0415.000;
 Thu, 6 Jun 2019 14:15:57 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v1 1/6] Kernel header update for
 hardware offloading changes.
Thread-Topic: [PATCH iproute2 net-next v1 1/6] Kernel header update for
 hardware offloading changes.
Thread-Index: AQHVHJCek9I7oduoxES1KSwbYlAKaaaPlkeA
Date:   Thu, 6 Jun 2019 21:15:57 +0000
Message-ID: <519A1AB1-5165-4B4A-A026-33CB4B0AE47B@intel.com>
References: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
In-Reply-To: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.182]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40A2F82568FDE24CB85BFCABD01B426D@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like I sent out the wrong version of this series.  Another version coming in momentarily. 

Sorry for the spam.

-Vedang

> On Jun 6, 2019, at 10:52 AM, Patel, Vedang <vedang.patel@intel.com> wrote:
> 
> This should only be updated after the kernel patches related to txtime-offload
> have been merged into the kernel.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
> include/uapi/linux/pkt_sched.h | 3 +++
> 1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 8b2f993c..16b18868 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -990,6 +990,7 @@ struct tc_etf_qopt {
> 	__u32 flags;
> #define TC_ETF_DEADLINE_MODE_ON	BIT(0)
> #define TC_ETF_OFFLOAD_ON	BIT(1)
> +#define TC_ETF_SKIP_SKB_CHECK   BIT(2)
> };
> 
> enum {
> @@ -1169,6 +1170,8 @@ enum {
> 	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
> +	TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, /* u32 */
> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
> 	__TCA_TAPRIO_ATTR_MAX,
> };
> 
> -- 
> 2.17.0
> 


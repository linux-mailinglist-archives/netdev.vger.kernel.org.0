Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7CB69B8E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 21:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbfGOTkW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Jul 2019 15:40:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:62362 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729948AbfGOTkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 15:40:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 12:40:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,494,1557212400"; 
   d="scan'208";a="187176797"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jul 2019 12:40:21 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jul 2019 12:40:20 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.139]) with mapi id 14.03.0439.000;
 Mon, 15 Jul 2019 12:40:20 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v2 1/6] Kernel header update for
 hardware offloading changes.
Thread-Topic: [PATCH iproute2 net-next v2 1/6] Kernel header update for
 hardware offloading changes.
Thread-Index: AQHVHLZawMzre0Bl50KXhj1a6LTj8abMxi6A
Date:   Mon, 15 Jul 2019 19:40:19 +0000
Message-ID: <0AFDC65C-2A16-47B7-96F6-F6844AF75095@intel.com>
References: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
In-Reply-To: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.11.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A39362D5B6DF14EB0187936E8CE41EE@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen, 

The kernel patches corresponding to this series have been merged. I just wanted to check whether these iproute2 related patches are on your TODO list.

Let me know if you need any information from me on these patches.

Thanks,
Vedang Patel
> On Jun 6, 2019, at 3:22 PM, Patel, Vedang <vedang.patel@intel.com> wrote:
> 
> This should only be updated after the kernel patches related to
> txtime-offload have been merged into the kernel.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
> include/uapi/linux/pkt_sched.h | 5 +++++
> 1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 8b2f993cbb77..c085860ff637 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -990,6 +990,7 @@ struct tc_etf_qopt {
> 	__u32 flags;
> #define TC_ETF_DEADLINE_MODE_ON	BIT(0)
> #define TC_ETF_OFFLOAD_ON	BIT(1)
> +#define TC_ETF_SKIP_SOCK_CHECK  BIT(2)
> };
> 
> enum {
> @@ -1158,6 +1159,8 @@ enum {
>  *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
>  */
> 
> +#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST 0x1
> +
> enum {
> 	TCA_TAPRIO_ATTR_UNSPEC,
> 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
> @@ -1169,6 +1172,8 @@ enum {
> 	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
> +	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
> 	__TCA_TAPRIO_ATTR_MAX,
> };
> 
> -- 
> 2.7.3
> 


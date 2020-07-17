Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528E2223D21
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgGQNn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:43:26 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:62999 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgGQNn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 09:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594993406; x=1626529406;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+RwbdX8eTiYt5tWOZI5oVIrx/wtRcrR8fHZUUHWMMGs=;
  b=I29+Es9ZHvyEPqiOS9WFirIIPviCcuORkWJ46+zgVRpcJezwQezRDFjG
   MM5sfeij3dNJJpv5GqL8gCZWbl2IS/Srf3jx3EF1Vvpcbxb/lYxyj8xfe
   6AWDCrwbRH0uBk4qu07Ot9ppgglM3MGgQlimYxYE4SA95ONxYfrauRXKG
   FyWVt92eEriaa02Zw3SU9R8WBnuTJbU2IhWAopshpTg5PhfE2L8rWEQwz
   7M5YR9c4vj/r7w8Rol2SXIy8HLCHhxRPrRCvRfKxudjLvsFqAM/aqmqa6
   q7Ubh5AuexcYkie+keIwJsnqYwMn/cWfq20AeE48XQvE7+Ah9MsZzUJgr
   Q==;
IronPort-SDR: GIWochLUvHOvEBP8fp7HS6gDHx2U9jNnOZIjk50e4uYjweL+kOAETltAq/A4q7m1KuMXt37rzd
 icWJnFI50OWd0oVJnyDXc5BxvS1beRvcEXtAelF3Sy5LRVf510P513V4NIqUMigUIKsbM2ejBu
 WemFaeKLyEfd8vx6veBQyJ13Lzzr4bZRcPUGeO7LYBr83a44BSWN6DKPFnEC84U6VaGd1zYWiQ
 o2VCNaohHK9lpPsKc3NAhoY9ZJAewPCF2jYuMfMpOvT/V+omGCYdjIDNMypt7E/S2Xy5yeBJbP
 IRY=
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="83589532"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jul 2020 06:43:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 06:43:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 17 Jul 2020 06:42:48 -0700
Date:   Fri, 17 Jul 2020 15:43:23 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <richardcochran@gmail.com>, <jacob.e.keller@intel.com>,
        <yangbo.lu@nxp.com>, <xiaoliang.yang_1@nxp.com>, <po.liu@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2 net-next 3/3] net: mscc: ocelot: add support for PTP
 waveform configuration
Message-ID: <20200717134323.bmfm3vna6vfaqweq@soft-dev3.localdomain>
References: <20200716224531.1040140-1-olteanv@gmail.com>
 <20200716224531.1040140-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200716224531.1040140-4-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/17/2020 01:45, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> For PPS output (perout period is 1.000000000), accept the new "phase"
> parameter from the periodic output request structure.
> 
> For both PPS and freeform output, accept the new "on" argument for
> specifying the duty cycle of the generated signal. Preserve the old
> defaults for this "on" time: 1 us for PPS, and half the period for
> freeform output.
> 
> Also preserve the old behavior that accepted the "phase" via the "start"
> argument.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Changes in v2:
> Made sure it applies to net-next.
> 
>  drivers/net/ethernet/mscc/ocelot_ptp.c | 74 +++++++++++++++++---------
>  1 file changed, 50 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
> index a3088a1676ed..1e08fe4daaef 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ptp.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
> @@ -184,18 +184,20 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>                       struct ptp_clock_request *rq, int on)
>  {
>         struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
> -       struct timespec64 ts_start, ts_period;
> +       struct timespec64 ts_phase, ts_period;
>         enum ocelot_ptp_pins ptp_pin;
>         unsigned long flags;
>         bool pps = false;
>         int pin = -1;
> +       s64 wf_high;
> +       s64 wf_low;
>         u32 val;
> -       s64 ns;
> 
>         switch (rq->type) {
>         case PTP_CLK_REQ_PEROUT:
>                 /* Reject requests with unsupported flags */
> -               if (rq->perout.flags)
> +               if (rq->perout.flags & ~(PTP_PEROUT_DUTY_CYCLE |
> +                                        PTP_PEROUT_PHASE))
>                         return -EOPNOTSUPP;
> 
>                 pin = ptp_find_pin(ocelot->ptp_clock, PTP_PF_PEROUT,
> @@ -211,22 +213,12 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>                 else
>                         return -EBUSY;
> 
> -               ts_start.tv_sec = rq->perout.start.sec;
> -               ts_start.tv_nsec = rq->perout.start.nsec;
>                 ts_period.tv_sec = rq->perout.period.sec;
>                 ts_period.tv_nsec = rq->perout.period.nsec;
> 
>                 if (ts_period.tv_sec == 1 && ts_period.tv_nsec == 0)
>                         pps = true;
> 
> -               if (ts_start.tv_sec || (ts_start.tv_nsec && !pps)) {
> -                       dev_warn(ocelot->dev,
> -                                "Absolute start time not supported!\n");
> -                       dev_warn(ocelot->dev,
> -                                "Accept nsec for PPS phase adjustment, otherwise start time should be 0 0.\n");
> -                       return -EINVAL;
> -               }
> -
>                 /* Handle turning off */
>                 if (!on) {
>                         spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
> @@ -236,16 +228,48 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>                         break;
>                 }
> 
> +               if (rq->perout.flags & PTP_PEROUT_PHASE) {
> +                       ts_phase.tv_sec = rq->perout.phase.sec;
> +                       ts_phase.tv_nsec = rq->perout.phase.nsec;
> +               } else {
> +                       /* Compatibility */
> +                       ts_phase.tv_sec = rq->perout.start.sec;
> +                       ts_phase.tv_nsec = rq->perout.start.nsec;
> +               }
> +               if (ts_phase.tv_sec || (ts_phase.tv_nsec && !pps)) {
> +                       dev_warn(ocelot->dev,
> +                                "Absolute start time not supported!\n");
> +                       dev_warn(ocelot->dev,
> +                                "Accept nsec for PPS phase adjustment, otherwise start time should be 0 0.\n");
> +                       return -EINVAL;
> +               }
> +
> +               /* Calculate waveform high and low times */
> +               if (rq->perout.flags & PTP_PEROUT_DUTY_CYCLE) {
> +                       struct timespec64 ts_on;
> +
> +                       ts_on.tv_sec = rq->perout.on.sec;
> +                       ts_on.tv_nsec = rq->perout.on.nsec;
> +
> +                       wf_high = timespec64_to_ns(&ts_on);
> +               } else {
> +                       if (pps) {
> +                               wf_high = 1000;
> +                       } else {
> +                               wf_high = timespec64_to_ns(&ts_period);
> +                               wf_high = div_s64(wf_high, 2);
> +                       }
> +               }
> +
> +               wf_low = timespec64_to_ns(&ts_period);
> +               wf_low -= wf_high;
> +
>                 /* Handle PPS request */
>                 if (pps) {
>                         spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
> -                       /* Pulse generated perout.start.nsec after TOD has
> -                        * increased seconds.
> -                        * Pulse width is set to 1us.
> -                        */
> -                       ocelot_write_rix(ocelot, ts_start.tv_nsec,
> +                       ocelot_write_rix(ocelot, ts_phase.tv_nsec,
>                                          PTP_PIN_WF_LOW_PERIOD, ptp_pin);
> -                       ocelot_write_rix(ocelot, 1000,
> +                       ocelot_write_rix(ocelot, wf_high,
>                                          PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
>                         val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
>                         val |= PTP_PIN_CFG_SYNC;
> @@ -255,14 +279,16 @@ int ocelot_ptp_enable(struct ptp_clock_info *ptp,
>                 }
> 
>                 /* Handle periodic clock */
> -               ns = timespec64_to_ns(&ts_period);
> -               ns = ns >> 1;
> -               if (ns > 0x3fffffff || ns <= 0x6)
> +               if (wf_high > 0x3fffffff || wf_high <= 0x6)
> +                       return -EINVAL;
> +               if (wf_low > 0x3fffffff || wf_low <= 0x6)
>                         return -EINVAL;
> 
>                 spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
> -               ocelot_write_rix(ocelot, ns, PTP_PIN_WF_LOW_PERIOD, ptp_pin);
> -               ocelot_write_rix(ocelot, ns, PTP_PIN_WF_HIGH_PERIOD, ptp_pin);
> +               ocelot_write_rix(ocelot, wf_low, PTP_PIN_WF_LOW_PERIOD,
> +                                ptp_pin);
> +               ocelot_write_rix(ocelot, wf_high, PTP_PIN_WF_HIGH_PERIOD,
> +                                ptp_pin);
>                 val = PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK);
>                 ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ptp_pin);
>                 spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
> --
> 2.25.1
> 

-- 
/Horatiu

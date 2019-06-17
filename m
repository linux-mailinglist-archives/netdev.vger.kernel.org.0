Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E527947D80
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfFQIri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:47:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:10238 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfFQIrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:47:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 01:47:37 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2019 01:47:32 -0700
Subject: Re: [PATCH v4 4/5] mmc: core: Add sdio_retune_hold_now() and
 sdio_retune_release()
To:     Doug Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>
References: <20190613234153.59309-1-dianders@chromium.org>
 <20190613234153.59309-5-dianders@chromium.org>
 <CAPDyKFrJ4+zn7Ak0tYHkBfXUtH3N7erb5R7Q+hgugchZmCRGrw@mail.gmail.com>
 <CAD=FV=Wuj=gANR2im_o4ZnoLEB+U6FqzKe4noLdQyi1vw+K2xw@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <d5ce23c7-d6b2-87ea-c659-29ffc977bfad@intel.com>
Date:   Mon, 17 Jun 2019 11:46:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Wuj=gANR2im_o4ZnoLEB+U6FqzKe4noLdQyi1vw+K2xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/19 7:38 PM, Doug Anderson wrote:
> Hi,
> 
> On Fri, Jun 14, 2019 at 5:10 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>
>> On Fri, 14 Jun 2019 at 01:42, Douglas Anderson <dianders@chromium.org> wrote:
>>>
>>> We want SDIO drivers to be able to temporarily stop retuning when the
>>> driver knows that the SDIO card is not in a state where retuning will
>>> work (maybe because the card is asleep).  We'll move the relevant
>>> functions to a place where drivers can call them.
>>>
>>> Signed-off-by: Douglas Anderson <dianders@chromium.org>
>>
>> This looks good to me.
>>
>> BTW, seems like this series is best funneled via my mmc tree, no? In
>> such case, I need acks for the brcmfmac driver patches.
> 
> For patch #1 I think it could just go in directly to the wireless
> tree.  It should be fine to land the rest of the patches separately.
> 
> For patch #2 - #5 then what you say makes sense to me.  I suppose
> you'd want at least a Reviewed-by from Arend and an Ack from Kalle on
> the Broadcom patches?
> 
> I'd also suggest that we Cc stable explicitly when applying.  That's
> easy for #2 and #3 since they have a Fixes tag.  For #4 and #5 I guess
> the question is how far back to go.  Maybe Adrian has an opinion here
> since I think he's the one who experienced these problems.

V4 seemed to apply cleanly back to v4.18

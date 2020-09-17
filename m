Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E7526E666
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgIQUNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:13:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:53012 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgIQUNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:13:05 -0400
IronPort-SDR: 6NcDcHpEBwhr8VOv1k3Lh6PgyvKzREsYwRuPmAcUHyuQT6ViTiexV1qtSsvh9e7zRr7L79hxgP
 J31VvyiHyb6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159837579"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="159837579"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:38:50 -0700
IronPort-SDR: qOFT4YCavFprCinb1Z7vOpnv+nojsFy+dMEenB4inym9YEVU2o7veUxWiIinutWVoS57vSlDEb
 KdeOHM92ijFw==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483882376"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.151.155]) ([10.212.151.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:38:50 -0700
Subject: Re: [PATCH] ptp: mark symbols static where possible
To:     Leon Romanovsky <leonro@nvidia.com>,
        Herrington <hankinsea@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200917022508.9732-1-hankinsea@gmail.com>
 <20200917071605.GQ486552@unreal>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <d5c82022-79ed-6768-2dc7-d5d5bb7f53f6@intel.com>
Date:   Thu, 17 Sep 2020 12:38:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917071605.GQ486552@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 12:16 AM, Leon Romanovsky wrote:
> On Thu, Sep 17, 2020 at 10:25:08AM +0800, Herrington wrote:
>> We get 1 warning when building kernel with W=1:
>> drivers/ptp/ptp_pch.c:182:5: warning: no previous prototype for ‘pch_ch_control_read’ [-Wmissing-prototypes]
>>  u32 pch_ch_control_read(struct pci_dev *pdev)
>> drivers/ptp/ptp_pch.c:193:6: warning: no previous prototype for ‘pch_ch_control_write’ [-Wmissing-prototypes]
>>  void pch_ch_control_write(struct pci_dev *pdev, u32 val)
>> drivers/ptp/ptp_pch.c:201:5: warning: no previous prototype for ‘pch_ch_event_read’ [-Wmissing-prototypes]
>>  u32 pch_ch_event_read(struct pci_dev *pdev)
>> drivers/ptp/ptp_pch.c:212:6: warning: no previous prototype for ‘pch_ch_event_write’ [-Wmissing-prototypes]
>>  void pch_ch_event_write(struct pci_dev *pdev, u32 val)
>> drivers/ptp/ptp_pch.c:220:5: warning: no previous prototype for ‘pch_src_uuid_lo_read’ [-Wmissing-prototypes]
>>  u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
>> drivers/ptp/ptp_pch.c:231:5: warning: no previous prototype for ‘pch_src_uuid_hi_read’ [-Wmissing-prototypes]
>>  u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
>> drivers/ptp/ptp_pch.c:242:5: warning: no previous prototype for ‘pch_rx_snap_read’ [-Wmissing-prototypes]
>>  u64 pch_rx_snap_read(struct pci_dev *pdev)
>> drivers/ptp/ptp_pch.c:259:5: warning: no previous prototype for ‘pch_tx_snap_read’ [-Wmissing-prototypes]
>>  u64 pch_tx_snap_read(struct pci_dev *pdev)
>> drivers/ptp/ptp_pch.c:300:5: warning: no previous prototype for ‘pch_set_station_address’ [-Wmissing-prototypes]
>>  int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
>>
>> Signed-off-by: Herrington <hankinsea@gmail.com>
>> ---
>>  drivers/ptp/ptp_pch.c | 18 +++++++++---------
>>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> This file is total mess.
> 
>>
>> diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
>> index ce10ecd41ba0..8db2d1893577 100644
>> --- a/drivers/ptp/ptp_pch.c
>> +++ b/drivers/ptp/ptp_pch.c
>> @@ -179,7 +179,7 @@ static inline void pch_block_reset(struct pch_dev *chip)
>>  	iowrite32(val, (&chip->regs->control));
>>  }
>>
>> -u32 pch_ch_control_read(struct pci_dev *pdev)
>> +static u32 pch_ch_control_read(struct pci_dev *pdev)
>>  {
>>  	struct pch_dev *chip = pci_get_drvdata(pdev);
>>  	u32 val;
>> @@ -190,7 +190,7 @@ u32 pch_ch_control_read(struct pci_dev *pdev)
>>  }
>>  EXPORT_SYMBOL(pch_ch_control_read);
> 
> This function is not used and can be deleted.
> 
>>
>> -void pch_ch_control_write(struct pci_dev *pdev, u32 val)
>> +static void pch_ch_control_write(struct pci_dev *pdev, u32 val)
>>  {
>>  	struct pch_dev *chip = pci_get_drvdata(pdev);
>>
>> @@ -198,7 +198,7 @@ void pch_ch_control_write(struct pci_dev *pdev, u32 val)
>>  }
>>  EXPORT_SYMBOL(pch_ch_control_write);
> 
> 
> This function in use (incorrectly) by
> drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> 
> Your patch will break it.
> 
> I didn't check other functions, but assume they are broken too.
> 
> Thanks
> 

Seems like the more appropriate fix is to include the right header so
that these functions do have prototypes.

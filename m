Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A28D57C1DD
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 03:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiGUB2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 21:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGUB2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 21:28:37 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DD974CD8;
        Wed, 20 Jul 2022 18:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658366916; x=1689902916;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2taxh7mCw2+GLKWNabZXLdL/LDPI6ZOkmkd+dAwnLEA=;
  b=LtQZf1ZuNv0J+sxdinA3UMIQzgjsHIRbkROouUIX8Ya7e5f+yUW1sOSZ
   gvmbJLtEE9lbHOVVxqDVkjW8oW/YbMcfNMLDzr6kBA/uOwkJszm7b7t5H
   2i3CzCvYZs55qOImdQulgEnihdPZq08ENlw4/r5Smi64N7JTzTdK0wycB
   I=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 20 Jul 2022 18:28:36 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 18:28:36 -0700
Received: from [10.253.78.99] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 20 Jul
 2022 18:28:33 -0700
Message-ID: <311eba1b-d62f-7029-9775-e4843d71befa@quicinc.com>
Date:   Thu, 21 Jul 2022 09:28:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 3/3] Bluetooth: btusb: Remove
 HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        <swyterzone@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <1658326045-9931-1-git-send-email-quic_zijuhu@quicinc.com>
 <1658326045-9931-4-git-send-email-quic_zijuhu@quicinc.com>
 <CABBYNZJ9Re7PZOFXhj-2tRwJ1UU2kY+QhB4dJT-=GyCYqb_Hhw@mail.gmail.com>
From:   quic_zijuhu <quic_zijuhu@quicinc.com>
In-Reply-To: <CABBYNZJ9Re7PZOFXhj-2tRwJ1UU2kY+QhB4dJT-=GyCYqb_Hhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/2022 11:38 PM, Luiz Augusto von Dentz wrote:
> Hi Zijun,
> 
> On Wed, Jul 20, 2022 at 7:07 AM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>>
>> Fake CSR BT controllers do not enable feature "Erroneous Data Reporting"
>> currently, BT core driver will check the feature bit instead of the quirk
>> to decide if HCI command HCI_Read|Write_Default_Erroneous_Data_Reporting
>> work fine, so remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR.
>>
>> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
>> ---
>>  drivers/bluetooth/btusb.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>> index f0f86c5c3b37..f2b3d31d56cf 100644
>> --- a/drivers/bluetooth/btusb.c
>> +++ b/drivers/bluetooth/btusb.c
>> @@ -2072,7 +2072,6 @@ static int btusb_setup_csr(struct hci_dev *hdev)
>>                  * without these the controller will lock up.
>>                  */
>>                 set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
>> -               set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
>>                 set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
>>                 set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
> 
> You will probably need to remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
> last otherwise it breaks the build in between patches, and please
> double check if there are no other instances of driver using it or
> perhaps leave it defined in case the feature is broken for some reason
> but then we need a macro that checks both the quirk and the feature
> bit.
> 
okay, i will split this change to solve build error between patches.

yes.  only QCA and CSR device with USB I/F use it. no other driver use it

the quirk was introduced to mark HCI_Read|Write_Default_Erroneous_Data_Reporting
broken, but the reason why these two HCI commands don't work fine is that the feature
"Erroneous Data Reporting" is not enabled by firmware.
so we need to check the feature bit instead of the quirk and don't also need the quirk.

>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>>
> 
> 


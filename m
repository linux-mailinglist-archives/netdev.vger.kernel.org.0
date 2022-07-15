Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68AB575CB9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 09:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiGOHt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 03:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiGOHty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 03:49:54 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDCF7968E;
        Fri, 15 Jul 2022 00:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657871392; x=1689407392;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h3VlnLcwsYVJ7E4+bLRWXMsZNEeSuy72jwB0bstzWBc=;
  b=RGjrqBPE4pvlhubIygHvFdY4hDWF9AvUrxZXFv1lxJsmOAyDu4lyn7kr
   +hb3qi7Kq9d/8ELTdD6cl4Pjrzr/H2OgPNKnjYM4Y0FRA3XeB0TytLAyZ
   ao4rh8kG3EYK1Z9czIxuL/5rabYCk6b6+LjnBcCtCETXhp+F1yzSP355w
   I=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 15 Jul 2022 00:49:52 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 00:49:52 -0700
Received: from [10.253.39.163] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 15 Jul
 2022 00:49:47 -0700
Message-ID: <c79f9e5f-dbd9-8cd6-1289-188dfa7ddcb9@quicinc.com>
Date:   Fri, 15 Jul 2022 15:49:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] Bluetooth: hci_sync: Remove redundant func definition
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <1657774452-4497-1-git-send-email-quic_zijuhu@quicinc.com>
 <CABBYNZJG8uKv-270u1P4NTr-gML5=uR2Syhjs=x4LMhJOnqSxA@mail.gmail.com>
 <2cb4f711-5e7c-6fc7-263f-0ed6437f0edb@quicinc.com>
 <CABBYNZJso0QxYhnuaYxu0SYimm7vGvUOPGmuRAYf8LnnHOYxRQ@mail.gmail.com>
From:   quic_zijuhu <quic_zijuhu@quicinc.com>
In-Reply-To: <CABBYNZJso0QxYhnuaYxu0SYimm7vGvUOPGmuRAYf8LnnHOYxRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/2022 12:03 PM, Luiz Augusto von Dentz wrote:
> Hi Quic_zijuhu,
> 
> On Thu, Jul 14, 2022 at 7:12 PM quic_zijuhu <quic_zijuhu@quicinc.com> wrote:
>>
>> On 7/15/2022 4:52 AM, Luiz Augusto von Dentz wrote:
>>> Hi Zijun,
>>>
>>> On Wed, Jul 13, 2022 at 9:54 PM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>>>>
>>>> both hci_request.c and hci_sync.c have the same definition
>>>> for disconnected_accept_list_entries(), so remove a redundant
>>>> copy.
>>>>
>>>> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
>>>> ---
>>>>  net/bluetooth/hci_request.c |  2 +-
>>>>  net/bluetooth/hci_request.h |  2 ++
>>>>  net/bluetooth/hci_sync.c    | 18 ------------------
>>>>  3 files changed, 3 insertions(+), 19 deletions(-)
>>>
>>> We are actually deprecating hci_request functions in favor of hci_sync
>>> ones so this is going in the opposite direction.
>>>
>> should remove disconnected_accept_list_entries() definition within hci_request.c instead of
>> hci_sync.c, right?
> 
> Correct
> 
thank you for your suggestion, correct within v4 sent, could you have a code review again?
>>>> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
>>>> index 635cc5fb451e..38e6c66a3327 100644
>>>> --- a/net/bluetooth/hci_request.c
>>>> +++ b/net/bluetooth/hci_request.c
>>>> @@ -1784,7 +1784,7 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
>>>>         return 0;
>>>>  }
>>>>
>>>> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
>>>> +bool disconnected_accept_list_entries(struct hci_dev *hdev)
>>>>  {
>>>>         struct bdaddr_list *b;
>>>>
>>>> diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
>>>> index 7f8df258e295..e80b500878d9 100644
>>>> --- a/net/bluetooth/hci_request.h
>>>> +++ b/net/bluetooth/hci_request.h
>>>> @@ -120,6 +120,8 @@ void __hci_req_update_scan(struct hci_request *req);
>>>>  int hci_update_random_address(struct hci_request *req, bool require_privacy,
>>>>                               bool use_rpa, u8 *own_addr_type);
>>>>
>>>> +bool disconnected_accept_list_entries(struct hci_dev *hdev);
>>>> +
>>>>  int hci_abort_conn(struct hci_conn *conn, u8 reason);
>>>>  void __hci_abort_conn(struct hci_request *req, struct hci_conn *conn,
>>>>                       u8 reason);
>>>> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
>>>> index 212b0cdb25f5..99ffac6c5e8c 100644
>>>> --- a/net/bluetooth/hci_sync.c
>>>> +++ b/net/bluetooth/hci_sync.c
>>>> @@ -2419,24 +2419,6 @@ int hci_write_fast_connectable_sync(struct hci_dev *hdev, bool enable)
>>>>         return err;
>>>>  }
>>>>
>>>> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
>>>> -{
>>>> -       struct bdaddr_list *b;
>>>> -
>>>> -       list_for_each_entry(b, &hdev->accept_list, list) {
>>>> -               struct hci_conn *conn;
>>>> -
>>>> -               conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
>>>> -               if (!conn)
>>>> -                       return true;
>>>> -
>>>> -               if (conn->state != BT_CONNECTED && conn->state != BT_CONFIG)
>>>> -                       return true;
>>>> -       }
>>>> -
>>>> -       return false;
>>>> -}
>>>> -
>>>>  static int hci_write_scan_enable_sync(struct hci_dev *hdev, u8 val)
>>>>  {
>>>>         return __hci_cmd_sync_status(hdev, HCI_OP_WRITE_SCAN_ENABLE,
>>>> --
>>>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>>>>
>>>
>>>
>>
> 
> 


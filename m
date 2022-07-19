Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99887579146
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiGSDX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiGSDX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:23:27 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F75183A5;
        Mon, 18 Jul 2022 20:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658201005; x=1689737005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HIDhUUPfxUeeF5NaAdzQDRStS26/WnQNQwjtuPgjHlY=;
  b=AGXoYJvYuo5E5sh/I0IFRmScpb6I187MmsfI27QpEYXkjm5Yc658x2oR
   4ds+K2koWyYv/IPkm2CUApMqiERedwJt7c1qz6o8Xpn2YcUFy+H8z7lcx
   kY/H9t4jiUTHOFqjHiqLMW087LgkgtfoZl+qNzXnPpgxvAIGGjs1FxkrH
   Q=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 18 Jul 2022 20:23:25 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 20:23:25 -0700
Received: from [10.253.14.208] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 18 Jul
 2022 20:23:22 -0700
Message-ID: <aae8b240-ecd8-64d0-6f33-86372417e899@quicinc.com>
Date:   Tue, 19 Jul 2022 11:23:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] Bluetooth: hci_sync: Remove redundant func definition
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
References: <1657871102-26907-1-git-send-email-quic_zijuhu@quicinc.com>
 <CABBYNZ+YcrGn09hxB9t7rn1ccY4xtv1WCLQrOLvyUXdQNA_usw@mail.gmail.com>
From:   quic_zijuhu <quic_zijuhu@quicinc.com>
In-Reply-To: <CABBYNZ+YcrGn09hxB9t7rn1ccY4xtv1WCLQrOLvyUXdQNA_usw@mail.gmail.com>
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

On 7/19/2022 7:12 AM, Luiz Augusto von Dentz wrote:
> Hi Zijun,
> 
> On Fri, Jul 15, 2022 at 12:45 AM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>>
>> both hci_request.c and hci_sync.c have the same definition for
>> disconnected_accept_list_entries(), so remove a redundant copy.
>>
>> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
>> ---
>> v3->v4
>>  -use 75 characters per line for Linux commit message bodies
>> v2->v3
>>  -remove table char to solve gitlint checking failure
>> v1->v2
>>  -remove the func copy within hci_request.c instead of hci_sync.c
>>  net/bluetooth/hci_request.c | 18 ------------------
>>  net/bluetooth/hci_request.h |  2 ++
>>  net/bluetooth/hci_sync.c    |  2 +-
>>  3 files changed, 3 insertions(+), 19 deletions(-)
>>
>> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
>> index 635cc5fb451e..edec0447aaa7 100644
>> --- a/net/bluetooth/hci_request.c
>> +++ b/net/bluetooth/hci_request.c
>> @@ -1784,24 +1784,6 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
>>         return 0;
>>  }
>>
>> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
>> -{
>> -       struct bdaddr_list *b;
>> -
>> -       list_for_each_entry(b, &hdev->accept_list, list) {
>> -               struct hci_conn *conn;
>> -
>> -               conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
>> -               if (!conn)
>> -                       return true;
>> -
>> -               if (conn->state != BT_CONNECTED && conn->state != BT_CONFIG)
>> -                       return true;
>> -       }
>> -
>> -       return false;
>> -}
>> -
>>  void __hci_req_update_scan(struct hci_request *req)
>>  {
>>         struct hci_dev *hdev = req->hdev;
>> diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
>> index 7f8df258e295..e80b500878d9 100644
>> --- a/net/bluetooth/hci_request.h
>> +++ b/net/bluetooth/hci_request.h
>> @@ -120,6 +120,8 @@ void __hci_req_update_scan(struct hci_request *req);
>>  int hci_update_random_address(struct hci_request *req, bool require_privacy,
>>                               bool use_rpa, u8 *own_addr_type);
>>
>> +bool disconnected_accept_list_entries(struct hci_dev *hdev);
> 
> I rather not add anything to hci_request.h since we want to deprecate
> its functions, in fact we might as well try to start removing the code
> paths that attempt to access things like
> disconnected_accept_list_entries since I think most of the code is
> already in place in hci_sync.c things like __hci_req_update_scan if it
> is no longer used anywhere else.
> 
so A: move extern disconnected_accept_list_entries() from hci_request.h to hci_request.c
   B: discard this change
what is your suggestion? A or B
>>  int hci_abort_conn(struct hci_conn *conn, u8 reason);
>>  void __hci_abort_conn(struct hci_request *req, struct hci_conn *conn,
>>                       u8 reason);
>> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
>> index 212b0cdb25f5..48a262f0ae49 100644
>> --- a/net/bluetooth/hci_sync.c
>> +++ b/net/bluetooth/hci_sync.c
>> @@ -2419,7 +2419,7 @@ int hci_write_fast_connectable_sync(struct hci_dev *hdev, bool enable)
>>         return err;
>>  }
>>
>> -static bool disconnected_accept_list_entries(struct hci_dev *hdev)
>> +bool disconnected_accept_list_entries(struct hci_dev *hdev)
>>  {
>>         struct bdaddr_list *b;
>>
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>>
> 
> 


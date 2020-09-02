Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E15125AE08
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgIBO5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgIBOAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:00:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303C4C061245;
        Wed,  2 Sep 2020 07:00:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ls14so2383720pjb.3;
        Wed, 02 Sep 2020 07:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4dcRwjz1s1csX6AJeRsJaJoQkhF+IffbkvIIRG1ifvo=;
        b=GxNyzBhmbUbco22yiPt89zB0uDIK5sv/wJtKrrZQZKYJYir5JrZI+VujGdPxpnrncU
         MSE8jSu+n5w1xqLilKadjA8pGGHPFmrQIy4aivBmKA/WqhP1S5iXGxIEObGvQEx5uSlF
         mOJldA+0y1jmqZ7A84vJdCG/MWIvbxlvqrni2aGpxpC6ukzEPFblx+GHDlFP2Y1Q0/SO
         H25Wfovg6NZC+o2jE4XGNmE0ZCZUfd9s90s/R8XDKaywrWyouOpaCSLMpa8y+6oH5bQs
         wjZdKSKBPtUx+g/lQAid6UaK1B8wGAxn2OynHDYHEPpotx2S96ENktBTrmBDKW3hADFN
         vJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4dcRwjz1s1csX6AJeRsJaJoQkhF+IffbkvIIRG1ifvo=;
        b=JfqVZrYrFwLjoceiQ35LUFJ9cZ8DLJrO6fMYHaUgPwZUs+exw6LSxGajxl6kE4YWHJ
         3UhlGk/EOvIl0ez+5h7dow2n5UnxVfZdZtHWX9iiEkb/+IHqam67CE1plJ11isSA3drU
         XtCOblOCRarPiuWB2LVRoxodHjxE7Mk6DBcV87xWenGTlG7sB71Xc/AcmOKS9Nfx/eDA
         5XxaXbRlDfNmBmxkaqq2Fj/kSxiOU8siDXmLQHITkVy1sk3deWb7K1X0GRIlvf3Orgt7
         FuF4cOgltUn6lqAf8D6tjMcEds+ULDtM/yLDfz9TX2kv6FTaQEK8MGnHogN/b5DvnvQX
         FCRQ==
X-Gm-Message-State: AOAM532M/wWawIeZEQTxFZuAlbhv70/EbarlwzlOeAPL0P0jNQHWSsaU
        Jp0pYeMIcT+E8CWpNlp0Xr4=
X-Google-Smtp-Source: ABdhPJw0G+CAri9uK6EPx9JuyMKErX89MtRXrDoep9PQfAEqaQUg7YZEmumP+oKYa1Im6FRNdUDsSw==
X-Received: by 2002:a17:90a:d315:: with SMTP id p21mr2475624pju.88.1599055205640;
        Wed, 02 Sep 2020 07:00:05 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id lb1sm4321084pjb.26.2020.09.02.07.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:00:05 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Wed, 2 Sep 2020 22:00:00 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20200902140000.jcarw6eqryyergig@Rk>
References: <20200826232735.104077-1-coiby.xu@gmail.com>
 <20200827005010.GA46897@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200827005010.GA46897@f3>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 09:50:10AM +0900, Benjamin Poirier wrote:
>On 2020-08-27 07:27 +0800, Coiby Xu wrote:
>> This fixes commit 0107635e15ac
>> ("staging: qlge: replace pr_err with netdev_err") which introduced an
>> build breakage of missing `struct ql_adapter *qdev` for some functions
>> and a warning of type mismatch with dumping enabled, i.e.,
>>
>> $ make CFLAGS_MODULE="QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 \
>>   QL_IB_DUMP=1 QL_REG_DUMP=1 QL_DEV_DUMP=1" M=drivers/staging/qlge
>>
>> qlge_dbg.c: In function ‘ql_dump_ob_mac_rsp’:
>> qlge_dbg.c:2051:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
>>  2051 |  netdev_err(qdev->ndev, "%s\n", __func__);
>>       |             ^~~~
>> qlge_dbg.c: In function ‘ql_dump_routing_entries’:
>> qlge_dbg.c:1435:10: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Wformat=]
>>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>>       |         ~^
>>       |          |
>>       |          char *
>>       |         %d
>>  1436 |        i, value);
>>       |        ~
>>       |        |
>>       |        int
>> qlge_dbg.c:1435:37: warning: format ‘%x’ expects a matching ‘unsigned int’ argument [-Wformat=]
>>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>>       |                                 ~~~~^
>>       |                                     |
>>       |                                     unsigned int
>>
>> Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
>> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/qlge.h      | 20 ++++++++++----------
>>  drivers/staging/qlge/qlge_dbg.c  | 24 ++++++++++++++++++------
>>  drivers/staging/qlge/qlge_main.c |  8 ++++----
>>  3 files changed, 32 insertions(+), 20 deletions(-)
>>
>[...]
>> @@ -1632,6 +1635,8 @@ void ql_dump_wqicb(struct wqicb *wqicb)
>>
>>  void ql_dump_tx_ring(struct tx_ring *tx_ring)
>>  {
>> +	struct ql_adapter *qdev = tx_ring->qdev;
>> +
>>  	if (!tx_ring)
>>  		return;
>
>Given the null check for tx_ring, it seems unwise to dereference tx_ring
>before the check.
>
>Looking at ql_dump_all(), I'm not sure that the check is needed at all
>though. Maybe it should be removed.
>
>Same problem in ql_dump_rx_ring().

Thank you for the spotting this issue! I'll remove the check.

>
>>  	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
>> @@ -1657,6 +1662,8 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
>>  void ql_dump_ricb(struct ricb *ricb)
>>  {
>>  	int i;
>> +	struct ql_adapter *qdev =
>> +		container_of(ricb, struct ql_adapter, ricb);
>
>Here, davem would point out that the variables are not declared in
>"reverse xmas tree" order.

I'll make davem happy then:)

--
Best regards,
Coiby

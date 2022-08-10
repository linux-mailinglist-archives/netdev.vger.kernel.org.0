Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D841E58E89F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiHJIWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiHJIWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:22:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B5D66A47;
        Wed, 10 Aug 2022 01:22:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w11-20020a17090a380b00b001f73f75a1feso1438906pjb.2;
        Wed, 10 Aug 2022 01:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from:from:to:cc;
        bh=9zO6VsxpNwvBhILnEVUXUDk4PHjbIaeGm/Tf8gWbKd8=;
        b=S3UoT348G+5VZXwsh4iDlr/D1pNVi+J/4RtltoMtjLQxwlM0H9OPW7euHzQf5I6QGd
         jjAJjXGEPnTuVOxgKg1SvYGeZnpr91Vzl+LqhfWXOIpGD4vxZqlop6nCqz7/d+xCvJ2F
         452AW2wH6gxBGU9RPMhC0huBgPtF1gOgEeipyiUlujPFJJNUJ6/4cjbH45qxL0WzkZBY
         BU38vSIC39jXKpRLc61x6onHXk3dDyzc/cHFa6Dq1pLXBw43RVjt1driQZEnC0393Wz/
         Rya1z9EG+P+YTXeLXwqQ4f+KdJdg3ymRIDxniqLup1T5JZpvHHTC/keirIqZdeq794IE
         mMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from
         :x-gm-message-state:from:to:cc;
        bh=9zO6VsxpNwvBhILnEVUXUDk4PHjbIaeGm/Tf8gWbKd8=;
        b=LxhezkHVrbUCb2bCb0gByNCUftag9P6dZu36A4fbcdYjhoj/2ntjSVKd11X1orLakf
         /uu6TLa+N9vYxNxxvYVOPIZpsUcitB0GXkwKG4u3DLIW6khDdl+maMtgPoJxFgI+5KK0
         Fr1QCKcsZSN8voPw8mhRL5sqwwShEx1bUpU6QbdNtQxGUUnchvWD2ZfSUGhrtQG+Lg4i
         S77YYF6/IsR0wpwRnKlmKkhwGJAanmceWf3ms+g9YAMW/Ph7triTAPDPfdBy9wCVs4Wn
         6rxlg2KzfkfHyFdcj3u74FSSjngJ24nldPyg0SJJkt/Vh8Vh/HQCKUtbA4Yb8LKSjAd6
         lnGA==
X-Gm-Message-State: ACgBeo0AtlfESs3OoOWQ4ydI32a17MjnBwd3LrdnxurmNpTPlDGhLu+9
        7yhCGGmGrG1fGfHPg8MIVlE+Zw+Jm/8aD9ni
X-Google-Smtp-Source: AA6agR5y9WLMW8E5HivgLerrbmcpreuQd7mObHrDuT7HnrqnxivT2oI2aJH1zwrapSoKpV1JBOFqHQ==
X-Received: by 2002:a17:903:268f:b0:16d:d62c:5b8b with SMTP id jf15-20020a170903268f00b0016dd62c5b8bmr27408513plb.107.1660119767437;
        Wed, 10 Aug 2022 01:22:47 -0700 (PDT)
Received: from [0.0.0.0] ([205.198.104.55])
        by smtp.gmail.com with ESMTPSA id j3-20020a62c503000000b0052dcd14e3desm1259922pfg.183.2022.08.10.01.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 01:22:47 -0700 (PDT)
From:   Linjun Bao <meljbao@gmail.com>
Subject: Re: [PATCH] igc: Remove _I_PHY_ID check for i225 devices
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220809133502.37387-1-meljbao@gmail.com>
 <b39c9fa3-1b7c-c7b1-c3dd-bf5ceb035dc8@intel.com>
Message-ID: <0b4ce201-be78-5a5d-0098-0cbe14ea43fd@gmail.com>
Date:   Wed, 10 Aug 2022 16:22:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b39c9fa3-1b7c-c7b1-c3dd-bf5ceb035dc8@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/8/10 上午1:32, Tony Nguyen wrote:
> On 8/9/2022 6:35 AM, Linjun Bao wrote:
>> Source commit 7c496de538ee ("igc: Remove _I_PHY_ID checking"),
>> remove _I_PHY_ID check for i225 device, since i225 devices only
>> have one PHY vendor.
>
> What are you trying to do with this patch? You're referencing the original commit so you know it's committed, but it's not clear to me why you are re-sending it.
>
I'm new here, please correct me if I am doing things in the wrong way.


Yes this commit was committed to mainline about one year ago. But this commit has not been included into kernel 5.4 yet, and I encountered the probe failure when using alderlake-s with Ethernet adapter i225-LM. Since I could not directly apply the patch 7c496de538ee to kernel 5.4, so I generated this patch for kernel 5.4 usage.


Looks like sending a duplicated patch is not expected. Would you please advise what is the proper action when encountering such case? I would like this fix to be implemented into LTS kernel 5.4, I also wrote a ticket on https://bugzilla.kernel.org/show_bug.cgi?id=216261, but no response.


Regards

Joseph


> Thanks,
> Tony
>
>> Signed-off-by: Linjun Bao <meljbao@gmail.com>
>> ---
>>   drivers/net/ethernet/intel/igc/igc_base.c | 10 +---------
>>   drivers/net/ethernet/intel/igc/igc_main.c |  3 +--
>>   drivers/net/ethernet/intel/igc/igc_phy.c  |  6 ++----
>>   3 files changed, 4 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
>> index db289bcce21d..d66429eb14a5 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_base.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_base.c
>> @@ -187,15 +187,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
>>         igc_check_for_copper_link(hw);
>>   -    /* Verify phy id and set remaining function pointers */
>> -    switch (phy->id) {
>> -    case I225_I_PHY_ID:
>> -        phy->type    = igc_phy_i225;
>> -        break;
>> -    default:
>> -        ret_val = -IGC_ERR_PHY;
>> -        goto out;
>> -    }
>> +    phy->type = igc_phy_i225;
>>     out:
>>       return ret_val;
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
>> index 9ba05d9aa8e0..b8297a63a7fd 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -2884,8 +2884,7 @@ bool igc_has_link(struct igc_adapter *adapter)
>>           break;
>>       }
>>   -    if (hw->mac.type == igc_i225 &&
>> -        hw->phy.id == I225_I_PHY_ID) {
>> +    if (hw->mac.type == igc_i225) {
>>           if (!netif_carrier_ok(adapter->netdev)) {
>>               adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
>>           } else if (!(adapter->flags & IGC_FLAG_NEED_LINK_UPDATE)) {
>> diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
>> index 6156c76d765f..1be112ce6774 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_phy.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_phy.c
>> @@ -235,8 +235,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
>>               return ret_val;
>>       }
>>   -    if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
>> -        hw->phy.id == I225_I_PHY_ID) {
>> +    if (phy->autoneg_mask & ADVERTISE_2500_FULL) {
>>           /* Read the MULTI GBT AN Control Register - reg 7.32 */
>>           ret_val = phy->ops.read_reg(hw, (STANDARD_AN_REG_MASK <<
>>                           MMD_DEVADDR_SHIFT) |
>> @@ -376,8 +375,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
>>           ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
>>                            mii_1000t_ctrl_reg);
>>   -    if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
>> -        hw->phy.id == I225_I_PHY_ID)
>> +    if (phy->autoneg_mask & ADVERTISE_2500_FULL)
>>           ret_val = phy->ops.write_reg(hw,
>>                            (STANDARD_AN_REG_MASK <<
>>                            MMD_DEVADDR_SHIFT) |

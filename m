Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C192C49D2EB
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiAZT62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiAZT61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:58:27 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434E8C06161C;
        Wed, 26 Jan 2022 11:58:27 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u15so926786wrt.3;
        Wed, 26 Jan 2022 11:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=Z6nIps8YazaNhe1+Yw3J4MaNNx0eAK31JViEHafHbC0=;
        b=PmljW7dIKrMfIyxEbZigwWK2vNVfa1ZaUrMIb0xBg8Qk5XXK1oeeusbQy+BcpFbpi2
         9gbY7gPdleaclJGdckxy/VMBqTcYp+NWZsqK2kDxUKTa1cJpsYjJRKxxw5br4aauiJyF
         eWMYJIsG5XyP71iEJGNIaLIFJvzvoUMem4MW4KKoBDA0UhivSDppJOnpccsja4YdsM8x
         viev721AIt7jnKz7P+M5DB57Z4YopGEOHiymwJ26cBtxfrwjPoc3GCMhcnT2c9NPC6fF
         SWHh9bSqwDuFhkL0a7uouxKNcsLSb9ZkcgK278xDwShvrCKNWBTTNOpUi5XknW8qIGjE
         29Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=Z6nIps8YazaNhe1+Yw3J4MaNNx0eAK31JViEHafHbC0=;
        b=t0m/YI/H/wOXqkV6G7VWlFeQF/E6oKYVaQ1+QmDx9R6NJAqvnSMwHBCHedIvfSF8hF
         aCWTCFI6C7c0rFRYZj4jcWxUr2zPRVi0patb3LtZxxtH/e26UMqTxcNGtOA7Y/yLRUlV
         vqPNJHSyASbp6Dk/vLSUk561Prk5MDiBAgPC5TfdG/8Is5kDfXUHnf4OjupIpqM4VAQA
         qmMD/hyycHihFfZipGr48/FqXI4MNL0PDlw/kqwLamQKQR4fwUftPvta3B6/Qjj7O1Tr
         JEYntg3yl5WswqGvP5q6wJ53rkNWs5CeStJN2mO33oRjyO6G7q7D0ATgH+A+weCmIIWQ
         UBpg==
X-Gm-Message-State: AOAM531C49XiHHLnMueI7/o3UiTH/uwKwRnu0HUZtUvxY89Mjxy3Vipb
        W1YKIBSYNNhHFyQxtkm1BjNBMJ04MUg=
X-Google-Smtp-Source: ABdhPJy+bP4OW/ajAVYQ3HlF3qJTr2n90JFNzt+a20v2SUd2DkxpPko5x7OnT4a/pksPc7zVNxnanA==
X-Received: by 2002:a05:6000:1568:: with SMTP id 8mr189647wrz.278.1643227105813;
        Wed, 26 Jan 2022 11:58:25 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:4959:c362:fa9a:b656? (p200300ea8f4d2b004959c362fa9ab656.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:4959:c362:fa9a:b656])
        by smtp.googlemail.com with ESMTPSA id w8sm224754wrq.3.2022.01.26.11.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 11:58:25 -0800 (PST)
Message-ID: <a42b7653-7be6-a0ed-5ed9-7668e5348c2d@gmail.com>
Date:   Wed, 26 Jan 2022 20:58:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     Hau <hau@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220124181937.6331-1-hau@realtek.com>
 <5ec25f20-8acf-544d-30f6-f0eeecd9b2f1@gmail.com>
 <439ba7073446410da75509a5add95e03@realtek.com>
 <daa376b3-d756-b85d-d256-49012ebe928b@gmail.com>
 <0a281169bb114b69a49f91be80bbdf45@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/1] r8169: enable RTL8125 ASPM L1.2
In-Reply-To: <0a281169bb114b69a49f91be80bbdf45@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2022 16:03, Hau wrote:
> 
> 
>> -----Original Message-----
>> From: Heiner Kallweit [mailto:hkallweit1@gmail.com]
>> Sent: Wednesday, January 26, 2022 9:47 PM
>> To: Hau <hau@realtek.com>; netdev@vger.kernel.org
>> Cc: nic_swsd <nic_swsd@realtek.com>; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH net-next 1/1] r8169: enable RTL8125 ASPM L1.2
>>
>> On 26.01.2022 14:00, Hau wrote:
>>>> On 24.01.2022 19:19, Chunhao Lin wrote:
>>>>> This patch will enable RTL8125 ASPM L1.2 on the platforms that have
>>>>> tested RTL8125 with ASPM L1.2 enabled.
>>>>> Register mac ocp 0xc0b2 will help to identify if RTL8125 has been
>>>>> tested on L1.2 enabled platform. If it is, this register will be set to 0xf.
>>>>> If not, this register will be default value 0.
>>>>>
>>>>> Signed-off-by: Chunhao Lin <hau@realtek.com>
>>>>> ---
>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 99
>>>>> ++++++++++++++++++-----
>>>>>  1 file changed, 79 insertions(+), 20 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>>>>> b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> index 19e2621e0645..b1e013969d4c 100644
>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> @@ -2238,21 +2238,6 @@ static void rtl_wol_enable_rx(struct
>>>> rtl8169_private *tp)
>>>>>  			AcceptBroadcast | AcceptMulticast |
>>>> AcceptMyPhys);  }
>>>>>
>>>>> -static void rtl_prepare_power_down(struct rtl8169_private *tp) -{
>>>>> -	if (tp->dash_type != RTL_DASH_NONE)
>>>>> -		return;
>>>>> -
>>>>> -	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
>>>>> -	    tp->mac_version == RTL_GIGA_MAC_VER_33)
>>>>> -		rtl_ephy_write(tp, 0x19, 0xff64);
>>>>> -
>>>>> -	if (device_may_wakeup(tp_to_dev(tp))) {
>>>>> -		phy_speed_down(tp->phydev, false);
>>>>> -		rtl_wol_enable_rx(tp);
>>>>> -	}
>>>>> -}
>>>>> -
>>>>>  static void rtl_init_rxcfg(struct rtl8169_private *tp)  {
>>>>>  	switch (tp->mac_version) {
>>>>> @@ -2650,6 +2635,34 @@ static void
>>>>> rtl_pcie_state_l2l3_disable(struct
>>>> rtl8169_private *tp)
>>>>>  	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Rdy_to_L23);  }
>>>>>
>>>>> +static void rtl_disable_exit_l1(struct rtl8169_private *tp) {
>>>>> +	/* Bits control which events trigger ASPM L1 exit:
>>>>> +	 * Bit 12: rxdv
>>>>> +	 * Bit 11: ltr_msg
>>>>> +	 * Bit 10: txdma_poll
>>>>> +	 * Bit  9: xadm
>>>>> +	 * Bit  8: pktavi
>>>>> +	 * Bit  7: txpla
>>>>> +	 */
>>>>> +	switch (tp->mac_version) {
>>>>> +	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
>>>>> +		rtl_eri_clear_bits(tp, 0xd4, 0x1f00);
>>>>> +		break;
>>>>> +	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
>>>>> +		rtl_eri_clear_bits(tp, 0xd4, 0x0c00);
>>>>> +		break;
>>>>> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
>>>>> +		rtl_eri_clear_bits(tp, 0xd4, 0x1f80);
>>>>> +		break;
>>>>> +	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
>>>>> +		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
>>>>> +		break;
>>>>> +	default:
>>>>> +		break;
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>  static void rtl_enable_exit_l1(struct rtl8169_private *tp)  {
>>>>>  	/* Bits control which events trigger ASPM L1 exit:
>>>>> @@ -2692,6 +2705,33 @@ static void rtl_hw_aspm_clkreq_enable(struct
>>>> rtl8169_private *tp, bool enable)
>>>>>  	udelay(10);
>>>>>  }
>>>>>
>>>>> +static void rtl_hw_aspm_l12_enable(struct rtl8169_private *tp, bool
>>>>> +enable) {
>>>>> +	/* Don't enable L1.2 in the chip if OS can't control ASPM */
>>>>> +	if (enable && tp->aspm_manageable) {
>>>>> +		r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
>>>>> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, BIT(2));
>>>>> +	} else {
>>>>> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
>>>>> +	}
>>>>> +}
>>>>> +
>>>>> +static void rtl_prepare_power_down(struct rtl8169_private *tp) {
>>>>> +	if (tp->dash_type != RTL_DASH_NONE)
>>>>> +		return;
>>>>> +
>>>>> +	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
>>>>> +	    tp->mac_version == RTL_GIGA_MAC_VER_33)
>>>>> +		rtl_ephy_write(tp, 0x19, 0xff64);
>>>>> +
>>>>> +	if (device_may_wakeup(tp_to_dev(tp))) {
>>>>> +		rtl_disable_exit_l1(tp);
>>>>> +		phy_speed_down(tp->phydev, false);
>>>>> +		rtl_wol_enable_rx(tp);
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>  static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
>>>>>  			      u16 tx_stat, u16 rx_dyn, u16 tx_dyn)  { @@ -
>>>> 3675,6 +3715,7
>>>>> @@ static void rtl_hw_start_8125b(struct rtl8169_private *tp)
>>>>>  	rtl_ephy_init(tp, e_info_8125b);
>>>>>  	rtl_hw_start_8125_common(tp);
>>>>>
>>>>> +	rtl_hw_aspm_l12_enable(tp, true);
>>>>>  	rtl_hw_aspm_clkreq_enable(tp, true);  }
>>>>>
>>>>> @@ -5255,6 +5296,20 @@ static void rtl_init_mac_address(struct
>>>> rtl8169_private *tp)
>>>>>  	rtl_rar_set(tp, mac_addr);
>>>>>  }
>>>>>
>>>>> +/* mac ocp 0xc0b2 will help to identify if RTL8125 has been tested
>>>>> + * on L1.2 enabled platform. If it is, this register will be set to 0xf.
>>>>> + * If not, this register will be default value 0.
>>>>> + */
>>>>> +static bool rtl_platform_l12_enabled(struct rtl8169_private *tp) {
>>>>> +	switch (tp->mac_version) {
>>>>> +	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
>>>>> +		return (r8168_mac_ocp_read(tp, 0xc0b2) & 0xf) ? true : false;
>>>>> +	default:
>>>>> +		return false;
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>  static int rtl_init_one(struct pci_dev *pdev, const struct
>>>>> pci_device_id *ent)  {
>>>>>  	struct rtl8169_private *tp;
>>>>> @@ -5333,11 +5388,15 @@ static int rtl_init_one(struct pci_dev
>>>>> *pdev,
>>>> const struct pci_device_id *ent)
>>>>>  	 * Chips from RTL8168h partially have issues with L1.2, but seem
>>>>>  	 * to work fine with L1 and L1.1.
>>>>>  	 */
>>>>> -	if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
>>>>> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
>>>>> -	else
>>>>> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
>>>>> -	tp->aspm_manageable = !rc;
>>>>> +	if (!rtl_platform_l12_enabled(tp)) {
>>>>> +		if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
>>>>> +			rc = pci_disable_link_state(pdev,
>>>> PCIE_LINK_STATE_L1_2);
>>>>> +		else
>>>>> +			rc = pci_disable_link_state(pdev,
>>>> PCIE_LINK_STATE_L1);
>>>>> +		tp->aspm_manageable = !rc;
>>>>> +	} else {
>>>>> +		tp->aspm_manageable = pcie_aspm_enabled(pdev);
>>>>> +	}
>>>>>
>>>>>  	tp->dash_type = rtl_check_dash(tp);
>>>>>
>>>>
>>>> Hi Hau,
>>>>
>>>> the following is a stripped-down version of the patch. Could you
>>>> please check/test?
>>> This patch is ok.
>>> L1 substate lock can apply for both rtl8125a.rtl8125b.
>>> if (enable && tp->aspm_manageable) {
>>> 	RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>>> 	RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>>>
>>> 	if (tp->mac_version >= RTL_GIGA_MAC_VER_60) {
>>> 		r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
>>> 		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, BIT(2));
>>> 	}
>>> } else {
>>> 	if (tp->mac_version >= RTL_GIGA_MAC_VER_60)
>>> 		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
>>>
>>> 	RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
>>> 	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en); }
>>>
>>>> If function rtl_disable_exit_l1() is actually needed, I'd prefer to
>>>> add it in a separate patch (to facilitate bisecting).
>>>>
>>> If exit l1 mask is enabled, hardware will prone to exit l1. That will
>>> prevent hardware from entering l1 substate. So It needs to disable l1
>>> exist mask when device go to d3 state for entering l1 substate..
>>>
>> My understanding of PCI power management may be incomplete, but:
>> If a device goes to D3, then doesn't the bus go to L2/L3?
>> L1 exit criteria would be irrelevant then.
> Your understanding is correct.
> D3 is divided to two substate, D3hot and D3cold. D3cold will enter L2/L3.
> D3hot may enter L1 or L2/L3 ready.  In D3hot case, enable exit l1 mask will
> prevent hardware from entering PM L1. That is our hardware issue.
> So we disable exit l1 mask before hardware enter D3.
> 
> 
I submitted the patch to enable L1.2 if tested with your Suggested-by.
One last question before submitting the disable_exit_l1 patch.

Depending on the chip version only certain L1 exit bits are set.

+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
+		rtl_eri_clear_bits(tp, 0xd4, 0x1f00);
+		break;
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
+		rtl_eri_clear_bits(tp, 0xd4, 0x0c00);
+		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
+		rtl_eri_clear_bits(tp, 0xd4, 0x1f80);
+		break;
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
+		break;

Would it be safe to shorten this to the following? Or is some bit
in this range used for another purpose on certain chip versions?

+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
+		rtl_eri_clear_bits(tp, 0xd4, 0x1f80);
+		break;
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
+		break;

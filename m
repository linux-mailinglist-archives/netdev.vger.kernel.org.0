Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C47349D017
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiAZQyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiAZQyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:54:24 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0D0C06161C;
        Wed, 26 Jan 2022 08:54:24 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a13so79955wrh.9;
        Wed, 26 Jan 2022 08:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DS5+6UCJeALQxLsUW3AHjRDIFwi2z+0gGhUNz0MN9mQ=;
        b=eRPYJn1VFGxY7N8Ks8JaEtLt+p+wytJa2apFG7Me5+mCiP9uW9op7N7M5hdOeQ2i39
         dfeerMIMjXrEcTBOL541yTjxeYYBO/eVWF/JRsq8ewYGllqIrrwbAecoxvskDd7qWOKk
         3/nLVuOagsvJdzqzeECyGfWNKE2CTgtPsmoGK/OjAZ89QtPNlu1eo3AwPGkr6kgsVNep
         ZuIiEr8TXw+97saIxYijQYUDwjucWFDetmVVY+rhrbAyqrh4nEnl/bMfJwBVCHDRwPzz
         5VZqz+KfrWtbWa9YEzBOsADC0UoluHzjRdv33fW0go0NMGK7nkmVBXX4pht/8hJEH0xl
         Qh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DS5+6UCJeALQxLsUW3AHjRDIFwi2z+0gGhUNz0MN9mQ=;
        b=uXBq8TArifrsdWG1mWex83200AtG7IiDMED9Hs+AODGwnKQOO9ip3wKgXzu+I8ve6q
         z2Au0sDLHf7zYyqcMMzP99YrmeMorAiF5AGeXrEZNwoJOKaKHBYXG7Lhney8z9uYEdRh
         jU3k21l9Ze91szV33GbAJvIw9nUxoScWuY6PlWoHTW/mkatC9QHO88/1o2Zy4RY7KBaq
         a9zHBFQQWqmeeLojZ7xixhQTR4CmuimwAi39aYEw4jwb6xN9YbF+t+1nk//OmIKXwIDS
         xpoSSbTo8gFOHrwe98PxKWbFn3sR4/gaP2U+rrqT6/dW7jE9aXIK57uaBYajV8f3+qZy
         qS4w==
X-Gm-Message-State: AOAM5332JWPDs0Sh9gDTgs7u52i0DxCLR5omOVL/epKmaYqpi/YblZ3z
        tINmZ6g2b6dgZLE+sagrRlGJts5189Y=
X-Google-Smtp-Source: ABdhPJzCamjZ4ogkFMNSXrChFqe+YMoxzDMdyyVG5WGBQt6YfvoNuCHhIPGqndK/8sbMi5kK4rCAYQ==
X-Received: by 2002:adf:eac3:: with SMTP id o3mr18901313wrn.27.1643216062764;
        Wed, 26 Jan 2022 08:54:22 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:4959:c362:fa9a:b656? (p200300ea8f4d2b004959c362fa9ab656.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:4959:c362:fa9a:b656])
        by smtp.googlemail.com with ESMTPSA id l40sm4259536wms.0.2022.01.26.08.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 08:54:22 -0800 (PST)
Message-ID: <fdaad686-f0cf-47e6-4558-e8e19b7be746@gmail.com>
Date:   Wed, 26 Jan 2022 17:54:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 1/1] r8169: enable RTL8125 ASPM L1.2
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

Thanks! One, hopefully last, question:
Are you aware of any boards/systems setting this "L1.2 was tested and is safe" flag?
Then this could be mentioned in the commit description.

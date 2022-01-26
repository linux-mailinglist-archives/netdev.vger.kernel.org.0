Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF2A49C7B4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbiAZKmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbiAZKmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:42:45 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3398C061747;
        Wed, 26 Jan 2022 02:42:44 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id r7so2281394wmq.5;
        Wed, 26 Jan 2022 02:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=29rxiBb7qaHrc9qjiiUIG9lGAiUNl897VESW+1cq9rk=;
        b=UxIzOXy1A6Lvi61saMtNbVcaUU6R2hz9Km3HhDbY4tCTJREAtoP9nmdYcArIFmJ3RH
         wPHMu6+CEjCnVdBhbRSA6QKnqRh4IfUJr/qbVYhijp0maQA7KSmsrbRvWZgmH1Uhd8WF
         dq/gY7hzhztX2PUIQEdU0vYQCMHxoRlOWHJqFtM0JzrddgdJqoBbbSExSRZpYzG/xFqY
         t9B6ZqYnMgr0XgYK4p607dsTo2Ni1AQNGkCzLG3PO0yWlwOYkJfhsJPq1KKZRmEBbBbq
         tJvefmrDExiMIRnODRGmCiTI07VUV5SQGh07JICVsnnF4O4QmE6qGWHP/RB4i2y0HAEP
         qewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=29rxiBb7qaHrc9qjiiUIG9lGAiUNl897VESW+1cq9rk=;
        b=XWnydZcSEASTKTSKF0HhsSPBkzapCJJGj+UJ5c/GnkzaQ4CPNYgtiU2hnlO0yh/4b8
         KEOC+G4XeRvQ0qp8z6LlbOU/z+EVpJHXV7rMGiSBjw0Mqfa4uvNb51/5N6o500Dw29U1
         5n5mzt+HpaUigOF/S1/39BPIMpRQpkva3SWJeudOsO6EuPKq3DYR4Gwjlui8vppVApcF
         JDB0J+i1LIr7pcQFEIiLr5hX/c2g/SnFYLHh8w8fRlhhXWDOsoAK91CNFbi3txSD3Q3T
         HQaliI1bsw+xNYpM2H0PtPAOoosoEYcx7ET0YdDRtloCIpqCSnt8sbTwrBfBDVOMx+Ox
         MXHA==
X-Gm-Message-State: AOAM530c84en4mKLNqxBXGbwuR0dwGimsZMvO493IZzfDdt02VmgeUiQ
        WYVu/pHX0imJRjvxx8MKxk//4itTXdY=
X-Google-Smtp-Source: ABdhPJzmze24zqLoaEHD8r0Fk+vV8MCc1Zs7GZIcIMz/JbrG53+SAyVXEijhfshkLsp/TR/1LfB6oQ==
X-Received: by 2002:a7b:c928:: with SMTP id h8mr6538555wml.168.1643193763201;
        Wed, 26 Jan 2022 02:42:43 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:bd02:e288:550c:1ac4? (p200300ea8f4d2b00bd02e288550c1ac4.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:bd02:e288:550c:1ac4])
        by smtp.googlemail.com with ESMTPSA id n15sm19070751wrf.37.2022.01.26.02.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 02:42:42 -0800 (PST)
Message-ID: <c8df96c7-79b2-8b5b-9036-12bd8bfd5582@gmail.com>
Date:   Wed, 26 Jan 2022 11:42:35 +0100
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
 <23d3e690-da16-df03-4c75-dc92625b2c96@gmail.com>
 <052d2be6e8f445f3a4890e259bdee8ce@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <052d2be6e8f445f3a4890e259bdee8ce@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2022 10:02, Hau wrote:
> 
> 
>> On 24.01.2022 19:19, Chunhao Lin wrote:
>>> This patch will enable RTL8125 ASPM L1.2 on the platforms that have
>>> tested RTL8125 with ASPM L1.2 enabled.
>>> Register mac ocp 0xc0b2 will help to identify if RTL8125 has been
>>> tested on L1.2 enabled platform. If it is, this register will be set to 0xf.
>>> If not, this register will be default value 0.
>>>
>>> Signed-off-by: Chunhao Lin <hau@realtek.com>
>>> ---
>>>  drivers/net/ethernet/realtek/r8169_main.c | 99
>>> ++++++++++++++++++-----
>>>  1 file changed, 79 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>>> b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 19e2621e0645..b1e013969d4c 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -2238,21 +2238,6 @@ static void rtl_wol_enable_rx(struct
>> rtl8169_private *tp)
>>>  			AcceptBroadcast | AcceptMulticast |
>> AcceptMyPhys);  }
>>>
>>> -static void rtl_prepare_power_down(struct rtl8169_private *tp) -{
>>> -	if (tp->dash_type != RTL_DASH_NONE)
>>> -		return;
>>> -
>>> -	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
>>> -	    tp->mac_version == RTL_GIGA_MAC_VER_33)
>>> -		rtl_ephy_write(tp, 0x19, 0xff64);
>>> -
>>> -	if (device_may_wakeup(tp_to_dev(tp))) {
>>> -		phy_speed_down(tp->phydev, false);
>>> -		rtl_wol_enable_rx(tp);
>>> -	}
>>> -}
>>> -
>>>  static void rtl_init_rxcfg(struct rtl8169_private *tp)  {
>>>  	switch (tp->mac_version) {
>>> @@ -2650,6 +2635,34 @@ static void rtl_pcie_state_l2l3_disable(struct
>> rtl8169_private *tp)
>>>  	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Rdy_to_L23);  }
>>>
>>> +static void rtl_disable_exit_l1(struct rtl8169_private *tp) {
>>> +	/* Bits control which events trigger ASPM L1 exit:
>>> +	 * Bit 12: rxdv
>>> +	 * Bit 11: ltr_msg
>>> +	 * Bit 10: txdma_poll
>>> +	 * Bit  9: xadm
>>> +	 * Bit  8: pktavi
>>> +	 * Bit  7: txpla
>>> +	 */
>>> +	switch (tp->mac_version) {
>>> +	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
>>> +		rtl_eri_clear_bits(tp, 0xd4, 0x1f00);
>>> +		break;
>>> +	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
>>> +		rtl_eri_clear_bits(tp, 0xd4, 0x0c00);
>>> +		break;
>>> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
>>> +		rtl_eri_clear_bits(tp, 0xd4, 0x1f80);
>>> +		break;
>>> +	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
>>> +		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
>>> +}
>>> +
>>>  static void rtl_enable_exit_l1(struct rtl8169_private *tp)  {
>>>  	/* Bits control which events trigger ASPM L1 exit:
>>> @@ -2692,6 +2705,33 @@ static void rtl_hw_aspm_clkreq_enable(struct
>> rtl8169_private *tp, bool enable)
>>>  	udelay(10);
>>>  }
>>>
>>> +static void rtl_hw_aspm_l12_enable(struct rtl8169_private *tp, bool
>>> +enable) {
>>> +	/* Don't enable L1.2 in the chip if OS can't control ASPM */
>>> +	if (enable && tp->aspm_manageable) {
>>> +		r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
>>> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, BIT(2));
>>> +	} else {
>>> +		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
>>> +	}
>>> +}
>>> +
>>
>> Register E094 bits 0..15 are cleared when enabling, but not touched on
>> disabling. I this correct?
>    Register E094 bits 8...15 is a timer counter that is used to control when to disable ephy tx/rx.
>    Set it to 0 means disable ephy tx/rx immediately when certain condition meet. 
>    It has no meaning when register E092 bit 2 is set to 0.
> 
Thanks for the explanation.

>> And for basically the same purpose we have the following function.
>> "don't enable L1.2 in the chip" is not covered by ASPM_en in Config5?
>    Register E092 is like  ASPM_en in Config5. But it controls L1 substate (L1.1/L1.2) enable status.
> 
How is this handled for the RTL8168 chip versions supporting L1 sub-states (RTL8168h)?
Is there a similar register or does Config5 ASPM_en control also the L1 substates
on these chip versions?

>>
>> static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool
>> enable) {
>> 	/* Don't enable ASPM in the chip if OS can't control ASPM */
>> 	if (enable && tp->aspm_manageable) {
>> 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>> 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>> 	} else {
>> 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
>> 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
>> 	}
>>
>> 	udelay(10);
>> }
>>
>>
...

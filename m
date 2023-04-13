Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD456E070C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjDMGih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMGig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:38:36 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9DB7EFB;
        Wed, 12 Apr 2023 23:38:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id EE7B0604F6;
        Thu, 13 Apr 2023 08:38:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681367906; bh=vxGGEG7u6NbcQ4pqG9vgSpAxccBKg2fLHKIKcpuXE4g=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=DrlazDMKu0Q8d9WvK67bIFWxA9FcwD3a0lkPpuqA//ckEGWWvRh/BIGqRczV61e0z
         WrAbNHHJepvobjMvk2ODxHpMW3GpDBjeTCold6kOFCdyDNw5hFe2hyuldz7fnwpq03
         CW/VvX6LYf/tDbgEpCfwLLa8mabcA7cKgVJ9LY/Q3qpwDVPVw89F7F/aCXgLbrE8gW
         FjTL5U4ONHrmVwejVbA2b2S3qg7KRfUMvUzK6GnFgjFvFwyb34Lp+tQF+nZMhI0AVC
         i8RVcjKpN4PjoKGrKJhMGojFnwGGdnaeaqqWDuRL+qpL3GP5efFdr3ZTnPchSSS9Kt
         eFkMtK9eTynKw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bxTAh7tasZoJ; Thu, 13 Apr 2023 08:38:22 +0200 (CEST)
Received: from [10.0.1.96] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id B887A604ED;
        Thu, 13 Apr 2023 08:38:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681367902; bh=vxGGEG7u6NbcQ4pqG9vgSpAxccBKg2fLHKIKcpuXE4g=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=k7uZkRcb8fuFZIKamH7FXAo4Ns6nhleo3mr9cwRq/LSvGXjZ5Uj84iRwp+oTVsbRO
         yk9O3WgxU8TKHu9bMDmxF0tL2ZqU06+qq4VsOcgHa8M4ZlB5RaWBapJ6uuI9VJn3VL
         8uc+G8avK2qvJHzBs8fkbfJ+NLpTIn8ws8RjNdkFSGhJqGPbh2wl9DJUlIzlbAVqu6
         82B2lFQwhXIcDuBT7fr4wMeoCNZ1lyTEEelx1agnCtgPJkfg35Ralz3xdn5RvfcVyu
         /4luI1wlqupXkt8JEwgVmjRRy644p0uMlM5qeRsPF/rJe2cU7jxn04P8WIo+yguyLL
         kerY5l0DD/wEw==
Message-ID: <358b1501-1d76-1a30-d893-ab119111a76f@alu.unizg.hr>
Date:   Thu, 13 Apr 2023 08:38:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: BUG: drivers/net/wireless: iwlwifi: IWL Error: "BUG: kernel NULL
 pointer dereference, address: 0000000000000150"
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     "Greenman, Gregory" <gregory.greenman@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr>
 <4008aff6-c432-dd0f-fcf6-1d384b809cd4@alu.unizg.hr>
 <c6bbca2a83353423a95a80cf0e6c93ccb6652847.camel@intel.com>
 <f13514c5-5289-4b7d-a0ef-1f861d87cb25@alu.unizg.hr>
Content-Language: en-US, hr
In-Reply-To: <f13514c5-5289-4b7d-a0ef-1f861d87cb25@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.4.2023. 13:46, Mirsad Todorovac wrote:
> On 4/11/23 10:47, Greenman, Gregory wrote:
>> On Mon, 2023-04-10 at 01:43 +0200, Mirsad Goran Todorovac wrote:
>>> On 10. 04. 2023. 00:21, Mirsad Goran Todorovac wrote:
>>>> Hi all,
>>>>
>>>> This is an error is the syslog found after investigating a Youtube FF chirping hang
>>>> while running kseftest of 6.3-rc6 torvalds tree kernel.
>>>>
>>>> Running multimedia and kselftest might seem off, but multimedia performance on Linux
>>>> and open source software is a very interesting research area.
>>>>
>>>> Here is the trace from the log:
>>>>
>>>> Apr  9 23:01:11 marvin-IdeaPad-3-15ITL6 kernel: [  615.957145] mmiotrace: disabled.
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.881758] iwlwifi 0000:00:14.3: Error sending STATISTICS_CMD: time out 
>>>> after 2000ms.
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.882332] iwlwifi 0000:00:14.3: Current CMD queue read_ptr 67 write_ptr 68
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884299] iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884373] iwlwifi 0000:00:14.3: Transport status: 0x0000004A, valid: 6
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884446] iwlwifi 0000:00:14.3: Loaded firmware version: 73.35c0a2c6.0 
>>>> QuZ-a0-jf-b0-73.ucode
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884520] iwlwifi 0000:00:14.3: 0x00000084 | NMI_INTERRUPT_UNKNOWN
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884624] iwlwifi 0000:00:14.3: 0x000022F0 | trm_hw_status0
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884695] iwlwifi 0000:00:14.3: 0x00000000 | trm_hw_status1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884766] iwlwifi 0000:00:14.3: 0x004C352E | branchlink2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884837] iwlwifi 0000:00:14.3: 0x004BA12A | interruptlink1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884907] iwlwifi 0000:00:14.3: 0x004BA12A | interruptlink2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885309] iwlwifi 0000:00:14.3: 0x0000CEEA | data1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885444] iwlwifi 0000:00:14.3: 0x01000000 | data2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885526] iwlwifi 0000:00:14.3: 0x00000000 | data3
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885598] iwlwifi 0000:00:14.3: 0x840075C7 | beacon time
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885670] iwlwifi 0000:00:14.3: 0x5282AA44 | tsf low
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885741] iwlwifi 0000:00:14.3: 0x00000082 | tsf hi
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885812] iwlwifi 0000:00:14.3: 0x00000000 | time gp1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885885] iwlwifi 0000:00:14.3: 0x24D400DC | time gp2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885963] iwlwifi 0000:00:14.3: 0x00000001 | uCode revision type
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886040] iwlwifi 0000:00:14.3: 0x00000049 | uCode version major
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886117] iwlwifi 0000:00:14.3: 0x35C0A2C6 | uCode version minor
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886193] iwlwifi 0000:00:14.3: 0x00000351 | hw version
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886268] iwlwifi 0000:00:14.3: 0x00489001 | board version
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886344] iwlwifi 0000:00:14.3: 0x80B3F400 | hcmd
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886420] iwlwifi 0000:00:14.3: 0x00020000 | isr0
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886496] iwlwifi 0000:00:14.3: 0x00000000 | isr1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886632] iwlwifi 0000:00:14.3: 0x08F00002 | isr2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886750] iwlwifi 0000:00:14.3: 0x00C3028C | isr3
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886889] iwlwifi 0000:00:14.3: 0x00000000 | isr4
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887035] iwlwifi 0000:00:14.3: 0x05C8001C | last cmd Id
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887180] iwlwifi 0000:00:14.3: 0x0000CEEA | wait_event
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887326] iwlwifi 0000:00:14.3: 0x00000854 | l2p_control
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887467] iwlwifi 0000:00:14.3: 0x00000020 | l2p_duration
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887610] iwlwifi 0000:00:14.3: 0x0000000F | l2p_mhvalid
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887756] iwlwifi 0000:00:14.3: 0x00000000 | l2p_addr_match
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887895] iwlwifi 0000:00:14.3: 0x00000009 | lmpm_pmg_sel
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888150] iwlwifi 0000:00:14.3: 0x00000000 | timestamp
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888288] iwlwifi 0000:00:14.3: 0x00006868 | flow_handler
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888730] iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888867] iwlwifi 0000:00:14.3: Transport status: 0x0000004A, valid: 7
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889159] iwlwifi 0000:00:14.3: 0x20000066 | NMI_INTERRUPT_HOST
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889306] iwlwifi 0000:00:14.3: 0x00000000 | umac branchlink1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889450] iwlwifi 0000:00:14.3: 0x80453B88 | umac branchlink2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889594] iwlwifi 0000:00:14.3: 0x8046FE32 | umac interruptlink1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889740] iwlwifi 0000:00:14.3: 0x8046FE32 | umac interruptlink2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889886] iwlwifi 0000:00:14.3: 0x01000000 | umac data1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890033] iwlwifi 0000:00:14.3: 0x8046FE32 | umac data2
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890176] iwlwifi 0000:00:14.3: 0x00000000 | umac data3
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890323] iwlwifi 0000:00:14.3: 0x00000049 | umac major
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890468] iwlwifi 0000:00:14.3: 0x35C0A2C6 | umac minor
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890613] iwlwifi 0000:00:14.3: 0x24D400DA | frame pointer
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890759] iwlwifi 0000:00:14.3: 0xC0886264 | stack pointer
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890905] iwlwifi 0000:00:14.3: 0x0043019C | last host cmd
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891050] iwlwifi 0000:00:14.3: 0x00000000 | isr status reg
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891323] iwlwifi 0000:00:14.3: IML/ROM dump:
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891469] iwlwifi 0000:00:14.3: 0x00000003 | IML/ROM error/state
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891731] iwlwifi 0000:00:14.3: 0x000053F8 | IML/ROM data1
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891997] iwlwifi 0000:00:14.3: 0x00000080 | IML/ROM WFPM_AUTH_KEY_0
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.892216] iwlwifi 0000:00:14.3: Fseq Registers:
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.893775] iwlwifi 0000:00:14.3: 0x60000000 | FSEQ_ERROR_CODE
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.893927] iwlwifi 0000:00:14.3: 0x80260000 | FSEQ_TOP_INIT_VERSION
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894077] iwlwifi 0000:00:14.3: 0x00020006 | FSEQ_CNVIO_INIT_VERSION
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894227] iwlwifi 0000:00:14.3: 0x0000A384 | FSEQ_OTP_VERSION
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894374] iwlwifi 0000:00:14.3: 0x3D544A68 | FSEQ_TOP_CONTENT_VERSION
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894526] iwlwifi 0000:00:14.3: 0x4552414E | FSEQ_ALIVE_TOKEN
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894675] iwlwifi 0000:00:14.3: 0x20000302 | FSEQ_CNVI_ID
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894826] iwlwifi 0000:00:14.3: 0x01300202 | FSEQ_CNVR_ID
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894976] iwlwifi 0000:00:14.3: 0x20000302 | CNVI_AUX_MISC_CHIP
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895129] iwlwifi 0000:00:14.3: 0x01300202 | CNVR_AUX_MISC_CHIP
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895282] iwlwifi 0000:00:14.3: 0x0000485B | 
>>>> CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895463] iwlwifi 0000:00:14.3: 0xA5A5A5A2 | 
>>>> CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.898477] iwlwifi 0000:00:14.3: WRT: Collecting data: ini trigger 4 fired 
>>>> (delay=0ms).
>>>> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.899785] ieee80211 phy0: Hardware restart was requested
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.878162] iwlwifi 0000:00:14.3: HCMD_ACTIVE already clear for command 
>>>> STATISTICS_CMD
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.878273] iwlwifi 0000:00:14.3: Hardware error detected. Restarting.
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.881860] ------------[ cut here ]------------
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.882201] WARNING: CPU: 5 PID: 47 at 
>>>> drivers/net/wireless/intel/iwlwifi/mvm/../iwl-trans.h:1200 iwl_mvm_rx_tx_cmd+0xc65/0xd50 [iwlmvm]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.882380] Modules linked in: ftrace_direct ccm rfcomm snd_seq_dummy 
>>>> snd_hrtimer cmac algif_skcipher snd_ctl_led snd_soc_skl_hda_dsp
>>>> snd_soc_intel_hda_dsp_common snd_soc_hdac_hdmi snd_sof_probes snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic 
>>>> ledtrig_audio bnep joydev uvcvideo videobuf2_vmalloc btusb uvc
>>>> videobuf2_memops btrtl videobuf2_v4l2 btbcm videodev btintel btmtk usbhid videobuf2_common bluetooth mc ecdh_generic ecc 
>>>> snd_soc_dmic snd_sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel
>>>> soundwire_generic_allocation soundwire_cadence hid_multitouch snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof 
>>>> hid_generic snd_sof_utils snd_soc_hdac_hda snd_hda_ext_core
>>>> snd_soc_acpi_intel_match snd_soc_acpi intel_tcc_cooling soundwire_bus x86_pkg_temp_thermal sunrpc mei_pxp intel_powerclamp 
>>>> mei_hdcp snd_soc_core snd_compress coretemp ac97_bus spi_pxa2xx_platform
>>>> crct10dif_pclmul snd_pcm_dmaengine dw_dmac crc32_pclmul dw_dmac_core ghash_clmulni_intel snd_hda_intel sha512_ssse3 8250_dw
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.885849]  snd_intel_dspcfg snd_intel_sdw_acpi aesni_intel crypto_simd 
>>>> wmi_bmof snd_hda_codec cryptd binfmt_misc snd_hda_core rapl snd_hwdep
>>>> pmt_telemetry intel_rapl_msr pmt_class intel_cstate snd_pcm i2c_hid_acpi i915 iwlmvm i2c_hid snd_seq_midi snd_seq_midi_event 
>>>> nls_iso8859_1 snd_rawmidi mac80211 drm_buddy libarc4 ttm snd_seq
>>>> drm_display_helper processor_thermal_device_pci_legacy cec snd_seq_device ideapad_laptop snd_timer btrfs sparse_keymap 
>>>> processor_thermal_device drm_kms_helper iwlwifi platform_profile
>>>> processor_thermal_rfim processor_thermal_mbox int3400_thermal mei_me blake2b_generic xhci_pci xor processor_thermal_rapl video 
>>>> wmi acpi_thermal_rel mei acpi_tad i2c_algo_bit acpi_pad
>>>> int3403_thermal intel_rapl_common snd xhci_pci_renesas i2c_i801 syscopyarea ahci cfg80211 intel_vsec int340x_thermal_zone 
>>>> intel_lpss_pci sysfillrect soundcore i2c_smbus intel_lpss sysimgblt
>>>> intel_soc_dts_iosf libahci igen6_edac idma64 raid6_pq msr parport_pc ppdev lp parport ramoops pstore_blk reed_solomon 
>>>> pstore_zone drm
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.886823]  efi_pstore ip_tables x_tables autofs4 nvme nvme_core input_leds 
>>>> vmd serio_raw mac_hid pinctrl_tigerlake [last unloaded:
>>>> ftrace_direct]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.886986] CPU: 5 PID: 47 Comm: ksoftirqd/5 Not tainted 
>>>> 6.3.0-rc6-mt-20230401-00001-gf86822a1170f #4
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887006] Hardware name: LENOVO 82H8/LNVNB161216, BIOS GGCN51WW 11/16/2022
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887022] RIP: 0010:iwl_mvm_rx_tx_cmd+0xc65/0xd50 [iwlmvm]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887096] Code: 85 c0 74 0d 0f b6 40 27 89 f1 21 c1 84 c0 0f 45 f1 40 0f b6 
>>>> f6 4c 89 ff e8 e8 3f ff ff 41 88 84 24 7e 14 00 00 e9 7c fe ff ff
>>>> <0f> 0b 48 8b 7f 40 48 c7 c1 10 ba fa c0 48 c7 c2 58 ce fb c0 31 f6
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887114] RSP: 0018:ffffb60200267b70 EFLAGS: 00010293
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887142] RAX: 0000000000001c80 RBX: ffff8b5af378c000 RCX: 0000000000000005
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887159] RDX: 0000000000000000 RSI: ffffb60200267bb0 RDI: ffff8b5a8ff20028
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887174] RBP: ffffb60200267c40 R08: 0000000000000000 R09: 0000000000000001
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887189] R10: ffffb60200267c58 R11: 0000000000000000 R12: 0000000000000000
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887205] R13: 0000000000000030 R14: ffffb60200267d18 R15: ffff8b5aa39d33e8
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887221] FS:  0000000000000000(0000) GS:ffff8b5c27a80000(0000) 
>>>> knlGS:0000000000000000
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887238] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887255] CR2: 00007f49f4dfe008 CR3: 000000017d850001 CR4: 0000000000f70ee0
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887271] PKRU: 55555554
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887286] Call Trace:
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887302]  <TASK>
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887359]  ? __pfx_iwl_mvm_rx_tx_cmd+0x10/0x10 [iwlmvm]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887446]  ? iwl_mvm_rx_tx_cmd+0x9/0xd50 [iwlmvm]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887540]  ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887563]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887582]  ? iwl_mvm_rx_common+0xde/0x390 [iwlmvm]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887650]  ? iwl_mvm_rx_mq+0x9/0xc0 [iwlmvm]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887739]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887757]  iwl_mvm_rx_mq+0x79/0xc0 [iwlmvm]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887821]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887839]  iwl_pcie_rx_handle+0x402/0xaa0 [iwlwifi]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887979]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887997]  iwl_pcie_napi_poll_msix+0x39/0xf0 [iwlwifi]
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888086]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888105]  __napi_poll+0x2e/0x1f0
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888146]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888164]  net_rx_action+0x1a5/0x330
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888240]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888258]  __do_softirq+0xb4/0x3a4
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888311]  ? smpboot_thread_fn+0x2a/0x290
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888340]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888358]  run_ksoftirqd+0x44/0x80
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888382]  ? ftrace_regs_caller_end+0x66/0x66
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888400]  smpboot_thread_fn+0x1d9/0x290
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888435]  ? __pfx_smpboot_thread_fn+0x10/0x10
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888458]  kthread+0x10f/0x140
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888481]  ? __pfx_kthread+0x10/0x10
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888517]  ret_from_fork+0x29/0x50
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888609]  </TASK>
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888623] irq event stamp: 4206602
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888636] hardirqs last  enabled at (4206608): [<ffffffffb9a51c98>] 
>>>> __up_console_sem+0x68/0x80
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888657] hardirqs last disabled at (4206613): [<ffffffffb9a51c7d>] 
>>>> __up_console_sem+0x4d/0x80
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888676] softirqs last  enabled at (4196852): [<ffffffffb9965b60>] 
>>>> return_to_handler+0x0/0x40
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888695] softirqs last disabled at (4196891): [<ffffffffb9965b60>] 
>>>> return_to_handler+0x0/0x40
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888714] ---[ end trace 0000000000000000 ]---
>>>> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888732] iwlwifi 0000:00:14.3: iwl_trans_reclaim bad state = 0
>>>>
>>>> Hope this helps.
>>>>
>>>> The platform is Ubuntu 22.10 kinetic kudu on Lenovo IdeaPad 3 15ITL6,
>>>> the above mentioned 6.3-rc6 torvalds tree kernel and GGCN51WW original
>>>> Lenovo BIOS.
>>>>
>>>> Please find the config and the lshw output and this listing at the URL:
>>>>
>>>> → https://domac.alu.unizg.hr/~mtodorov/linux/bugreports/intel/iwlwifi/
>>>
>>> The fault was reproduced while running complete "make kselftest" and having
>>> at the same time Firefox with 100+ tabs and 2 Youtube tabs running.
>>>
>>> Apr 10 00:32:16 marvin-IdeaPad-3-15ITL6 kernel: mmiotrace: disabled.
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Error sending STATISTICS_CMD: time out after 2000ms.
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Current CMD queue read_ptr 54 write_ptr 55
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Transport status: 0x0000004A, valid: 6
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Loaded firmware version: 73.35c0a2c6.0 QuZ-a0-jf-b0-73.ucode
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000084 | NMI_INTERRUPT_UNKNOWN
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x1080A200 | trm_hw_status0
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00010000 | trm_hw_status1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x004C352E | branchlink2
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000638C | interruptlink1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000638C | interruptlink2
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00011864 | data1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01000000 | data2
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | data3
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x5F008D9F | beacon time
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x9892726D | tsf low
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000083 | tsf hi
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00008D3B | time gp1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2124C243 | time gp2
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000001 | uCode revision type
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000049 | uCode version major
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x35C0A2C6 | uCode version minor
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000351 | hw version
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00489001 | board version
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0489001C | hcmd
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xE682B000 | isr0
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x09040000 | isr1
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x08F0011A | isr2
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00C3028C | isr3
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | isr4
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0488001C | last cmd Id
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00011864 | wait_event
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x000000C4 | l2p_control
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00018034 | l2p_duration
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000007 | l2p_mhvalid
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000081 | l2p_addr_match
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000009 | lmpm_pmg_sel
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | timestamp
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000808 | flow_handler
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Transport status: 0x0000004A, valid: 7
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x20000066 | NMI_INTERRUPT_HOST
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | umac branchlink1
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x80453B88 | umac branchlink2
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8046FE32 | umac interruptlink1
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8046FE32 | umac interruptlink2
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01000000 | umac data1
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8046FE32 | umac data2
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | umac data3
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000049 | umac major
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x35C0A2C6 | umac minor
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2124C241 | frame pointer
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xC0886264 | stack pointer
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0036019C | last host cmd
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | isr status reg
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: IML/ROM dump:
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000003 | IML/ROM error/state
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00005404 | IML/ROM data1
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000080 | IML/ROM WFPM_AUTH_KEY_0
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Fseq Registers:
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x60000000 | FSEQ_ERROR_CODE
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x80260000 | FSEQ_TOP_INIT_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00020006 | FSEQ_CNVIO_INIT_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000A384 | FSEQ_OTP_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3D544A68 | FSEQ_TOP_CONTENT_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x4552414E | FSEQ_ALIVE_TOKEN
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x20000302 | FSEQ_CNVI_ID
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01300202 | FSEQ_CNVR_ID
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x20000302 | CNVI_AUX_MISC_CHIP
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01300202 | CNVR_AUX_MISC_CHIP
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000485B | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xA5A5A5A2 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: WRT: Collecting data: ini trigger 4 fired (delay=0ms).
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: ieee80211 phy0: Hardware restart was requested
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Hardware error detected. Restarting.
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: BUG: Apr 10 00:32:16 marvin-IdeaPad-3-15ITL6 kernel: mmiotrace: disabled.
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Error sending STATISTICS_CMD: time out after 2000ms.
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Current CMD queue read_ptr 54 write_ptr 55
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Transport status: 0x0000004A, valid: 6
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Loaded firmware version: 73.35c0a2c6.0 QuZ-a0-jf-b0-73.ucode
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000084 | NMI_INTERRUPT_UNKNOWN
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x1080A200 | trm_hw_status0
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00010000 | trm_hw_status1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x004C352E | branchlink2
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000638C | interruptlink1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000638C | interruptlink2
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00011864 | data1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01000000 | data2
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | data3
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x5F008D9F | beacon time
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x9892726D | tsf low
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000083 | tsf hi
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00008D3B | time gp1
>>> Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2124C243 | time gp2
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000001 | uCode revision type
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000049 | uCode version major
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x35C0A2C6 | uCode version minor
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000351 | hw version
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00489001 | board version
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0489001C | hcmd
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xE682B000 | isr0
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x09040000 | isr1
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x08F0011A | isr2
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00C3028C | isr3
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | isr4
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0488001C | last cmd Id
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00011864 | wait_event
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x000000C4 | l2p_control
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00018034 | l2p_duration
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000007 | l2p_mhvalid
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000081 | l2p_addr_match
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000009 | lmpm_pmg_sel
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | timestamp
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000808 | flow_handler
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Transport status: 0x0000004A, valid: 7
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x20000066 | NMI_INTERRUPT_HOST
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | umac branchlink1
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x80453B88 | umac branchlink2
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8046FE32 | umac interruptlink1
>>> Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8046FE32 | umac interruptlink2
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01000000 | umac data1
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8046FE32 | umac data2
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | umac data3
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000049 | umac major
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x35C0A2C6 | umac minor
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2124C241 | frame pointer
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xC0886264 | stack pointer
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0036019C | last host cmd
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000000 | isr status reg
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: IML/ROM dump:
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000003 | IML/ROM error/state
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00005404 | IML/ROM data1
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00000080 | IML/ROM WFPM_AUTH_KEY_0
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Fseq Registers:
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x60000000 | FSEQ_ERROR_CODE
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x80260000 | FSEQ_TOP_INIT_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x00020006 | FSEQ_CNVIO_INIT_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000A384 | FSEQ_OTP_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3D544A68 | FSEQ_TOP_CONTENT_VERSION
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x4552414E | FSEQ_ALIVE_TOKEN
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x20000302 | FSEQ_CNVI_ID
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01300202 | FSEQ_CNVR_ID
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x20000302 | CNVI_AUX_MISC_CHIP
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x01300202 | CNVR_AUX_MISC_CHIP
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0000485B | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xA5A5A5A2 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: WRT: Collecting data: ini trigger 4 fired (delay=0ms).
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: ieee80211 phy0: Hardware restart was requested
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Hardware error detected. Restarting.
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: BUG: kernel NULL pointer dereference, address: 0000000000000150
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: #PF: supervisor read access in kernel mode
>>> -- Boot 60997fcc74c1448a967138e3f6d00cbf --
>>> Apr 10 00:34:49 marvin-IdeaPad-3-15ITL6 kernel: microcode: updated early: 0xa4 -> 0xa6, date = 2022-06-28
>>>
>>> Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: #PF: supervisor read access in kernel mode
>>> -- Boot 60997fcc74c1448a967138e3f6d00cbf --
>>> Apr 10 00:34:49 marvin-IdeaPad-3-15ITL6 kernel: microcode: updated early: 0xa4 -> 0xa6, date = 2022-06-28
>>>
>>> I will add "make kselftest" log to the directory with lshw and config.
>>>
>>> Best regards,
>>> Mirsad
>>>
>> Thanks for the report!
>> The kernel stack there is not a real kernel crash, but is a result of a WARN_ON() in the code.
>> However, there's a kernel NULL pointer deref later. Can I ask you to collect a log of the
>> crash itself? Maybe with netconsole if the machine completely crashes?
> 
> Hi, Mr. Greenman,
> 
> Did you see the provided journalctl at the link?
> 
> I have found this interesting information:
> 
>                                                  other info that might help us debug this:
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  Possible unsafe locking scenario:
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        CPU0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        ----
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   lock(&local->queue_stop_reason_lock);
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   <Interrupt>
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:     lock(&local->queue_stop_reason_lock);
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:
>                                                   *** DEADLOCK ***
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel: 8 locks held by kworker/5:0/25656:
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #0: ffff9d618009d138 ((wq_completion)events_freezable){+.+.}-{0:0}, at: 
> process_one_work+0x1ca/0x530
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #1: ffffb1ef4637fe68 ((work_completion)(&local->restart_work)){+.+.}-{0:0}, at: 
> process_one_work+0x1ce/0x530
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #2: ffffffff9f166548 (rtnl_mutex){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #3: ffff9d6190778728 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #4: ffff9d619077b480 (&mvm->mutex){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #5: ffff9d61907bacd8 (&trans_pcie->mutex){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #6: ffffffff9ef9cda0 (rcu_read_lock){....}-{1:2}, at: 
> iwl_mvm_queue_state_change+0x59/0x3a0 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  #7: ffffffff9ef9cda0 (rcu_read_lock){....}-{1:2}, at: 
> iwl_mvm_mac_itxq_xmit+0x42/0x210 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:
>                                                  stack backtrace:
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel: CPU: 5 PID: 25656 Comm: kworker/5:0 Tainted: G        W 
> 6.3.0-rc6-mt-20230401-00001-gf86822a1170f #4
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel: Hardware name: LENOVO 82H8/LNVNB161216, BIOS GGCN51WW 11/16/2022
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel: Workqueue: events_freezable ieee80211_restart_work [mac80211]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel: Call Trace:
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  <TASK>
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  dump_stack_lvl+0x5f/0xa0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  dump_stack+0x14/0x20
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  print_usage_bug.part.46+0x208/0x2a0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  mark_lock.part.47+0x605/0x630
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? sched_clock+0xd/0x20
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? trace_clock_local+0x14/0x30
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? __rb_reserve_next+0x5f/0x490
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? _raw_spin_lock+0x1b/0x50
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  __lock_acquire+0x464/0x1990
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? mark_held_locks+0x4e/0x80
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  lock_acquire+0xc7/0x2d0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_return_to_handler+0x8b/0x100
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? preempt_count_add+0x4/0x70
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  _raw_spin_lock+0x36/0x50
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ieee80211_tx_dequeue+0xb4/0x1330 [mac80211]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? prepare_ftrace_return+0xc5/0x190
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_graph_func+0x16/0x20
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? 0xffffffffc02ab0b1
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? lock_acquire+0xc7/0x2d0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? iwl_mvm_mac_itxq_xmit+0x42/0x210 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ieee80211_tx_dequeue+0x9/0x1330 [mac80211]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? __rcu_read_lock+0x4/0x40
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_mvm_mac_itxq_xmit+0xae/0x210 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_mvm_queue_state_change+0x311/0x3a0 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_mvm_wake_sw_queue+0x17/0x20 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_txq_gen2_unmap+0x1c9/0x1f0 [iwlwifi]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_txq_gen2_free+0x55/0x130 [iwlwifi]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_txq_gen2_tx_free+0x63/0x80 [iwlwifi]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  _iwl_trans_pcie_gen2_stop_device+0x3f3/0x5b0 [iwlwifi]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? _iwl_trans_pcie_gen2_stop_device+0x9/0x5b0 [iwlwifi]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? mutex_lock_nested+0x4/0x30
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_trans_pcie_gen2_stop_device+0x5f/0x90 [iwlwifi]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_mvm_stop_device+0x78/0xd0 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  __iwl_mvm_mac_start+0x114/0x210 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  iwl_mvm_mac_start+0x76/0x150 [iwlmvm]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  drv_start+0x79/0x180 [mac80211]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ieee80211_reconfig+0x1523/0x1ce0 [mac80211]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? synchronize_net+0x4/0x50
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ieee80211_restart_work+0x108/0x170 [mac80211]
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  process_one_work+0x250/0x530
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? ftrace_regs_caller_end+0x66/0x66
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  worker_thread+0x48/0x3a0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? __pfx_worker_thread+0x10/0x10
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  kthread+0x10f/0x140
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ? __pfx_kthread+0x10/0x10
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  ret_from_fork+0x29/0x50
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  </TASK>
> 
> Other than this, I am not technically savvy enough to give the other possible logs
> than /var/log/syslog and journalctl ...
> 
> Could you please give additional instructions.
> 
> Thank you very much.

Hi, Gregory,

I have browsed through the material I provided, and somehow the NULL pointer dereference is not
there in the logs. But I am certain that I have copied this line with the kernel BUG from the
logs. I haven't erased any logs yet, so I believe I will be able to recover these log lines
as soon as I get physically to the device.

Best regards,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union

Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu



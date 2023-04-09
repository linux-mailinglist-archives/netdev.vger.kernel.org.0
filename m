Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DA66DC20A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 01:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDIXnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 19:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIXni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 19:43:38 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D5130D8;
        Sun,  9 Apr 2023 16:43:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 5C3D9604F9;
        Mon, 10 Apr 2023 01:43:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681083812; bh=Y79VZenj1k2ZKixdKSz00yHNAbJEeRKLOykwV/IVnDw=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=YDV1EeWlF02MDXX8NRwvJwfZf/ZQUYIkHY1fQzTSh9GJssU/4PUokXNXBy2a0ZgF3
         5A8DaX9QHUiN2B6s9JCGxYNfTAlY5gROP62Y8w+kp1sfQS1wGfGV1SUDKLC3W9XmZN
         iYOEbb28SH7LFt9sd9VO1zF6nqdT8li4824ORpPVF0rfFJn4kTWiDyh/jbARGma/g5
         a6mbyFP3QwI9TncmFEOQTmsimeC4Ziy92QCGyp1bbxU4n3rHbG0BSPwqt42h6D3Uax
         SQSlTEkpPaMCfNo+hfsMS33+kf7qoqcwoc0FeX7rJoHDqCZ/1aB0f1Bwh08g5xpa81
         +aS7ZudEP+/WA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kXjQaZzSxB1T; Mon, 10 Apr 2023 01:43:28 +0200 (CEST)
Received: from [192.168.1.4] (unknown [94.250.188.177])
        by domac.alu.hr (Postfix) with ESMTPSA id 3EBCA604ED;
        Mon, 10 Apr 2023 01:43:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681083808; bh=Y79VZenj1k2ZKixdKSz00yHNAbJEeRKLOykwV/IVnDw=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=tg5pXpTmdo9WhzLeprYuPOoTLKUaktiTjSsgKnSFFQQTehRNJ+FitOdCDnXHJVq8B
         XACYpfMNsWxp12JoU99Q0c9Yt8+Tb9tPRNJeQ4cTlGKSlqdcLY1Bq5EThSBUv4EmLh
         XoCStpi8J9dklT+Rd7zPaFuAxtl3++Jh1Rd/+KDQBbhVrNYNn25+VDaD936vWWTP44
         mvoc06qI6IVYMPBBcW0FTpJsWPYSuoZHB+NG7ruKshCWog7u7gdS+bk2GjOjgjVb9c
         EUPaYY6dWwwVfKTADfphCM3cBQ7nnnOxDGMC7OPbnBoxMM0WHD/UqQE4EUEtN/DOYA
         54ijzXQBmyzvA==
Message-ID: <4008aff6-c432-dd0f-fcf6-1d384b809cd4@alu.unizg.hr>
Date:   Mon, 10 Apr 2023 01:43:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: BUG: drivers/net/wireless: iwlwifi: IWL Error: "BUG: kernel NULL
 pointer dereference, address: 0000000000000150"
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr>
Content-Language: en-US, hr
In-Reply-To: <1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10. 04. 2023. 00:21, Mirsad Goran Todorovac wrote:
> Hi all,
>=20
> This is an error is the syslog found after investigating a Youtube FF c=
hirping hang
> while running kseftest of 6.3-rc6 torvalds tree kernel.
>=20
> Running multimedia and kselftest might seem off, but multimedia perform=
ance on Linux
> and open source software is a very interesting research area.
>=20
> Here is the trace from the log:
>=20
> Apr  9 23:01:11 marvin-IdeaPad-3-15ITL6 kernel: [  615.957145] mmiotrac=
e: disabled.
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.881758] iwlwifi =
0000:00:14.3: Error sending STATISTICS_CMD: time out after 2000ms.
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.882332] iwlwifi =
0000:00:14.3: Current CMD queue read_ptr 67 write_ptr 68
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884299] iwlwifi =
0000:00:14.3: Start IWL Error Log Dump:
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884373] iwlwifi =
0000:00:14.3: Transport status: 0x0000004A, valid: 6
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884446] iwlwifi =
0000:00:14.3: Loaded firmware version: 73.35c0a2c6.0 QuZ-a0-jf-b0-73.ucod=
e
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884520] iwlwifi =
0000:00:14.3: 0x00000084 | NMI_INTERRUPT_UNKNOWN      =20
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884624] iwlwifi =
0000:00:14.3: 0x000022F0 | trm_hw_status0
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884695] iwlwifi =
0000:00:14.3: 0x00000000 | trm_hw_status1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884766] iwlwifi =
0000:00:14.3: 0x004C352E | branchlink2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884837] iwlwifi =
0000:00:14.3: 0x004BA12A | interruptlink1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884907] iwlwifi =
0000:00:14.3: 0x004BA12A | interruptlink2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885309] iwlwifi =
0000:00:14.3: 0x0000CEEA | data1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885444] iwlwifi =
0000:00:14.3: 0x01000000 | data2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885526] iwlwifi =
0000:00:14.3: 0x00000000 | data3
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885598] iwlwifi =
0000:00:14.3: 0x840075C7 | beacon time
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885670] iwlwifi =
0000:00:14.3: 0x5282AA44 | tsf low
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885741] iwlwifi =
0000:00:14.3: 0x00000082 | tsf hi
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885812] iwlwifi =
0000:00:14.3: 0x00000000 | time gp1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885885] iwlwifi =
0000:00:14.3: 0x24D400DC | time gp2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885963] iwlwifi =
0000:00:14.3: 0x00000001 | uCode revision type
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886040] iwlwifi =
0000:00:14.3: 0x00000049 | uCode version major
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886117] iwlwifi =
0000:00:14.3: 0x35C0A2C6 | uCode version minor
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886193] iwlwifi =
0000:00:14.3: 0x00000351 | hw version
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886268] iwlwifi =
0000:00:14.3: 0x00489001 | board version
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886344] iwlwifi =
0000:00:14.3: 0x80B3F400 | hcmd
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886420] iwlwifi =
0000:00:14.3: 0x00020000 | isr0
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886496] iwlwifi =
0000:00:14.3: 0x00000000 | isr1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886632] iwlwifi =
0000:00:14.3: 0x08F00002 | isr2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886750] iwlwifi =
0000:00:14.3: 0x00C3028C | isr3
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886889] iwlwifi =
0000:00:14.3: 0x00000000 | isr4
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887035] iwlwifi =
0000:00:14.3: 0x05C8001C | last cmd Id
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887180] iwlwifi =
0000:00:14.3: 0x0000CEEA | wait_event
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887326] iwlwifi =
0000:00:14.3: 0x00000854 | l2p_control
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887467] iwlwifi =
0000:00:14.3: 0x00000020 | l2p_duration
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887610] iwlwifi =
0000:00:14.3: 0x0000000F | l2p_mhvalid
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887756] iwlwifi =
0000:00:14.3: 0x00000000 | l2p_addr_match
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887895] iwlwifi =
0000:00:14.3: 0x00000009 | lmpm_pmg_sel
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888150] iwlwifi =
0000:00:14.3: 0x00000000 | timestamp
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888288] iwlwifi =
0000:00:14.3: 0x00006868 | flow_handler
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888730] iwlwifi =
0000:00:14.3: Start IWL Error Log Dump:
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888867] iwlwifi =
0000:00:14.3: Transport status: 0x0000004A, valid: 7
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889159] iwlwifi =
0000:00:14.3: 0x20000066 | NMI_INTERRUPT_HOST
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889306] iwlwifi =
0000:00:14.3: 0x00000000 | umac branchlink1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889450] iwlwifi =
0000:00:14.3: 0x80453B88 | umac branchlink2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889594] iwlwifi =
0000:00:14.3: 0x8046FE32 | umac interruptlink1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889740] iwlwifi =
0000:00:14.3: 0x8046FE32 | umac interruptlink2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889886] iwlwifi =
0000:00:14.3: 0x01000000 | umac data1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890033] iwlwifi =
0000:00:14.3: 0x8046FE32 | umac data2
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890176] iwlwifi =
0000:00:14.3: 0x00000000 | umac data3
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890323] iwlwifi =
0000:00:14.3: 0x00000049 | umac major
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890468] iwlwifi =
0000:00:14.3: 0x35C0A2C6 | umac minor
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890613] iwlwifi =
0000:00:14.3: 0x24D400DA | frame pointer
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890759] iwlwifi =
0000:00:14.3: 0xC0886264 | stack pointer
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890905] iwlwifi =
0000:00:14.3: 0x0043019C | last host cmd
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891050] iwlwifi =
0000:00:14.3: 0x00000000 | isr status reg
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891323] iwlwifi =
0000:00:14.3: IML/ROM dump:
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891469] iwlwifi =
0000:00:14.3: 0x00000003 | IML/ROM error/state
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891731] iwlwifi =
0000:00:14.3: 0x000053F8 | IML/ROM data1
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891997] iwlwifi =
0000:00:14.3: 0x00000080 | IML/ROM WFPM_AUTH_KEY_0
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.892216] iwlwifi =
0000:00:14.3: Fseq Registers:
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.893775] iwlwifi =
0000:00:14.3: 0x60000000 | FSEQ_ERROR_CODE
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.893927] iwlwifi =
0000:00:14.3: 0x80260000 | FSEQ_TOP_INIT_VERSION
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894077] iwlwifi =
0000:00:14.3: 0x00020006 | FSEQ_CNVIO_INIT_VERSION
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894227] iwlwifi =
0000:00:14.3: 0x0000A384 | FSEQ_OTP_VERSION
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894374] iwlwifi =
0000:00:14.3: 0x3D544A68 | FSEQ_TOP_CONTENT_VERSION
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894526] iwlwifi =
0000:00:14.3: 0x4552414E | FSEQ_ALIVE_TOKEN
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894675] iwlwifi =
0000:00:14.3: 0x20000302 | FSEQ_CNVI_ID
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894826] iwlwifi =
0000:00:14.3: 0x01300202 | FSEQ_CNVR_ID
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894976] iwlwifi =
0000:00:14.3: 0x20000302 | CNVI_AUX_MISC_CHIP
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895129] iwlwifi =
0000:00:14.3: 0x01300202 | CNVR_AUX_MISC_CHIP
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895282] iwlwifi =
0000:00:14.3: 0x0000485B | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895463] iwlwifi =
0000:00:14.3: 0xA5A5A5A2 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.898477] iwlwifi =
0000:00:14.3: WRT: Collecting data: ini trigger 4 fired (delay=3D0ms).
> Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.899785] ieee8021=
1 phy0: Hardware restart was requested
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.878162] iwlwifi =
0000:00:14.3: HCMD_ACTIVE already clear for command STATISTICS_CMD
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.878273] iwlwifi =
0000:00:14.3: Hardware error detected. Restarting.
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.881860] --------=
----[ cut here ]------------
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.882201] WARNING:=
 CPU: 5 PID: 47 at drivers/net/wireless/intel/iwlwifi/mvm/../iwl-trans.h:=
1200 iwl_mvm_rx_tx_cmd+0xc65/0xd50 [iwlmvm]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.882380] Modules =
linked in: ftrace_direct ccm rfcomm snd_seq_dummy snd_hrtimer cmac algif_=
skcipher snd_ctl_led snd_soc_skl_hda_dsp snd_soc_intel_hda_dsp_common snd=
_soc_hdac_hdmi snd_sof_probes snd_hda_codec_hdmi snd_hda_codec_realtek sn=
d_hda_codec_generic ledtrig_audio bnep joydev uvcvideo videobuf2_vmalloc =
btusb uvc videobuf2_memops btrtl videobuf2_v4l2 btbcm videodev btintel bt=
mtk usbhid videobuf2_common bluetooth mc ecdh_generic ecc snd_soc_dmic sn=
d_sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel soundwire_ge=
neric_allocation soundwire_cadence hid_multitouch snd_sof_intel_hda snd_s=
of_pci snd_sof_xtensa_dsp snd_sof hid_generic snd_sof_utils snd_soc_hdac_=
hda snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi intel_tcc_cool=
ing soundwire_bus x86_pkg_temp_thermal sunrpc mei_pxp intel_powerclamp me=
i_hdcp snd_soc_core snd_compress coretemp ac97_bus spi_pxa2xx_platform cr=
ct10dif_pclmul snd_pcm_dmaengine dw_dmac crc32_pclmul dw_dmac_core ghash_=
clmulni_intel snd_hda_intel sha512_ssse3 8250_dw
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.885849]  snd_int=
el_dspcfg snd_intel_sdw_acpi aesni_intel crypto_simd wmi_bmof snd_hda_cod=
ec cryptd binfmt_misc snd_hda_core rapl snd_hwdep pmt_telemetry intel_rap=
l_msr pmt_class intel_cstate snd_pcm i2c_hid_acpi i915 iwlmvm i2c_hid snd=
_seq_midi snd_seq_midi_event nls_iso8859_1 snd_rawmidi mac80211 drm_buddy=
 libarc4 ttm snd_seq drm_display_helper processor_thermal_device_pci_lega=
cy cec snd_seq_device ideapad_laptop snd_timer btrfs sparse_keymap proces=
sor_thermal_device drm_kms_helper iwlwifi platform_profile processor_ther=
mal_rfim processor_thermal_mbox int3400_thermal mei_me blake2b_generic xh=
ci_pci xor processor_thermal_rapl video wmi acpi_thermal_rel mei acpi_tad=
 i2c_algo_bit acpi_pad int3403_thermal intel_rapl_common snd xhci_pci_ren=
esas i2c_i801 syscopyarea ahci cfg80211 intel_vsec int340x_thermal_zone i=
ntel_lpss_pci sysfillrect soundcore i2c_smbus intel_lpss sysimgblt intel_=
soc_dts_iosf libahci igen6_edac idma64 raid6_pq msr parport_pc ppdev lp p=
arport ramoops pstore_blk reed_solomon pstore_zone drm
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.886823]  efi_pst=
ore ip_tables x_tables autofs4 nvme nvme_core input_leds vmd serio_raw ma=
c_hid pinctrl_tigerlake [last unloaded: ftrace_direct]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.886986] CPU: 5 P=
ID: 47 Comm: ksoftirqd/5 Not tainted 6.3.0-rc6-mt-20230401-00001-gf86822a=
1170f #4
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887006] Hardware=
 name: LENOVO 82H8/LNVNB161216, BIOS GGCN51WW 11/16/2022
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887022] RIP: 001=
0:iwl_mvm_rx_tx_cmd+0xc65/0xd50 [iwlmvm]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887096] Code: 85=
 c0 74 0d 0f b6 40 27 89 f1 21 c1 84 c0 0f 45 f1 40 0f b6 f6 4c 89 ff e8 =
e8 3f ff ff 41 88 84 24 7e 14 00 00 e9 7c fe ff ff <0f> 0b 48 8b 7f 40 48=
 c7 c1 10 ba fa c0 48 c7 c2 58 ce fb c0 31 f6
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887114] RSP: 001=
8:ffffb60200267b70 EFLAGS: 00010293
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887142] RAX: 000=
0000000001c80 RBX: ffff8b5af378c000 RCX: 0000000000000005
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887159] RDX: 000=
0000000000000 RSI: ffffb60200267bb0 RDI: ffff8b5a8ff20028
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887174] RBP: fff=
fb60200267c40 R08: 0000000000000000 R09: 0000000000000001
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887189] R10: fff=
fb60200267c58 R11: 0000000000000000 R12: 0000000000000000
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887205] R13: 000=
0000000000030 R14: ffffb60200267d18 R15: ffff8b5aa39d33e8
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887221] FS:  000=
0000000000000(0000) GS:ffff8b5c27a80000(0000) knlGS:0000000000000000
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887238] CS:  001=
0 DS: 0000 ES: 0000 CR0: 0000000080050033
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887255] CR2: 000=
07f49f4dfe008 CR3: 000000017d850001 CR4: 0000000000f70ee0
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887271] PKRU: 55=
555554
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887286] Call Tra=
ce:
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887302]  <TASK>
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887359]  ? __pfx=
_iwl_mvm_rx_tx_cmd+0x10/0x10 [iwlmvm]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887446]  ? iwl_m=
vm_rx_tx_cmd+0x9/0xd50 [iwlmvm]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887540]  ftrace_=
regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887563]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887582]  ? iwl_m=
vm_rx_common+0xde/0x390 [iwlmvm]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887650]  ? iwl_m=
vm_rx_mq+0x9/0xc0 [iwlmvm]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887739]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887757]  iwl_mvm=
_rx_mq+0x79/0xc0 [iwlmvm]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887821]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887839]  iwl_pci=
e_rx_handle+0x402/0xaa0 [iwlwifi]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887979]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887997]  iwl_pci=
e_napi_poll_msix+0x39/0xf0 [iwlwifi]
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888086]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888105]  __napi_=
poll+0x2e/0x1f0
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888146]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888164]  net_rx_=
action+0x1a5/0x330
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888240]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888258]  __do_so=
ftirq+0xb4/0x3a4
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888311]  ? smpbo=
ot_thread_fn+0x2a/0x290
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888340]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888358]  run_kso=
ftirqd+0x44/0x80
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888382]  ? ftrac=
e_regs_caller_end+0x66/0x66
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888400]  smpboot=
_thread_fn+0x1d9/0x290
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888435]  ? __pfx=
_smpboot_thread_fn+0x10/0x10
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888458]  kthread=
+0x10f/0x140
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888481]  ? __pfx=
_kthread+0x10/0x10
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888517]  ret_fro=
m_fork+0x29/0x50
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888609]  </TASK>=

> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888623] irq even=
t stamp: 4206602
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888636] hardirqs=
 last  enabled at (4206608): [<ffffffffb9a51c98>] __up_console_sem+0x68/0=
x80
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888657] hardirqs=
 last disabled at (4206613): [<ffffffffb9a51c7d>] __up_console_sem+0x4d/0=
x80
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888676] softirqs=
 last  enabled at (4196852): [<ffffffffb9965b60>] return_to_handler+0x0/0=
x40
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888695] softirqs=
 last disabled at (4196891): [<ffffffffb9965b60>] return_to_handler+0x0/0=
x40
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888714] ---[ end=
 trace 0000000000000000 ]---
> Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888732] iwlwifi =
0000:00:14.3: iwl_trans_reclaim bad state =3D 0
>=20
> Hope this helps.
>=20
> The platform is Ubuntu 22.10 kinetic kudu on Lenovo IdeaPad 3 15ITL6,
> the above mentioned 6.3-rc6 torvalds tree kernel and GGCN51WW original
> Lenovo BIOS.
>=20
> Please find the config and the lshw output and this listing at the URL:=

>=20
> =E2=86=92 https://domac.alu.unizg.hr/~mtodorov/linux/bugreports/intel/i=
wlwifi/

The fault was reproduced while running complete "make kselftest" and havi=
ng
at the same time Firefox with 100+ tabs and 2 Youtube tabs running.

Apr 10 00:32:16 marvin-IdeaPad-3-15ITL6 kernel: mmiotrace: disabled.
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Err=
or sending STATISTICS_CMD: time out after 2000ms.
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Cur=
rent CMD queue read_ptr 54 write_ptr 55
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Sta=
rt IWL Error Log Dump:
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Tra=
nsport status: 0x0000004A, valid: 6
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Loa=
ded firmware version: 73.35c0a2c6.0 QuZ-a0-jf-b0-73.ucode
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000084 | NMI_INTERRUPT_UNKNOWN      =20
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x1=
080A200 | trm_hw_status0
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0010000 | trm_hw_status1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
04C352E | branchlink2
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000638C | interruptlink1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000638C | interruptlink2
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0011864 | data1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1000000 | data2
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | data3
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x5=
F008D9F | beacon time
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x9=
892726D | tsf low
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000083 | tsf hi
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0008D3B | time gp1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
124C243 | time gp2
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000001 | uCode revision type
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000049 | uCode version major
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3=
5C0A2C6 | uCode version minor
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000351 | hw version
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0489001 | board version
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
489001C | hcmd
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xE=
682B000 | isr0
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
9040000 | isr1
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
8F0011A | isr2
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0C3028C | isr3
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | isr4
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
488001C | last cmd Id
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0011864 | wait_event
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
00000C4 | l2p_control
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0018034 | l2p_duration
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000007 | l2p_mhvalid
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000081 | l2p_addr_match
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000009 | lmpm_pmg_sel
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | timestamp
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000808 | flow_handler
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Sta=
rt IWL Error Log Dump:
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Tra=
nsport status: 0x0000004A, valid: 7
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
0000066 | NMI_INTERRUPT_HOST
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | umac branchlink1
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
0453B88 | umac branchlink2
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
046FE32 | umac interruptlink1
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
046FE32 | umac interruptlink2
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1000000 | umac data1
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
046FE32 | umac data2
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | umac data3
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000049 | umac major
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3=
5C0A2C6 | umac minor
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
124C241 | frame pointer
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xC=
0886264 | stack pointer
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
036019C | last host cmd
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | isr status reg
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: IML=
/ROM dump:
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000003 | IML/ROM error/state
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0005404 | IML/ROM data1
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000080 | IML/ROM WFPM_AUTH_KEY_0
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Fse=
q Registers:
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x6=
0000000 | FSEQ_ERROR_CODE
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
0260000 | FSEQ_TOP_INIT_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0020006 | FSEQ_CNVIO_INIT_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000A384 | FSEQ_OTP_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3=
D544A68 | FSEQ_TOP_CONTENT_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x4=
552414E | FSEQ_ALIVE_TOKEN
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
0000302 | FSEQ_CNVI_ID
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1300202 | FSEQ_CNVR_ID
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
0000302 | CNVI_AUX_MISC_CHIP
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1300202 | CNVR_AUX_MISC_CHIP
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000485B | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xA=
5A5A5A2 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: WRT=
: Collecting data: ini trigger 4 fired (delay=3D0ms).
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: ieee80211 phy0: Hardware =
restart was requested
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Har=
dware error detected. Restarting.
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: BUG: Apr 10 00:32:16 marv=
in-IdeaPad-3-15ITL6 kernel: mmiotrace: disabled.
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Err=
or sending STATISTICS_CMD: time out after 2000ms.
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Cur=
rent CMD queue read_ptr 54 write_ptr 55
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Sta=
rt IWL Error Log Dump:
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Tra=
nsport status: 0x0000004A, valid: 6
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Loa=
ded firmware version: 73.35c0a2c6.0 QuZ-a0-jf-b0-73.ucode
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000084 | NMI_INTERRUPT_UNKNOWN      =20
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x1=
080A200 | trm_hw_status0
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0010000 | trm_hw_status1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
04C352E | branchlink2
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000638C | interruptlink1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000638C | interruptlink2
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0011864 | data1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1000000 | data2
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | data3
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x5=
F008D9F | beacon time
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x9=
892726D | tsf low
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000083 | tsf hi
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0008D3B | time gp1
Apr 10 00:32:36 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
124C243 | time gp2
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000001 | uCode revision type
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000049 | uCode version major
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3=
5C0A2C6 | uCode version minor
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000351 | hw version
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0489001 | board version
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
489001C | hcmd
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xE=
682B000 | isr0
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
9040000 | isr1
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
8F0011A | isr2
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0C3028C | isr3
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | isr4
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
488001C | last cmd Id
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0011864 | wait_event
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
00000C4 | l2p_control
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0018034 | l2p_duration
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000007 | l2p_mhvalid
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000081 | l2p_addr_match
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000009 | lmpm_pmg_sel
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | timestamp
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000808 | flow_handler
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Sta=
rt IWL Error Log Dump:
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Tra=
nsport status: 0x0000004A, valid: 7
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
0000066 | NMI_INTERRUPT_HOST
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | umac branchlink1
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
0453B88 | umac branchlink2
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
046FE32 | umac interruptlink1
Apr 10 00:32:37 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
046FE32 | umac interruptlink2
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1000000 | umac data1
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
046FE32 | umac data2
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | umac data3
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000049 | umac major
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3=
5C0A2C6 | umac minor
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
124C241 | frame pointer
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xC=
0886264 | stack pointer
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
036019C | last host cmd
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000000 | isr status reg
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: IML=
/ROM dump:
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000003 | IML/ROM error/state
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0005404 | IML/ROM data1
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0000080 | IML/ROM WFPM_AUTH_KEY_0
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Fse=
q Registers:
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x6=
0000000 | FSEQ_ERROR_CODE
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x8=
0260000 | FSEQ_TOP_INIT_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
0020006 | FSEQ_CNVIO_INIT_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000A384 | FSEQ_OTP_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x3=
D544A68 | FSEQ_TOP_CONTENT_VERSION
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x4=
552414E | FSEQ_ALIVE_TOKEN
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
0000302 | FSEQ_CNVI_ID
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1300202 | FSEQ_CNVR_ID
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x2=
0000302 | CNVI_AUX_MISC_CHIP
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
1300202 | CNVR_AUX_MISC_CHIP
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0x0=
000485B | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: 0xA=
5A5A5A2 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: WRT=
: Collecting data: ini trigger 4 fired (delay=3D0ms).
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: ieee80211 phy0: Hardware =
restart was requested
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: iwlwifi 0000:00:14.3: Har=
dware error detected. Restarting.
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: BUG: kernel NULL pointer =
dereference, address: 0000000000000150
Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: #PF: supervisor read acce=
ss in kernel mode
-- Boot 60997fcc74c1448a967138e3f6d00cbf --
Apr 10 00:34:49 marvin-IdeaPad-3-15ITL6 kernel: microcode: updated early:=
 0xa4 -> 0xa6, date =3D 2022-06-28

Apr 10 00:32:38 marvin-IdeaPad-3-15ITL6 kernel: #PF: supervisor read acce=
ss in kernel mode
-- Boot 60997fcc74c1448a967138e3f6d00cbf --
Apr 10 00:34:49 marvin-IdeaPad-3-15ITL6 kernel: microcode: updated early:=
 0xa4 -> 0xa6, date =3D 2022-06-28

I will add "make kselftest" log to the directory with lshw and config.

Best regards,
Mirsad

--=20
Mirsad Goran Todorovac
Sistem in=C5=BEenjer
Grafi=C4=8Dki fakultet | Akademija likovnih umjetnosti
Sveu=C4=8Dili=C5=A1te u Zagrebu
=20
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

"I see something approaching fast ... Will it be friends with me?"


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C0680618
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 07:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbjA3Gnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 01:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjA3Gnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 01:43:31 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4C213DEF;
        Sun, 29 Jan 2023 22:43:28 -0800 (PST)
Received: from [10.59.106.37] (unknown [77.235.169.38])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 51C6561CC457B;
        Mon, 30 Jan 2023 07:43:24 +0100 (CET)
Message-ID: <b55d06ad-5031-791c-b79c-6a5014020aec@molgen.mpg.de>
Date:   Mon, 30 Jan 2023 07:43:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/4] Attempt at adding WCN6855 BT support
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
References: <20230129215136.5557-1-steev@kali.org>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230129215136.5557-1-steev@kali.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc: +Mark Pearson]

Dear Steev,


Am 29.01.23 um 22:51 schrieb Steev Klimaszewski:
> This patchset is somewhat of an RFC/RFT, and also just something to get this out
> there.
> 
> First things first, I do not have access to the specs nor the schematics, so a
> lot of this was done via guess work, looking at the acpi tables, and looking at
> how a similar device (wcn6750) was added.
> 
> There are definitely checkpatch warnings, and I do apologize to those who won't
> review things until there are no warnings for wasting your time.
> 
> One example is that I have the vregs commented out, the dt-bindings say that
> they are required since it's based on the wcn6750 work but also like the 6750,
> I've added defaults into the driver, and those seem to work, at least for the
> initial testing.
> 
> The end result is that we do have a working device, but not entirely reliable.
> 
> Hopefully by getting this out there, people who do have access to the specs or
> schematics can see where the improvements or fixes need to come.

Thank you for the patches. Reading until the end and seeing patch 4/4, 
this is related to the Lenovo Thinkpad X13s. I am adding Mark Pearson to 
the Cc list. No idea if GNU/Linux is officially supported by Lenovo, but 
even if not, maybe Mark is able to get you access to the specifications 
and schematics.


Kind regards,

Paul


> There are a few things that I am not sure why they happen, and don't have the
> knowledge level to figure out why they happen or debugging it.
> 
> Bluetooth: hci0: setting up wcn6855
> Bluetooth: hci0: Frame reassembly failed (-84)
> Bluetooth: hci0: QCA Product ID   :0x00000013
> Bluetooth: hci0: QCA SOC Version  :0x400c0210
> Bluetooth: hci0: QCA ROM Version  :0x00000201
> Bluetooth: hci0: QCA Patch Version:0x000038e6
> Bluetooth: hci0: QCA controller version 0x02100201
> Bluetooth: hci0: unexpected event for opcode 0xfc48
> Bluetooth: hci0: Sending QCA Patch config failed (-110)
> Bluetooth: hci0: QCA Downloading qca/hpbtfw21.tlv
> Bluetooth: hci0: QCA Downloading qca/hpnv21g.bin
> Bluetooth: hci0: QCA setup on UART is completed
> 
> I do not know why the Frame assembly failed, nor the unexpected event.
> 
> Likewise, I'm not entirely sure why it says the patch config send times out, and
> *then* seems to send it?
> 
> The BD Address also seems to be incorrect, and I'm not sure what is going on
> there either.
> 
> Additionally, I've tried with an additional patch that I'm not including that is
> based on commit 059924fdf6c1 ("Bluetooth: btqca: Use NVM files based on SoC ID
> for WCN3991") to try using the hpnv21g.bin or hpnv21.bin, and the firmware acted
> the same regardless, so I am assuming I don't truly need the "g" firmware on my
> Thinkpad X13s.
> 
> Testing was done by connecting a Razer Orochi bluetooth mouse, and using it, as
> well as connecting to and using an H2GO bluetooth speaker and playing audio out
> via canberra-gtk-play as well as a couple of YouTube videos in a browser.
> 
> The mouse only seems to work when < 2 ft. from the laptop, and for the speaker, only
> "A2DP Sink, codec SBC" would provide audio output, and while I could see that
> data was being sent to the speaker, it wasn't always outputting, and going >
> 4ft. away, would often disconnect.
> 
> steev@wintermute:~$ hciconfig -a
> hci0:   Type: Primary  Bus: UART
>          BD Address: 00:00:00:00:5A:AD  ACL MTU: 1024:8  SCO MTU: 240:4
>          UP RUNNING PSCAN
>          RX bytes:1492 acl:0 sco:0 events:126 errors:0
>          TX bytes:128743 acl:0 sco:0 commands:597 errors:0
>          Features: 0xff 0xfe 0x8f 0xfe 0xd8 0x3f 0x5b 0x87
>          Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
>          Link policy: RSWITCH HOLD SNIFF
>          Link mode: PERIPHERAL ACCEPT
>          Name: 'wintermute'
>          Class: 0x0c010c
>          Service Classes: Rendering, Capturing
>          Device Class: Computer, Laptop
>          HCI Version:  (0xc)  Revision: 0x0
>          LMP Version:  (0xc)  Subversion: 0x46f7
>          Manufacturer: Qualcomm (29)
> 
> steev@wintermute:~$ dmesg | grep Razer
> [ 3089.235440] input: Razer Orochi as /devices/virtual/misc/uhid/0005:1532:0056.0003/input/input11
> [ 3089.238580] hid-generic 0005:1532:0056.0003: input,hidraw2: BLUETOOTH HID v0.01 Mouse [Razer Orochi] on 00:00:00:00:5a:ad
> steev@wintermute:~$ dmesg | grep H2GO
> [ 3140.959947] input: H2GO Speaker (AVRCP) as /devices/virtual/input/input12
> 
> Bjorn Andersson (1):
>    arm64: dts: qcom: sc8280xp: Enable BT
> 
> Steev Klimaszewski (3):
>    dt-bindings: net: Add WCN6855 Bluetooth bindings
>    Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
>    arm64: dts: qcom: thinkpad-x13s: Add bluetooth
> 
>   .../net/bluetooth/qualcomm-bluetooth.yaml     |  2 +
>   .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 68 +++++++++++++++++++
>   arch/arm64/boot/dts/qcom/sc8280xp.dtsi        | 14 ++++
>   drivers/bluetooth/btqca.c                     | 24 ++++++-
>   drivers/bluetooth/btqca.h                     | 10 +++
>   drivers/bluetooth/hci_qca.c                   | 59 ++++++++++++----
>   6 files changed, 162 insertions(+), 15 deletions(-)
> 
> 
> base-commit: e2f86c02fdc96ca29ced53221a3cbf50aa6f8b49

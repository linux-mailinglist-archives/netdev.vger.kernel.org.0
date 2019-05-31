Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E6431283
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfEaQgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:36:53 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35394 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfEaQgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:36:52 -0400
Received: by mail-io1-f68.google.com with SMTP id p2so8712861iol.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sWH2fRj1Mi7gFEy1Vo3Yban4ZfrElYghc3kI9aR4+g4=;
        b=EaG977szScW8r2vr4msPSESu7B0zum65EZBOErQAq2N32o9DBG6pFfG9P6qstZFi93
         yPit22+S0RkamVcwb3yToQUOGJvx4Yw6B0Nt8/dowbd8OaE2/J0vz0rXzt5eLtlpsqcC
         qhmMlPn7fhNXVeJY8gbtXhBPL1xjxwLZkQ6KWD4pYjrSxJmbm9plyNZ/gmlgkv37Yfgw
         esCNaYzzX0vnPJQpM6V0dpfeGXL+Ic7NZ7ZcI8N16WBif9y+JV8wRyl4IEmWtCWN9R7T
         QpiJdGOdFyWFW/LyaZDXnqz4yoin68RrQ7akFhEnTbfQYY35HzsBySFnhbIrMMBCNvLd
         cVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sWH2fRj1Mi7gFEy1Vo3Yban4ZfrElYghc3kI9aR4+g4=;
        b=Eawlye85f8R0MnaG7wxa49kAeAuaw0ytpqXzm9MSrYXDPL2ZPm0jwVEW6MA/7ov93B
         vYA3Mzt0prSs8jcklOzoNrWJWD41fMxJSMw9g4XcRoBnT/OJAiXj44LHUJ55EAJrbAm/
         aKvLFdgsds5xLcsLhNndvC08g56eDXTZf31lDHdeJ7df1aeJFbpYTaZ8Sc+sLSdBDuv4
         3LFH3QJyCEkBCF4Yu/rrvm802MFgP7syxzUdopmoFME2rQvHhhApPrATXDsLfty69NKi
         iBjE/py8MqgKiO5JaD1GcHVQv8RvBCHm7kv/fP26aQtMP6C3LYe7fFXixSm6XBJvifdI
         X/MQ==
X-Gm-Message-State: APjAAAXkv8sNoSutXJFJhr4GkynI82ShP+RmfDig8Uo8NrdQnLOW4me5
        2BAh7aXkj4L5fzmfiuEouu19hw==
X-Google-Smtp-Source: APXvYqwF1QelzFZK9OIIns6zH2PSZ2TasRMDIzTWOpJ7KwvscJ5avHLcUTTuC1V8jHgWrTx3FSJMFg==
X-Received: by 2002:a6b:8b8b:: with SMTP id n133mr6924128iod.183.1559320611338;
        Fri, 31 May 2019 09:36:51 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id j13sm1985761iog.78.2019.05.31.09.36.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:36:50 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Dan Williams <dcbw@redhat.com>, davem@davemloft.net, arnd@arndb.de,
        bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20190531035348.7194-1-elder@linaro.org>
 <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
Date:   Fri, 31 May 2019 11:36:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 9:58 AM, Dan Williams wrote:
> On Thu, 2019-05-30 at 22:53 -0500, Alex Elder wrote:
>> This series presents the driver for the Qualcomm IP Accelerator
>> (IPA).
>>
>> This is version 2 of the series.  This version has addressed almost
>> all of the feedback received in the first version:
>>   
>> https://lore.kernel.org/lkml/20190512012508.10608-1-elder@linaro.org/
>> More detail is included in the individual patches, but here is a
>> high-level summary of what's changed since then:
>>   - Two spinlocks have been removed.
>>       - The code for enabling and disabling endpoint interrupts has
>>         been simplified considerably, and the spinlock is no longer
>> 	required
>>       - A spinlock used when updating ring buffer pointers is no
>>         longer needed.  Integers indexing the ring are used instead
>> 	(and they don't even have to be atomic).
>>   - One spinlock remains to protect list updates, but it is always
>>     acquired using spin_lock_bh() (no more irqsave).
>>   - Information about the queueing and completion of messages is now
>>     supplied to the network stack in batches rather than one at a
>>     time.
>>   - I/O completion handling has been simplified, with the IRQ
>>     handler now consisting mainly of disabling the interrupt and
>>     calling napi_schedule().
>>   - Some comments have been updated and improved througout.
>>
>> What follows is the introduction supplied with v1 of the series.
>>
>> -----
>>
>> The IPA is a component present in some Qualcomm SoCs that allows
>> network functions such as aggregation, filtering, routing, and NAT
>> to be performed without active involvement of the main application
>> processor (AP).
>>
>> Initially, these advanced features are disabled; the IPA driver
>> simply provides a network interface that makes the modem's LTE
>> network available to the AP.  In addition, only support for the
>> IPA found in the Qualcomm SDM845 SoC is provided.
> 
> My question from the Nov 2018 IPA rmnet driver still stands; how does
> this relate to net/ethernet/qualcomm/rmnet/ if at all? And if this is
> really just a netdev talking to the IPA itself and unrelated to
> net/ethernet/qualcomm/rmnet, let's call it "ipa%d" and stop cargo-
> culting rmnet around just because it happens to be a net driver for a
> QC SoC.

First, the relationship between the IPA driver and the rmnet driver
is that the IPA driver is assumed to sit between the rmnet driver
and the hardware.

Currently the modem is assumed to use QMAP protocol.  This means
each packet is prefixed by a (struct rmnet_map_header) structure
that allows the IPA connection to be multiplexed for several logical
connections.  The rmnet driver parses such messages and implements
the multiplexed network interfaces.

QMAP protocol can also be used for aggregating many small packets
into a larger message.  The rmnet driver implements de-aggregation
of such messages (and could probably aggregate them for TX as well).

Finally, the IPA can support checksum offload, and the rmnet
driver handles providing a prepended header (for TX) and
interpreting the appended trailer (for RX) if these features
are enabled.

So basically, the purpose of the rmnet driver is to handle QMAP
protocol connections, and right now that's what the modem
provides.

> Is the firmware that the driver loads already in linux-firmware or
> going to be there soon?

It is not right now, and I have no information on when it can be
available.  The AP *can* load the firmware but right now we rely
on the modem doing it (until we can make the firmware available).

> How does the driver support multiple PDNs (eg PDP or EPS contexts) that
> are enabled through the control plane via QMI messages? I couldn't
> quite find that out.

To be honest, I don't know the answer to this.  All of my work
has been on this transport driver and I believe these things
are handled by user space.  But I really don't know details.

					-Alex

> Thanks,
> Dan
> 
>> This code is derived from a driver developed internally by Qualcomm.
>> A version of the original source can be seen here:
>>   https://source.codeaurora.org/quic/la/kernel/msm-4.9/tree
>> in the "drivers/platform/msm/ipa" directory.  Many were involved in
>> developing this, but the following individuals deserve explicit
>> acknowledgement for their substantial contributions:
>>
>>     Abhishek Choubey
>>     Ady Abraham
>>     Chaitanya Pratapa
>>     David Arinzon
>>     Ghanim Fodi
>>     Gidon Studinski
>>     Ravi Gummadidala
>>     Shihuan Liu
>>     Skylar Chang
>>
>> A version of this code was posted in November 2018 as an RFC.
>>   
>> https://lore.kernel.org/lkml/20181107003250.5832-1-elder@linaro.org/
>> All feedback received was addressed.  The code has undergone
>> considerable further rework since that time, and most of the
>> "future work" described then has now been completed.
>>
>> This code is available in buildable form here, based on kernel
>> v5.2-rc1:
>>   remote: ssh://git@git.linaro.org/people/alex.elder/linux.git
>>   branch: ipa-v2_kernel-v5.2-rc2
>>     75adf2ac1266 arm64: defconfig: enable build of IPA code
>>
>> The branch depends on a commit now found in in net-next.  It has
>> been cherry-picked, and (in this branch) has this commit ID:
>>   13c627b5a078 net: qualcomm: rmnet: Move common struct definitions
>> to include
>> by 
>>
>> 					-Alex
>>
>> Alex Elder (17):
>>   bitfield.h: add FIELD_MAX() and field_max()
>>   dt-bindings: soc: qcom: add IPA bindings
>>   soc: qcom: ipa: main code
>>   soc: qcom: ipa: configuration data
>>   soc: qcom: ipa: clocking, interrupts, and memory
>>   soc: qcom: ipa: GSI headers
>>   soc: qcom: ipa: the generic software interface
>>   soc: qcom: ipa: GSI transactions
>>   soc: qcom: ipa: IPA interface to GSI
>>   soc: qcom: ipa: IPA endpoints
>>   soc: qcom: ipa: immediate commands
>>   soc: qcom: ipa: IPA network device and microcontroller
>>   soc: qcom: ipa: AP/modem communications
>>   soc: qcom: ipa: support build of IPA code
>>   MAINTAINERS: add entry for the Qualcomm IPA driver
>>   arm64: dts: sdm845: add IPA information
>>   arm64: defconfig: enable build of IPA code
>>
>>  .../devicetree/bindings/net/qcom,ipa.yaml     |  180 ++
>>  MAINTAINERS                                   |    6 +
>>  arch/arm64/boot/dts/qcom/sdm845.dtsi          |   51 +
>>  arch/arm64/configs/defconfig                  |    1 +
>>  drivers/net/Kconfig                           |    2 +
>>  drivers/net/Makefile                          |    1 +
>>  drivers/net/ipa/Kconfig                       |   16 +
>>  drivers/net/ipa/Makefile                      |    7 +
>>  drivers/net/ipa/gsi.c                         | 1635
>> +++++++++++++++++
>>  drivers/net/ipa/gsi.h                         |  246 +++
>>  drivers/net/ipa/gsi_private.h                 |  148 ++
>>  drivers/net/ipa/gsi_reg.h                     |  376 ++++
>>  drivers/net/ipa/gsi_trans.c                   |  624 +++++++
>>  drivers/net/ipa/gsi_trans.h                   |  116 ++
>>  drivers/net/ipa/ipa.h                         |  131 ++
>>  drivers/net/ipa/ipa_clock.c                   |  297 +++
>>  drivers/net/ipa/ipa_clock.h                   |   52 +
>>  drivers/net/ipa/ipa_cmd.c                     |  377 ++++
>>  drivers/net/ipa/ipa_cmd.h                     |  116 ++
>>  drivers/net/ipa/ipa_data-sdm845.c             |  245 +++
>>  drivers/net/ipa/ipa_data.h                    |  267 +++
>>  drivers/net/ipa/ipa_endpoint.c                | 1283 +++++++++++++
>>  drivers/net/ipa/ipa_endpoint.h                |   97 +
>>  drivers/net/ipa/ipa_gsi.c                     |   48 +
>>  drivers/net/ipa/ipa_gsi.h                     |   49 +
>>  drivers/net/ipa/ipa_interrupt.c               |  279 +++
>>  drivers/net/ipa/ipa_interrupt.h               |   53 +
>>  drivers/net/ipa/ipa_main.c                    |  921 ++++++++++
>>  drivers/net/ipa/ipa_mem.c                     |  234 +++
>>  drivers/net/ipa/ipa_mem.h                     |   83 +
>>  drivers/net/ipa/ipa_netdev.c                  |  251 +++
>>  drivers/net/ipa/ipa_netdev.h                  |   24 +
>>  drivers/net/ipa/ipa_qmi.c                     |  402 ++++
>>  drivers/net/ipa/ipa_qmi.h                     |   35 +
>>  drivers/net/ipa/ipa_qmi_msg.c                 |  583 ++++++
>>  drivers/net/ipa/ipa_qmi_msg.h                 |  238 +++
>>  drivers/net/ipa/ipa_reg.h                     |  279 +++
>>  drivers/net/ipa/ipa_smp2p.c                   |  304 +++
>>  drivers/net/ipa/ipa_smp2p.h                   |   47 +
>>  drivers/net/ipa/ipa_uc.c                      |  208 +++
>>  drivers/net/ipa/ipa_uc.h                      |   32 +
>>  include/linux/bitfield.h                      |   14 +
>>  42 files changed, 10358 insertions(+)
>>  create mode 100644
>> Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>  create mode 100644 drivers/net/ipa/Kconfig
>>  create mode 100644 drivers/net/ipa/Makefile
>>  create mode 100644 drivers/net/ipa/gsi.c
>>  create mode 100644 drivers/net/ipa/gsi.h
>>  create mode 100644 drivers/net/ipa/gsi_private.h
>>  create mode 100644 drivers/net/ipa/gsi_reg.h
>>  create mode 100644 drivers/net/ipa/gsi_trans.c
>>  create mode 100644 drivers/net/ipa/gsi_trans.h
>>  create mode 100644 drivers/net/ipa/ipa.h
>>  create mode 100644 drivers/net/ipa/ipa_clock.c
>>  create mode 100644 drivers/net/ipa/ipa_clock.h
>>  create mode 100644 drivers/net/ipa/ipa_cmd.c
>>  create mode 100644 drivers/net/ipa/ipa_cmd.h
>>  create mode 100644 drivers/net/ipa/ipa_data-sdm845.c
>>  create mode 100644 drivers/net/ipa/ipa_data.h
>>  create mode 100644 drivers/net/ipa/ipa_endpoint.c
>>  create mode 100644 drivers/net/ipa/ipa_endpoint.h
>>  create mode 100644 drivers/net/ipa/ipa_gsi.c
>>  create mode 100644 drivers/net/ipa/ipa_gsi.h
>>  create mode 100644 drivers/net/ipa/ipa_interrupt.c
>>  create mode 100644 drivers/net/ipa/ipa_interrupt.h
>>  create mode 100644 drivers/net/ipa/ipa_main.c
>>  create mode 100644 drivers/net/ipa/ipa_mem.c
>>  create mode 100644 drivers/net/ipa/ipa_mem.h
>>  create mode 100644 drivers/net/ipa/ipa_netdev.c
>>  create mode 100644 drivers/net/ipa/ipa_netdev.h
>>  create mode 100644 drivers/net/ipa/ipa_qmi.c
>>  create mode 100644 drivers/net/ipa/ipa_qmi.h
>>  create mode 100644 drivers/net/ipa/ipa_qmi_msg.c
>>  create mode 100644 drivers/net/ipa/ipa_qmi_msg.h
>>  create mode 100644 drivers/net/ipa/ipa_reg.h
>>  create mode 100644 drivers/net/ipa/ipa_smp2p.c
>>  create mode 100644 drivers/net/ipa/ipa_smp2p.h
>>  create mode 100644 drivers/net/ipa/ipa_uc.c
>>  create mode 100644 drivers/net/ipa/ipa_uc.h
>>
> 


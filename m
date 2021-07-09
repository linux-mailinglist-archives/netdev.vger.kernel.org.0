Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCE23C2993
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhGITak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGITak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 15:30:40 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FE5C0613DD;
        Fri,  9 Jul 2021 12:27:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bg14so18106843ejb.9;
        Fri, 09 Jul 2021 12:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sEnVICRMuoJMD7G0wE1JB+IlHKoACsuNW31rIP52pAc=;
        b=shP+UtX2IX685qxVGYaqByPazHqkbc6pZXiVOCpRNzxzRXl4GqpM+8qRLyJNs+JVSp
         hROiw9cA4bTXiegv3Jmv84CxRvhXZO/h3i1/ie0Pr0xjU0/evoIj2eQgkmuo8U5k748Z
         oZF3UFIM5jJoepiTGLEilo9uZj6fNHKJZIdjPQuYMCUlN08llh9Dhmrxrjt1t88F00z7
         xJDgLmVunmq8r1RIO3/cyUXsE708nNZ3hKTZWiqh+J2rePtbZoSwsmt22+lmNveViNbe
         awTFD/TGBv6wgTmnMIjBr58OZTWsPH/kVCB2lAaUPHoahKyWj5HnZ0V+/N7DNqO/egZi
         +3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sEnVICRMuoJMD7G0wE1JB+IlHKoACsuNW31rIP52pAc=;
        b=VOCX3CiJ3Ttqc692ylXs/Cmzqy6DTv0Vbjb+zObPT1ku+W9ka2k8F/xfjcmGAX51U1
         P59rZ7z2QUHgpR4RbJsdkCkW4XlAXuG4GfB/XWgBXB9JFrJbP4aIg34vyNqahX+pj1Bd
         j3cCLu6UwfZv+1JQrvG+UIu9R4K3vAtkMXy1pMEIO3kl2tAKAxYF8qEI2QVN4Tdr/11Z
         gLIlK2nNNDlZZefPoTsPalPD1OzslRshRD1fwb/e+EyaBDcGxTJ0m/a5RzDcEVV/L8X6
         atZmzUR8WF2+3OCBNQ/EbJlcK79Ca2DGyjN/GFxbJFRUd2P5L+8KltZ3F6A1hREwm0DV
         5zJg==
X-Gm-Message-State: AOAM533k7LJcRdcRQnywC4TqRrYc7waCMPO2fJIfLeJftqNQqa7f3mc0
        7E015qfLokIzS7Oke4GXZ7VfBTHy/80=
X-Google-Smtp-Source: ABdhPJwb2A9rqY9tKihEpL+tzmGSq5XcKmEjdQApoSklot8Vd0ty/fWu6vHFTVnoGOwAvjeh5l1Z/A==
X-Received: by 2002:a17:906:b099:: with SMTP id x25mr39425088ejy.72.1625858873899;
        Fri, 09 Jul 2021 12:27:53 -0700 (PDT)
Received: from [10.17.0.13] ([37.58.58.229])
        by smtp.gmail.com with ESMTPSA id l16sm2745537ejb.26.2021.07.09.12.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 12:27:53 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709145831.6123-1-verdre@v0yd.nl>
 <20210709145831.6123-3-verdre@v0yd.nl> <20210709151800.7b2qqezlcicbgrqn@pali>
 <b1002254-97c6-d271-c385-4a5c9fe0c914@mailbox.org>
 <20210709161251.g4cvq3l4fnh4ve4r@pali>
 <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
 <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
Date:   Fri, 9 Jul 2021 21:27:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709184443.fxcbc77te6ptypar@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/21 8:44 PM, Pali Rohár wrote:

[...]

>> My (very) quick attempt ('echo 1 > /sys/bus/pci/.../reset) at
>> reproducing this didn't work, so I think at very least a network
>> connection needs to be active.
> 
> This is doing PCIe function level reset. Maybe you can get more luck
> with PCIe Hot Reset. See following link how to trigger PCIe Hot Reset
> from userspace: https://alexforencich.com/wiki/en/pcie/hot-reset-linux

Thanks for that link! That does indeed do something which breaks the
adapter. Running the script produces

   [  178.388414] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
   [  178.389128] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
   [  178.461365] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
   [  178.461373] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done
   [  178.984106] pci 0000:01:00.0: [11ab:2b38] type 00 class 0x020000
   [  178.984161] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x000fffff 64bit pref]
   [  178.984193] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x000fffff 64bit pref]
   [  178.984430] pci 0000:01:00.0: supports D1 D2
   [  178.984434] pci 0000:01:00.0: PME# supported from D0 D1 D3hot D3cold
   [  178.984871] pcieport 0000:00:1c.0: ASPM: current common clock configuration is inconsistent, reconfiguring
   [  179.297919] pci 0000:01:00.0: BAR 0: assigned [mem 0xd4400000-0xd44fffff 64bit pref]
   [  179.297961] pci 0000:01:00.0: BAR 2: assigned [mem 0xd4500000-0xd45fffff 64bit pref]
   [  179.298316] mwifiex_pcie 0000:01:00.0: enabling device (0000 -> 0002)
   [  179.298752] mwifiex_pcie: PCI memory map Virt0: 00000000c4593df1 PCI memory map Virt2: 0000000039d67daf
   [  179.300522] mwifiex_pcie 0000:01:00.0: WLAN read winner status failed!
   [  179.300552] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
   [  179.300622] mwifiex_pcie 0000:01:00.0: Read register failed
   [  179.300912] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
   [  179.300928] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done

after which the card is unusable (there is no WiFi interface availabel
any more). Reloading the driver module doesn't help and produces

   [  376.906833] mwifiex_pcie: PCI memory map Virt0: 0000000025149d28 PCI memory map Virt2: 00000000c4593df1
   [  376.907278] mwifiex_pcie 0000:01:00.0: WLAN read winner status failed!
   [  376.907281] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
   [  376.907293] mwifiex_pcie 0000:01:00.0: Read register failed
   [  376.907404] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
   [  376.907406] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done

again. Performing a function level reset produces

   [  402.489572] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_prepare: adapter structure is not valid
   [  403.514219] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_done: adapter structure is not valid

and doesn't help either.

Running the same command on a kernel with (among other) this patch
unfortunately also breaks the adapter in the same way. As far as I can
tell though, it doesn't run through the reset code added by this patch
(as indicated by the log message when performing FLR), which I assume
in a non-forced scenario, e.g. firmware issues (which IIRC is why this
patch exists), it would?

>> Unfortunately I can't test that with a
>> network connection (and without compiling a custom kernel for which I
>> don't have the time right now) because there's currently another bug
>> deadlocking on device removal if there's an active connection during
>> removal (which also seems to trigger on reset). That one ill be fixed
>> by
>>
>>    https://lore.kernel.org/linux-wireless/20210515024227.2159311-1-briannorris@chromium.org/
>>
>> Jonas might know more.

[...]

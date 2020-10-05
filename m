Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE9F283510
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 13:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgJELgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 07:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJELgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 07:36:42 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D691C0613CE;
        Mon,  5 Oct 2020 04:36:41 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so5798124pgo.13;
        Mon, 05 Oct 2020 04:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sf17c7HvXf8uNuzV8+ZjY1/GkdlrtyTHe3Oz9ln6I+8=;
        b=GEqNnyO/GWOFkvGTnhpXCXZ8mgcQUckcXR88hlywAimwgJhnWZ9OhnTM2KEmXWN4zj
         R7I7zZWnejdpaiNmie85D9stM0etKWhBAPEo58lszbhRYNy2G4Q1VCR4IWGOYgnOB79l
         iVafOq99O6Ufkz2jmqrLsAwGfg6olCut9mjm5JA4DyCBdt07BsH7EwJFHbNN85fz0Bjd
         an0GZugO0aQcahZxKXzWLe103B6JONhEHdDJO5F+l6HqtVVJlyRTvGrdSugKs+l3aH1m
         E/K97pg9o9psk5BGOZHAi641YaoHiKZoCRkU4lzIUfVZ9xmRj+A5FgrurmLovpa87uCE
         IjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sf17c7HvXf8uNuzV8+ZjY1/GkdlrtyTHe3Oz9ln6I+8=;
        b=jWdlrIkz//eBvAeUWBlZIdcTyFNJtZaKNUSptBSeeeAChZ4AA20RGqie5sWyFeWeoi
         JoRevI1qzF/tX+zGOwhATmxeoLL+ZKBDOUNnI14g3JGEwF+GIMzN53xrxsdzN+JxhgGD
         6/jLFhVyIBX8tc5i+p0xUCMo7UjgFwwTu0KUNypyaRGtsRnGOoNhMbKeiEGPYK7z5t4V
         gjEYzYEhXggKX+5LNOqpYuCXsd6jBZlefrglKJ5mOOGn8KEbFf9Q303B18WkAnvU5QGF
         mlr4EFtRsbaHDiaMzO41dJPeahXWiBzMQ22nWPlgJyBUAB49mEMXtl1WPaTygCKROtTl
         A+tQ==
X-Gm-Message-State: AOAM533J3UraND8c5gnPWhepAl2MlXE5ENyaeyYTjPyWYLuad14wmSPB
        YfCzVQq6vpS4uqMjwObMBvwxoCjMmIBInQ==
X-Google-Smtp-Source: ABdhPJzpUesusDh3wP10bYr0k8QIwo2tBQUz1xY/lhN9izPtibifDzHCTYqPnwhAyt9quq3LtFO+aA==
X-Received: by 2002:a63:5c2:: with SMTP id 185mr6626366pgf.395.1601897800542;
        Mon, 05 Oct 2020 04:36:40 -0700 (PDT)
Received: from [192.168.1.5] ([159.192.164.48])
        by smtp.googlemail.com with ESMTPSA id v3sm8058232pju.44.2020.10.05.04.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 04:36:40 -0700 (PDT)
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
To:     Johan Hovold <johan@kernel.org>,
        Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
 <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
 <20201005082045.GL5141@localhost>
 <20201005130134.459b4de9@monster.powergraphx.local>
 <20201005110638.GP5141@localhost>
From:   Lars Melin <larsm17@gmail.com>
Message-ID: <5222246c-08d7-dcf8-248d-c1fefc72c46f@gmail.com>
Date:   Mon, 5 Oct 2020 18:36:36 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201005110638.GP5141@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/2020 18:06, Johan Hovold wrote:
> On Mon, Oct 05, 2020 at 01:01:34PM +0200, Wilken Gottwalt wrote:
>> On Mon, 5 Oct 2020 10:20:45 +0200
>> Johan Hovold <johan@kernel.org> wrote:
>>
>>> On Sat, Oct 03, 2020 at 11:40:29AM +0200, Wilken Gottwalt wrote:
>>>> Add usb ids of the Cellient MPL200 card.
>>>>
>>>> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
>>>> ---
> 
>>>> @@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
>>>>   	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff,
>>>> 0x02, 0x01) }, { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2,
>>>> 0xff, 0x00, 0x00) }, { USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
>>>> +	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
>>>> +	  .driver_info = RSVD(1) | RSVD(4) },
>>>
>>> Would you mind posting the output of "lsusb -v" for this device?
>>
>> I would like to, but unfortunately I lost access to this really rare hardware
>> about a month ago. It is a Qualcomm device (0x05c6:0x9025) with a slightly
>> modified firmware to rebrand it as a Cellient product with a different vendor
>> id. How to proceed here, if I have no access to it anymore? Drop it?
> 
> No, that's ok, I've applied the patch now. It's just that in case we
> ever need to revisit the handling of quirky devices, it has proven
> useful to have a record the descriptors.
> 
> Do you remember the interface layout and why you blacklisted interface
> 1?
> 
> Johan
> 

It is very likely that Cellient has replaced the VID with their own and 
kept the PID, it is something other mfgrs has done when buying modules 
from Qualcomm's series of devices with predefined composition.

The MS Windows driver for 05c6:9025 describes the interfaces as:

MI_00 Qualcomm HS-USB Diagnostics 9025
MI_01 Android Composite ADB Interface
MI_02 Qualcomm HS-USB Android Modem 9025
MI_03 Qualcomm HS-USB NMEA 9025
MI_04 Qualcomm Wireless HS-USB Ethernet Adapter 9025
MI_05 USB Mass Storage Device

where the net interface is for QMI/RMNET.
It fully matches the blacklisting Wilken has done for 2692:9025

br
Lars






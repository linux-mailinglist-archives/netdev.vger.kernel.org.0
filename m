Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345F449D652
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiAZXni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiAZXnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 18:43:37 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD4DC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:43:37 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id r14so1129661qtt.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=0muTo4uRZ70YCwX6/v+4u66TzelKiI99n7msjCM8zH4=;
        b=H7S5kjHfOZwyiEXgw+ZkvHgnhwIox/j51Y4uKukg2qG7Q31aFuzOEiM7Vd+T9ZUshv
         XJymh+/Txzn6Qc86u68pZzM2ZxaCCEF/kYHXm7oKpFqFF/BkQ5hLvB1eC3jdboiNIPQg
         s6mXuWveVV0QZdphrbYn0iKiDjdtUatXHCq+ndiyXP7K7OeI/dIXBJkI52Oz/WwPY/Y5
         1LrpaZUhrnJuwSZz03y9gzNO9RJeXkKu85U6nCMIKkpct2/qt+VhUQMQekratlGUXMQQ
         aWjyvqd5jsvIxCmTYIw6YE6wzduSTTzO8R4URqud+8AAvVlyHDOl4U5mnnkIHxQphVXo
         jf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=0muTo4uRZ70YCwX6/v+4u66TzelKiI99n7msjCM8zH4=;
        b=AhC9KH6qzv86StNSczGm1ZuvpXs13BX4bIJ4VbYN81466phstkko0gfEMYY+svgJCI
         vqnMG/SPz/pxEgcKVIMJnm7ruhzZpHER/pdTjRu/wrKaqxPNdB9Cf72QHnGc3IjjlwiK
         HFxfu5fbXpylovxysXd8i4p7tlZvMyBQmZRBha9w4Ucc8X6ikFN4EZqy7mA14C9rIjGF
         1b/Z48SrJ3FIKNqgNWFO/MMYJGQamuVX4NDMhOsHc6G6cU1OMD8G6e04o3oR0W73ZetG
         62umRYpBBoSvVutm9Al46UXGg0XMHhVjb3Co9eCXUXtNt4ofnVCymq1v0nA+m5IZgYJg
         sQfw==
X-Gm-Message-State: AOAM531/7BdvbzVHe+fa0EN24utOamLGWTgSTUx2l28xWVIGoNKchUT4
        6OARsnzaLSC2mNSXeF4k674m2udojgx3ow==
X-Google-Smtp-Source: ABdhPJyOZ4c2KT9+v+HX9rxPginUJoZ+AUFJG2kvk+aw3/w6XXQgT1EpYyZ3LZnhXRCh2a38VtyaAA==
X-Received: by 2002:a05:622a:1744:: with SMTP id l4mr852954qtk.571.1643240616660;
        Wed, 26 Jan 2022 15:43:36 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h6sm551185qko.7.2022.01.26.15.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 15:43:36 -0800 (PST)
Message-ID: <89023d8a-4bf2-be3f-99c4-46c137da8599@linaro.org>
Date:   Wed, 26 Jan 2022 17:43:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: IPA monitor (Final RFC)
Content-Language: en-US
From:   Alex Elder <elder@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org> <YeLk3STfx2DO4+FO@lunn.ch>
 <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
 <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <f02ad768-2c8e-c8ed-e5f6-6ee79bf97c06@linaro.org>
 <36491c9e-c9fb-6740-9e51-58c23737318f@linaro.org>
In-Reply-To: <36491c9e-c9fb-6740-9e51-58c23737318f@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Damned double spacing.  I'm not sure why it's happening...	-Alex

In previous messages I explained how the Qualcomm IP Accelerator
(IPA) sometimes has the ability to replicate all packets it
processes, and supply those replicated packets to the main
application processor (AP).  I initially suggested using a network
device as the interface for this, but after some discussion, Jakub
recommended using a debugfs file to supply these packets.

Below is basically a specification for the design I'll use.  It is
what I intend to implement, so if anyone has any objection, please
voice it now.  I'll be sending this code out for review in the
coming few weeks.

Thank you.

					-Alex

- A new debugfs directory "qcom_ipaX" will be created for each IPA
   instance (X = IPA device number).  There's normally only going to
   be one of these, but there is at least one SoC that has two.
     /sys/kernel/debug/qcom_ipa0/
- If an IPA instance supports a "monitor endpoint", a "monitor" file
   will be created in its "qcom_ipaX" directory.
     /sys/kernel/debug/qcom_ipa0/monitor
- The "monitor" file is opened exclusively (no O_EXCL needed).  An
   attempt to open that file when it's already open produces EBUSY.
- The monitor file is read-only (S_IRUSR), and does not support seeks.
- Once opened, "monitor packets" (which consist of a fixed size
   status header, followed by replicated packet data) will be
   accumulated in *receive* buffers.  If a replicated packet is
   large, it will have been truncated by hardware to reduce
   monitoring bandwidth.
- Once opened, reads to the monitor file are satisfied as follows:
     - If no receive buffers have accumulated, the read will block
       until at least one monitor packet can be returned.
     - If the file is opened with O_NONBLOCK, a read that would block
       will return EAGAIN instead of blocking.
     - A read that blocks is interruptible.
     - A valid monitor packet is supplied to user space at most once.
     - Only "complete" monitor packets are supplied to the reader.
       I.e., a status header will always be supplied together with
       the packet data it describes.
     - A *read* buffer will be filled with as many monitor packets as
       possible.  If they'll fit in the read buffer, all accumulated
       monitor packets will be returned to the reader.
     - If the read buffer has insufficient room for the next
       available monitor packet, the read request returns.
     - If any monitor packet received from hardware is bad, it--along
       with everything beyond it in its page--will be discarded.
         - The received data must be big enough to hold a status
	  header.
	- The received data must contain the packet data, meaning
	  packet length in the status header lies within range.

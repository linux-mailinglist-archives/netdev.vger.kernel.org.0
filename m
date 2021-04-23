Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C46369268
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242571AbhDWMt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242541AbhDWMt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 08:49:26 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5389DC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:48:49 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h141so4700275iof.2
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cQ+MBXE+++xp1zOWlTgF7TNTO8L2yA1pVovqRQEspeU=;
        b=G9D0VkOd02dIR5UwpVtNRa+BD0De8I/lJwpxjwa3FTZqtD3miUu4AfhbDi7ZE2/UMQ
         eNzZc6a3weOdVNLOzHhQOXK4V2IX2ijHkd0ECewA2826vxlIjNj+1PFWwE8DvVeSyehR
         qNT1p5R/gd7ckG+6BPmC4U28svU7nF8z+lkQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cQ+MBXE+++xp1zOWlTgF7TNTO8L2yA1pVovqRQEspeU=;
        b=EiW08mszUVxtFDXPufByXx5y6QtR6xzOpMrwVoQotevxsKH6suoaRkdW1S9Le6yMjP
         ttdrfqwltHoCH/l7vUPImBt/AOvKuO8Xol4F9cv/S3hldwwKXJfUF8+Qhczp16gUZBFA
         38KB0XfjarMgMAU3um+izUr7ve1PE3R+QtUWlkWz0x+W8obtcAkexeuFjkpFkba2xd27
         fMOirIjtMXV3sHnkzMPSK0oMBvHfNflBJ1UVJfYXi956dTpEO1ZT9DdZm3h62Ygm8tpQ
         zKLJzG/WAdwF/oH5FkQB5HejnFnRtVhDJ/ZPkqlKCisSoIKuFBiOO7MflPF7f8GUzxVi
         Bwcg==
X-Gm-Message-State: AOAM533FnmV1ZVslgOL6CkyqS9C86m/W5OQazelM0nTpn9KDsZxEmyPx
        Ep5wO9n3waTEq2TLKZXHutkLAA==
X-Google-Smtp-Source: ABdhPJyYOpZ9/IADM3mbcd5lY/wDXn4qWQFT2fWsQqT7XJ59KdFeo57J9qAuf13jiV45CXHMGOWgSQ==
X-Received: by 2002:a6b:fa14:: with SMTP id p20mr3053966ioh.168.1619182128721;
        Fri, 23 Apr 2021 05:48:48 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id f12sm2579599ils.50.2021.04.23.05.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 05:48:48 -0700 (PDT)
Subject: Re: [PATCH net-next v5 1/3] docs: networking: Add documentation for
 MAPv5
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <stranche@codeaurora.org linux-doc@vger.kernel.org corbet@lwn.net>
 <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
 <1619180343-3943-2-git-send-email-sharathv@codeaurora.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <ea12b4dd-a540-fdf7-44f8-6b9bc822a50d@ieee.org>
Date:   Fri, 23 Apr 2021 07:48:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1619180343-3943-2-git-send-email-sharathv@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/21 7:19 AM, Sharath Chandra Vurukala wrote:
> Adding documentation explaining the new MAPv4/v5 packet formats
> and the corresponding checksum offload headers.
> 
> Acked-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Acked-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>

You indicated I acknowledged this, and I didn't have any
other real input, so this looks good.

					-Alex

> ---
>   .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++++++--
>   1 file changed, 114 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst b/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
> index 70643b5..4118384 100644
> --- a/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
> +++ b/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
> @@ -27,34 +27,136 @@ these MAP frames and send them to appropriate PDN's.
>   2. Packet format
>   ================
>   
> -a. MAP packet (data / control)
> +a. MAP packet v1 (data / control)
>   
> -MAP header has the same endianness of the IP packet.
> +MAP header fields are in big endian format.
>   
>   Packet format::
>   
> -  Bit             0             1           2-7      8 - 15           16 - 31
> +  Bit             0             1           2-7      8-15           16-31
>     Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload length
> -  Bit            32 - x
> -  Function     Raw  Bytes
> +
> +  Bit            32-x
> +  Function      Raw bytes
>   
>   Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
> -or data packet. Control packet is used for transport level flow control. Data
> +or data packet. Command packet is used for transport level flow control. Data
>   packets are standard IP packets.
>   
> -Reserved bits are usually zeroed out and to be ignored by receiver.
> +Reserved bits must be zero when sent and ignored when received.
>   
> -Padding is number of bytes to be added for 4 byte alignment if required by
> -hardware.
> +Padding is the number of bytes to be appended to the payload to
> +ensure 4 byte alignment.
>   
>   Multiplexer ID is to indicate the PDN on which data has to be sent.
>   
>   Payload length includes the padding length but does not include MAP header
>   length.
>   
> -b. MAP packet (command specific)::
> +b. Map packet v4 (data / control)
> +
> +MAP header fields are in big endian format.
> +
> +Packet format::
> +
> +  Bit             0             1           2-7      8-15           16-31
> +  Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload length
> +
> +  Bit            32-(x-33)      (x-32)-x
> +  Function      Raw bytes      Checksum offload header
> +
> +Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
> +or data packet. Command packet is used for transport level flow control. Data
> +packets are standard IP packets.
> +
> +Reserved bits must be zero when sent and ignored when received.
> +
> +Padding is the number of bytes to be appended to the payload to
> +ensure 4 byte alignment.
> +
> +Multiplexer ID is to indicate the PDN on which data has to be sent.
> +
> +Payload length includes the padding length but does not include MAP header
> +length.
> +
> +Checksum offload header, has the information about the checksum processing done
> +by the hardware.Checksum offload header fields are in big endian format.
> +
> +Packet format::
> +
> +  Bit             0-14        15              16-31
> +  Function      Reserved   Valid     Checksum start offset
> +
> +  Bit                31-47                    48-64
> +  Function      Checksum length           Checksum value
> +
> +Reserved bits must be zero when sent and ignored when received.
> +
> +Valid bit indicates whether the partial checksum is calculated and is valid.
> +Set to 1, if its is valid. Set to 0 otherwise.
> +
> +Padding is the number of bytes to be appended to the payload to
> +ensure 4 byte alignment.
> +
> +Checksum start offset, Indicates the offset in bytes from the beginning of the
> +IP header, from which modem computed checksum.
> +
> +Checksum length is the Length in bytes starting from CKSUM_START_OFFSET,
> +over which checksum is computed.
> +
> +Checksum value, indicates the checksum computed.
> +
> +c. MAP packet v5 (data / control)
> +
> +MAP header fields are in big endian format.
> +
> +Packet format::
> +
> +  Bit             0             1         2-7      8-15           16-31
> +  Function   Command / Data  Next header  Pad   Multiplexer ID   Payload length
> +
> +  Bit            32-x
> +  Function      Raw bytes
> +
> +Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
> +or data packet. Command packet is used for transport level flow control. Data
> +packets are standard IP packets.
> +
> +Next header is used to indicate the presence of another header, currently is
> +limited to checksum header.
> +
> +Padding is the number of bytes to be appended to the payload to
> +ensure 4 byte alignment.
> +
> +Multiplexer ID is to indicate the PDN on which data has to be sent.
> +
> +Payload length includes the padding length but does not include MAP header
> +length.
> +
> +d. Checksum offload header v5
> +
> +Checksum offload header fields are in big endian format.
> +
> +  Bit            0 - 6          7               8-15              16-31
> +  Function     Header Type    Next Header     Checksum Valid    Reserved
> +
> +Header Type is to indicate the type of header, this usually is set to CHECKSUM
> +
> +Header types
> += ==========================================
> +0 Reserved
> +1 Reserved
> +2 checksum header
> +
> +Checksum Valid is to indicate whether the header checksum is valid. Value of 1
> +implies that checksum is calculated on this packet and is valid, value of 0
> +indicates that the calculated packet checksum is invalid.
> +
> +Reserved bits must be zero when sent and ignored when received.
> +
> +e. MAP packet v1/v5 (command specific)::
>   
> -    Bit             0             1           2-7      8 - 15           16 - 31
> +    Bit             0             1         2-7      8 - 15           16 - 31
>       Function   Command         Reserved     Pad   Multiplexer ID    Payload length
>       Bit          32 - 39        40 - 45    46 - 47       48 - 63
>       Function   Command name    Reserved   Command Type   Reserved
> @@ -74,7 +176,7 @@ Command types
>   3 is for error during processing of commands
>   = ==========================================
>   
> -c. Aggregation
> +f. Aggregation
>   
>   Aggregation is multiple MAP packets (can be data or command) delivered to
>   rmnet in a single linear skb. rmnet will process the individual
> 


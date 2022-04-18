Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7970505AF8
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbiDRP3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244172AbiDRP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:29:03 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D6154692
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 07:31:33 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-de3eda6b5dso14382603fac.0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 07:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yKz2pc9mSxU5f+xWE5OCWErviiukUDroeZ0G+XnbX/4=;
        b=ohfSnfgLIuQuKQOw6A7D/VvhL2cGKpuPtGfxY5GG+VDycmowbQmsn5waCFZ38nzCh3
         koZvvTEOHUPuLyDJdsY/hJXPjQq9G1x+r8eS7YzpiB+NYFVFEDqpK3yLNqytXoLuvLPL
         Xx2ILF68oUqBKbUELuFbdm+zId88PT7BWVCoP2hGmQ5Y/Iu0stlZHspSYOGuPWoKVzeJ
         xdkkIokJxN+fMnLS5wF2I3g+akrNpE8tGS6+uiQeGTkw7NCIo5liXqXW8672eMfrfj9d
         9bzWp75k7Pj7Z52H1cN33ksmCV0+uRg+9YiqpnWY4MSLifTTn6PyY+YWfpZuv7LrhgdM
         mNwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yKz2pc9mSxU5f+xWE5OCWErviiukUDroeZ0G+XnbX/4=;
        b=MvH2F4QH72R/MqF+Q3kHkzmoz4KeKVtWnBy3wCVYC+px81okVW+i2NebRFMZ+YSnOP
         8ouebTN8PfbxNR68hSiCCM8gwu3e1hzav9ASMY/aeBsRIE9sj9cPsh6D/rNOHWy8Bokw
         Kr6mZtr5IUkAAEMsPEJB53whHKJiLdQsiGIAY/OvI3OwVrL94RW8ONWHeNOXEyPHuU0a
         vDPfHelm8Vbnby5fFKVzTO4zgw19t1emRUnpduXEBZpMwDBoa5FokfsFQPM1dm/m8wvO
         BSWD8+Y1A4o/bUnGjBScYTqaJmdlK8/S9M3pVL3OSpXCbkpeSTO2PxeK0+0tkOee6fBH
         7jVQ==
X-Gm-Message-State: AOAM531kSCJ3krmnEeSJIsrw+kUizLChbepENnQSjpi3Wc96R7+BHNhD
        nLAdTSBfZhyFxsRgeHtANtg=
X-Google-Smtp-Source: ABdhPJyMBECRx8hU0N5OH6JTsXRgOGwS2A4qdcAQzsYmgo4ig5VcxpxXaeZ5ZqClYz88yrNRTU5xDw==
X-Received: by 2002:a05:6870:5487:b0:e6:10f4:ec50 with SMTP id f7-20020a056870548700b000e610f4ec50mr234851oan.18.1650292293217;
        Mon, 18 Apr 2022 07:31:33 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id r35-20020a056870582300b000df0dc42ff5sm4078546oap.0.2022.04.18.07.31.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 07:31:32 -0700 (PDT)
Message-ID: <4d86acf1-d449-92d7-f8c7-bd0edc9e5107@gmail.com>
Date:   Mon, 18 Apr 2022 08:31:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 00/17] Introduce line card support for modular
 switch
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, mlxsw@nvidia.com
References: <20220418064241.2925668-1-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/22 12:42 AM, Ido Schimmel wrote:
> Jiri says:
> 
> This patchset introduces support for modular switch systems and also
> introduces mlxsw support for NVIDIA Mellanox SN4800 modular switch.
> It contains 8 slots to accommodate line cards - replaceable PHY modules
> which may contain gearboxes.
> Currently supported line card:
> 16X 100GbE (QSFP28)
> Other line cards that are going to be supported:
> 8X 200GbE (QSFP56)
> 4X 400GbE (QSFP-DD)
> There may be other types of line cards added in the future.
> 
> To be consistent with the port split configuration (splitter cabels),
> the line card entities are treated in the similar way. The nature of
> a line card is not "a pluggable device", but "a pluggable PHY module".
> 
> A concept of "provisioning" is introduced. The user may "provision"
> certain slot with a line card type. Driver then creates all instances
> (devlink ports, netdevices, etc) related to this line card type. It does
> not matter if the line card is plugged-in at the time. User is able to
> configure netdevices, devlink ports, setup port splitters, etc. From the
> perspective of the switch ASIC, all is present and can be configured.
> 
> The carrier of netdevices stays down if the line card is not plugged-in.
> Once the line card is inserted and activated, the carrier of
> the related netdevices is then reflecting the physical line state,
> same as for an ordinary fixed port.
> 
> Once user does not want to use the line card related instances
> anymore, he can "unprovision" the slot. Driver then removes the
> instances.
> 
> Patches 1-4 are extending devlink driver API and UAPI in order to
> register, show, dump, provision and activate the line card.
> Patches 5-17 are implementing the introduced API in mlxsw.
> The last patch adds a selftest for mlxsw line cards.
> 
> Example:
> $ devlink port # No ports are listed
> $ devlink lc
> pci/0000:01:00.0:
>   lc 1 state unprovisioned
>     supported_types:
>        16x100G
>   lc 2 state unprovisioned
>     supported_types:
>        16x100G
>   lc 3 state unprovisioned
>     supported_types:
>        16x100G
>   lc 4 state unprovisioned
>     supported_types:
>        16x100G
>   lc 5 state unprovisioned
>     supported_types:
>        16x100G
>   lc 6 state unprovisioned
>     supported_types:
>        16x100G
>   lc 7 state unprovisioned
>     supported_types:
>        16x100G
>   lc 8 state unprovisioned
>     supported_types:
>        16x100G
> 
> Note that driver exposes list supported line card types. Currently
> there is only one: "16x100G".
> 
> To provision the slot #8:
> 
> $ devlink lc set pci/0000:01:00.0 lc 8 type 16x100G
> $ devlink lc show pci/0000:01:00.0 lc 8
> pci/0000:01:00.0:
>   lc 8 state active type 16x100G
>     supported_types:
>        16x100G
> $ devlink port
> pci/0000:01:00.0/0: type notset flavour cpu port 0 splittable false
> pci/0000:01:00.0/53: type eth netdev enp1s0nl8p1 flavour physical lc 8 port 1 splittable true lanes 4
> pci/0000:01:00.0/54: type eth netdev enp1s0nl8p2 flavour physical lc 8 port 2 splittable true lanes 4
> pci/0000:01:00.0/55: type eth netdev enp1s0nl8p3 flavour physical lc 8 port 3 splittable true lanes 4
> pci/0000:01:00.0/56: type eth netdev enp1s0nl8p4 flavour physical lc 8 port 4 splittable true lanes 4
> pci/0000:01:00.0/57: type eth netdev enp1s0nl8p5 flavour physical lc 8 port 5 splittable true lanes 4
> pci/0000:01:00.0/58: type eth netdev enp1s0nl8p6 flavour physical lc 8 port 6 splittable true lanes 4
> pci/0000:01:00.0/59: type eth netdev enp1s0nl8p7 flavour physical lc 8 port 7 splittable true lanes 4
> pci/0000:01:00.0/60: type eth netdev enp1s0nl8p8 flavour physical lc 8 port 8 splittable true lanes 4
> pci/0000:01:00.0/61: type eth netdev enp1s0nl8p9 flavour physical lc 8 port 9 splittable true lanes 4
> pci/0000:01:00.0/62: type eth netdev enp1s0nl8p10 flavour physical lc 8 port 10 splittable true lanes 4
> pci/0000:01:00.0/63: type eth netdev enp1s0nl8p11 flavour physical lc 8 port 11 splittable true lanes 4
> pci/0000:01:00.0/64: type eth netdev enp1s0nl8p12 flavour physical lc 8 port 12 splittable true lanes 4
> pci/0000:01:00.0/125: type eth netdev enp1s0nl8p13 flavour physical lc 8 port 13 splittable true lanes 4
> pci/0000:01:00.0/126: type eth netdev enp1s0nl8p14 flavour physical lc 8 port 14 splittable true lanes 4
> pci/0000:01:00.0/127: type eth netdev enp1s0nl8p15 flavour physical lc 8 port 15 splittable true lanes 4
> pci/0000:01:00.0/128: type eth netdev enp1s0nl8p16 flavour physical lc 8 port 16 splittable true lanes 4
> 
> To uprovision the slot #8:
> 
> $ devlink lc set pci/0000:01:00.0 lc 8 notype
> 

are there any changes from the last RFC?

https://lore.kernel.org/netdev/20210122094648.1631078-1-jiri@resnulli.us/



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A775AE43E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 11:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbiIFJ3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 05:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiIFJ3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 05:29:37 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FE89FE6;
        Tue,  6 Sep 2022 02:29:35 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t3so5646061ply.2;
        Tue, 06 Sep 2022 02:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=nwwWl+D6Cbqti98AYLwJCMw6j9XEvZlxYSURArm6zSc=;
        b=DINTbITVkqBl6NnHryAPut6WB8f1LiW4BD953VsZQp2iBmABJIWKe9e91vAiVHyC9P
         WzvP0xuXkfImIe/voYMU/VrozNBhygAuvC/2HJW67gkB4JELQpTM9H68XJd4BMyMUxJn
         iYxpww5GDgDgaz9dEH/yMxMMxJw9NSM/tRMFOIz8JOySq32GJZaXpDxV7ZR2wLmTWwYu
         bJF3p2iFOjdEkYzSlzsLDOBs7w/2Q0ylf2zKdZGCkjmTHdmBOTRX6FJvGzldZzNKNCkN
         CCS77bCSxqUl4hsyNIOPD3R2Gg13cOcQkvZyty57k6t2CJHE1fmyoeOhH0iIchPKrws/
         v1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=nwwWl+D6Cbqti98AYLwJCMw6j9XEvZlxYSURArm6zSc=;
        b=MaxEfpI2jqrWVFQ8inICXQHRaa+VZitmvnPQpn9tZ0SaS7XNJ9/9sWCqjAuciFQrXU
         4JRkGpugFzm2l3bkiURbwTV4lVq0fOClN6Q4E84E0CqIOChWrH+H+GDMq3DQA4M7I4EW
         JJz1QVYoZ7xHAt3c+oBdr8p2oHzkc7lhRT0S4vGQMwq12zrqs1L0OGg89m6STPeAXjaE
         PjJuLxuwRmliTyt+OEEAsmdVO9sNJpr8BKhttpZa0r3IdB8p1rrolbc73XFk48Y3WyMh
         O6Cq+9tc6PRq+Fr/xsOP2fdR8kpkai9atF93VX3KWX5a+yMkXToHQkotgjgrYdwQkgf8
         ALXA==
X-Gm-Message-State: ACgBeo2OF3/N94VWIhf3tbkNFn7pWV2MfjByBFNqIs6doK4syL5CwEt5
        Tt1qeKD4GOEnajJoh0XH60w=
X-Google-Smtp-Source: AA6agR5PS+mibtWvHVZbg3Sz+aoKp0kun0uzmNDbXq35hKAC7/FNVppil5VPWfu41hY9owryQJNNhA==
X-Received: by 2002:a17:90b:1b45:b0:1ff:fa05:1049 with SMTP id nv5-20020a17090b1b4500b001fffa051049mr21200997pjb.68.1662456575283;
        Tue, 06 Sep 2022 02:29:35 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-72.three.co.id. [180.214.232.72])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902f14900b00174f7d107c8sm1512675plb.293.2022.09.06.02.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 02:29:35 -0700 (PDT)
Message-ID: <228fb86d-4239-0aa9-ba88-e3fdc7cbe99f@gmail.com>
Date:   Tue, 6 Sep 2022 16:29:27 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 net-next] docs: net: add an explanation of VF (and
 other) Representors
Content-Language: en-US
To:     ecree@xilinx.com, netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, simon.horman@corigine.com,
        alexander.duyck@gmail.com, rdunlap@infradead.org, parav@nvidia.com,
        roid@nvidia.com, marcin.szycik@linux.intel.com,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20220905135557.39233-1-ecree@xilinx.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220905135557.39233-1-ecree@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/22 20:55, ecree@xilinx.com wrote:
> +Thus, the following should all have representors:
> +
> + - VFs belonging to the switchdev function.
> + - Other PFs on the local PCIe controller, and any VFs belonging to them.
> + - PFs and VFs on external PCIe controllers on the device (e.g. for any embedded
> +   System-on-Chip within the SmartNIC).
> + - PFs and VFs with other personalities, including network block devices (such
> +   as a vDPA virtio-blk PF backed by remote/distributed storage), if (and only
> +   if) their network access is implemented through a virtual switch port. [#]_
> +   Note that such functions can require a representor despite the representee
> +   not having a netdev.
> + - Subfunctions (SFs) belonging to any of the above PFs or VFs, if they have
> +   their own port on the switch (as opposed to using their parent PF's port).
> + - Any accelerators or plugins on the device whose interface to the network is
> +   through a virtual switch port, even if they do not have a corresponding PCIe
> +   PF or VF.
> +
<snipped>
> +
> +.. [#] The concept here is that a hardware IP stack in the device performs the
> +   translation between block DMA requests and network packets, so that only
> +   network packets pass through the virtual port onto the switch.  The network
> +   access that the IP stack "sees" would then be configurable through tc rules;
> +   e.g. its traffic might all be wrapped in a specific VLAN or VxLAN.  However,
> +   any needed configuration of the block device *qua* block device, not being a
> +   networking entity, would not be appropriate for the representor and would
> +   thus use some other channel such as devlink.
> +   Contrast this with the case of a virtio-blk implementation which forwards the
> +   DMA requests unchanged to another PF whose driver then initiates and
> +   terminates IP traffic in software; in that case the DMA traffic would *not*
> +   run over the virtual switch and the virtio-blk PF should thus *not* have a
> +   representor.
> +

I think by convention, footnotes should be put on bottom of the doc.

Other than that, LGTM.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara

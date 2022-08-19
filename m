Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE198599E0E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349330AbiHSPSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349092AbiHSPS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:18:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CC63D5A8;
        Fri, 19 Aug 2022 08:18:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j8so9386062ejx.9;
        Fri, 19 Aug 2022 08:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=yn41Vs/apFs4uTrJa9DFPk8MRYPvsR2BQKcLDumZVTQ=;
        b=TZOa/sUoF/RI0h5dFlGV2gVXHo1YBUojtMr6sluB+STWhHlQ7sznFRKPfelKvYRB2N
         bu/6Vix0MZnR8FM74KUA686RvyobgnOdWfNT3o/pIrQJ76XQVBuRxaQyuAzpDXpBH5kK
         FWeqWWf1rJUZdqRHx4vWbQQZE/PpEQut1Aey4XKzRNV7GSPXWMnpPu5H9d5CZpaY5q3i
         tTN9KFq0YvL0QH8kTxgHvfgsJw0eTNYkVg0sEi93ouhaGnAPUIp/qrgQYxcU16mMtJ82
         +iz7gAyXchSCApIRE8Jz+l/2uhOazPbov4NJ41qsPPDO6CqgZRCfjQJtkDuJL4ppslK8
         h1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=yn41Vs/apFs4uTrJa9DFPk8MRYPvsR2BQKcLDumZVTQ=;
        b=IXvOCEi9fCdR10owE+avFl7Axj3tCVfK5v5epSNGU4L1FF7w8NZcFWyDOvFyC4P/PO
         ItdPLr0eatblcbCsVsY7eKVaVftuyD22/0yEt4djbP9w26IbERcK9PoVuTxTuvA6bfZh
         u1Mq9gKaFUbs8M5GV31nxc2HoRn6c+6W3WPc1XHuOPD2/147I8pg9HyM7H1nW3JvzFBF
         IkIx6ud9SyUrnn+1Bdt/ebQlOqFx2k0E25LwUduoIaPC75r43up9LlOelP+55MlQgBrO
         JpMM2YqoSp8CRRoqK3TU9mpEkC3plKZ3hNb1R71a40sOGonoKD1yg5QRyITT34cuBX4s
         hw1A==
X-Gm-Message-State: ACgBeo0Iv+8SDF5wI9rz+/k/jKx0Cvm/uDTGYocEFjJfDIVuwP8VPE/n
        repxqPpajqTLG5Vq0CJCtPM=
X-Google-Smtp-Source: AA6agR4xTqCasDQvLaJScGPCcg+7MXxE1zfpa/lhChBBLEPafhJM3pJa2K10mI/4A2Zu3ozQXYNmWw==
X-Received: by 2002:a17:906:84f7:b0:738:3461:68c6 with SMTP id zp23-20020a17090684f700b00738346168c6mr5195790ejb.506.1660922300802;
        Fri, 19 Aug 2022 08:18:20 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a1709061baa00b0072a881b21d8sm2424932ejg.119.2022.08.19.08.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 08:18:20 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Roi Dayan <roid@nvidia.com>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, simon.horman@corigine.com,
        alexander.duyck@gmail.com, rdunlap@infradead.org
References: <20220815142251.8909-1-ecree@xilinx.com>
 <5edbd360-7afb-2605-21ba-7337be15e235@nvidia.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bb31b68c-1303-0f18-eace-74bf7e05cbb1@gmail.com>
Date:   Fri, 19 Aug 2022 16:18:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5edbd360-7afb-2605-21ba-7337be15e235@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2022 16:07, Roi Dayan wrote:
> On 2022-08-15 5:22 PM, ecree@xilinx.com wrote:
>> +The representor netdevice should *not* directly refer to a PCIe device (e.g.
>> +through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
>> +representee or of the master PF.
> 
> Hi,
> maybe I'm confused here, but why representor should not refer to pci
> device ? it does exists today for systemd renaming.
> and this is used beside of implementing the other ndos you mention
> below.

The master PF is already identified via ``phys_switch_id``, another linkage
 is not needed and only means that userland looking up netdevices by PCIe
 address has to do another step to distinguish the PF's own netdev from all
 the representors.  Allegedly[1] nfp ran into issues where OpenStack would
 sometimes use the reprs for ops that logically should have been on the PF
 because they all had the same /sys/class/net/$INTF/device and it wasn't
 smart enough to tell the difference.

Semantically, the representor is a virtual device, that's backed by the PF
 netdevice rather than the PF's hardware directly — even if it has e.g.
 dedicated queues, it's still not in administrative control of the PCIe
 function in the way that the PF driver instance is.  And compare to e.g.
 a vlan netdev stacked on top of the PF netdev — we don't put the PF in
 /sys/class/net/vlan0/device...

> $  git grep SET_NETDEV_DEV|grep rep
> drivers/net/ethernet/intel/ice/ice_repr.c: SET_NETDEV_DEV(repr->netdev, ice_pf_to_dev(vf->pf));
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c: SET_NETDEV_DEV(netdev, mdev->device);
> drivers/net/ethernet/netronome/nfp/flower/main.c: SET_NETDEV_DEV(repr, &priv->nn->pdev->dev);

Yes, several existing drivers do this[2].  IMHO they're wrong.

-ed

[1]: https://lore.kernel.org/all/20220728113231.26fdfab0@kernel.org/
[2]: https://lore.kernel.org/netdev/71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com/

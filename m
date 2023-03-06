Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD056AC32E
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 15:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCFO0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 09:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCFO0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 09:26:49 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D98D2313E
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 06:26:13 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id u9so39367196edd.2
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 06:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678112706;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xKEIbZNzea3T59teJFpJFSS5WJ3+z49ovYMV1oln6xg=;
        b=aoyeUNJctHw55elNFwk95n2tm9eUHPIgnhJGIa/eLplRzYnuEQlTd0GgNF9ZVUC4YX
         junOwUKsZiih6zbPidybrHGw4p4R4Y9fJlmEU58/0KUqusYQ7WnOVNOkLR1UwlOd7XzG
         74WQCae/4cvpMotQTLkxFpsKBTCtokJhxMPKDpEunvqvwuDN9qDyVRra+tQ9BOlQx7L3
         hwbjlb4F7ZfC2sNuJzn3/uC71KY5CE/QA3SZpQogto6Z0RlU1XUsUUyt79sQt3l4Q4lX
         3uREHuSX0XcjjlR+xx5VZxtymHx9orn/l/Ea+nb+DFOkYrYFPnRobuh7MMBP532a2wZE
         D60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678112706;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKEIbZNzea3T59teJFpJFSS5WJ3+z49ovYMV1oln6xg=;
        b=52lKMN+5/XGEZIba23w5Zyv3AFPALAyLJ/qayQoURLhth4XY87tKjssAU4TCevAzeC
         j6iWp3vK/UYz5SkXKoqd/bzVt6/F/TdpHNDz3PEf1fc9eQ1tZGcGOjxLI+xoCNuSjm+N
         T7/JZakGHYrB8S8ZJHUcyUsrAjbZA8g43Y3tzY7xgeudufxRU6DLjJwOCyDh9XKJr7KU
         ja8apm4w6f1PZNrnwC6HtEkfgIKLWeK1HlRkQE6tp3c3tIJ+WdXKbWHV8WAazaBfOYr7
         YrjBWL9fVNX6BQkAlSH2ResZn6HHjiFR0beCGrx9VP/aeL6/vYjN46zsvvLxDzBThZ16
         j/CQ==
X-Gm-Message-State: AO0yUKUJ18PPq849qg9xTo4X1tdqOcvykk7RrKCj+MBSGKS8cVIFIJ8B
        ZDTK9rb7q8mNaLAEdi7T3wRf9fwpQJ81ENrd
X-Google-Smtp-Source: AK7set/TYP6F2mfRSW+zSISNjHSlesatjdgxr/3knKH/gqtjNvIQw33ACP4o8Z+2hkGsIB+z9VbORA==
X-Received: by 2002:a17:906:a3c2:b0:8e1:12b6:a8fc with SMTP id ca2-20020a170906a3c200b008e112b6a8fcmr10277071ejb.4.1678112705692;
        Mon, 06 Mar 2023 06:25:05 -0800 (PST)
Received: from localhost ([185.220.101.165])
        by smtp.gmail.com with ESMTPSA id qt2-20020a170906ece200b008e938e98046sm4604851ejb.223.2023.03.06.06.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 06:25:05 -0800 (PST)
Date:   Mon, 6 Mar 2023 16:25:00 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     =?utf-8?Q?Stanis=C5=82aw?= Czech <s.czech@nowatel.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: htb offload on vlan (mlx5)
Message-ID: <ZAX3vAu8QEbKOz5t@mail.gmail.com>
References: <dccaf6ea-f0f8-8749-6b59-fb83d9c60d68@nowatel.com>
 <ZAWz+iSrxfLnXX+N@mail.gmail.com>
 <425d50fa-9915-6eb7-609c-0e6a5373870a@nowatel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <425d50fa-9915-6eb7-609c-0e6a5373870a@nowatel.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 02:59:40PM +0100, Stanisław Czech wrote:
> 06.03.2023  10:35, Maxim Mikityanskiy wrote:
> > That's expected, vlan_features doesn't contain NETIF_F_HW_TC, and I
> > think that's the case for all drivers. Regarding HTB offload, I don't
> > think the current implementation in mlx5e can be easily modified to
> > support being attached to a VLAN only, because the current
> > implementation relies on objects created globally in the NIC.
> > 
> > CCed Nvidia folks in case they have more comments.
> > 
> 
> Thank you for you answer Maxim... I tried to use SR IOV and use the HTB
> offload functionality on the VF
> but it's not possible either:
> 
> ethtool -K enp1s0np0 hw-tc-offload  on
> echo 7 > /sys/class/infiniband/mlx5_0/device/mlx5_num_vfs
> ethtool -K enp1s0f7v6 hw-tc-offload  on
> 
> ip l s dev enp1s0np0 name eth0
> ip l s dev eth0 vf 6 vlan 4
> 
> and I see in
> ethtool -k eth0
> hw-tc-offload: on
> 
> but still:
> Error: mlx5_core: Missing QoS capabilities. Try disabling SRIOV or use a
> supported device.
> 
> So I guess there is no way to use HTB offloading anywhere else than on the
> PF device itself...

Yes, as the error message suggests, when SRIOV is enabled, the firmware
doesn't expose the needed capabilities for HTB offload. That means these
two features aren't compatible at the moment, and there is nothing the
driver could do, because the limitation comes from the firmware side.

> 
> Anyway, maybe using multiple VFS to support multiple VLANs (single VF for
> single vlan) would
> be more efficent than simple vlans on PF interface (regarding qdisc lock
> problem) ?

You mean with non-offloaded HTB? You might try, but there will still be
the lock contention issue in case of multiple queues. There will be
multiple locks, though (one per VF), which might alleviate the
contention, but there are too many variables to guess without actually
testing it. It also depends on how many VLANs you have, because each VF
has its memory footprint. It also may be worth looking at SFs, which are
lighter than VFs.

> I would like to utilize more CPU cores as the vlans on a single PF interface
> use only a single
> cpu core ( the 100% ksoftirqd problem)
> 
> Could this be some workaround?
> 
> 
> Greetings,
> *Stanisław Czech*
> 

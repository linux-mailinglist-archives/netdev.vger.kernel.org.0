Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F8C6C6C11
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjCWPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjCWPQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:16:51 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD6628EBA
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:16:50 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id y14so20917327wrq.4
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679584608;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c3k9Ly83rWYeBdOFN0YSjMirs2WGv/NaAHCWvrPGpc0=;
        b=Rgwc1WfcSsNt/V9r6oA47s4+S3OWIeCPVuBUBdRPGJaQ9WNKkQAnbpwrg0VanUgJsT
         1ReT3NrbHAlFdiDljETADXIVs9YPn4X2zBO8FgIPA3tp2g7QmdBaG6SU3sYW76acXXNd
         GheeIeFN/kc6+p1894Y6ln6G73RaP+ctWCPSJ/Yw08yTAg80Tq80mim2BIoKMQpwB29m
         XhLprAf0sOnjkJxPoCvAKHW8s96yo5gvkDH39fCmvKWVBBSQpv8zOUXBWmGba4RtS4eX
         sx4G4JlfXsX65X158ogn1OXNHxqkz/IBFnvk1kZ6LEvdwMX8JbJZt41a/T4ATAkipuym
         S8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584608;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c3k9Ly83rWYeBdOFN0YSjMirs2WGv/NaAHCWvrPGpc0=;
        b=6qyo/UvJnTO5MsVGd7knd9e5S4Vl4HZvxheLN+FZz4YBPzAPBq+Y3VH4C+ZLHt7JFp
         rDxa1pTanjpMC70R1Z8nId5AxTSVg+GCX9MXC4ZQDF5sMJvbhGTh3BWVYPguvnMNB6gH
         yvds3uWIIlLPk5OYNMV866vSI8Dfw4GpGp8ebAA8kL9bE1yIHtqBIwzVT6ybeY/A9T4P
         Vuhi7kmrqjgYp1cb6NqgumKUBVdLhzJlCAsJv4RmsK1x/yF8b0mD7Vn51UGCZJpZTdub
         2DwAcVObHUroDWKduR+BagfghKpzs+d80Ypw2xqmvHo02uF3a+2zIq0hvsA8KIOpp5Lv
         RlXA==
X-Gm-Message-State: AAQBX9d1kPnld5yj52+PGeR/ZrSTEqLZgmmaKR/hjPc4YC19Rb4seI4b
        /LinGTgUImcIrmLXuoN30PU=
X-Google-Smtp-Source: AKy350Z83RYu7+lttoPFuRALmAJrEkEXnMKI5tzBxplIt0Vk6xngED7Xa+deKcobpfe0RM3DggUsyg==
X-Received: by 2002:adf:cf11:0:b0:2c7:d6a:d7fa with SMTP id o17-20020adfcf11000000b002c70d6ad7famr2748817wrj.25.1679584608482;
        Thu, 23 Mar 2023 08:16:48 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b002c71a32394dsm16417789wrn.64.2023.03.23.08.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:16:48 -0700 (PDT)
Subject: Re: [PATCH v2 net] sfc: ef10: don't overwrite offload features at NIC
 reset
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>
References: <20230323083417.7345-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <aa91d648-9293-795b-2e42-d4373081d538@gmail.com>
Date:   Thu, 23 Mar 2023 15:16:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230323083417.7345-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2023 08:34, Íñigo Huguet wrote:
> At NIC reset, some offload features related to encapsulated traffic
> might have changed (this mainly happens if the firmware-variant is
> changed with the sfboot userspace tool). Because of this, features are
> checked and set again at reset time.
> 
> However, this was not done right, and some features were improperly
> overwritten at NIC reset:
> - Tunneled IPv6 segmentation was always disabled
> - Features disabled with ethtool were reenabled
> - Features that becomes unsupported after the reset were not disabled
> 
> Also, checking if the device supports IPV6_CSUM to enable TSO6 is no
> longer necessary because all currently supported devices support it.
> Additionally, move the assignment of some other features to the
> EF10_OFFLOAD_FEATURES macro, like it is done in ef100, leaving the
> selection of features in efx_pci_probe_post_io a bit cleaner.
> 
> Fixes: ffffd2454a7a ("sfc: correctly advertise tunneled IPv6 segmentation")
> Fixes: 24b2c3751aa3 ("sfc: advertise encapsulated offloads on EF10")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Suggested-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
> Tested-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
> v2: reworded the paragraph that explains the code cleanup in efx_pci_probe_post_io
> because it was not very clear
> ---

Acked-by: Edward Cree <ecree.xilinx@gmail.com>

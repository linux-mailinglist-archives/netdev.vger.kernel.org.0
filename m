Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A17450D45D
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiDXTHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 15:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237488AbiDXTHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 15:07:01 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C895138C8B
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 12:03:59 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a1so10464418edt.3
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 12:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qJq22moH50D3yv21TnAqKX91eugYhGfPDI8P8HcZhgY=;
        b=u4f9uaPTM2qqSek3Ph5UN5CThDaMVDlVcGSOQ5d2lcd1ujtvYPbN+NMRXl4Q6K93KX
         tsRtItnFuZXrcIeMzf32whW8fYf/mK/BTclzbG7AEf2zI8xoKjfppuT3P+vhD70Y3Bka
         uo/+265lmvNoy4vRb7bB6bOXhCH5YaCaXT2npe4SsKJKh1wkWhI4M8RwLgbBH3ax2pFX
         27TYnAhsYH712KbrUwq7TdbsQ11T7lHRIXWNuLwFiPmV6p9TOHQFheUmO35D8sXkt1zF
         KFVs1/LlHNiYtQcictJS6vxebKuQM7fd9vvEBSgXAcW6JRlTLDdZsvHg008KyIGKQYBz
         2w2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qJq22moH50D3yv21TnAqKX91eugYhGfPDI8P8HcZhgY=;
        b=uJHVbOpBMtVeOXCIvwcM8zWYGgqOF/Ao3bqyk3OvPf4Z2YR77m366P9d3n70vwp/Eu
         2yHTNH/aNr9MMtFyLLLFXPln2qB9pXraxM6glUwg8/hQ71JvxHzwUxK9cyDK3esAEW7x
         PFG87t7K9EpIXhAtKRpL1UanRFJdyja0m8LWawpNB9pKjK45Dlrdq1lrfDOxTvx0X/U0
         4ogmd0cCHGg945pKOdgB+41k7SjYh4RANrJNINnWUDVdDtYkot6cXLpot7BscqQVlPhN
         ZbQ7WzpfxAlX5TdTD4LJEMqBMozqCE2duqrP99XX2aomXGiN31vDeL/v65ZMWrHDgD1S
         Debw==
X-Gm-Message-State: AOAM5308k+K4KYS4oJ9m+TauaJw/djm/PS07AGAdC3bVl/D93h31vRtZ
        m5pspW4VY6HO6iU6cBdTi4X+mw==
X-Google-Smtp-Source: ABdhPJyUVaMPjUt+mdsjqcf930Ct9uv9xglikY4FGgz8i3dp7UkGqa4JXcCFi8ZR3vHIZp8MjPpMFw==
X-Received: by 2002:aa7:cb96:0:b0:413:8d05:ebc with SMTP id r22-20020aa7cb96000000b004138d050ebcmr15415684edt.81.1650827037726;
        Sun, 24 Apr 2022 12:03:57 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm2847723ejo.191.2022.04.24.12.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 12:03:57 -0700 (PDT)
Message-ID: <3b8c790d-9e90-d920-9580-8e736435f7f3@blackwall.org>
Date:   Sun, 24 Apr 2022 22:03:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 2/2] net: vxlan: vxlan_core.c: Add extack
 support to vxlan_fdb_delete
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        Julia Lawall <julia.lawall@inria.fr>
Cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, jdenham@redhat.com, sbrivio@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        GR-Linux-NIC-Dev@marvell.com, bridge@lists.linux-foundation.org
References: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <0d09ad611bb78b9113491007955f2211f3a06e82.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <alpine.DEB.2.22.394.2204241813210.7691@hadrien>
 <06622e4c-b9a5-1c4f-2764-a72733000b4e@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <06622e4c-b9a5-1c4f-2764-a72733000b4e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2022 21:52, Alaa Mohamed wrote:
> 
> On ٢٤‏/٤‏/٢٠٢٢ ١٨:١٥, Julia Lawall wrote:
>>
>> On Sun, 24 Apr 2022, Alaa Mohamed wrote:
>>
>>> Add extack to vxlan_fdb_delete and vxlan_fdb_parse
>> It could be helpful to say more about what adding extack support involves.
>>
>>> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>>> ---
>>> changes in V2:
>>>     - fix spelling vxlan_fdb_delete
>>>     - add missing braces
>>>     - edit error message
>>> ---
>>> changes in V3:
>>>     fix errors reported by checkpatch.pl
>> But your changes would seem to also be introducing more checkpatch errors,
>> because the Linux kernel coding style puts a space before an { at the
>> start of an if branch.
> I ran checkpatch script before submitting this patch and got no error

This is what I got:
WARNING: suspect code indent for conditional statements (8, 24)
#366: FILE: drivers/net/vxlan/vxlan_core.c:1137:
 	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
[...]
+			NL_SET_ERR_MSG(extack, "DST, VNI, ifindex and port are mutually exclusive with NH_ID");

WARNING: line length of 111 exceeds 100 columns
#370: FILE: drivers/net/vxlan/vxlan_core.c:1139:
+			NL_SET_ERR_MSG(extack, "DST, VNI, ifindex and port are mutually exclusive with NH_ID");

ERROR: space required before the open brace '{'
#377: FILE: drivers/net/vxlan/vxlan_core.c:1145:
+		if (err){

ERROR: space required before the open brace '{'
#389: FILE: drivers/net/vxlan/vxlan_core.c:1164:
+		if (nla_len(tb[NDA_PORT]) != sizeof(__be16)){

ERROR: space required before the open brace '{'
#400: FILE: drivers/net/vxlan/vxlan_core.c:1174:
+		if (nla_len(tb[NDA_VNI]) != sizeof(u32)){

ERROR: space required before the open brace '{'
#411: FILE: drivers/net/vxlan/vxlan_core.c:1184:
+		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32)){

ERROR: space required before the open brace '{'
#423: FILE: drivers/net/vxlan/vxlan_core.c:1196:
+		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32)){

ERROR: space required before the open brace '{'
#430: FILE: drivers/net/vxlan/vxlan_core.c:1202:
+		if (!tdev){

ERROR: space required after that ',' (ctx:VxV)
#431: FILE: drivers/net/vxlan/vxlan_core.c:1203:
+			NL_SET_ERR_MSG(extack,"Device not found");




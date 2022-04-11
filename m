Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295264FBE5A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346835AbiDKOJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243386AbiDKOJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:09:32 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D71C1F60F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:07:17 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id j6so10672466qkp.9
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9zzzhPvN63EJarDgo5F+nUhVuzdYl4hsnveFvIUCa6U=;
        b=gbtW8kw0bD7IIYC564nOWDqhipxl+VCV0GO28wmfLNVkNEVnAmQv1WBwWc/jRnGwV5
         MVKybuMPilO8ldsivfLU53qHK9u/K45wCq+zRv49LnnPy0ZI71q0+vt57vTxngnu1xEn
         VNOprVrltZxUWH6Affiq2P/pHoo41twIehv42GUUK5V4zH560UdZU024FdpUNCoC7bTF
         kUyYin7/ZzQZNj3zxxynCRURojrX64gMZqWI4KmkzUW9BFEyLAnV2FvnA7pENgsoO7FP
         Oszk2r2NCKep+bBkYQnSVHdq8aOP28/8V+mR8XGRpKJ7MJqrzRKAgt0xMWT2ASqc6bUT
         ZY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9zzzhPvN63EJarDgo5F+nUhVuzdYl4hsnveFvIUCa6U=;
        b=0pCqawzQH0kDVCYZn9GeODKilJ7kEC7fndtRdMLT6C5QJk4BdwkMBp1oSUMZdm67Lk
         y8fgaQfuqNjePCdWk1zdH0uisIWVBFFtar9OW2/lm4H5ie+c+fU4B0u17QtqLnLVQBVG
         HKzCw9a3ms01LmtKuhskFWI6VLPN+E05j/w/YV028RXV8tlfb1w6DvmBOUphwPzC3s7g
         QUA4Wij2jiSRgoIlkhWC/ZpNOk1xJ0raz28sP3Htqu3zMC5WeQBqlLs+qt4ueP4JQJBs
         IGVtOURVJ1VjDwHQIzpv9ONkM5dItDNinNGn6gfvi1GAhK9WIWk/ebaqdMhsbjGD4yvh
         cu8g==
X-Gm-Message-State: AOAM530ToJxfXwLraUwsWfQRxRs3LXKloidD2ikT94EFVXwCe08/d2Tx
        /YFi04QYQvMQs6MknNfxY0L1Cg==
X-Google-Smtp-Source: ABdhPJzJYQ96V0Z9a2o/GKwz89BYZBhLINEoEDtfQR5bCthvLfz2s0+Qogzm9LdiyINzL46v8gKXxA==
X-Received: by 2002:a05:620a:c4b:b0:67e:11a2:7cfb with SMTP id u11-20020a05620a0c4b00b0067e11a27cfbmr21161441qki.9.1649686036309;
        Mon, 11 Apr 2022 07:07:16 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id e7-20020ac85987000000b002e1b7fa2201sm25261257qte.56.2022.04.11.07.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 07:07:15 -0700 (PDT)
Message-ID: <1b1b82a9-3e1b-d20a-f62c-f35fe1f155b8@mojatatu.com>
Date:   Mon, 11 Apr 2022 10:07:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 0/5] flower: match on the number of vlan tags
Content-Language: en-US
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>
References: <20220411133100.18126-1-boris.sukholitko@broadcom.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220411133100.18126-1-boris.sukholitko@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-11 09:30, Boris Sukholitko wrote:
> Hi,
> 
> Our customers in the fiber telecom world have network configurations
> where they would like to control their traffic according to the number
> of tags appearing in the packet.
> 
> For example, TR247 GPON conformance test suite specification mostly
> talks about untagged, single, double tagged packets and gives lax
> guidelines on the vlan protocol vs. number of vlan tags.
> 
> This is different from the common IT networks where 802.1Q and 802.1ad
> protocols are usually describe single and double tagged packet. GPON
> configurations that we work with have arbitrary mix the above protocols
> and number of vlan tags in the packet.
> 
> The following patch series implement number of vlans flower filter. They
> add num_of_vlans flower filter as an alternative to vlan ethtype protocol
> matching. The end result is that the following command becomes possible:
> 
> tc filter add dev eth1 ingress flower \
>    num_of_vlans 1 vlan_prio 5 action drop
> 

The idea looks sane. I guess flow dissector is now not just involving
headers but metadata as well. I can see this applied to MPLS for 
example, etc.
Can you please provide more elaborate example of more than 1 vlan?

Where would the line be drawn:
Is it max of two vlans?
Is there potential of <=X, meaning matching of upto X Vlans?

cheers,
jamal

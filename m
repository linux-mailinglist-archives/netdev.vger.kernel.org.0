Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FA64D1C95
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 16:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348044AbiCHP7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 10:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348637AbiCHP6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 10:58:21 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A489517FF;
        Tue,  8 Mar 2022 07:56:49 -0800 (PST)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRcCb-000FLb-6W; Tue, 08 Mar 2022 16:56:45 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRcCa-0005jg-S4; Tue, 08 Mar 2022 16:56:44 +0100
Subject: Re: [PATCH v3 bpf-next 0/3] introduce xdp frags support to veth
 driver
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, pabeni@redhat.com, echaudro@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
References: <cover.1645558706.git.lorenzo@kernel.org>
 <Yid8OBYtqEhlr30X@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9399f038-1197-e19e-4b1b-c63aa4b9537a@iogearbox.net>
Date:   Tue, 8 Mar 2022 16:56:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Yid8OBYtqEhlr30X@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26475/Tue Mar  8 10:31:43 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 4:54 PM, Lorenzo Bianconi wrote:
>> Introduce xdp frags support to veth driver in order to allow increasing the mtu
>> over the page boundary if the attached xdp program declares to support xdp
>> fragments. Enable NETIF_F_ALL_TSO when the device is running in xdp mode.
>> This series has been tested running xdp_router_ipv4 sample available in the
>> kernel tree redirecting tcp traffic from veth pair into the mvneta driver.
> 
> please drop this revision, I will post a new version soon adding a check on max
> supported mtu when the loaded program support xdp frags.

Ok, thanks for the notification, Lorenzo; tossed from patchwork.

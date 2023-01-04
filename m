Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB37D65D6B6
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbjADO6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjADO6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:58:25 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29D10A2
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 06:58:22 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id EE91260293A85;
        Wed,  4 Jan 2023 15:58:19 +0100 (CET)
Message-ID: <ba85381a-37dc-9e61-de71-527d686d6430@molgen.mpg.de>
Date:   Wed, 4 Jan 2023 15:58:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Seth David Schoen <schoen@loyalty.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Backporting *ip: Treat IPv4 segment's lowest address as unicast* to
 Linux 5.10.y?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux folks,


Seth backported commit 94c821c74bf5fe0c25e09df5334a16f98608db90 in 
OpenWrt [1]. Could we also add to the Linux LTS 5.10 series?


Kind regards,

Paul


[1]: 
https://github.com/openwrt/openwrt/commit/68f983ba4102faac55211c6c6e799641ed3e3da6

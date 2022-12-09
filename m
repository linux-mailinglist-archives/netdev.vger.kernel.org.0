Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D27648B4E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLIXUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLIXT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:19:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A049B296;
        Fri,  9 Dec 2022 15:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2ADEB829BA;
        Fri,  9 Dec 2022 23:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE5DC433EF;
        Fri,  9 Dec 2022 23:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670627995;
        bh=EABoT7dZpo3rJmaMyhA0E1HAb5w79M7WwC7+Gsjt9xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRLw7IdkQXqinseyhGTzsbT5BDDCXmleUUBQOwr2NC67heZwen2xlhCeyYZf88CBU
         z72RXOb2q6uqdVOD2CqTRurGDNVpMBDNgeUa6BcHj0D6BIIOEh8/eG3aSHOSQbXdZX
         448qa9TIexdpyX3cjPeuKBpfODKVUMj8bhnV0R31cWlAgMuYEvSb+CUpHFPYENsc9D
         OUbXSKsBqjHvRm0qcceAUCsnBIPLIvxxMlr2t0IywtYt3tJZQWp02zIS/BUXn0R8/3
         P6MFCYzpK5JokC5CPVkHQ09jTRfqvc/kihlsxy3UPXWD/AJuuvlmYXMOEF/QuMDl6L
         IilSsu2cw26wA==
Date:   Fri, 9 Dec 2022 15:19:53 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        lars.povlsen@microchip.com, UNGLinuxDriver@microchip.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net-next] net: microchip: vcap: Fix initialization of
 value and mask
Message-ID: <Y5PCmYVzx3nuZ9qa@x130>
References: <20221209120701.218937-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221209120701.218937-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 13:07, Horatiu Vultur wrote:
>Fix the following smatch warning:
>
>smatch warnings:
>drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:103 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'value'.
>drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:106 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'mask'.
>
>In case the vcap field was VCAP_FIELD_U128 and the key was different
>than IP6_S/DIP then the value and mask were not initialized, therefore
>initialize them.
>
>Fixes: 610c32b2ce66 ("net: microchip: vcap: Add vcap_get_rule")
>Reported-by: kernel test robot <lkp@intel.com>
>Reported-by: Dan Carpenter <error27@gmail.com>
>Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>



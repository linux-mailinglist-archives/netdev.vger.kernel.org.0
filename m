Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6284962C663
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiKPRbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiKPRbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:31:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257E832BAC;
        Wed, 16 Nov 2022 09:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5E1861F19;
        Wed, 16 Nov 2022 17:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7868C433D6;
        Wed, 16 Nov 2022 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668619904;
        bh=k/mclaGRWSSKaHQyVCATKfg00cajGmKZnSOod2U9WK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YRt1So9HKPrbeHYJZB7K7jXqsyi31FkOREw99T9TJ91gEXbwxVERE3ECreeoZ7ZeS
         c+Tot8d9qJDXrBh+k+ZDUBAD4qc1U08sN5VFAfbqVdRH6Zl7dA0rd7Pjl/zMLgJnHR
         +SyF0V29IcCVdpo1Ea+8+ywRIivzAQZGzr8C2nw047Tp0QgclMQTvazupYY4NHX/ni
         fF1PWaPs2Zf+VNjMgZlQyk+z5SoCofkxHTMzApj9lTP5NEz0wzk5ge45wUn5CmpPZL
         7br7bV3+85wzy2iNEG8z2af/7CzdImsf30c1aYBpqkweA/TI/sKSOLQYH/75Le1Mj7
         Gqm5Ec8vV821w==
Date:   Wed, 16 Nov 2022 09:31:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v2 1/2] dsa: lan9303: Change stat name
Message-ID: <20221116093142.3aed46a1@kernel.org>
In-Reply-To: <5842f6bc-f578-52a1-c8a4-7c04ada3c146@gmail.com>
References: <20221115165131.11467-1-jerry.ray@microchip.com>
        <5842f6bc-f578-52a1-c8a4-7c04ada3c146@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 09:08:58 -0800 Florian Fainelli wrote:
> This looks like a bugfix no? We should not we slap a:
> 
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the 
> SMSC-LAN9303")

With the entire Fixes tag as a single line ;) And that'll mean that
patches 1 and 2 need to be posted separately. First one to net and the
second one to net-next.

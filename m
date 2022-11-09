Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7556622136
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiKIBLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiKIBLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:11:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA1361753;
        Tue,  8 Nov 2022 17:11:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A602B81CC4;
        Wed,  9 Nov 2022 01:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AF0C433D6;
        Wed,  9 Nov 2022 01:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667956265;
        bh=N1mDvJWTQweP2UXmkBHXLZc3ZbvuCdWaKolpO1ltwFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UYAKWhagw/qGzdMBUGJr/M3IYHE9hv2hxN7xQ6cq4u1j+LfUKM8FGgbmWYRce7KkH
         k9xdgnsZPqYB+yFJ3neLswnWb+mTPGuCe/XVUfITtso5+3mXoFYq3yz9mi9tipbx0z
         hkUaql/VRt2OZzP4QjWJTlP4+hANdBmb5gB+2j5EsvcacUclZ/MzJveLnwYqZ5d2jn
         xucavTxEbRhZgVF8JtHxPwpRdJrJEcR3ISUCvmHvAw9orotNlvry/oyOr+KQ7jhews
         hdCXkJUub+ZYKqqsdq/bwu3kSCHiAjRHOOvf+q7g3Ca0zEi+lhGSQkR7vdOrn7czAP
         U5vis15rmEKBg==
Date:   Tue, 8 Nov 2022 17:11:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v5 0/8] Extend TC key support for Sparx5 IS2
 VCAP
Message-ID: <20221108171103.73ca999b@kernel.org>
In-Reply-To: <20221104141830.1527159-1-steen.hegelund@microchip.com>
References: <20221104141830.1527159-1-steen.hegelund@microchip.com>
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

On Fri, 4 Nov 2022 15:18:22 +0100 Steen Hegelund wrote:
> v5      Add support for a TC matchall filter with a single goto action
>         which will activate the lookups of the VCAP.  Removing this filter
>         will deactivate the VCAP lookups again.

There are conflicts applying this patch set to net-next now,
could you rebase + repost?

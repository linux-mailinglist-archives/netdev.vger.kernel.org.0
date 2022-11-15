Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE95629F08
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbiKOQ2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiKOQ2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:28:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64BDFC3;
        Tue, 15 Nov 2022 08:28:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95CC3B8199C;
        Tue, 15 Nov 2022 16:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8CCC433D6;
        Tue, 15 Nov 2022 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668529712;
        bh=ipaYfFl0oD9bil2P6jH1Lug9DkoRTE5mXrzrMm0NQWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E89RVoLH3qxY7gfoyp6OhNYNRcHrNZ6TdnRFR448AMjLKqYZoW32ntZskG4gUG/fj
         cJUr5MbkcxvrN62GxxVyGEkq3QS0R16wSSm4onjPuU3WtoqRsC/oYWFX4E5AomaAwN
         UvEhyvtRH74BI+oNJFojcU6qHMWC4fsooEAkvcksQqgfbbUndhbgK0VFjXVXQEgyA0
         4LU6fGrqHQd8dzcp/B6zLL5GoYkNsTLllAMvFKymbfXHQTfIVSeu/IT2GkVEttmQ1e
         bb8sh1Fo3NvXbs+vTdBnKCAZmUOXkk65fyhGoIi9OTh/Sq4B3laUlhP+mdfsC2bBCA
         57ErjFbeyIUqg==
Date:   Tue, 15 Nov 2022 08:28:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next v3] ethtool: doc: clarify what drivers can
 implement in their get_drvinfo()
Message-ID: <20221115082830.61fffeab@kernel.org>
In-Reply-To: <CAMZ6RqJ-2_ymLiGuObmBLRDpNNy0ZpMCeRU2qgNPvq2oArnX8A@mail.gmail.com>
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
        <20221113083404.86983-1-mailhol.vincent@wanadoo.fr>
        <20221114212718.76bd6c8b@kernel.org>
        <CAMZ6RqJ-2_ymLiGuObmBLRDpNNy0ZpMCeRU2qgNPvq2oArnX8A@mail.gmail.com>
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

On Tue, 15 Nov 2022 16:52:39 +0900 Vincent MAILHOL wrote:
> - * @fw_version: Firmware version string; may be an empty string
> - * @erom_version: Expansion ROM version string; may be an empty string
> + * @fw_version: Firmware version string; drivers can set it; may be an
> + *     empty string
> + * @erom_version: Expansion ROM version string; drivers can set it;
> + *     may be an empty string

"drivers can set it" rings a little odd to my non-native-English-
-speaker's ear. Perhaps "driver-defined;" ? Either way is fine, tho.

>   * @bus_info: Device bus address.  This should match the dev_name()
>   *     string for the underlying bus device, if there is one.  May be
>   *     an empty string.
> @@ -180,9 +182,10 @@ static inline __u32 ethtool_cmd_speed(const
> struct ethtool_cmd *ep)
>   * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
>   * strings in any string set (from Linux 2.6.34).
>   *
> - * Drivers should set at most @driver, @version, @fw_version and
> - * @bus_info in their get_drvinfo() implementation.  The ethtool
> - * core fills in the other fields using other driver operations.
> + * Majority of the drivers should no longer implement the
> + * get_drvinfo() callback.  Most fields are correctly filled in by the
> + * core using system information, or populated using other driver
> + * operations.

SG! Good point on the doc being for the struct. We can make the notice
even stronger if you want by saying s/Majority of the/Modern/

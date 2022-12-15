Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3913B64D5BF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 04:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLODzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 22:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLODzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 22:55:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D50113E15
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 19:55:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54BA1B81A13
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 03:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CE8C433EF;
        Thu, 15 Dec 2022 03:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671076546;
        bh=hUrXNhuhRQ1ubTrU8XdbVW9KpPSDe4JMvPJhtryIu+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mkkaY4QEuc2UwEhlv7Qv5Ecdb51V6l5d5YzmBKB5n1iwwXlKUgs28luFePzMEJttd
         7t7GSerR+2sji7TJ9l4Kvs5pI3fRWpmG6ZVmn2FESlGbLDdebZiYm1hudwtyqLVKtA
         IycgkCruHrfWgFE4cXfy1G+OYUV1eZS2fo+49GNekQSBc7I5JJXdKqoh1u7X7SuPdt
         wkfT033qmNLHZ5L7hBfweNsD+EVgcrZ+ZLvzuPZ/lADPePbi9yOfqb3+xKm4GO5dRa
         Yop/uJbgHzbhdqj/vjbJWepC/Swa3/wyerGZJqZ5MUBAfxlC4gzUfOiKVuRMxRWeIc
         ZMX59j/A1sAxg==
Date:   Wed, 14 Dec 2022 19:55:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH ethtool-next v1 0/3] add netlink support for rss get
Message-ID: <20221214195544.65896858@kernel.org>
In-Reply-To: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
References: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
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

On Wed, 14 Dec 2022 15:54:15 -0800 Sudheer Mogilappagari wrote:
> These patches add netlink based handler to fetch RSS information
> using "ethtool -x <eth> [context %d]" command.

Can we please support JSON output from the start?
I can't stress enough how useful json output is in practice.

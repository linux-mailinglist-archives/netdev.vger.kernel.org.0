Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA58A69B72D
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 01:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBRAvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 19:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBRAvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 19:51:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD05840DF;
        Fri, 17 Feb 2023 16:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=x7SdNnCw+9pEPf0Fv6F2R1Hf0cHjwJ79vpLEtLZyn8k=; b=mnSScH0Q+BMXkAUBOfdjzdIeso
        NLZrXnwtRVIAPQcYcl14vva1QyZ/b3LQT0T61F0qubKsCw6J3/kaUtxepAsY7d5l2QjYBfZHCVwXJ
        7fu9zmykeqYyqbrAF2ZuoMlaT2xGifvO2m0xzLghqZGLyLq0QeJ9gAWSx5lc39z36viM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTBRV-005M31-MP; Sat, 18 Feb 2023 01:51:09 +0100
Date:   Sat, 18 Feb 2023 01:51:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bo Liu <liubo03@inspur.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: pse-pd: Fix double word in comments
Message-ID: <Y/Ag/b8HAtqWlyfg@lunn.ch>
References: <20230217071609.2776-1-liubo03@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217071609.2776-1-liubo03@inspur.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 02:16:09AM -0500, Bo Liu wrote:
> Remove the repeated word "for" in comments.

Hi Bo

How did you determine the list of people to email?

./scripts/get_maintainer.pl net/ethtool/pse-pd.c
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL],commit_signer:2/3=67%)
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL],commit_signer:3/3=100%,authored:2/3=67%,added_lines:30/215=14%,removed_lines:51/51=100%)
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [GENERAL])
Oleksij Rempel <linux@rempel-privat.de> (commit_signer:2/3=67%,authored:1/3=33%,added_lines:185/215=86%)
Andrew Lunn <andrew@lunn.ch> (commit_signer:1/3=33%)
kernel test robot <lkp@intel.com> (commit_signer:1/3=33%)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

Oleksij Rempel actually added this file, so you really should Cc: him,
even for trivial patches like this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

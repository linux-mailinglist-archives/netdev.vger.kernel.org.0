Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD24E6DFD71
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 20:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjDLSZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 14:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjDLSZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 14:25:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAF572A9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 11:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A5563329
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 18:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1511BC433D2;
        Wed, 12 Apr 2023 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681323950;
        bh=UEarsG8+t9h8x0NcSx6SKLQ286Rdbp1kW501IH/u5Pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rw4r1bjxez4sjgEz2qfJ95KECPAbSZMIMUDps6w/OLDVxTk97Jbt8JZLR+Ri2SKju
         CcGaAkOI5FiwRA5saOEyQrYL7e0WlUGxUgwcML4TtSzTtzDGqYOUm6XgG+v6vFuIum
         PCr3asMuYdcTivtfnSnLXyYCIr2Xbp6b0uEGOQyUaZT0fuJ8vkQyZ6fv07z2S1L22+
         BORMVhWeEGkF24zCaXvdDoYRxzNlmaxy5Bl09+U/JT0yTdTPGiONWSgvAclAZ2GryA
         IWk5uZJWJzVlRlxhl9bB4vGWKe5rTejFh1HwY1MbX6IJZzWEk5D8QxL0XCpMZsIjk/
         +hxcpgMfoVfoA==
Date:   Wed, 12 Apr 2023 14:25:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, willemb@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org, decot@google.com,
        davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel IDPF
 driver
Message-ID: <ZDb3rBo8iOlTzKRd@sashalap>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 06:13:39PM -0700, Pavan Kumar Linga wrote:
>v1 --> v2: link [1]
> * removed the OASIS reference in the commit message to make it clear
>   that this is an Intel vendor specific driver

How will this work when the OASIS driver is ready down the road?

We'll end up with two "idpf" drivers, where one will work with hardware
that is not fully spec compliant using this Intel driver, and everything
else will use the OASIS driver?

Does Intel plan to remove this driver when the OASIS one lands?

At the very least, having two "idpf" drivers will be very confusing.

-- 
Thanks,
Sasha

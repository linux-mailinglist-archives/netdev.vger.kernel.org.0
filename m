Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE15588285
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiHBT3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 15:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiHBT3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 15:29:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C9952DD4;
        Tue,  2 Aug 2022 12:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA9766149D;
        Tue,  2 Aug 2022 19:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE584C433D6;
        Tue,  2 Aug 2022 19:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659468591;
        bh=sDAM1SkrSW3oBwm2JR0NuYN1X7SGSbkmaVuAjkVRnLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FMRKUMQUJr2ZmEXgrIarTKzASc1dJpL8ZyXHffsbBbpxJQ40EiUel1hWPcWuQTd/t
         F6L4FYY61TexsKxgJrR+P6L7Z+lbmyesVMb24rHeGYZOkBtYuF4XnN0b8qdij6qWWh
         Ti+qjzrnfTpINxlINhk0mpgAQLD5speoVw19qjo3VX/y7AMzg9iMO3Vl8lIXVWpnwu
         Ll+fUYt23wgAdg7eKP42pBOE25DP5FJhizfb06otZgtkQEk9KkeJ77MJkWf1LvQksf
         PE/d9fBBdxV2vg+bsA9BqM7jBG6LvQl5rNfQUKKOkh9jPUWzkXHiIIRdiOAyuX6ODA
         2rjP0SmjMbU/g==
Date:   Tue, 2 Aug 2022 12:29:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [net-next v3 0/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <20220802122949.7080822f@kernel.org>
In-Reply-To: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
References: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Aug 2022 18:59:44 +0300 andrei.tachici@stud.acs.upb.ro wrote:
> Subject: [net-next v3 0/3] net: ethernet: adi: Add ADIN1110 support

# Form letter - net-next is closed

The merge window for Linux 6.0 has started and therefore 
net-next is closed for new drivers, features, code refactoring 
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 6.0-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.

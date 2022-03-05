Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BA64CE283
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 04:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiCEDrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 22:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiCEDrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 22:47:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B279240078;
        Fri,  4 Mar 2022 19:46:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17DD860B22;
        Sat,  5 Mar 2022 03:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2ADC004E1;
        Sat,  5 Mar 2022 03:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646452001;
        bh=THvl/XBRt/H3hsP73htK0LNdZZJbBwfB3D+k9ciILWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XFY5joiuEoOUr70zRMrxLuVNjC/+/TPsuPjrRVTv9iZenElb81NxskfVHELiuRxWN
         G7qxeEh2sWn2A2JSnq87F3RYbZLEKOPEj3gdTRzM+K6YUW5CiTx728uyFHN9ZyX1ob
         +yUQnmidNHCH/Px2mX/Ld8bILkyt7qumEfJVtnQXfQDOm3GSFmTg6YEI5ZTZrOQ/7Y
         INFmt0IhP+qvthIGVudKJI8aFl8CNwF8nDF0/zQfBSjkQlUX9OVJXtUXS25gbqlFL+
         WhuMl/CcPM6EsPc+BHGno0VXio1IwcTZOUgswpIGbMwGU+9DXqeEervm9xWLae5qjY
         7G48zwuaRpt1w==
Date:   Fri, 4 Mar 2022 19:46:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2022-03-04
Message-ID: <20220304194640.4409744d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220304193919.649815-1-luiz.dentz@gmail.com>
References: <20220304193919.649815-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Mar 2022 11:39:19 -0800 Luiz Augusto von Dentz wrote:
> bluetooth-next pull request for net-next:
> 
>  - Add new PID/VID (0x13d3/0x3567) for MT7921
>  - Add new PID/VID (0x2550/0x8761) for Realtek 8761BU
>  - Add support for LG LGSBWAC02 (MT7663BUN)
>  - Add support for BCM43430A0 and BCM43430A1
>  - Add support for Intel Madison Peak (MsP2)

The missing sign-offs are back. I don't think our attempts to fix that
last time did much good, so let me pull, but please be vigilant.

The checker script is here FWIW:
https://raw.githubusercontent.com/gregkh/gregkh-linux/master/work/verify_signedoff.sh

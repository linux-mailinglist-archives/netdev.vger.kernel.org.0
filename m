Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4D53941B
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345785AbiEaPiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345784AbiEaPiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ECE515AA
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 08:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B3F16136F
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 15:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC84C385A9;
        Tue, 31 May 2022 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654011479;
        bh=pghjFWuzmnr+8XPeplwQLYeC45U9JY3EtacsQNDkwHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b5FMFm2E5HjX7SOoPZlQUPF/L+bPfeV4NVHXv+PbRHn8MX8kbHKoa/QI8YV8kwaLj
         J0I/HWU7HIfN+UVc2cTg///2OW/VIvmKUdvAs4K2kucGKpVnf4h/GzmtdtVWtHLsmh
         3IeQ6oS6xbtQIM07XnI821rafGFQny9kjGSxwNML9hgXpZw/Dxcuy9oZIMAK9gstck
         oyDZqJFiojs+26F4SPmJLcJUlaGnBpH4yPmHIX8+VBwT9N5oqWuRZGtFrW4iAuXX74
         sacO3+8bKLV/8QdBpmjbtpN3bBw/lIMScjkZDdbxpf6PTflBipU7JAAf1MPieYYCWb
         3BAsn2qolMirg==
Date:   Tue, 31 May 2022 08:37:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] sfc/siena: fix some efx_separate_tx_channels
 errors
Message-ID: <20220531083757.459b65dc@kernel.org>
In-Reply-To: <20220531134034.389792-1-ihuguet@redhat.com>
References: <20220531134034.389792-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 15:40:32 +0200 =C3=8D=C3=B1igo Huguet wrote:
> Trying to load sfc driver with modparam efx_separate_tx_channels=3D1
> resulted in errors during initialization and not being able to use the
> NIC. This patches fix a few bugs and make it work again.
>=20
> This has been already done in sfc, do it also in sfc_siena.

Does not apply.

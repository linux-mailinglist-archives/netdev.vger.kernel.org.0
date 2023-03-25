Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30046C8A1C
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjCYCIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjCYCIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:08:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2636A149A7
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 19:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D759CB82610
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 02:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66601C433D2;
        Sat, 25 Mar 2023 02:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710087;
        bh=F3rGjl9MugXH6OoItAcJHGg0BgIUhsHNvdudGkCwmxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iiPFB2BZqvxTpOLdsBW7hbK8v0yuW+b+aUDHklPaC9smfDNaZdE3iHK9WplZJX959
         t01yHD80gA9k8zROL25sKvwSfSrZvEf04hscNpGH8T3qfH0mSSlNaF+AclcConHI0/
         PAVhkM13utTIXoJyXW4XNAAnDU9F/6/Ld0Iv/qIDnmR4G7iqupjQCjQ3QjKBj9m4Qz
         Jhg9jYJZHFEWuoCT+PqfaN4LyqqiG5tpSNV0Ogm5xUo87fqvtChWdn6GBMVaIzqZbF
         izIr2jDEDSM13uIC/xnS9Xn53nv2Q15vqnGpgLkFSwuvOP+u8bISSM1E7xDebJCoVA
         JFitaELGHWqSQ==
Date:   Fri, 24 Mar 2023 19:08:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <hkallweit1@gmail.com>
Cc:     ChunHao Lin <hau@realtek.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [PATCH net v2] r8169: fix RTL8168H and RTL8107E rx crc error
Message-ID: <20230324190806.133faca0@kernel.org>
In-Reply-To: <20230323143309.9356-1-hau@realtek.com>
References: <20230323143309.9356-1-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 22:33:09 +0800 ChunHao Lin wrote:
> When link speed is 10 Mbps and temperature is under -20=C2=B0C, RTL8168H =
and
> RTL8107E may have rx crc error. Disable phy 10 Mbps pll off to fix this
> issue.
>=20
> Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
> Signed-off-by: ChunHao Lin <hau@realtek.com>

Hi Heiner, looks good?

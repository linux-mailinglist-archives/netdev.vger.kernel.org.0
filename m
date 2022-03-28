Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEF4EA15A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245420AbiC1UWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344410AbiC1UWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:22:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B4740E4D;
        Mon, 28 Mar 2022 13:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD83B81204;
        Mon, 28 Mar 2022 20:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF991C340F0;
        Mon, 28 Mar 2022 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648498816;
        bh=DYKSgCLyLSG5eVAyXEXBJzv5wUb4KbwLHueX4TuM2es=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nccR77DmMt5fnc/o6gzPVyT3/n47SLxU5yK+UpwKdHx+DMcaLuX/6OketRHPbmZK4
         q8cXPhOeS5U/lTt4ZBRJMWdOApW5jbpoUqhxVh/BedGBZMTMV5wkH3BtP7s6iGDW7Q
         y0QdQapyEyF3Bt/RYtFN3DcVWfO6ymXfIwUMVbM0YopTHxL2aIt7JhbD6dj4ejWOxW
         pc+m/7ZMIf0Ie62Bdb6sgKnlk4iE+Z9kmM5yyWzogfPqXEglCECce8tPm4qxiKW+nA
         n66IatdJU8T97URqDPNt56LnxyLR99fOCTtEa0OoWadqYlrX2oFEX/OYDMGmH5+pqh
         E51HpRAN1M85Q==
Date:   Mon, 28 Mar 2022 13:20:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Benjamin =?UTF-8?B?U3TDvHJ6?= <benni@stuerz.xyz>
Cc:     Kalle Valo <kvalo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/22] Replace comments with C99 initializers
Message-ID: <20220328132014.6b8c0a21@kernel.org>
In-Reply-To: <cc104272-d79a-41e1-f4de-cb78fb073991@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz>
        <87fsn2zaix.fsf@kernel.org>
        <cc104272-d79a-41e1-f4de-cb78fb073991@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Mar 2022 13:51:42 +0200 Benjamin St=C3=BCrz wrote:
> > Just a small tip: If you are new, start with something small and learn
> > from that. Don't do a controversial big patchset spanning multiple
> > subsystems, that's the hard way to learn things. First submit one patch
> > at a time to one subsystem and gain understanding of the process that
> > way.
>=20
> I actually thought this would be such simple thing. Do you know of any
> good thing where to start? I already looked into drivers/staging/*/TODO
> and didn't found something for me personally.

FWIW on the netdev side there's work coming to convert a set of features
from unsigned long to a BITMAP which will require converting a lot of
drivers to an explicit helpers from direct access.

https://lore.kernel.org/all/20220324154932.17557-14-shenjian15@huawei.com/

If it seems interesting enough you can try reaching out to Jian Shen.

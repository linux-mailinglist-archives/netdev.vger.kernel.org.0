Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D228668754A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjBBFip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjBBFiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:38:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980837F6B2;
        Wed,  1 Feb 2023 21:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48287B82410;
        Thu,  2 Feb 2023 05:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97590C433EF;
        Thu,  2 Feb 2023 05:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675316117;
        bh=uNgmP9SRUAz5KYM3lBfnzzQKQg8IDZramM4i2rbaMp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nr00+ntTEPu+Ib54xeituoy4BRBrjVMda6QdH7usVo5txQdUlywnvmRXAemX9XdJo
         /y2dgbDCPGHomDSWy9IGd1jgJiHspV+NdHg/RQf2BxJPDOWX9VLBIoc3Mhr9GfYDIH
         650QC1QZfVusnXfo5nYKqzdp+SaI2b8FBlErIgnP/X/3WWIxwF8g44P5NkQ0Lx58Rm
         bxrlDkeRwToJiVWCXVPBOLxhmIjClwoF+fAb9yfsDE0Ow3SpGbSBCeFQjGhYoIdGpD
         txupNwgIcYj428OPxVr8vLOCpyo3WiqzFU8fJ15+eQnBBL0d2isjJCvq+YaRwVwOxy
         gIRsXEOvfKdWQ==
Date:   Wed, 1 Feb 2023 21:35:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?6Zm2IOe8mA==?= <taoyuan_eddy@hotmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?UTF-8?B?5Zue5aSNOg==?= [PATCH v2 1/1] net: openvswitch:
 reduce cpu_used_mask memory
Message-ID: <20230201213515.6ffeb25a@kernel.org>
In-Reply-To: <OS3P286MB2295325EEB3F45E1F974001EF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <OS3P286MB22954422E3DD09FF5FD6B091F5D19@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
        <Y9pstLgirSaKz9qh@nanopsycho>
        <OS3P286MB2295325EEB3F45E1F974001EF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 05:09:51 +0000 =E9=99=B6 =E7=BC=98 wrote:
> I guest you are pointing to the field "From: taoyuan_eddy@hotmail.com" in=
 the patch header linked from "Headers show" section in the patch page
>=20
>=20
> https://patchwork.kernel.org/project/netdevbpf/patch/OS3P286MB22954422E3D=
D09FF5FD6B091F5D19@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM/
>=20
> I will fix that accordingly.

The From is correct, please look at the entire email Jiri also
commented about the code.

Two more notes:
 - don't top post on the list
 - reply in plain text not HTML

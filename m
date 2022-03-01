Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9A74C8443
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 07:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiCAGoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 01:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiCAGoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 01:44:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6895C583BB
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 22:43:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB0A46119E
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 06:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC49C340EE;
        Tue,  1 Mar 2022 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646117014;
        bh=xkgVGQunhZzASom+AwYVbZbNBA6U/qrxiRBWLGuu7BE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RT2Uw/7LjM7WuUqBHk6iH7T25m6+v5dVdyTzCGZ2i0BoVUlA0+1A5s2YKywYEqOCB
         K5SDZYCF6u1FtOCZNF4qxU3Kn3/QbkKaPtZeQQBDn3n6B7juvao/yOiN+uTAecQSji
         EC1aDzxlQpFT8ZvslHXBlJEWe7R8OP06QatUFkGh4/j3rZYHdtIuKLbujQ0ohm6O3Q
         Gsy2fjGbCbkzPUdnBng3pTeHX5geg6OUv++ALMU+YuLsT7lbNqlRsa8VDjZ/GnldO+
         fqoG7BrK1yuKZHEo1Te84KmVrEu7KU9oyAeXs+U+ZXl5fjUoe6xitR8y3T4igDBlRc
         X12dfTCZzfEcQ==
Date:   Mon, 28 Feb 2022 22:43:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai =?UTF-8?B?TMO8a2U=?= <kailueke@linux.microsoft.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH 2/2] Revert "xfrm: state and policy should fail if
 XFRMA_IF_ID 0"
Message-ID: <20220228224332.0cca8d99@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <924f1394-5fd4-590a-16b4-fb4d60185972@linux.microsoft.com>
References: <447cf566-8b6e-80d2-b20d-c20ccd89bdb9@linux.microsoft.com>
        <924f1394-5fd4-590a-16b4-fb4d60185972@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 19:53:59 +0100 Kai L=C3=BCke wrote:
> This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because it
> breaks userspace (e.g., Cilium is affected because it used id 0 for the
> dummy state https://github.com/cilium/cilium/pull/18789).
>=20
> Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>

What's the story here? You posted your patches twice and they look
white space damaged (tabs replaced by spaces). Does commit 6d0d95a1c2b0
("xfrm: fix the if_id check in changelink") which is in net/master now
solve the issue for you?

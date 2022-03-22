Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5584E3559
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiCVAX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbiCVAX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F6022BD9
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 17:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66BE96159A
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 00:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922B3C340E8;
        Tue, 22 Mar 2022 00:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647908395;
        bh=yz2HsEPB15vob2ZyDuvGZxXm4nZX4zlilN56i7l6xig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LzXRwlpEqPcD2OLR93OUDhZZluTkvKe1FL047G3BkXFn6UHbBpfEQwkJjdBJdyI8o
         Ll0fg5VlZ1yTTiTPlUA0UCyJ7Rr79dUqp8uBI07zEysKoy6JWPJIXBq/d29EK7xydF
         xGn8fzGjp5jUB1Ohlu5TPJh2QKTGhxprS124CDB86mC+aLS5aYZ5WaHWCmvGywqCXI
         CxucgtWdaDyQ23JNYrL6ELH19ZMjwn483Ed6nX4H38ZhLX2Iq1bWLu14FeMV+tRhfB
         I0uI/VYTEYZt3L7j42kkAjd3Vqv7LgX6o4Lz+CybNw4lwVB7C8CdYOpo/zceeybiou
         aUQoy3s9eT/UQ==
Date:   Mon, 21 Mar 2022 17:19:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: geneve: add missing netlink policy and
 size for IFLA_GENEVE_INNER_PROTO_INHERIT
Message-ID: <20220321171954.28d89f5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220319093454.1871948-1-eyal.birger@gmail.com>
References: <20220319093454.1871948-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Mar 2022 11:34:54 +0200 Eyal Birger wrote:
> Add missing netlink attribute policy and size calculation.
> 
> Fixes: 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

You should also set .strict_start_type on the policy to
IFLA_GENEVE_INNER_PROTO_INHERIT while at it.

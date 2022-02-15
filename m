Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8674B5FA3
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbiBOAy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:54:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiBOAy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:54:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F14BC8F;
        Mon, 14 Feb 2022 16:54:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AABB614F8;
        Tue, 15 Feb 2022 00:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0C0C340E9;
        Tue, 15 Feb 2022 00:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644886478;
        bh=HEiIZMjEKQ7AQOV3WTDf8XC3x+qJ7mJU59+gDlJbdVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y4EhxNa1TpAWFPO5vL1e9pgKFCFscD5yp+z9OG5Xv++M9n6iazAFJitTQhXdQOz3q
         ZOnyKymr5UmO0G5drdewoxRmOmE04JTs8pz2nmoFpRTTRsYoiTc0McSqL6NASmzopw
         TJT8I8HjfC/H3jJZF9jo8hwmVlJAa9ln6keCvOpTg7mgCRyBraOxY8P8QqM95SyftB
         zsukqEJ5jKKLRp6eBu3RE0ZgxYTlcF7ESmVa3MExJvUcCujk46SR1qu8W3SGbuGykk
         K2HK1UkOlM7lE7VRYPcDf/rTmZf2RpEEEoIMizqoa4BEPx6sPq4r8oNMjPv1I7Qi3p
         tRcQ5vdwaYwyQ==
Date:   Mon, 14 Feb 2022 16:54:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>, netdev@vger.kernel.org,
        davem@davemloft.net, selinux@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prashanth Prahlad <pprahlad@redhat.com>
Subject: Re: [PATCH net v3 2/2] security: implement sctp_assoc_established
 hook in selinux
Message-ID: <20220214165436.1f6a9987@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHC9VhT90617FoqQJBCrDQ8gceVVA6a1h74h6T4ZOwNk6RVB3g@mail.gmail.com>
References: <20220212175922.665442-1-omosnace@redhat.com>
        <20220212175922.665442-3-omosnace@redhat.com>
        <CAHC9VhT90617FoqQJBCrDQ8gceVVA6a1h74h6T4ZOwNk6RVB3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Feb 2022 17:14:04 -0500 Paul Moore wrote:
> If I can get an ACK from one of the SCTP and/or netdev folks I'll
> merge this into the selinux/next branch.

No objections here FWIW, I'd defer the official acking to the SCTP
maintainers.

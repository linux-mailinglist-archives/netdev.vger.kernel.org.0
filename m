Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63766682202
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjAaC00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjAaC0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:26:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5851E39C;
        Mon, 30 Jan 2023 18:26:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 601666123A;
        Tue, 31 Jan 2023 02:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C896C433D2;
        Tue, 31 Jan 2023 02:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675131983;
        bh=aCCucSdoSdhppwPg+lsdxd6WYii3AlD+yZxP5jbXsd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZC2jjT1Qm1s6v2bpupIemKEcSG/fS/pN/xLn+1FABAzMTaA1kLw8OovvOLMxcmNiF
         XZV43UiKT6+55yBpeljKeyZ8IEAZNFskK2+bo6zYpszyRe5e+oGIWJoIg3uLK5650C
         llu/o3MP28niw5vxAfQy9m08nhlNd1PlbhmJw3b7IY+XKBKNJMx5PyJbNjBkOMvgGv
         1zCxdmctIZHVH/VUXniF7RmkrnjBktxFPRKE0wkaKWojo4RWco4fNbhB2lejB38xPe
         1ryO5JFkgA15VP5K15C+ZDj/Wi+61hxGCDEUPGSugOH6p1vgqojVQGWa1FnJ6HW46f
         n2wRM9JliNw0Q==
Date:   Mon, 30 Jan 2023 18:26:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add kerneldoc comment to napi_complete_done
Message-ID: <20230130182622.462a2e0e@kernel.org>
In-Reply-To: <20230129132618.1361421-1-j.neuschaefer@gmx.net>
References: <20230129132618.1361421-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Jan 2023 14:26:18 +0100 Jonathan Neusch=C3=A4fer wrote:
> Document napi_complete_done, so that it shows up in HTML documentation.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index aad12a179e540..828e58791baa1 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h

Please put the doc in the source file, rather than the header.


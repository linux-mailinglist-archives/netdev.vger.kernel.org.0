Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBA76BDB0E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCPVfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCPVft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63325B41B;
        Thu, 16 Mar 2023 14:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3836562032;
        Thu, 16 Mar 2023 21:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321E2C433EF;
        Thu, 16 Mar 2023 21:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679002547;
        bh=R4HZeWi7PTHx5F9UF+jKDoQEKtKmsTGxdYSqVIkV7XM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hF1xfHjAgcNypQ4Unhr+OScQjzVaNTyKEqlsvulBZmaedRSl7aS37c1Dz9IKgvpeZ
         N+byNgWsts8stXI9Ct3HNaAN4gqZHsU//m8OyFnaoKHdwg30FrTQSW8B2vNmg8qvHh
         xaDuTSZEY5HJcS1fGbl0DRL3DjjWOPHJ9MZrajVk6XRcMTCwD06KNrR/rzJX9Ttw0Q
         7iKI4u5uZPrGJBPh/0gs947e3oY5sjUlPE9ZaIdR7xoOv+oT2zx/ei/HXmRsDG59re
         xZp1IhIjjdjH9OQLb5M+uRG77n6EP6HUQ1ZAp4uvsJuxBzU9DslV/7/IwU5MtTKkiS
         gWzLGlbwL3ymg==
Date:   Thu, 16 Mar 2023 14:35:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230316143546.74676a59@kernel.org>
In-Reply-To: <87o7ot9eh1.fsf@toke.dk>
References: <20230315223044.471002-1-kuba@kernel.org>
        <87o7ot9eh1.fsf@toke.dk>
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

On Thu, 16 Mar 2023 11:29:14 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > +Threaded NAPI
> > +-------------
> > +
> > +Use dedicated kernel threads rather than software IRQ context for NAPI
> > +processing. The configuration is per netdevice and will affect all
> > +NAPI instances of that device. Each NAPI instance will spawn a separate
> > +thread (called ``napi/${ifc-name}-${napi-id}``). =20
>=20
> This section starts a bit abruptly. Maybe start it with "Threaded NAPI
> is an operating mode that uses dedicated..." or something along those
> lines?

Fair point, I'll change as suggested.

> Other than that:
>=20
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Thanks!

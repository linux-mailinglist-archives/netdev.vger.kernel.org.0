Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856B363B367
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiK1Uhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbiK1UhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEFE2E9F0;
        Mon, 28 Nov 2022 12:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77F7D61425;
        Mon, 28 Nov 2022 20:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803FEC433D6;
        Mon, 28 Nov 2022 20:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669667831;
        bh=gA/R9XUu1RyeNA5k8uLXGdmmguYce0gCqm1AwGbvTaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1TfiEAavDQ6tX9zQsI0HAPzJT3sgpyAgqHN+QGhveiTb7L7ehPho3ESXOD1RsGiF
         iVlQwpIoRhBKgV8bbuFzTWLTpt2SR7d0IN4QLOKfh9eCIn4X71F7X53ALV2Pkg/v0r
         Vv5+QzsD6ukL0Zeoy4+piWYbfkYqitr7qEHLPBbWMb3YE8ZAipOqv8UyuqKhtjQEMN
         INmyK4+taD8G4lPLrAB0ytW0NVA0RXd8bst8L/QegHUhQ4/BaNR+avB835ww9g8cBD
         ONBZ0jYDOyfjpGHC35vjLBJbas25dALH38AslzttfYISp+NZH87HaU3bR0QJhquZRF
         tO94SYGYHL7iA==
Date:   Mon, 28 Nov 2022 12:37:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        yc-core@yandex-team.ru
Subject: Re: [RESEND PATCH v1] drivers/net/bonding/bond_3ad: return when
 there's no aggregator
Message-ID: <20221128123710.7f295930@kernel.org>
In-Reply-To: <20221124080008.188175-1-d-tatianin@yandex-team.ru>
References: <20221124080008.188175-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Nov 2022 11:00:08 +0300 Daniil Tatianin wrote:
> Otherwise we would dereference a NULL aggregator pointer when calling
> __set_agg_ports_ready on the line below.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Did not make it to the list.

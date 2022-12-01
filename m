Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E74763E969
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiLAFqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLAFqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:46:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A167740E;
        Wed, 30 Nov 2022 21:46:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A644B81DEC;
        Thu,  1 Dec 2022 05:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28FDC433D6;
        Thu,  1 Dec 2022 05:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669873596;
        bh=VUtsviNV3rU/6hUaSUnVyOu2cg1Pbw372sWMP+ogmFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dpYMSBdhXxXGH/67nBSXACQ9sHvOFPwT6ABdASy27c6Hmn6sWH78Y+3AhwkMLGOYy
         PRvvDFIDxsSkaSc8tbF1AguhVsG856o7RKq6cjNHBTbh935bnCDpusce37dhQleANb
         +ecilIMG0BaqeB6MxYNil/gewVmeG2XRDPQ96eUPfV7ABgNdot6spXbnHXQgbdlECZ
         lhRA+Yr1KKU2maUYHrEgkiHPJ8fYrNLo6sqJBfttKoPt+IeP7b67XXnYU04CiEtRwu
         ABsKB+PHSBufaqQnnogyGxw8pLJm2jzAHALY1Cv00KuQG3fDaow8ARM//nqLpoxaqs
         PMEx0ndDrdXng==
Date:   Wed, 30 Nov 2022 21:46:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v1] drivers/net/bonding/bond_3ad: return when
 there's no aggregator
Message-ID: <20221130214635.362c80e0@kernel.org>
In-Reply-To: <20221129072617.439074-1-d-tatianin@yandex-team.ru>
References: <20221129072617.439074-1-d-tatianin@yandex-team.ru>
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

On Tue, 29 Nov 2022 10:26:17 +0300 Daniil Tatianin wrote:
> Otherwise we would dereference a NULL aggregator pointer when calling
> __set_agg_ports_ready on the line below.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Okay, went thru, now let's try CCing the maintainers of bonding...

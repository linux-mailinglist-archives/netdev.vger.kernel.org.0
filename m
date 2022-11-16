Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6579662B249
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiKPEX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiKPEX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:23:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DFF3E0A2;
        Tue, 15 Nov 2022 20:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B926EB81AC8;
        Wed, 16 Nov 2022 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A4FC433B5;
        Wed, 16 Nov 2022 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668572417;
        bh=ZPuXBMXyGGEChyGhyLmvOZeldjgCCa80SQQC+Tek/RE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L3DthBrlNJz7h7A4J7e1yB3aRQY4zmK4yRlpaRBIEX7OYSCkPhGkwX2pJ7PhZ7/Ci
         Wl8M80Ie25kwRl6c+Np9Knyz2y1i5Kj/N2oZoEQhYm4HBQwVnxhVYwrkg+fP1hF9no
         wLg4JJVPgS4vsqWPvvBP4QTn6deoo1yXeqWBwVKvdnZQdW7yyKlYKbOIM6y36tQ4NO
         PgW8/DFl3WVEqA5waQcfsn4tfgWd5F+qMW510+i9nhNc6AV6nhO8/CKbI+4ZLuvyLP
         YXD1TRDKN2Zhc2/KxFhH7VZ9MYBVSKtXakHNd8WKLHsk/T7iB37EN1CU+GsIHxtMSO
         a8j4J3NMKrPVg==
Date:   Tue, 15 Nov 2022 20:20:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        yc-core@yandex-team.ru
Subject: Re: [PATCH v1] drivers/net/bonding/bond_3ad: return when there's no
 aggregator
Message-ID: <20221115202015.79844fab@kernel.org>
In-Reply-To: <20221114082523.3479224-1-d-tatianin@yandex-team.ru>
References: <20221114082523.3479224-1-d-tatianin@yandex-team.ru>
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

On Mon, 14 Nov 2022 11:25:23 +0300 Daniil Tatianin wrote:
> Otherwise we would dereference a NULL aggregator pointer when calling
> __set_agg_ports_ready on the line below.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.

This patch also didn't make it to the list.

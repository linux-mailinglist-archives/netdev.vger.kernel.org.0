Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BF24FC5EA
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 22:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbiDKUiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 16:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240007AbiDKUiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 16:38:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097321BE82
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 13:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2B86B818BE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA872C385A3;
        Mon, 11 Apr 2022 20:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649709354;
        bh=vj1JBXGNU7gBh96SibOhRokIPp/WexncyN00z+79HiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VlX82bZPKKwaIDm9JxjN4c3scqIjopNoN6UNw4Aen8b3XyupCZuj6i40YemxMSSzk
         Nya3hponO8lB+wPnXh7ff4b1QugmbHOAdVYDYWcuFBMaLgp+yq47TTUZonoBgasPdP
         Knx2M4OuzpEYk+2rLWlhGSwuLyAhXiuXM40kYdBbr+oPUNW3+pvZuFXODyaEK1SfpE
         pzXHW3RApGVfggoSVZQRP+OZED8qCCM4XM/nMd+lYzY0qjWgckCujVNNs/JF6Fn1KY
         15qAw9sDALJfGdmcMFB449fIUNle2KLSQQmiQ1qAp8PvGC5yl+eSRgzeUH0sq5pims
         RELIvWkkooezg==
Date:   Mon, 11 Apr 2022 13:35:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, andrew@lunn.ch, jdamato@fastly.com
Subject: Re: [PATCH v4 net-next 0/2] net: mvneta: add support for
 page_pool_get_stats
Message-ID: <20220411133552.04344b93@kernel.org>
In-Reply-To: <cover.1649689580.git.lorenzo@kernel.org>
References: <cover.1649689580.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 17:11:40 +0200 Lorenzo Bianconi wrote:
> Introduce page_pool stats ethtool APIs in order to avoid driver duplicated
> code.

Does not apply at the time of posting.

If series depends on other patches people post it as RFC until
dependencies are merged.

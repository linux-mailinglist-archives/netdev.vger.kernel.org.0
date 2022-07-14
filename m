Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68C057581F
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 01:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiGNXnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 19:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiGNXnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 19:43:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A602663E8;
        Thu, 14 Jul 2022 16:43:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F13E362060;
        Thu, 14 Jul 2022 23:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05823C34114;
        Thu, 14 Jul 2022 23:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657842217;
        bh=QJ+IA9Z/8wyG4jgJreze8fyxTn9U2vb4t27Z3sdzMDY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cX8oqWAFRrj/tEPy2fsqVXI3GU0FK4m3n24q8tNLzNieR9jrp5/CGlSy7P0UOvoN7
         t1j2BOL9ThC1b0Cj3aD5OWLpvtfW626dBrQthneyasT6gmq5Or1bekuNpjFIWaJht9
         9XYOk0AY5JQ4sBnOnBgTkXeGhsFdIX2cNEgXzQYNGknagJS9APj0UvbKv6PFvusNMW
         upWO6m7pUVv5+R9e0Y0uM+0hQ/uTjy9o+QfGBlfonw2FNEu9drPt0Py991FszxEmJL
         de2LGPk4YShy8P2o5NP69VIqmkbelFQkyzco0HEtPxenaWBHbpMNvkzV3rX1FZ7FnF
         fJwDVP4d9CptQ==
Date:   Thu, 14 Jul 2022 16:43:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ben Dooks <ben.dooks@sifive.com>
Cc:     linux-kernel@vger.kernel.org,
        Sudip Mukherjee <sudip.mukherjee@sifive.com>,
        Jude Onyenegecha <jude.onyenegecha@sifive.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: macb: fixup sparse warnings on __be16 ports
Message-ID: <20220714164336.0f2768a2@kernel.org>
In-Reply-To: <20220714084305.209425-1-ben.dooks@sifive.com>
References: <20220714084305.209425-1-ben.dooks@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 09:43:05 +0100 Ben Dooks wrote:
> -			htons(fs->h_u.tcp_ip4_spec.psrc), htons(fs->h_u.tcp_ip4_spec.pdst));
> +		        be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc),
> +		        be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst));

There are some spaces on this line, please use tabs,
checkpatch will be able to help you validate.

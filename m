Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5A36C36CF
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCUQTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCUQTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:19:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D535611640;
        Tue, 21 Mar 2023 09:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFAC1B818CE;
        Tue, 21 Mar 2023 16:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4539C433D2;
        Tue, 21 Mar 2023 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679415582;
        bh=nSCf8mJZjMVljeWisul4AhH31jB5GSrv2dGElw8BRZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ETKQ5RB7py3Gt7I6u3XvD/SvQfhZHnG8Kh+YxJraIItc49x/j/AL5u1ydRAMsFtWJ
         9mwt9r70Y6xB5jSh72A9mXCpfDbDn24XMch3rrelgs17nlURxTxMBqpfSfd3aHotyH
         PsQy9JcoiuMKwixp6T4ulqG4MVUs0lEOL2DYPSIiXiatZZ0XO6GAFCLHCp5ZNv1GXF
         TO6yHFZf1LYn0xB9lJF7GN/vxzDAqHh1M9JlpIcyBNH+lyz6Uz8RLcu0MVAHflG4WE
         4DXJhmRPHwjRym7lpVkzgghNx+FXXaI9wInWDAz2CTMTmdYPi/9NGQLZu8aZeUHf5n
         lXh6AFJrQLQaQ==
Date:   Tue, 21 Mar 2023 09:19:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 00/10] mtk: wed: move cpuboot, ilm and dlm in
 dedicated dts nodes
Message-ID: <20230321091940.2f296a4b@kernel.org>
In-Reply-To: <ZBl65HJ/C0OXbs8p@lore-desk>
References: <cover.1679330630.git.lorenzo@kernel.org>
        <20230320214356.27c62f9f@kernel.org>
        <ZBl65HJ/C0OXbs8p@lore-desk>
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

On Tue, 21 Mar 2023 10:37:40 +0100 Lorenzo Bianconi wrote:
> > On Mon, 20 Mar 2023 17:57:54 +0100 Lorenzo Bianconi wrote:  
> > >  arch/arm64/boot/dts/mediatek/mt7986a.dtsi     | 69 +++++++-------  
> > 
> > Do you know if this can go via our tree, or via arm/MediaTek ?  
> 
> Since the series requires some network driver changes I would say it should go
> through the net-next tree but I do not have any strong opinion on it.

We'll need to get an ack from Matthias to take it via networking,
but whatever's easiest.

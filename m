Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56853EBC3
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbiFFQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 12:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241478AbiFFQEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 12:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336D616328D
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 09:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83BB260B69
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 16:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5753DC385A9;
        Mon,  6 Jun 2022 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654531469;
        bh=QgN4ANv6NaTVFcL3hAtD9O0GcJVsKivOd345MlHqi40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZJiZNk6pE/OMZH+rnXHyXWvBU/u8cYDo5IgAx0V1bsBjf35Ji+wHP0DbHkMfIMSag
         TB+foMT3zby8kTcPdg3ZdJ3lh3G+qlN5YWn/KIygGVb0FMsV5FGyCZGSaBqY1r27QJ
         5WGIqodbMMy7em/0TBoRhinPKs+HtLBSwxCQJu09kkhDtk8IF3qgSr+lnSOdfZlgtj
         Z3kQ+wrftKgy0dnUT+C6tBM038MDpQQcSBI8dHNl0ZJ5fZNDJdH7z/SPRTezmjovyy
         t/Yq10jaAiIaLcE/4oinIqL0quK0i1d2NFJ4a2WeNp0oRcHPrg+4UpUZ77yKSc+dES
         5i4bSvvO7HcWg==
Date:   Mon, 6 Jun 2022 09:04:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: PR with merges
Message-ID: <20220606090427.21b5a055@kernel.org>
In-Reply-To: <20220604115157.3xaiey6hud4fdqln@pengutronix.de>
References: <20220604115157.3xaiey6hud4fdqln@pengutronix.de>
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

On Sat, 4 Jun 2022 13:51:57 +0200 Marc Kleine-Budde wrote:
> Hello David, hello Jakub,
> 
> I was wondering if you take pull requests from me (for net-next) which
> are not a linear patch series but contain merges? A merge would add a
> single feature and is based on net-next.

Yes, that's perfectly fine.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2BE54D630
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 02:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347351AbiFPAiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 20:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241061AbiFPAiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 20:38:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F3F13D3B;
        Wed, 15 Jun 2022 17:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24D1761B1D;
        Thu, 16 Jun 2022 00:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2240AC3411A;
        Thu, 16 Jun 2022 00:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655339892;
        bh=cWWAkAmTLB5aFZm061WYGM85uXQwNZYKsHtM7mOFquY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rMBUm1fNr+ABKQ2bugrj26iqTnyjiYlDnvPEAg8Exu9o2QK00GmZ9PRuHckQaW9lc
         FBrzASEcqIOr8E2TCBoYaVNrz3XQ37ko6RSSCFB6OpzTHpy0jbpllPXkF0CpsFL/UR
         wk3qxSknjzXtIvzrktY7ZxCoDna/vtir85WQj1K2FJ6ZJge7ZFNqmyI0+0+dgONZSI
         oP2GNWtH0Tj7YZKQmFaZPf2oT0FntBBlmWpGZeUXm7s+tM/4QWCH5dVvT2aL9yQ72d
         Wf8J6YihvVT0yXXqCZ1v73/sgBspqfrPR71iQeV61F0ESY/acw8SdfoyPB1aj+oHaq
         FVu5V8m0M/M0g==
Date:   Wed, 15 Jun 2022 17:38:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: axienet: Fix spelling mistake "archecture"
 -> "architecture"
Message-ID: <20220615173811.52dbd496@kernel.org>
In-Reply-To: <20220614064647.47598-1-colin.i.king@gmail.com>
References: <20220614064647.47598-1-colin.i.king@gmail.com>
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

On Tue, 14 Jun 2022 07:46:47 +0100 Colin Ian King wrote:
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Did not apply to net-next, please respin/

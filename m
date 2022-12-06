Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97207644CA8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLFTvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLFTvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:51:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B702EF3E;
        Tue,  6 Dec 2022 11:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01AA1B819D0;
        Tue,  6 Dec 2022 19:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72936C433D6;
        Tue,  6 Dec 2022 19:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670356300;
        bh=heFkPah0AL8dVF8yyOPqXEnqxwJ3RdAh7wZhIzOsj84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ueHYHWhLYnb+Y8xOqKlUizdKWKGKL76HbMhypdEP16JPVeiggJADMldToY4MxRUh4
         gasuxWY55RWlxYkvtIZ0Z6f1bIcHzmOhDubZ+8o9Gey3F6si3KsO9rXNVOjnaOEgTR
         NNAPPuzX/pkiScVYBll3EnfO32fr3U4vB1zH8E+U+2y9neY4mpuTbC0K+RfOwU9ggG
         BgX4pfSF6SS8aDVPIXK2sirzWC9Iyz4opjyl+c2v1O0Ql5dnNwH9x17WuP+qW9sMkO
         lbMftpqYJkNJIz3AwcndJiz4MhudbS3FDvrSq5Q2SHgH1MJbn9rHEDezrutARAAViT
         YUKgMcB5q44rQ==
Date:   Tue, 6 Dec 2022 11:51:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvneta: Fix an out of bounds check
Message-ID: <20221206115139.45341dc8@kernel.org>
In-Reply-To: <Y49R7GJLxSkI4VU2@kadam>
References: <Y49Q/Z1X1PKxIFfx@kili>
        <Y49R7GJLxSkI4VU2@kadam>
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

On Tue, 6 Dec 2022 17:30:04 +0300 Dan Carpenter wrote:
> Sorry, this applies to net.  Not net-next.  :/

Would you mind reposting? The bot tried only net-next and no checks
could run since it didn't apply.

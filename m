Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F0F6890DF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBCHbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBCHbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:31:11 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494F53D0A2;
        Thu,  2 Feb 2023 23:31:06 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 00FFF82FD0;
        Fri,  3 Feb 2023 07:31:02 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675409465;
        bh=8FQ47k12Bm+BjalIYpS9xoa2TPbONlxAeOkX09ntjZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNhfm1kTWNXn3olzHKt4b+AEMhM2rp3ClNz5XJq3g1CXDH/UDZ+prJNBbpUDA4nNp
         E0Iq3N34Ge3BYl1Z1qrDDZpo6QgG8t1p9eEGAYD1DNUeYm6haAOXGzGglqaYmada9G
         jrEqlxfjbMS+o8FeKokqSJATaO5geEIgXsF/VW31A06ADF88c7bI2fL/2hocp4EpV4
         BbJapaPnGSk/J5aOrRuG0JtljciWF+6LlK+J/yDytYc2YnBknDrLOI0oI2/Cs4A0hx
         6W5aADyp1xFXiSmyvbm5bvqBd13nNjSWNuWdB4CttQ2WIEQj+al8hn5v4qMtbpBVve
         eU9VJgFecKD7w==
Date:   Fri, 3 Feb 2023 14:30:59 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [PATCH v7 2/3] io_uring: add api to set / get napi configuration.
Message-ID: <Y9y4M2d/OsewlM/R@biznet-home.integral.gnuweeb.org>
References: <20230203060850.3060238-1-shr@devkernel.io>
 <20230203060850.3060238-3-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203060850.3060238-3-shr@devkernel.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 10:08:49PM -0800, Stefan Roesch wrote:
> This adds an api to register the busy poll timeout from liburing. To be
> able to use this functionality, the corresponding liburing patch is needed.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi


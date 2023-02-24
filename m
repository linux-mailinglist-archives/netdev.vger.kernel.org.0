Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF7F6A1445
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBXAX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBXAX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:23:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800D31E29D
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:23:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 017AEB81A29
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B48DC433D2;
        Fri, 24 Feb 2023 00:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677198234;
        bh=7tnZPJxVeJqti8xkQszY1U/yyDMQE+yVFTR6KGTN0hI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GvQNs2Kja0aNVN5dxLXgJdJ9klVqCDLk4WdNYkktMarq2W7lPAQ41h7O1uFiteq7T
         1pIjIdAjUADvRkpH/5rzAVp+wf16PPiY9ZvWMbXOBMmWRPY8MSEUT8CeoXYbafVPq5
         yaOl/KlB5cD4xse5c5fCGNZtvKBJSnJ1MbRA/RyViLEKnNqaS8PzXl//H5IYNxBF0+
         Pa4B0u85SUyb4T+8BoZyLCA2OlxgxV0AhDovD2g/ENEfA4R2knJEiJOCPDmW3BLvXS
         WU2tv/M5P1INzRfvLapfZblfRdl14qeORyUgJ0xQ1isGCcwjkQiHop+l+7ohBvxgG+
         fJqb4dAffUH8A==
Date:   Thu, 23 Feb 2023 16:23:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [ANN] netdev master branches going away tomorrow!
Message-ID: <20230223162353.10a94cc1@kernel.org>
In-Reply-To: <20230222102946.7912b1b9@kernel.org>
References: <20230222102946.7912b1b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Feb 2023 10:29:46 -0800 Jakub Kicinski wrote:
> net and net-next currently have two identical branches - master 
> and main. The master branch will got away tomorrow. Please make
> sure you use the main branch for tracking upstream if you're not
> doing so yet.

The removal has been performed. It seems that the pw-bot has gone 
on strike, but that's hopefully easy to fix. Please let us know
if you notice any other issues..

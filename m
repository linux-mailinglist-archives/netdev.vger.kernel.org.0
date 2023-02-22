Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4C169FAFD
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjBVS3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 13:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBVS3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 13:29:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C0A1BDA
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 10:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48784614F8
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 18:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB7FC433D2;
        Wed, 22 Feb 2023 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677090587;
        bh=1+x+SdJZsaq+JY38beV8Paqdi8awewBNjQ7fFVA6PfU=;
        h=Date:From:To:Cc:Subject:From;
        b=GeACnWwscGPH+Lxm/TXesdER4ZJAyYMA7pBeHk6oLVJHNk3cBfEjVLmFc56qAqKc0
         jSiXfxcm8UgIPiqD5fsXLnX4G8alsKsTHH2SSw1sYhFpAPKjv7zbxZznxuYQ4cyB7w
         /lXt45kupFMgzgWoCHWxHqQQ00B8lgQYAMatsFEcNdXYS6NZlBjfHc9oGbkZi+43gt
         wYGcHw4WEyYA/P8CSPMxwYMojSEnRFjibavNM8tgOgiY1knFku2jp6+Zq0WgaXnR2k
         c8c/aB3VjT9Igv5BwLNNnP8BgN1e8lC74HX8ix7CEBKk32rEKx9Nw81wYomcJpjzSj
         Wv4OJ5WHKkqZg==
Date:   Wed, 22 Feb 2023 10:29:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: [ANN] netdev master branches going away tomorrow!
Message-ID: <20230222102946.7912b1b9@kernel.org>
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

Hi!

net and net-next currently have two identical branches - master 
and main. The master branch will got away tomorrow. Please make
sure you use the main branch for tracking upstream if you're not
doing so yet.


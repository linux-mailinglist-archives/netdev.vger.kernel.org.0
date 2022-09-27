Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF905EB64B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiI0AdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiI0AdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:33:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9489FEE640;
        Mon, 26 Sep 2022 17:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F5626151F;
        Tue, 27 Sep 2022 00:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36662C433D6;
        Tue, 27 Sep 2022 00:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664238793;
        bh=F9uwrTRrrB6ehWWU5SZkXZTq8t8gAoqykefYLXGJx/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/EyzvmioHAobjA0jyeiVZYDyNTnQwrkVVjzWM6SnGxk1HAyiuxjg6e+wLgZjuAwG
         +AGnSP+mPEcibS/Qy3IBg8KmFSfRp8fJhW6oVvPQV5IzeOdB4um2SjeN/I2xHQSR1y
         7xa92B08CE8hYgOsLdz8bJ34cKoVwiV5PflX96wyouyJ2Ghctbrnd5JuuNCRMXyL4U
         cOc5MOuf/hMu7A/qyyFU+T9laFC41NzHMSG6n1EYM4A0OO6YCyk9wyHl4c7KOj7T0x
         yiGOX0d3EeNnFsBaNz9t2y87wENyYtKRalViuMTPTB2dX0EHj0vZtr0QpjHT/TwXZ7
         u/tujSjHv8Z3A==
Date:   Mon, 26 Sep 2022 17:33:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, agordeev@linux.ibm.com
Subject: Re: [PATCH 3/7] s390/qeth: Convert snprintf() to scnprintf()
Message-ID: <20220926173312.7a735619@kernel.org>
In-Reply-To: <YzHyniCyf+G/2xI8@fedora>
References: <YzHyniCyf+G/2xI8@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 19:42:38 +0100 Jules Irenge wrote:
> Coccinnelle reports a warning
> Warning: Use scnprintf or sprintf
> Adding to that, there has been a slow migration from snprintf to scnprintf.
> This LWN article explains the rationale for this change
> https: //lwn.net/Articles/69419/
> Ie. snprintf() returns what *would* be the resulting length,
> while scnprintf() returns the actual length.
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Looks legit but please repost this separately.
We only see patch 3 of the series.

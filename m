Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE33A66A377
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjAMTj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjAMTjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:39:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7C89BB2A
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 11:34:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E68AB821CB
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E81C433EF;
        Fri, 13 Jan 2023 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638496;
        bh=VCykJyPvehSkAxwyf0pWqtXwmCO0g4EZS/lsX4aIkx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=doaZUIKLlM+tfgj+5jglMqohXV7jfciG6WjKIfoivPlKzR6SiqnEo4L8k2Q6/vT1e
         cMfGMeaNWseS9W0jMmhC3WOxBIyfB2o0aG6R6thjkBjBoVS3SOofxvce4NY+j1zw+D
         E1lzueOiQo+GxdAASh9O6lND5Hz134nEe6GOcC/bEstK2JvI7aIYlHqxx8V2AKO5ZC
         8TB2DHmuhTPtbZ0JGCAuoDrbib3zlayQsLcHZeLjB01W5238XnRVm+Lej0Y1h/mYgu
         cCvA3XtRzW/7YkKqdcjYOhUk0O77oDeGMbd0EZ5XX6uMfWuGzwGkHSriGLTjkoVD8E
         brjdR5r2w4yPw==
Date:   Fri, 13 Jan 2023 11:34:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] net: thunderbolt: Add tracepoints
Message-ID: <20230113113455.4b973891@kernel.org>
In-Reply-To: <20230111062633.1385-1-mika.westerberg@linux.intel.com>
References: <20230111062633.1385-1-mika.westerberg@linux.intel.com>
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

On Wed, 11 Jan 2023 08:26:30 +0200 Mika Westerberg wrote:
> This series adds tracepoints and additional logging to the
> Thunderbolt/USB4 networking driver. These are useful when debugging
> possible issues.
> 
> Before that we move the driver into its own directory under drivers/net
> so that we can add additional files without trashing the network drivers
> main directory, and update the MAINTAINERS accordingly.

Applied, thanks!

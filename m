Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F44B605556
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiJTCNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiJTCNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:13:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49015165CA5;
        Wed, 19 Oct 2022 19:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D6FDB82566;
        Thu, 20 Oct 2022 02:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1E8C433C1;
        Thu, 20 Oct 2022 02:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666232008;
        bh=XC98uwIS/sZvYPBYvUdHMbjc9tVZkDZBmOMIwyp9e6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qUw2opMCQMi+cyA0D6P+TuLYqG0NWhKCiGaRKEcSp+Wmjiy+BQi44zVqiRDDvRpo7
         QtFvuJl7XdavY9JgMkPhLPvCwideXXqC0mohsDTnAiCpE4YPTBBmmANq2wow/Soaf6
         qAOo9+/9j4nCREPcRWsZNKt1Su0X1lwfHqGzgEfbJz+yGFRylivyclXJeNAmFEUzzC
         nOcHmMmZxZicKsxRu1IB2M2eICZDa78VNd8i0wKTsW8/crTSP5kpFjmYZtHUwl+XGU
         9zOP330UeejL9efiGY070YpbW7rr2OnrIG8KJRyg207xsdbV3tTpzeSVdZeBcCxFJg
         NAAkgfWbTlJ8g==
Date:   Wed, 19 Oct 2022 19:13:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frank.li@nxp.com
Subject: Re: [PATCH net-next] net: fec: Add support for periodic output
 signal of PPS
Message-ID: <20221019191327.34018fdc@kernel.org>
In-Reply-To: <20221019050808.3840206-1-wei.fang@nxp.com>
References: <20221019050808.3840206-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 13:08:08 +0800 wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> This patch adds the support for configuring periodic output
> signal of PPS. So the PPS can be output at a specified time
> and period.
> For developers or testers, they can use the command "echo
> <channel> <start.sec> <start.nsec> <period.sec> <period.
> nsec> > /sys/class/ptp/ptp0/period" to specify time and  
> period to output PPS signal.
> Notice that, the channel can only be set to 0. In addtion,
> the start time must larger than the current PTP clock time.
> So users can use the command "phc_ctl /dev/ptp0 -- get" to
> get the current PTP clock time before.

You need to CC Richard C the PTP maintainer on PTP-related
patches, please repost.

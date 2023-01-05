Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0713565E2CB
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 03:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjAECKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 21:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAECKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 21:10:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F9F4319E
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 18:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7484CB818BF
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 02:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D640FC433D2;
        Thu,  5 Jan 2023 02:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672884608;
        bh=iaeoXsld99tQKCKzc3rchpMs1v3IjsLsBD45NyBEIUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dpgd+4kzrP/1lZ3yNrq1aH2c09B9VSs5rgtxbM1hPJEnXpH2B/5xRplwrermvbca5
         r8S5pF8vBz6X+gt+LKgX+biX4GlqKfPGXga+DT1fWWmOj7YtSgc0G2eNvSwIHUnrQi
         AUMqGGVNIfK5C5dQvuZjXuXL7DubyN492I3AUzBZXNh5WE5ZG1yOq6+lOoAhFHZ9Kt
         v/vsWcmkOiNtqLXKpPrYGKSg20NH+rZ6QtFgIgaBjATvZbzsTrNrbJvC+ysEmgy7Qj
         lum2zUl1JL7TjzNf+V0GhGi5wflF4A4/LYPNJ7dSF2I2Zuhi8fCzs53FwxxwD4BISU
         0Pt9K4B8rpjqA==
Date:   Wed, 4 Jan 2023 18:10:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 02/14] devlink: split out core code
Message-ID: <20230104181007.65d0eb6e@kernel.org>
In-Reply-To: <Y7VL6P0hfCEvBFzV@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-3-kuba@kernel.org>
        <Y7VL6P0hfCEvBFzV@nanopsycho>
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

On Wed, 4 Jan 2023 10:50:32 +0100 Jiri Pirko wrote:
> >Rename devlink_netdevice_event() to make it clear that it only touches
> >ports (that's the only change which isn't a pure code move).  
> 
> Did you do any other changes on the move? 

Please read the paragraph you're quoting again.
I specifically addressed this question.

> I believe that for patches like this that move a lot of code it is
> beneficial to move the code "as is". The changes could be done in a
> separate patches, for the ease of review purposes.

I obviously know that. That's why patch 1 and patch 2 are separate.
The line between what warrants a separate patch and what doesn't
is somewhat subjective.

> Could you please?

Sure.. :/

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD968FB46
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBHXlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBHXle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:41:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3999719F1A
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 15:41:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0683B81F03
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 23:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ED4C433D2;
        Wed,  8 Feb 2023 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675899690;
        bh=AjKDB1Dpdgtd3LjEuT1GUo2/6Xvg6n5h6NJKPSr3EiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iixqPjDeXwsVB4lRG8eXnQQZL6TeNRhnEzkQBQjhkVLtVqGxf7TdalZPck8vRxGG9
         Nw+8Lup4mH5tiA+L7mIwaL80Mb7a/R3TLh/IeIrLINZaeTkyjXumHL93V2OhtmfLsC
         LEmQUKYja/zyU14x0wHzSc1CXj7TybQ0+bKCCTuENyekdsqS9nEJEUWtnGjONLxO0I
         9FGcsOJhmVZjgkspO8gcGnaaKcglbuI6NLkUbuxDY83Teq577fCBIO6ml4jW548rlD
         9COjrn3WraHeuYWURLI9rpIa0YSbg2xwNGai/W8d21wiUXn7DRhNln/5xRbsmZ/0oP
         OZSbLfqhwpBqA==
Date:   Wed, 8 Feb 2023 15:41:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <20230208154128.00b701c5@kernel.org>
In-Reply-To: <Y+OWy0prxf5pNWpv@nanopsycho>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
        <20230206153603.2801791-2-simon.horman@corigine.com>
        <Y+OKPYua5jm7kHz8@nanopsycho>
        <Y+OQmjJFeQeF2kJx@corigine.com>
        <Y+OWy0prxf5pNWpv@nanopsycho>
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

On Wed, 8 Feb 2023 13:34:19 +0100 Jiri Pirko wrote:
>> Of course if TC is involved, then we have flexibility.
>>
>> What we are talking about here is primarily legacy mode.  
> 
> I don't see any reason to add knobs for purpose of supporting the legacy
> mode, sorry.
> 
> If you need this functionality, use TC.

Agreed, I seem to remember that mlx4 had some custom module param 
to do exactly the same thing. But this is a new addition so we should
just say no.

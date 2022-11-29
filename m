Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE1763BC6E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiK2JAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiK2JAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B48B5B5AC
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 073FE615E9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E363EC433C1;
        Tue, 29 Nov 2022 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669712417;
        bh=JMtlPLzZ3a8fXa9Q793wRaTS3fttDUGM3PLHlR6YI3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EHJIG+TR359VmsNT5iPayk59dMzJSPkzpLsBoCKl0C9vOB+/WxLRZYadp7o59YZOj
         8wAbN9dF2RLZ47Nbw21HQQ7mvev3ZirlLyqtAdzYxMKnWOn3zBddPzbzDZmHb17N/t
         aZYvwg8VS3UJcvhJBLHapMlVN24EzjECVnaLpYu/cUWAjidsfV6nQvARvMXArynG1O
         7hTlXdwoLbKNm4wZUwYZGm2MyGPlWIXsG4wyJbqia042Al8Yln1KUVwbaiG12DZhBE
         ekv7nwmE6R7ok0+kD80RzW/1s2d0NGkGR8oAGSKDl/JQ+H1/voAE9nm4O3DmIbe2gk
         abnGFPJSv4j0w==
Date:   Tue, 29 Nov 2022 11:00:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Shannon Nelson <shnelson@amd.com>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling
 VIF support
Message-ID: <Y4XKHTAOxQwKuaQU@unreal>
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-11-snelson@pensando.io>
 <20221128102953.2a61e246@kernel.org>
 <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com>
 <Y4U8wIXSM2kESQIr@lunn.ch>
 <43eebffe-7ac1-6311-6973-c7a53935e42d@amd.com>
 <Y4VEZj7KQG+zSjlh@lunn.ch>
 <20221128153922.2e94958a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128153922.2e94958a@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 03:39:22PM -0800, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 00:29:42 +0100 Andrew Lunn wrote:
> > > How about:
> > > 	DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_MIGRATION  
> > 
> > Much better.
> 
> +1, although I care much less about the define name which is stupidly
> long anyway and more about the actual value that the user will see

We have enable/disable devlink live migration knob in our queue. Saeed
thought to send it next week.

Thanks

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7144451CE99
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388159AbiEFB45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345307AbiEFB44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:56:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1512B2B1A9;
        Thu,  5 May 2022 18:53:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE82F6204C;
        Fri,  6 May 2022 01:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6DAC385A4;
        Fri,  6 May 2022 01:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651801994;
        bh=4j5KB+Ahm7k1P9XIxIkr92yIiBjJ5oXszlFyUFGvtLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U07jtolEjea8+39Z56AzTqwJdfh13Mqlc0Fk8txgFE91sX8XE1XVzUh+S+yY8459g
         YlMcJPR9HvEelQO3IHbX9VNR+F4wF/bAlkidK3H92bxqR9h4MNUQT6km6OczcA1LZ9
         /vuG/Xzcz1KNXs59CIPnEdr1QV3o/K4Mxp51wy4U+gBuYgh3NwQfy5dFVD4bjLijUd
         vsX2mRlvIT4Elz6QlD/ty7dGVxB9++DSecntvYB/J9lLAeJnubYouvoMPKTZ6Xm5M7
         Hetty/ajeSMGnLUN8UY0UQuJwuK7qsRsVGC5IyW1eHdkxJ+KE/NHnLcdyjVDgYZDOT
         kxb87gx49w8Qw==
Date:   Thu, 5 May 2022 18:53:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4 2/2] ptp: ptp_clockmatrix: return -EBUSY if phase
 pull-in is in progress
Message-ID: <20220505185312.3a56cadc@kernel.org>
In-Reply-To: <1651697455-1588-2-git-send-email-min.li.xe@renesas.com>
References: <1651697455-1588-1-git-send-email-min.li.xe@renesas.com>
        <1651697455-1588-2-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 May 2022 16:50:55 -0400 Min Li wrote:
> +	err = idtcm_output_enable(channel, enable, perout->index);
>  
>  	if (err) {

no empty line between call and error check

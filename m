Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BCA5171C1
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbiEBOnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbiEBOnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:43:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A88A120BA
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E681DB80EFA
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 14:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC03C385AC;
        Mon,  2 May 2022 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651502374;
        bh=6znODqSBb42svrOk3wcAvBAIp7jlhv+dO8Y+YtBP1Wk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KMKJNiTazZvEDdnfeppfR+lwyga86viufVb/BogqIXzM29SIhkfPbX5LY+8xBHTA3
         bPyBnb+DzRxQZFYr8fzQCgX9wbgEQ7YuP+BgxyVVPQnWaod/JAsa54DIONIOtaHAK/
         DN29eWuSCMxJcaPp+W+4+kkhw/X32r65BrOxm8Iv1c1XNTSUD34OyvI9cBprf/ab2O
         6Ug6X9W8WL/zmETa86CGZ0oIGVIgLak0oQfPtG10IFoWOUAJBrKKUe8UPOWzTkmn6C
         8RFHMCRQJ08WtQElr69I1hQGluyZ64HvQbcc/2LQ2XlwKr9gIMxGUIdB89k4fOBg0H
         SBASfY264+yqw==
Date:   Mon, 2 May 2022 07:39:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220502073933.5699595c@kernel.org>
In-Reply-To: <YmzW12YL15hAFZRV@nanopsycho>
References: <YmeXyzumj1oTSX+x@nanopsycho>
        <20220426054130.7d997821@kernel.org>
        <Ymf66h5dMNOLun8k@nanopsycho>
        <20220426075133.53562a2e@kernel.org>
        <YmjyRgYYRU/ZaF9X@nanopsycho>
        <20220427071447.69ec3e6f@kernel.org>
        <YmvRRSFeRqufKbO/@nanopsycho>
        <20220429114535.64794e94@kernel.org>
        <Ymw8jBoK3Vx8A/uq@nanopsycho>
        <20220429153845.5d833979@kernel.org>
        <YmzW12YL15hAFZRV@nanopsycho>
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

On Sat, 30 Apr 2022 08:27:35 +0200 Jiri Pirko wrote:
> Now I just want to use this component name to target individual line
> cards. I see it is a nice fit. Don't you think?

Still on the fence.

> I see that the manpage is mentioning "the component names from devlink dev info"
> which is not actually implemented, but exactly what I proposed.

How do you tie the line card to the component name? lc8_dev0 from 
the flashing example is not present in the lc info output.

> >Please answer questions. I already complained about this once in 
> >this thread.  
> 
> Sorry, I missed this one. The file IS a FW just for a SINGLE gearbox.

I see.

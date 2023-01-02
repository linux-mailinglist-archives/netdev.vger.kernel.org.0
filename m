Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E077A65B827
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 00:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjABXZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 18:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjABXZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 18:25:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5026DC60
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E001561077
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 23:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139CCC433EF;
        Mon,  2 Jan 2023 23:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672701948;
        bh=9/Z4kIF8l8TTVhLWlWW1DQh6EBD3saXupljXHUf16FI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GZ/BPK0rPI0oilI6lumf8HowvEib8XCQasNZmSfRhGZI9I5hLB9dDYqgCL0N8SW7Q
         zDeoZBqE8c75VTVowwYTNA2VrAoIhYcChQx7xVOLfqDcTTr/l+6F2RmtvZuU9Fzz79
         aspaJNoVXjzuDfvXRjsUfD0QO+oWiPPoJoWic7CaXmFvMIAZ1DeYbo6071/NWAMpd3
         BTGHV54xStqoD9Hm5g9X2MdRlM4DXHpYgoc+sRYcRXlMSDM3WvVOQW4otl+Hj8FJsm
         aiyjZlF2suUbj6tcqYg5VPj7O4eeT6SsLLkRCEel3IqXe4s/2dwQIQmpRQw39sNApT
         Bnau+kLiS5w3w==
Date:   Mon, 2 Jan 2023 15:25:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 10/10] netdevsim: register devlink instance
 before sub-objects
Message-ID: <20230102152546.1797b0e9@kernel.org>
In-Reply-To: <Y7Ldciiq9wX+xUqM@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-11-kuba@kernel.org>
        <Y7Ldciiq9wX+xUqM@nanopsycho>
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

On Mon, 2 Jan 2023 14:34:42 +0100 Jiri Pirko wrote:
> Sat, Dec 17, 2022 at 02:19:53AM CET, kuba@kernel.org wrote:
> >Move the devlink instance registration up so that all the sub-object
> >manipulation happens on a valid instance.  
> 
> I wonder, why don't you squash patch 8 to this one and make 1 move, to
> the fina destination?

I found the squashed version a lot harder to review.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E805D6C7346
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 23:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjCWWqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 18:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWWqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 18:46:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136F244B8
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 15:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFB2628CC
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 22:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE8EC433D2;
        Thu, 23 Mar 2023 22:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679611576;
        bh=gQbvpHZewx2gEFZP4SRhYieRcGI/sz2SjdLybk0iNMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cvq1PelldySmHLuJ3SUwumG5X2qybeHEjqZPFggYr8rEwkqCftxoBQItdMZs1nY4/
         6ROUGYunh1evy/4aC0mgW49D32IeGTFy0R3CML/l/4LD2NI8u1tSPPMfJPPXc2+mrS
         YsSEcTL/HxMUrK3Hgz4ANfgS4Q3luOhTciIB7qY1NpeVbNoVOTKTzNRWsDEV9tkGUy
         jUvwC05p9fI3Pu1GNoypdaNIhLhMoi3zR8zvE8vX3EOB70OsQwtXRypzz1AVbrCumd
         vNLexHCW3j975wDtTNpj1CNNq6P8dtHplBeNhJZWy9fW4l49BaJY2eHaMWMfiYCgGy
         nMLATzp//UGtA==
Date:   Thu, 23 Mar 2023 15:46:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, alexander.duyck@gmail.com,
        michael.chan@broadcom.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230323154614.6c24afca@kernel.org>
In-Reply-To: <fccbd0cc-f760-4f1a-8830-64a245b228dc@lunn.ch>
References: <20230322233028.269410-1-kuba@kernel.org>
        <06d6a33e-60d4-45ea-b928-d3691912b85e@lunn.ch>
        <20230322180406.2a46c3bd@kernel.org>
        <fccbd0cc-f760-4f1a-8830-64a245b228dc@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 22:02:29 +0100 Andrew Lunn wrote:
> We do seem to have a policy of asking for a 0/X. And it is used for
> the merge commit. That is my real point. And i don't see why the text
> can be repeated in the merge commit and the individual commits.

Alright, I'll respin and add a cover. But I think we should be critical
of the rules. The rules are just a mental shortcut, we shouldn't lose
sight of why they are in place and maintain some flexibility.

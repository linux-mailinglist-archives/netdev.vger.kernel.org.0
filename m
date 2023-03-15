Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1396BC0B8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjCOXRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCOXRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:17:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C41395BEC;
        Wed, 15 Mar 2023 16:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28DFFB81F87;
        Wed, 15 Mar 2023 23:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9A3C433D2;
        Wed, 15 Mar 2023 23:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678922227;
        bh=imQ6VhRez4Il/unuI/rKJ2W1NFjpyIkTWoLdxytcoBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FSEv9znIPAOcq7j/eZfgwpBAY5YIdh7R/4aPKNWLohOIeZ9eKy2w9B/RSvYRoELfj
         Vh6kMl8avQ1oKF+PIyX2cT9stQ3+QzZvt21ukGhE9EhVxDf9b1/y1AjEt7mvHkmr6v
         U/XAzr4a6RT4pONLWdsutvyAaIhqInBRnMZS0cUamzvyoWsrJvnpeh7XmPHi6Yv6iK
         UXk+bpw2P5UxDb/1mw57x4WI6VbNC93YMWgzQYynI0RhvpJT53xggR/6NFTiOV7Umx
         +XuDgSVxPEtjSZ8V7XykRc85sSz0OFXVkHXZDp/hffl+S2ZlL+CmAcaSqfD0UoYkLK
         W4m4GklhSCfnA==
Date:   Wed, 15 Mar 2023 16:17:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <jesse.brandeburg@intel.com>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230315161706.2b4b83a9@kernel.org>
In-Reply-To: <e7640f5c-654c-d195-23de-f0ca476242f1@intel.com>
References: <20230315223044.471002-1-kuba@kernel.org>
        <e7640f5c-654c-d195-23de-f0ca476242f1@intel.com>
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

On Wed, 15 Mar 2023 16:12:42 -0700 Tony Nguyen wrote:
> >   .../device_drivers/ethernet/intel/e100.rst    |   3 +-
> >   .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
> >   .../device_drivers/ethernet/intel/ixgb.rst    |   4 +-  
> 
> ice has an entry as well; we recently updated the (more?) ancient link 
> to the ancient one :P

Sweet Baby J. I'll fix that in v2, and there seems to be another 
link in CAN.. should have grepped harder :)

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7082557822
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiFWKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiFWKtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:49:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18F7496A6;
        Thu, 23 Jun 2022 03:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FDF461E88;
        Thu, 23 Jun 2022 10:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1094BC3411B;
        Thu, 23 Jun 2022 10:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655981377;
        bh=NUEG+ghgZ8P4bhMwjDxq6aXDJa+xYsPVTQ4Nht0vb9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5Wd5i5sipZrrE/ESlGDfBkl2g8kf1MJEtEeSP9CF86js7HHdYJHNW+o/kp4I3DjC
         jzJvyRrDv7oiZ2pbtHvda/ZMb6FB4TkY4TBldli7kni902BqDMIxZgH2N/WklvuO3g
         jZY2Kgr5lPmaYEKh8kqzNAMHxlecSaSvE3CR7leY=
Date:   Thu, 23 Jun 2022 12:49:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [STABLE v4.9 & v4.14] l2tp: Prevent circular locking and
 use-afer-free issues
Message-ID: <YrRFOw5gx5vq6sIw@kroah.com>
References: <YrRB771x/JrsGjXM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrRB771x/JrsGjXM@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 11:35:27AM +0100, Lee Jones wrote:
> Dear Stable,
> 
> Please could you apply the following patches to the v4.9 and v4.14
> trees:
> 
>   225eb26489d05 l2tp: don't use inet_shutdown on ppp session destroy          
>   d02ba2a6110c5 l2tp: fix race in pppol2tp_release with session object destroy
> 
> They fix circular locking dependency and use-after-free issues.

Now queued up, thanks.

greg k-h
Cc: stable <stable@kernel.org>

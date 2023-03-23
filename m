Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927F96C6FA2
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCWRqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCWRqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:46:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E733AAE;
        Thu, 23 Mar 2023 10:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FC56280C;
        Thu, 23 Mar 2023 17:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B33C433D2;
        Thu, 23 Mar 2023 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679593600;
        bh=yvwFrMcVQ1G9nYIZE+hVQ31zZvC2wJXnljhbbliwuV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K35DrD9ZwTyP0FiHm0VdMIET78QOxRB9YqxJoMKalsm04GzuAtb8gxNIB9p4L1JBP
         Dg8mTsZIt5WpkgRr8KoopEgDzShCGidDzeYSpug3ghu19a6wcpIiWnhmR3edG0zgVy
         eeR16Eb8YsiOF2LJtVByxRI2XEJOUXmlCjl5Ok9Ql+O7/anfrmwO1niqzQNhtwdfTB
         pe+Jwj4YGbcizMZLivwhYBd1TKgxvfD+TVhQ+Bt/OoapxlzT/WRG4ZrtNls/tfBCr1
         yMafsMtrJfekpHAsm9XzJF3aBUkICwC66x8jY/oAZrZAAcWAdBaWpS/SrWhwqmjPoi
         uek3miuj1e/kg==
Date:   Thu, 23 Mar 2023 10:46:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: bluetooth 2023-03-22
Message-ID: <20230323104639.05b3674b@kernel.org>
In-Reply-To: <20230322214614.0e70a4a0@kernel.org>
References: <20230322232543.3079578-1-luiz.dentz@gmail.com>
        <20230322214614.0e70a4a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 21:46:14 -0700 Jakub Kicinski wrote:
> On Wed, 22 Mar 2023 16:25:43 -0700 Luiz Augusto von Dentz wrote:
> > The following changes since commit bb765a743377d46d8da8e7f7e5128022504741b9:
> > 
> >   mlxsw: spectrum_fid: Fix incorrect local port type (2023-03-22 15:50:32 +0100)  
> 
> Did you rebase? Do you still have the old head?
> Because this fixes tag is now incorrect:
> 
> Fixes: ee9b749cb9ad ("Bluetooth: btintel: Iterate only bluetooth device ACPI entries")
> Has these problem(s):
> 	- Target SHA1 does not exist

Hi, any chance of getting fix fixed in the next hour or so?
It can still make today's PR..

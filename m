Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986746A8804
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCBRmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 12:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCBRme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 12:42:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F4030B03;
        Thu,  2 Mar 2023 09:42:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0FA861626;
        Thu,  2 Mar 2023 17:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2034C433EF;
        Thu,  2 Mar 2023 17:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677778953;
        bh=Tj4MAXnmhNqTK49IcnPgxtzci+VaZAAiDH7yX4csSpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QbTkQvjK/pKCRM33wQtdHeTgmWOf8amITOoDLjIzL/BU629vBi09F8v2Dyh0POfpR
         taZydFynqKcf34vCnGlNDEpLmXOarqKces6N8pP9QZXc8S0KdVHXHu2Yt9gCb+DzqX
         A8er/aDVCLphYpphb9selrgXRCo/yxk4SpJ4UOys=
Date:   Thu, 2 Mar 2023 18:42:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 0/5] mac80211_hwsim: Add PMSR support
Message-ID: <ZADgBqP57XcW3/tH@kroah.com>
References: <20230302160310.923349-1-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302160310.923349-1-jaewan@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 04:03:05PM +0000, Jaewan Kim wrote:
> Dear Kernel maintainers,
> 
> First of all, thank you for spending your precious time for reviewing
> my changes, and also sorry for my mistakes in previous patchsets.
> 
> Let me propose series of CLs for adding PMSR support in the mac80211_hwsim.

What is a "CL"?


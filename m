Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CF356A149
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiGGLvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiGGLvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A3633358;
        Thu,  7 Jul 2022 04:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6916B82139;
        Thu,  7 Jul 2022 11:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC58C341C6;
        Thu,  7 Jul 2022 11:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657194659;
        bh=TP53YBQef1ChOsCkOpSzExLmVlTCAif4oYcWv8otfSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RY90JevPl0TVo4BTTieT6ZL52OQT5su34lvywU81tRT6kkTGLstayMyXXQcZuFVyG
         MDLsn4a0S3IdSYHnoK8RJI7dhnSKgVlCHWv5qbrByWNpKELFCjfwiy08a23EdGBti1
         I1aBblLBvsgcFHXQY9d0i5A1QccI6jCOTMg1ERGs=
Date:   Thu, 7 Jul 2022 13:50:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: Ping: [PATCH] net: Fix UAF in ieee80211_scan_rx()
Message-ID: <YsbIoB5KTqdRva6g@kroah.com>
References: <20220701145423.53208-1-code@siddh.me>
 <181d8729017.4900485b8578.8329491601163367716@siddh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <181d8729017.4900485b8578.8329491601163367716@siddh.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 05:06:35PM +0530, Siddh Raman Pant via Linux-kernel-mentees wrote:
> Ping?

context-less pings, on a patch that was sent less than 1 week ago, are
usually not a good idea.  Normally wait for 2 weeks and then resend if
you have not heard anything back.

good luck!

greg k-h

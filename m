Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DC6671665
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjARIi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjARIhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:37:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B497F997;
        Tue, 17 Jan 2023 23:57:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 861C6B81B87;
        Wed, 18 Jan 2023 07:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFFAC433EF;
        Wed, 18 Jan 2023 07:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674028626;
        bh=yvep6EZf7KhTbiZC5vBWUyi37FuVkUD4eecWyNjQFzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cg3YMskxdcLoIG4b2ZGfpbE36ghOZpCwapNIze3wlXzIbkX2qS0j0HPdt3V1gge0E
         b7w5/mNtjUAnSW3PvvwTCU7ZpUpjwr0uXqyYk2wRsvX9a+GkddoUo8BdUoUsoTu8tO
         Js80KLc1ru6PxRlhbA04ywTQd+IGRMac6OZ5lsk4=
Date:   Wed, 18 Jan 2023 08:57:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [RESEND v3 2/2] mac80211_hwsim: handle RTT requests with virtio
Message-ID: <Y8emT2iIetDrja7t@kroah.com>
References: <20230112070947.1168555-1-jaewan@google.com>
 <20230112070947.1168555-2-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112070947.1168555-2-jaewan@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 04:09:47PM +0900, Jaewan Kim wrote:
> This CL adds PMSR (peer measurement) support,
> which is generic measurement between peers.
> And also adds its one and only mearsurement type - RTT (Round Trip Time).
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> Reported-by: kernel test robot <lkp@intel.com>

I really doubt that the kernel test robot reported the lack of this new
feature :(

thanks,

greg k-h

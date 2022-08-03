Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6EA588BCC
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 14:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiHCMI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 08:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbiHCMI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 08:08:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45484B4BB;
        Wed,  3 Aug 2022 05:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D00C76126C;
        Wed,  3 Aug 2022 12:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCABC433D6;
        Wed,  3 Aug 2022 12:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659528504;
        bh=pT+C96VEzjx+xj5fwziqLCOvXwwGJjJH/rP2yIPS21o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wBsciplCvvGCvG084ML0kCqneJ7D2no/hYicTtzHOET6R9QxmiXobq7zhYRmSI2yZ
         ihH+Bq373YzhWKniC2XdAFD84VMLQ3S66CWsaGdvbizPAHqnJdetiarPve90umwGcC
         7kq9SRm7tj426hFtYeSmxf/vpvqE1DXkEGLAIFto=
Date:   Wed, 3 Aug 2022 14:08:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org,
        syzkaller <syzkaller@googlegroups.com>,
        George Kennedy <george.kennedy@oracle.com>
Subject: Re: [PATCH backport for 5.10] tun: avoid double free in
 tun_free_netdev
Message-ID: <YuplNZaPUqT56xAR@kroah.com>
References: <20220802154711.1745023-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802154711.1745023-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 06:47:11PM +0300, Fedor Pchelkin wrote:
> From: George Kennedy <george.kennedy@oracle.com>
> 
> commit 158b515f703e75e7d68289bf4d98c664e1d632df upstream.

Now queued up, thanks.

greg k-h

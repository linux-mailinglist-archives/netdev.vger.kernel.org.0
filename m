Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E923755C88E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiF1FlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244900AbiF1FlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:41:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187AD1658C;
        Mon, 27 Jun 2022 22:41:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A205CE1EA8;
        Tue, 28 Jun 2022 05:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8B8C3411D;
        Tue, 28 Jun 2022 05:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656394875;
        bh=3rk+amtQYr6K4EV1HsjlJfIYPKrB69t8yjS0oLu39g4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJsReago9Eu7RZpO4myn1G8xcci5HKDjqaUCBUSOoumBJzdyD7Zq7tlGioJXrgm4U
         SSmUBGwlqr+VqjYWYKKnua5CIhfmYnvtHcDQu+7sT0Hwo870XqElFQo6lBeCF0G0Im
         lVNDh30eX7hZoPP+pDtqsH+xlR15rSzSTmqJZv28=
Date:   Tue, 28 Jun 2022 07:41:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Franklin Lin <franklin_lin@wistron.corp-partner.google.com>
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        franklin_lin@wistron.com
Subject: Re: [PATCH] drivers/net/usb/r8152: Enable MAC address passthru
 support
Message-ID: <YrqUeDIyBHFMu+EG@kroah.com>
References: <20220628015325.1204234-1-franklin_lin@wistron.corp-partner.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628015325.1204234-1-franklin_lin@wistron.corp-partner.google.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:53:25AM +0800, Franklin Lin wrote:
> From: franklin_lin <franklin_lin@wistron.corp-partner.google.com>
> 
> Enable the support for providing a MAC address
> for a dock to use based on the VPD values set in the platform.
> 
> Signed-off-by: franklin_lin <franklin_lin@wistron.corp-partner.google.com>

Please use your name "Franklin Lin", and the corp-partner.google.com
email addresses are not "real" addresses.  Please use your normal
corporate one instead.

thanks,

greg k-h

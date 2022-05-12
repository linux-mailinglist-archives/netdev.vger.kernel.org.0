Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39037524157
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349546AbiELAFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349534AbiELAFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423A479384;
        Wed, 11 May 2022 17:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E632CB82676;
        Thu, 12 May 2022 00:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FE0C340EE;
        Thu, 12 May 2022 00:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652313917;
        bh=0wHso0NcQCFeRl6MO0efGvitZ3BcC9Zk9fIkqeV91Zo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihY5LNiM9iPUBX7aHEnRfDpWj3i37GEG+NCCDa/8JrkXahCO9H7pPI+Qa33rde9z/
         YLSRY7UIil35GcYX0WPKEQkWWutFQEyxRyP3033feTfrlB2zff7E1jK5viT9XKmuog
         GZiD94gVjAUIOp4Fr/r/dvOuCW8YsUghhgyeu9Xie0d/r+sh2nFt9gZYrb0M1SDvtx
         225a5ip+93ECjSANAF0PCMJiyM2FgoIMqbBmUdx0u6wNOnEL585VLiO4F2N0IidkLR
         qDrDQ8xVmubrlFKK5gtelfdDa9c+eRiu2RXsGURzq7WKpsMn3w0/TU4pexwKSi5tYb
         1QYI21JFEz+JA==
Date:   Wed, 11 May 2022 17:05:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ober <dober6023@gmail.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com,
        markpearson@lenovo.com, dober@lenovo.com
Subject: Re: [PATCH v3] net: usb: r8152: Add in new Devices that are
 supported for Mac-Passthru
Message-ID: <20220511170516.5c87ac27@kernel.org>
In-Reply-To: <20220511193015.248364-1-dober6023@gmail.com>
References: <20220511193015.248364-1-dober6023@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 15:30:15 -0400 David Ober wrote:
> Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the
> original Realtek USB ethernet Vendor and Product IDs
> If the Network device is Realtek verify that it is on a Lenovo USB hub
> before enabling the passthru feature
> 
> This also adds in the device IDs for the Lenovo USB Dongle and one other
> USB-C dock
> 
> Signed-off-by: David Ober <dober6023@gmail.com>

Argh. Don't repost patches more than once every 24 hours.

There are 200+ emails sent to netdev every day, let all the feedback
come in.

I'm dropping this for now.

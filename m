Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3827468A827
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbjBDEVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBDEVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:21:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB3725296;
        Fri,  3 Feb 2023 20:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34877B82CF1;
        Sat,  4 Feb 2023 04:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E15C433D2;
        Sat,  4 Feb 2023 04:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675484508;
        bh=Iq4DPKkBQBz/8pmXIaF+AWRRYtoJ9g5h72FZKtb//0Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ksCwJu6BNy6XJJDY3lYGnmPHTsS96TzieKGfZHoPTjL14v74N1BIuXnJTRelgKlQp
         AuYKF+PtzOZYRpT5d66+FojZgl6XRJzWhaJC4B/rlHN/1YdX6u8MLK3Yy1Ed0SqdDq
         SY5N8PnQgBWbv67o0LOhvpOV1n7LiypMPa/+7zWOWfnilXWYsYwZMTUXbOql0Y8IVJ
         NdxUApzctKPTzrDbiqx/gaHpbaCXN0ki/EhxGw3DDVr8GdfV1hULlUeC4CPCvsCw3G
         Tb2jTQUJFTBdYcR8a6nmIkq7LYw1+phkW7KAVxO3wkV4JUKJGKo6YTxRrN3wLzmOk0
         eHThhzgJd5coQ==
Date:   Fri, 3 Feb 2023 20:21:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull-request: ieee802154-next 2023-02-02
Message-ID: <20230203202147.56106b5b@kernel.org>
In-Reply-To: <20230202153723.1554935-1-stefan@datenfreihafen.org>
References: <20230202153723.1554935-1-stefan@datenfreihafen.org>
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

On Thu,  2 Feb 2023 16:37:23 +0100 Stefan Schmidt wrote:
> Miquel Raynal build upon his earlier work and introduced two new
> features into the ieee802154 stack. Beaconing to announce existing
> PAN's and passive scanning to discover the beacons and associated
> PAN's. The matching changes to the userspace configuration tool
> have been posted as well and will be released when 6.3 is ready.

I left some comments on the netlink part, sorry for not looking 
at it earlier.

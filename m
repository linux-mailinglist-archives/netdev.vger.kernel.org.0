Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6031968AC0D
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 20:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbjBDTSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 14:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBDTSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 14:18:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D347F298E8;
        Sat,  4 Feb 2023 11:18:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A9460AB3;
        Sat,  4 Feb 2023 19:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B783C433D2;
        Sat,  4 Feb 2023 19:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675538281;
        bh=Imo+SNBOrS8vsejfOzz0FuxZ5RoGIEfIIyP61jAvq2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KUOHO5P3p+NJBdFZWxnQU/1Lt8eVJQRgFG51ilbtQ8Pk0UtB9ekEetobDLsImvD6b
         WlE3Oe7wHfinySRGvCQE9iTfMbubsliPL4CYp2K8saPEkRb6OEY6MKAv0ZFgU3Q4B5
         dXoMgXtUTGx25epFxVnXgs516ElXdm0DO+O6HOT1ZseOu09I/ddlJFZqoxqzA0d0O9
         Kn6Biy3UUDjVWurjBMwk4u5QaOtbLQ2q82aurJ8za4fJiJMQpfp+fGwoXal5oRs0iF
         jBcFFycbTLij0Yb9tmfTWYrveJGGMa3dz/OTNtGXmnK1Bv+U/6UR/PQUJ4BcjxhABk
         +L1QHiW9WGuBQ==
Date:   Sat, 4 Feb 2023 11:18:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>, davem@davemloft.net,
        linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull-request: ieee802154-next 2023-02-02
Message-ID: <20230204111800.24d6e856@kernel.org>
In-Reply-To: <20230204124656.470db6b7@xps-13>
References: <20230202153723.1554935-1-stefan@datenfreihafen.org>
        <20230203202147.56106b5b@kernel.org>
        <20230204124656.470db6b7@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 Feb 2023 12:46:56 +0100 Miquel Raynal wrote:
> > I left some comments on the netlink part, sorry for not looking 
> > at it earlier.  
> 
> As I'm not extremely comfortable with all the netlink conventions I
> might have squeezed "important" checks, I will try to make the code
> more robust as you suggested.
> 
> I will do my best to address these, probably next week, do you prefer
> to wait for these additional changes to apply on top of wpan-next and
> Stefan to rush with another PR before -rc8? Or do you accept to pull the
> changes now and to receive a couple of patches in a following fixes
> PR? (the latter would be the best IMHO, but it's of course up to you).

I have a slight preference to wait with the pulling until the fixes/
refactoring arrives. 

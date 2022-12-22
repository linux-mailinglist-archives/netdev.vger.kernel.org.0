Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9D8653A3C
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiLVBL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVBL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:11:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA01ADF86
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 17:11:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C71616FC
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504CDC433EF;
        Thu, 22 Dec 2022 01:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671671516;
        bh=5i76t7STg4TwvZXjj9xtOdVej3Nmaz4HoVwiPbAEQ7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CKybKw7OFvJtAoQXlJzhWxAZGeV8rhNS5FqlY+W+iSaWRXYfDt1UHQJFw/P678Mki
         cC9UF9mcmeuU29gD43y5LSnxGO/EGc8DfB6tMhv6NZf4AFfcUOPvYsGdQg6B7zzlda
         wgEY9E/dK6aUMTWBnx+TJjSNxbJa1lO8wavYQroI7VsA/rpJoJBvusLi0PAXe12Kvd
         bv7MhVolmYZ6sjAPRN3fRmpvmQfutO+3ZidSCoXH1PVp4X4ADnVr78qEJAjD+j9hjw
         vC0C9hNORiytv1tULzyGd+eFhDWNxoaSCvlDvhp3Tnv4+fxUCFVEm9EIoK3UU4ow42
         w81TpqW7jsluQ==
Date:   Wed, 21 Dec 2022 17:11:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, f.fainelli@gmail.com, rdunlap@infradead.org
Subject: Re: [PATCH net 0/2] netdev doc de-FAQization
Message-ID: <20221221171155.1a18486f@kernel.org>
In-Reply-To: <Y6OGyrmLKqy51k6K@lunn.ch>
References: <20221221184007.1170384-1-kuba@kernel.org>
        <Y6OGyrmLKqy51k6K@lunn.ch>
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

On Wed, 21 Dec 2022 23:20:58 +0100 Andrew Lunn wrote:
> I think you kept the top level header 'netdev FAQ'. Do we also want to
> change that, since it is no longer question/answer formatted? Not that
> i have a good idea what to call it instead.

Well spotted, I updated it to "Networking subsystem (netdev)".

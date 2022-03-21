Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A0F4E32F1
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiCUWro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiCUWrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:47:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E640536EFB4
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 15:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20384B81A0C
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EF5C340E8;
        Mon, 21 Mar 2022 21:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647898815;
        bh=alJOakDT4f5aU3bAFJiAP+dAXc5lywv2OHTQxQpaR20=;
        h=Date:From:To:Cc:Subject:From;
        b=k72uAwkaPuHleNtCGrgb49aFLiZYsGxKanjTXEPYAPOeL5MYP4BrikGyfQZ1hh+Kf
         fIqb/XNL28J89MGqksnPB9O2XurelhN3S9oiKj3Zmxv4ypT3E26kVTspjkmaLqS/1/
         OicdHvU38/h3lTgCMr7pKS0vWU4xryO2FCrEltEWOTnYPkRFDxUE+uMXqogHzwgO/z
         CMhVvNk3PMUu35MT/KVGF3jmp7hf10JYbVnSWGPQP4/WtqNH98aqsg+9SR9qxr4DcF
         KbFig0CS6SEJ0VsqbhD2MMr/fzEEtZ90CMXrqjHGgCyA5YVSOEdVQSLqaYxetpAIri
         8Q8iDh0UpxiuA==
Date:   Mon, 21 Mar 2022 14:40:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof =?UTF-8?B?SGHFgmFzYQ==?= <khalasa@piap.pl>,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Is drivers/net/wan/lmc dead?
Message-ID: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The driver for LAN Media WAN interfaces spews build warnings on
microblaze.

CCing usual suspects and people mentioned as authors in the source code.

As far as I can tell it has no maintainer.

It has also received not received a single functional change that'd
indicate someone owns this HW since the beginning of the git era.

Can we remove this driver or should we invest effort into fixing it?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471BE57E685
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiGVS26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbiGVS25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:28:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0A37C1A4
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56B57B829E0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 18:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E20C341C6;
        Fri, 22 Jul 2022 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658514534;
        bh=x7ez5yrWO1DKcYftENLlzo497W/KVkA/nBJC8fv8vZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=snaNu0b80K9Q+DoeansPVGNqTbj0Nte8ayboev6jtZHeixcqctFDUTFVSjZLTigrP
         h0OdVRlaPIxmRTRAOQVfYX4luG6r3ZEjGGViSuFbZWx6YrN8Mo8weVrCRNa3EiSlYt
         00kXXTdESiGnwBlxFpmFwIwLLgxeY9Im9jq9xBmvARx99liNX5247qPK7knZYTO1h9
         +xMScWRYEbhydjK6rIf3L8N9cA5YcIqOFAIGbnzg4Y7fi2v8/Db3vFyZLY+hq5ovx8
         CFYg34OO4dADfCZe0xRpHDBH6WHanhr669nKajKZUtiGdpAOV7cONA0MnsnxWvyKqy
         LhHng3SpTdnjA==
Date:   Fri, 22 Jul 2022 11:28:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@ieee.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Alex Elder <elder@kernel.org>
Subject: Re: [PATCH net-next] net: ipa: fix build
Message-ID: <20220722112852.22ac71e8@kernel.org>
In-Reply-To: <a23bd6b6-2244-1e58-20d1-5713d304acfd@ieee.org>
References: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
        <5a1c541c-3b61-a838-1502-5224d4b8d0a4@ieee.org>
        <16b633abfdcdcb624054187a5fc342bfeb9831f9.camel@redhat.com>
        <20220721094107.5766c21b@kernel.org>
        <a23bd6b6-2244-1e58-20d1-5713d304acfd@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 08:12:03 -0500 Alex Elder wrote:
> Is this the right fix?  It's A-OK with me if it is.

It seems so. AFAICT the headers are located one level down in the
directory structure so ../ looks right. Not sure why O=dir/ makes 
it work but there are bigger mysteries to chase :)

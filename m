Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA65C6EE4D3
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbjDYPfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbjDYPfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:35:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22031A5F5
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEEAB616C3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 15:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83A6C433EF;
        Tue, 25 Apr 2023 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682436898;
        bh=7FT5I2IeqrkuJywxptyy6HF3OiDCdqaBxI1/MDUAyAQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B41/6hJOeZIQRCnAMt04vVL+efRJLwWKOFH2FD6uMs6qX9erP2DWemUJzdktgG/XK
         79zesJnAa2F4pHFGiR1ZRIzFnroIzGLEhLvQ3H6ysNy4KKvLGEtDsHWsWCC3xvS0T8
         NXuRn9y9ia3dwa0Da591mOj0cizaShpZzZu1FV6+9/SAmAQac/jzsWEzwc4+rb1tF4
         ayOJH0k1sipwqkO5zRF5mnXEum3Cr0Vg3VCuhGZAsFWckKk0+R7EzNMv48rveK9BFW
         OP3tkQDKhpJz+kGxwrdrsLL2J4WRds3kPbm8CdcSWz51CLpYkqRpwhJQzb1PkDDpK/
         lZD+bSz2Ly1Fg==
Date:   Tue, 25 Apr 2023 08:34:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] netlink: settings: fix netlink support when
 PLCA is not present
Message-ID: <20230425083456.5e8702a0@kernel.org>
In-Reply-To: <ZEfmecrilOyvyGi2@gvm01>
References: <20230425000742.130480-1-kuba@kernel.org>
        <ZEfmecrilOyvyGi2@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 16:40:57 +0200 Piergiorgio Beruto wrote:
> please ignore my previous reply, the segmentation fault I saw was
> actually triggered by a different problem I had on my reference
> platform.
> 
> I've successfully tested this patch with and without netlink.
> Please, add me as reviewer and tester.

Good to hear :)  Thank you!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976735BBE5D
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiIRO2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiIRO2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:28:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62EF1C93B
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 07:28:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41B27CE0E6D
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 14:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB39C433C1;
        Sun, 18 Sep 2022 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663511307;
        bh=vaHDugw4ewTLodMCWzX/z839/4GapJMT/oEbUG/X+UI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yiBaExkXdhBjUSgeAfwPMUS2godwE9tNKmiWG1aIhxkUc6rmoUSl9W08zL3tnKXUs
         C1SF+03bjm6ZZUVCpD2MmcRi3kXDq+fVV+KY0OpwINgJsOOFfltu6oUw28vHUFnXIb
         Y4iTclAKZUCJieEi4i2jntcVGDySS05c0qwNx8H8=
Date:   Sun, 18 Sep 2022 16:28:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>, pablo@netfilter.org
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
Message-ID: <YycrJqcuQJOVCvr6@kroah.com>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
 <YybvTYO2pCwlDr2f@kroah.com>
 <91719698-62E7-4447-8220-CBA64F0BB5C9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91719698-62E7-4447-8220-CBA64F0BB5C9@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 18, 2022 at 04:49:26PM +0300, Martin Zaharinov wrote:
> Hi Greg
> 
> Yes still receive this message in dmesg this is kernel 5.19.9 : 

Wait, but that's not what I asked, I said:

> > Is this new?  If so, can you use 'git bisect' to find the problem?  Or
> > has this always been there?

thanks,

greg k-h

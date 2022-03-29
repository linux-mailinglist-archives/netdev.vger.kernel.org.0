Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8FA4EA6BD
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 06:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiC2Eyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 00:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiC2Eyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 00:54:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F2435AAE;
        Mon, 28 Mar 2022 21:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05034B80E5E;
        Tue, 29 Mar 2022 04:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F86C340ED;
        Tue, 29 Mar 2022 04:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648529568;
        bh=nqtB51WbL533ssiMiWnXoFzRKK3tHm0SboYWFYoGas8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AITz1Q/fLsZb40JAq2rmZd7/yGi8qkxegN30pgF3p9QYTlW6I4UbbfHPZW8XFkP2P
         r7cGTbZyUfDaV8GacobSTIx+onP1T1//5gNnw9jXnoCAYSlzooJNOmMLngbTzU6aBV
         e3p+zn0StVWXFbX0xykcR7nfcQzNTfNkBa8HZ82UGusFWuPtktOaVl/J6DyXyBJSk0
         Glkh2j/ZlLCMWB/d22Pxrkk4ZNzTkQdw6eaX1kVy41jrdPYHBRzWoqJrcrYkT+2ghx
         FsolsnNgFXqm5TJxAGjRJLjPTZCZMfiOJHLQt0+QJV7QjupOvOudzbRa+IJAYR5XNj
         XgRwW19rOmOfg==
Date:   Mon, 28 Mar 2022 21:52:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     <andrew@lunn.ch>, <bpf@vger.kernel.org>, <corbet@lwn.net>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <linux-doc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net 00/13] docs: update and move the netdev-FAQ
Message-ID: <20220328215247.69d31c4a@kernel.org>
In-Reply-To: <20220329043808.95053-1-kuniyu@amazon.co.jp>
References: <20220327025400.2481365-1-kuba@kernel.org>
        <20220329043808.95053-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 13:38:08 +0900 Kuniyuki Iwashima wrote:
> From:   Jakub Kicinski <kuba@kernel.org>
> Date:   Sat, 26 Mar 2022 19:53:47 -0700
> > A section of documentation for tree-specific process quirks had
> > been created a while back. There's only one tree in it, so far,
> > the tip tree, but the contents seem to answer similar questions
> > as we answer in the netdev-FAQ. Move the netdev-FAQ.
> > 
> > Take this opportunity to touch up and update a few sections.  
> 
> Thanks for update!
> 
> I would like to clarify one thing about this website.
> 
>   http://vger.kernel.org/~davem/net-next.html
> 
> I often check this before submitting patches.  I like this much, but it
> seems not working properly for now.  Is this no longer maintained or by
> coincidence this time?  If I could help something, please let me know :)

Sorry about that, DaveM has been traveling during this merge window. 
He said he'll fix it soon.

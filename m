Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A654F624768
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiKJQso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiKJQsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:48:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB8843AE5;
        Thu, 10 Nov 2022 08:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D93CE60C3C;
        Thu, 10 Nov 2022 16:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB98C433D6;
        Thu, 10 Nov 2022 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668098805;
        bh=XWk0+yhF8pz1o6YbZeShycdwa3dm9HdB1/A+oSRvD18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D74V8xGZXZ/wOtfDgKaBsz+CceZZaDZHc/wwh8UXXhZIo0JO53hqmat2NpKRdOQJ9
         07rb0SEycSVj6lN81mcC7HTK2sw1afBA9TjJMZ88g8WS5hGvNHhTMqBsOqH70Hg6vb
         hMhC2+/5LsQ8ZmcGVRmL8r+m//E6wTzDetLacEh5eDMHK8ijh/CJRDb1f9wwxvAkEX
         xHPen4uJw4AlpljlKywa6nhFWIcQgwXaKEdbEb2pvdOBKcZiqv6ReAWSmcE38FMQsM
         6UkR7DAXZgkbmuoVS9+ug8QU+cmt7xu9FAOmyF+IvwGEe4bh9YJjupdkURp0wurxvy
         XR8q7YoUV/rSA==
Date:   Thu, 10 Nov 2022 08:46:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuang W <nashuiliang@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: macvlan: Use built-in RCU list checking
Message-ID: <20221110084643.665bbbd3@kernel.org>
In-Reply-To: <CACueBy5zSfmK_Pm-f7FmCZ1FhgvLpp7w+qKm82WMmDb3n5ZY7w@mail.gmail.com>
References: <20221108125254.688234-1-nashuiliang@gmail.com>
        <63f95025240ce6fa9d9c57ac26875d67dfd2bc71.camel@redhat.com>
        <CACueBy5zSfmK_Pm-f7FmCZ1FhgvLpp7w+qKm82WMmDb3n5ZY7w@mail.gmail.com>
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

On Thu, 10 Nov 2022 19:27:52 +0800 Chuang W wrote:
> > The patch LGTM, but IMHO this should target the -net tree, as it's
> > addressing an issue bothering people.  
> 
> Sorry, can I sincerely ask if the -net tree is
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git or

This one, but you should also put the name in the subject, like this:

	[PATCH net v2] net: macvlan: Use built-in RCU list checking

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git ?


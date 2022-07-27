Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7619D581DB6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 04:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbiG0Cr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 22:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiG0Cr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 22:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CC926558;
        Tue, 26 Jul 2022 19:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B79961766;
        Wed, 27 Jul 2022 02:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A1AC433C1;
        Wed, 27 Jul 2022 02:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658890044;
        bh=2j7hAK9n+nEEJAGpo0so/NxZzWK0KHstyi50HWjaQa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hSYOOpJvcGn5ntipQlBeXj8dHlM2eUrebgEcCyvOLb7BU0ls0agZpmIqI5leVmc4n
         yL2thNiS54BIm6sCynKOmkrtjZvXznM3UhmKA+e/kqleQEl60afA1cKQwyAvdYPVFf
         /q1y3ITHqVmu2UHVkrYdb0f3KCu10nBbsFmZpvz8vF+3HtEEwBriDdW6EiU8D1hTrA
         BfsCV9jwGrMtz6EZyE+BnaJsqVxNFJXpv4dLJeEktR9tGLW7eMo1YGO6yw6YMIKbYZ
         aRxBZ1uRqOqILa6lxBJIBAEf0rMswV/2dvgVvt/dOte5KUBf7AxwrBBYt9mYDlwoBO
         Jra6DGWQZQICA==
Date:   Tue, 26 Jul 2022 19:47:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Tedd Ho-Jeong An <hj.tedd.an@gmail.com>,
        David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth-next 2022-07-22
Message-ID: <20220726194723.717ea49a@kernel.org>
In-Reply-To: <CABBYNZJoAe+XDp_Zq4bfepizxpmUiB_Vo-ix1A2TyJXjzQVe+Q@mail.gmail.com>
References: <20220722205400.847019-1-luiz.dentz@gmail.com>
        <20220722165510.191fad93@kernel.org>
        <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
        <20220722171919.04493224@kernel.org>
        <CABBYNZJ5-yPzxd0mo4E+wXuEwo1my+iaiW8YOwYP05Uhmtd98Q@mail.gmail.com>
        <20220722175003.5d4ba0e0@kernel.org>
        <CABBYNZ+74ndrzdx=4dGLE6oQbZ2w6SGnUGeS0OSqH6EnND4qJw@mail.gmail.com>
        <20220726153140.7fefd4b4@kernel.org>
        <CABBYNZJoAe+XDp_Zq4bfepizxpmUiB_Vo-ix1A2TyJXjzQVe+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 18:06:47 -0700 Luiz Augusto von Dentz wrote:
> > No strong preference here as long as we can keep the sign-offs etc in
> > control. Note that I'm not aware of any other tree we pull rebasing,
> > tho, so you may run into unique issues.  
> 
> Maybe I need to get in touch with other maintainers to know what they
> are doing, but how about net-next, how does it gets updated? Is that
> done via git merge or git pull alone is enough?

git pull, if you mean upstream trees making their wait into net-next.
And afterwards submitter does git pull --ff-only to update their tree.

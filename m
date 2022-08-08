Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFA558CDAD
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243918AbiHHSeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237830AbiHHSd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:33:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE5917E0F;
        Mon,  8 Aug 2022 11:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6770E61229;
        Mon,  8 Aug 2022 18:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BE1C433B5;
        Mon,  8 Aug 2022 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659983636;
        bh=1VQ11gHLr87lHj6/9x8gTQ9nytaOq8HzAs4f2LgF+Jk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rDTce0ZtooT3WhkORC51F6Yc8UnvkS32wF7uWAE8IELp7OEFWaTOKehoPOxZokb3h
         CDxViU7B7nF9tzOcjh50GR/GVeUevUcRJ9QgSjFSDqVKrEAAYtOPVLld/kPT5PGDsD
         xuPwIfx5jz/dTZ0TJsqtx0Dc5AwqEAe0Nhcxie5KW3A8ZWza5vTbDdB0w7T3VoqX/4
         Zq7qhKBxU2eEZycMactGFFqcmIYDwdS9aDoCJfFEoKiZ2EVGcMwGqSxXV7n24qzHeG
         s2vQI1jSSaxR51tq9/waptpARe7AbOrV0OoagQKdEVAOKozpj4wGCJYA9eKpm2OkqS
         D4uy/zd0GxR1Q==
Date:   Mon, 8 Aug 2022 11:33:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <aspriel@gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
Message-ID: <20220808113355.32f29e8c@kernel.org>
In-Reply-To: <8735e7i22v.fsf@kernel.org>
References: <20220803101438.24327-1-pabeni@redhat.com>
        <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
        <87les4id7b.fsf@kernel.org>
        <877d3mixdh.fsf@kernel.org>
        <CAHk-=wiW62CSONUNdpPcohmnTOtF_Fa4tSrz-H+pqE3VmpuARA@mail.gmail.com>
        <8735e7i22v.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 08 Aug 2022 11:14:48 +0300 Kalle Valo wrote:
> Ok, let's do that. I now applied the fix:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commit/?id=baa56dfe2cdad12edb2625b2d454e205943c3402
> 
> Network folks, I'm planning to submit a pull request on Tuesday or
> Wednesday. Do you still submit your pull requests to Linus on Thursdays?

With fixes, yes! Thu the 11th will be the next round.

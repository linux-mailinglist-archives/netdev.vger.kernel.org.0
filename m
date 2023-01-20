Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B224F675087
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjATJRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjATJRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:17:47 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12B68F6F4;
        Fri, 20 Jan 2023 01:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=K0kC5g0BC3EhF8JShryrGN36pACW/Rqty8M1nBrIchs=;
        t=1674206248; x=1675415848; b=HNHOVIB+SNhK26y4hqZiCIqeL3sJBstX1Rr5kI83MHNu6mL
        LvE3GpmapuwGDlNS+TDu1hL71dFlJJm+FEwYNKhQEF1i/G77U14zKZiUeX+cC3jBCC+uepiRU2neB
        PBsXEH44hqwYtEtDNExyaxq8F/I6bbwH7Y0SeSvHfXExQLrRmKUDcKOShbfgThyOeNr8kgdBFDoII
        nkZ7uot8XJrQ+bJC+gstLMgCNe+kPe0OwL+x8roTbNXqM6jCg8gt4b6cWARu09crH618kKjP3O6U8
        60T8iabmsyHIUFLT3DrNDk5QANz1AcE+smJVPd9YJZnnCvNI1e20VL5BFKYc63yQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pInWS-007Nb3-0Y;
        Fri, 20 Jan 2023 10:17:20 +0100
Message-ID: <210590039104c51e5b3ffbc3166807cc4617bb92.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v3 3/8] net: add basic C code generators for
 Netlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com
Date:   Fri, 20 Jan 2023 10:17:19 +0100
In-Reply-To: <20230119175302.3a592798@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
         <20230119003613.111778-4-kuba@kernel.org>
         <ddcea8b3cb8c2d218a2747a1e2f566dbaaee8f01.camel@sipsolutions.net>
         <20230119175302.3a592798@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-19 at 17:53 -0800, Jakub Kicinski wrote:
>=20
> > Doesn't look that bad overall, IMHO. :)
>=20
> I hope we can avoid over-focusing on the python tools :P

Oh sure.

> I'm no python expert and the code would use a lot of refactoring.
> But there's only so many hours in the day and the alternative
> seems that it will bit rot in my tree forever :(
>=20
:)

Yeah I don't mind. The quality of the implementation matters to a point,
but honestly I was just reading through this to convince myself it
wasn't just a totally stinking pile of hacks ;-) Which you/I have
managed, so personally I'm happy with this.

johannes


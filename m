Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C2B6743D5
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjASU7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjASU5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:57:03 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D2F4DBD1;
        Thu, 19 Jan 2023 12:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=6xzfIq9o8936qqdQEq047u27GOHat+lkIMkZN/5JZnk=;
        t=1674161774; x=1675371374; b=OZcvqzBcFDM6tCR2qnhx57W2MinOOhnn1kzr094ECEoGFSD
        2F3TjeOIb3YqnDvlC+uOm8FdElXWpocRwO3xlmC3bYxMvDZ/18QgHMY5vUB/apguXr/C7isB3proG
        MCduR4TW8dfyh3CxgCfbaLYCuQtrykrEdTdKU5XwVXqeZkCGMbqeQJuZaKXaJvX4tsYS9+lwJVO8m
        Wh/VsgjaWlrEqcY9w4f/PZq9MV/G2lg46dLmeoWWew8nH9K94qxYs0U1d8nJaoXwv2cy20p1mFlRa
        iY+F05sLLWj6evFSbtsM0zuw0NSoICN17gMR+tYENZtbwHg61+RjCZbLKtDxDthA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pIbx8-006fDl-2F;
        Thu, 19 Jan 2023 21:56:06 +0100
Message-ID: <a340a5e2da55f352322c2aa902b592ece9bfbb5a.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v3 7/8] net: fou: use policy and operation
 tables generated from the spec
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com
Date:   Thu, 19 Jan 2023 21:56:05 +0100
In-Reply-To: <20230119003613.111778-8-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
         <20230119003613.111778-8-kuba@kernel.org>
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

On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:
>=20
> +fou-y :=3D fou_core.o fou-nl.o

I feel like you could've been consistent there and used "fou-core.o"
with a dash, but hey :-)

johannes

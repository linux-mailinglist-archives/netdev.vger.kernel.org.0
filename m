Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE595AD2C9
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 14:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238378AbiIEMfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238199AbiIEMe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:34:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D47647EE
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 05:28:50 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662380927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rzi5aYHtJog/AJR69H7eAWVW0Lmrkt7z5YRvFgKyopg=;
        b=dlR1A/EdAscnbVa8FyKG+ImKEF+Hr2s5JwkA752llEWi0Qk9qOwK1iQ4F0ouQBCvtDktbI
        WKjdXb80sIBwZgv8pUihQxAeBhPqcfQg7BCamjitODwqdDE5K9zHwCnO6dDS24RPig6b7W
        AO0m2O2oXxi2TY9U3NYvbyccmmwU5V3iplRoT1dDrKexcyhGwtVP5Y1QTudM1gywTcV1tn
        E9LUNRP+57nV1pAgW6p7gYq6z8fWfzsTUrjXYYN74sbgrIz49/MHOvc0NR2dpHETSWPSzN
        gvQxohnRLm7JQrCMm/zB02kdei9VsKMjTEYsjXVw+Eb4KqYXCXsmbiJwDAhpXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662380927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rzi5aYHtJog/AJR69H7eAWVW0Lmrkt7z5YRvFgKyopg=;
        b=Z+314Jm2HcHzvk+8sP0969Lv6PWvRHore0FTcAGTpAMzhe0/WkT3LoYaNoJAr1M6mQGjia
        EbLG9Y6/jOkToGDQ==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
In-Reply-To: <a1b21de9-a379-f920-e7d1-07ac7f5a7e96@gmail.com>
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf> <87v8q8jjgh.fsf@kurt>
 <20220831234329.w7wnxy4u3e5i6ydl@skbuf> <87czcfzkb6.fsf@kurt>
 <20220901113912.wrwmftzrjlxsof7y@skbuf> <87r10sr3ou.fsf@kurt>
 <a1b21de9-a379-f920-e7d1-07ac7f5a7e96@gmail.com>
Date:   Mon, 05 Sep 2022 14:28:46 +0200
Message-ID: <874jxmj98h.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

>>   static void dwmac1000_core_init(struct mac_device_info *hw,
>>   				struct net_device *dev)
>
> You should be able to remove the net_device reference here since we do=20
> not use it anymore after the removal of netdev_uses_dsa() or=20
> de-referencing of priv.

That's true for dwmac1000_core_init(). However, dwmac4_core_init() is
using priv now for some timestamping waitqueue initialization.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMV634THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgsHIEACcWLNxDlxzF4RxnIuJdXxm5WJTc0DA
DXjYQQ36IHzQuLZfe3EyFBeKPKcam1KQUdjCGr8BfG/E8PfXXsrW2P65fPBIc/jf
LS/50VR1tStx6yxNVU1hStD6fJ6zNFUEKf2+i9VeDG44MhLw1T4lVW2IgYPPXwXe
qWmtovei3Dp7eT3e7RA4aNajfknctESr+hF3gVksLnyNL6eoSVLLJJEF0MRkukc0
Zif3fXF285OfefmpS6XLbnIk4mM1hcjlCgHpX0nPNX3/jo0uSgcmXqDIhM6ImgP/
kPJxalXanP8w51Wz+6oh9OYW5d5Bux+lX3va7cKjkTlh6FhjWgEiq9qLxGi+p7Z4
QUvGpzawiWLI81xYFe8Xfs8w1Kg8qs4DpyXyW6+N2vMu5vUAU0hmfndU0AX7om5R
q1JDUwrZ/QIBOUTRJLI6zEEFZTg7q91bxMGPM6i6y6KogrFBFkSNDBXG+nguRUuh
y4T3KOXDL8Q7HBfYOZqMQNaG0rHkg2FieIF0prZtQmROuHUDzifD6zhTrvi734ET
I8G5Z8NKs13v88kcP1RPDZXs/WCtvixVtfCT17yl3qrQXKHVJ81v9bbNqEOE0z/l
528btIDp3gYQCRXs1A9IU07xBoOJ71j7jRqF5yfa1PboilCfMB9tqCKUE14MQoKV
NoeW6Y9QjbWtsA==
=12u4
-----END PGP SIGNATURE-----
--=-=-=--

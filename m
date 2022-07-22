Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A620357DBBA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiGVIHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGVIHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:07:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00F39B576;
        Fri, 22 Jul 2022 01:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=fOgdifvNKN2Ggq7uhtwrt+Fqbi7IrThgIQlfWKX5neU=;
        t=1658477221; x=1659686821; b=x5SyH1hdo675lSOm0QsdEo7sH9MJzRVEiI12V04SfhAhOs+
        FvOO+IOIU1D1f5zA+m+2XCsNUuacnJMKmq97Dg5fP8mqiwy+W55naP9Gsv03mtAML2jtxTnAWLbZK
        dNNbk2ii5fsseevljppkAheIMyF9Ww8N3aOAovGNRIR7Xdqv6QcU2nOj/qNahnd6AxhoOmEc0ZF9z
        TErmeREoGk/wBJi40IgrEm7DFtlNcaEibzQQSNz+lyPx5SMFW0hgR3EKydtE9FIu9Pf6V0cWigByY
        YTs71o5I4DKihY8yYt71SmPn+O6BMXb94nXpjIaVVq35JV9rXsIBLmkEL5nXIhJA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oEngW-005DnT-2d;
        Fri, 22 Jul 2022 10:06:56 +0200
Message-ID: <9b2b7ae17008881d9ee35163aeaa183604f5364a.camel@sipsolutions.net>
Subject: Re: mac80211/ath11k regression in next-20220720
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Johan Hovold <johan@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 22 Jul 2022 10:06:55 +0200
In-Reply-To: <YtpaQXhM5wuz4Zbq@hovoldconsulting.com>
References: <YtpXNYta924al1Po@hovoldconsulting.com>
         <0a400422546112e91e087ce285ec5a532193ada3.camel@sipsolutions.net>
         <YtpaQXhM5wuz4Zbq@hovoldconsulting.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
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

On Fri, 2022-07-22 at 10:05 +0200, Johan Hovold wrote:
> > We think the "fix" is this:
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.=
git/commit/?h=3Dmld&id=3Ddd5a559d8e90fdb9424e0580b91702c5838928dc
> >=20
> > Do you want to try it?
>=20
> Thanks for the quick reply. And yes, that fixes the problem.

OK great, thanks for checking!

> I apparently failed to apply all commits from that mld branch, but this
> one alone fixes it.

OK, I'll check later.

> > Note that if that fixes it, it's still a bug in the driver, but one tha=
t
> > you'd otherwise not hit.
>=20
> Yeah, those warnings looked like secondary issues if that's what you're
> referring to?

No, I mean there are legitimate cases where override=3D=3Dtrue, and then th=
e
driver breaks. It's just uncommon (I think perhaps only specific
userspace [debug] configurations), but it could happen.

johannes

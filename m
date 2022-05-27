Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA3535D62
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350282AbiE0JX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346872AbiE0JXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:23:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2329C5E16D;
        Fri, 27 May 2022 02:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=BNRMXkWKvCwoT8hSX6gBpFCOPN4WSiAhGB0Malvj7JE=;
        t=1653643404; x=1654853004; b=RHON+xmL1jhl2kx07zUTIx6aAw/ddbSmcrazWmGtFbg3Tfy
        +dRB++gHZotpUkFQpEqVfqbYidmewQsiKEqpTfW7L9qzwQseWEKh0PVMX3YEMRxf5ASsfC0ObaaQd
        ZUSjNA5d9CGouGZDoXh3Gkjf0Gmsd43jfgUnpUL1KHuupKOwjNgKVLn+4PYCp8CXSJC8DtCwcF9hU
        AsMnhVE/8JyGa9F5rBg2jMdAx07qJgzsC/yeSWVv0/WGE8pLCh9aCJTVWXzg+0N6fymk2auHrJQN+
        hSrsb29e8lZmrnT6Auo6//AHDsi4CuCQL2jIviNoBYvnHgB+4faPzjK5QUOZP8bw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nuWBb-005zKZ-Lh;
        Fri, 27 May 2022 11:23:11 +0200
Message-ID: <604ee91b52c79c575bb0ac0849f504be354bf404.camel@sipsolutions.net>
Subject: Re: mainline build failure due to c1918196427b ("iwlwifi: pcie:
 simplify MSI-X cause mapping")
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date:   Fri, 27 May 2022 11:23:10 +0200
In-Reply-To: <875ylrqqko.fsf@kernel.org>
References: <YpCWIlVFd7JDPfT+@debian> <875ylrqqko.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-05-27 at 12:20 +0300, Kalle Valo wrote:
>=20
> iwlwifi: pcie: rename CAUSE macro
>=20
> https://patchwork.kernel.org/project/linux-wireless/patch/20220523220300.=
682be2029361.I283200b18da589a975a284073dca8ed001ee107a@changeid/
>=20
> It's marked as accepted but I don't know where it's applied to, Gregory?

Gregory picked it up to our internal tree.

> This is failing the build, should Linus apply the fix directly to his
> tree?

I had previous asked Jakub if he wanted to do that, but he didn't (yet).
I don't know what's the best course of action right now...

No objections to it taking any kind of fast path though :)

johannes


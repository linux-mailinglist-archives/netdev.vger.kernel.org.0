Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE15D4AA7FD
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 10:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbiBEJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 04:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiBEJ57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 04:57:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F26C061346
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 01:57:57 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644055074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rUzpOjcIclh+K4ustrBQhEISjpjgNHpUfwww4DPGBAc=;
        b=mlxtq9YB3wXo3XdyAZgmNqpOm8cXLX43sK+wwAfriHDfeFjdi+kmQYnrlNjKv4RptBI08X
        wkUctZPc9AzP2SEVH4k/L27Wq0BU9DHD4vaJcrnFB1fb0WR6o1PS5EbvWROhAP8ulr2+tX
        IHsVf/asEdsMrM6OEzvf/gE+HHidIlzmSWqE+N6dpVhIumpL1eqPD9uV7PPXahOjREs5QU
        1CN3YSr/bBQwr3jp0kToVKQWDYOoeQIQTcFHfJpvAoIi0fqzmJaGm2LriJjIXAgDmkqMdD
        CvU7Yl+a6zgVaj2KsBOa/vexm+Ew8iehKE7VSEQg9DUWnKPFBNYjuwshhF9urQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644055074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rUzpOjcIclh+K4ustrBQhEISjpjgNHpUfwww4DPGBAc=;
        b=wDraDeu9LbVVE68bleXWhCjeujWLTEicQgnOZpkmeCVyF8/gfN+g/E2BC/p3R59t565Eli
        2O1Mt+4OBKe8PIAw==
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "andre.guedes@intel.com" <andre.guedes@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vedang.patel@intel.com" <vedang.patel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] igc: Clear old XDP info when changing ring settings
In-Reply-To: <0f1e1c0fc4f555ef0eaaa983da6d8f012a0acf60.camel@intel.com>
References: <20220204080217.70054-1-kurt@linutronix.de>
 <0f1e1c0fc4f555ef0eaaa983da6d8f012a0acf60.camel@intel.com>
Date:   Sat, 05 Feb 2022 10:57:52 +0100
Message-ID: <87iltttz33.fsf@kurt>
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

On Fri Feb 04 2022, Anthony L. Nguyen wrote:
> Thanks for the patch, but we have a patch[1] to resolve this issue in a
> more preferred method. igb is actually changing as well to this new
> solution [2].

OK, great.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmH+SiATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgrFSEACRiD2JcjOKtNMEMeuSLJicYnV0po2C
RvupFkgpPOgTJIL/yfTUXVoA38AQXRPC7PVuxYH+ScNa+NhjaTYvsQ5AVxd41QTx
wBonV2J7xp9WkDP8hO3sfu+hfVj15hNqKib4geNz+wnECAuNr9OVrHiUaWNU8T21
J+wO+z/b7So9p0aR9VGEUWXawM4hBnbACzMSdcLRIctdF7XSUttD07oF3yMbr7Hb
m3nMLVw8JyZXe3ooL89pwQv60yBu6eUJjFnkiJCPPZjYPCv4GiPKUYpNO9aMZocF
o6QWGxDL3E6xQ4GpVO3FfYFVPtyzOsPiZ31SiTpBKxzI9awo0nfnnna6kJY8SmOd
Wecc+e804Y54ISTIlyiPWmvbMSa73hjFPfUksJL1dg1Ti8cmh2uXEarvGUYfYwW6
B7jr+v18TBd0s4aTCRXHkX6LMNiikxvS8fypZH3fyB9bAQ1hN71oAv+w0O8k1PCm
AxKhowCmdqaof6Mbl6TI6n5Tre5HfZWXfO+VvaohVtpVR+Izae1bCwapvr8cmaRA
S2NGF2ZaBgr9LcYVdAcxqVCXC8gITmNPMZ14iyKzcfMADk/OueZLB5WL2h1oo2Oq
KlhzFVpmTI4/id071ImAuRiGod0TtgHJcZl9VLkKzmz2jcyg/4iEK+mVvYIF2P7r
190kHrW6fs6INw==
=Hw31
-----END PGP SIGNATURE-----
--=-=-=--

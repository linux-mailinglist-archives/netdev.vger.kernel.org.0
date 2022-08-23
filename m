Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F9559E4A0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbiHWNrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238650AbiHWNrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:47:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B90C20766C
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:51:52 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661251835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nJMvSnzOfKnLLHT11Q1DGzX+DAQF0C2lBP38jFwkGOM=;
        b=zTieD6dAuzWVh7mB/huTZyucUx45RY40At00fZFLTCX4r9XFTAu74g6dQuO1T7zgmX/8Wh
        4tEvUfdAml5AjOaY9fl65dowbEoZduLVk8KGAeiCIEypoW2zeU7IvEA7FKy49+Z6kCGHlO
        I8zlEjXPFAwH+6dp0VtMt2JKgvwxW3STmRZv4gxz10gwcjzIFzttTRbd4fSIXrn23nwK1S
        WWvoC57ZWkmorVgIzqvUFp31DPYQmI/urzRcBzVi3AQXd4KnH08o69UKL/GoWmGvFGAYKB
        R5RNvI9cUZzgZ7sIAC+xvtuldF2XnL3her14SGxSnMIyhZiHbDF452X/o3JaHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661251835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nJMvSnzOfKnLLHT11Q1DGzX+DAQF0C2lBP38jFwkGOM=;
        b=pOAcT47kE4nlNu7i5qGP7PKQUH7lPpZ46iSmM5pCY2YClfYuaX9ODSCe8rZZiGb9fjsoCa
        v2bVgI7vT2T8dOAw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
In-Reply-To: <20220819165940.ett7n4vwbw6hvqvi@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <87czcwk5rf.fsf@kurt> <20220819165940.ett7n4vwbw6hvqvi@skbuf>
Date:   Tue, 23 Aug 2022 12:50:33 +0200
Message-ID: <87tu631beu.fsf@kurt>
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

On Fri Aug 19 2022, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Fri, Aug 19, 2022 at 10:16:20AM +0200, Kurt Kanzenbach wrote:
>> On Wed Aug 17 2022, Vladimir Oltean wrote:
>> > Vinicius' progress on upstreaming frame preemption support for Intel I=
226
>> > seemed to stall, so I decided to give it a go using my own view as wel=
l.
>> > https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.10=
98888-1-vinicius.gomes@intel.com/
>>=20
>> Great to see progress on FPE :-).
>
> Let's hope it lasts ;)
>
>> > - Finally, the hardware I'm working with (here, the test vehicle is the
>> >   NXP ENETC from LS1028A, although I have patches for the Felix switch
>> >   as well, but those need a bit of a revolution in the driver to go in
>> >   first). This hardware is not without its flaws, but at least allows =
me
>> >   to concentrate on the UAPI portions for this series.
>> >
>> > I also have a kselftest written, but it's for the Felix switch (covers
>> > forwarding latency) and so it's not included here.
>>=20
>> What kind of selftest did you implement? So far I've been doing this:
>> Using a cyclic real time application to create high priority frames and
>> running iperf3 in parallel to simulate low priority traffic
>> constantly. Afterwards, checking the NIC statistics for fragments and so
>> on. Also checking the latency of the RT frames with FPE on/off.
>>=20
>> BTW, if you guys need help with testing of patches, i do have access to
>> i225 and stmmacs which both support FPE. Also the Hirschmann switches
>> should support it.
>
> Blah, I didn't want to spoil the surprise just yet. I am orchestrating 2
> isochron senders at specific times, one of PT traffic and one of ET.
>
> There are actually 2 variants of this: one is for endpoint FP and the
> other is for bridge FP. I only had time to convert the bridge FP to
> kselftest format; not the endpoint one (for enetc).
>
> In the endpoint case, interference is created on the sender interface.
> I compare HW TX timestamps to the expected TX times to calculate how
> long it took until PT was preempted. I repeat the test millions of times
> until I can plot the latencies having the PT <-> ET base time offset on
> the X axis. It looks very cool.
>
> The bridge case is similar, except for the fact that interference is
> created on a bridge port going to a common receiver of 2 isochron
> senders. What I plot is the path delay, and again, this shows actual
> preemption times with a nanosecond resolution.

That makes a lot of sense and this kind of test scenario should work for
other endpoints implementations such as igc and stmmac too.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMEsPkTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzggUAD/4rNrVgWfcuuo36BXB3Hcuafsbz/HqP
ehpEDr90yl6wBKjdEhitsJA2hVo8eUIvcmOyzd2Z5UQec6qfGl6ITWD0FbPOgeFT
QTAJGT6Q82F8/w4rB2u8zPbSBfbeDBX4F379XwieRWHTNih5HjMCSYioLFaQiP9m
A+XpVRjwZc+5I/CinPXC7yC7enqq75kItxUK3W+7YBDtfYs5n7ADMAoedK7/e75M
Y5VCTwzGLlP6M9DZG+SQGkMdhFmX2YhwTWafb55Ii1Fjm+lztm+j7MPVyxlE+GqQ
aw8HeAqJ12MDrxuqD1ZuQSfkMhCw6DpufFonYZ51bOu0a2lh1fqv7X/k64kxkGPV
noKqlxLAlXUlxgJSQI3V4gwLsxIUpduvf+Q3+sqHfrPwfmEexNlnupRdAmuzJXCk
ZL8Tg2CoUYl0zEesH+MqKsJP4k6MjzoQhvYJ0K1uM9Vg00hDY6jP8eSu3mEuatKR
j9sTnZ3zIwd4FGjgN5WTg9w297KSs7vJCjvMSOKF0yzQDhm5BjiHpuyPqs1LsuWb
uHziqCrKjtVMbQn97mxTGSBIwpoDtqAhGJPzpcUvU7YqRxvKK+tYZnsAKYHdTn+H
pVbipaooAymwo09LPqqZpAXTcsbJXzoPFGY1mtjLKUDMoA8UXyoSVPh1pQBuJ7j2
M4qDM3agho2rjQ==
=KUho
-----END PGP SIGNATURE-----
--=-=-=--

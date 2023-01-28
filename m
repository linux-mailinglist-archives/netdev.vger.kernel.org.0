Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A493667F7B2
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjA1L74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 06:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbjA1L7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 06:59:55 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6E3721E3
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 03:59:54 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u8P3whJzVXYe+t8p6AxS2oxRJD2cxKmwZihkRncXYUE=;
        b=DOY2vZIsLJJkLJIpyGPiFPa58hzYHAe+lUOZwaVfgDvE74yfNz2iBvar87GVOwdAnYvj7x
        vZnlv+nGIHq+cxGSSMBRArx3Cp8zZ9xtecorzF8+ZHyBQYffpgk/zdlgIyM5o10RDav0P1
        oWvyg7uGrSyeFW8fJHmAYz2kIWxTi5HOGaU0+sF+hiu0vt5pagedyA68vQOCJ/DyJqJJw3
        Ixo279maPaQ3IpTHVXBdTGdpmbHOC3dPn+LDaZkaXAFUoa6jC4M7n9PgdC1EdEMyZgxJUD
        NvSRMbCMKT9BAWUNdnsV/9pO3Axs7SFU3MbP9mEgrHPGpnks+yafUlLhYNq24A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u8P3whJzVXYe+t8p6AxS2oxRJD2cxKmwZihkRncXYUE=;
        b=yAYdbFrywEimWdzssVm/FCPt4h63kyIl52cbv07vnie8gRerIZ+UzJJrtHSKmlujBZX/7J
        vLg4HvAA6zkDd2CQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 03/15] net/sched: taprio: refactor one skb
 dequeue from TXQ to separate function
In-Reply-To: <20230128010719.2182346-4-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-4-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 12:59:52 +0100
Message-ID: <87pmayvphj.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Jan 28 2023, Vladimir Oltean wrote:
> Future changes will refactor the TXQ selection procedure, and a lot of
> stuff will become messy, the indentation of the bulk of the dequeue
> procedure would increase, etc.
>
> Break out the bulk of the function into a new one, which knows the TXQ
> (child qdisc) we should perform a dequeue from.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVDjgTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgqW9EACEuRRN/sJi3IGeaBJPoegDl2F1YvIo
KMgriMPi0JzGHzydaIzDlQ3YwsnF6C8wCbOhwwOaSlalU1dGdAJdeWxSJSkDupnE
34GpPSQZuqaZHKIQPsZ9zodYHKMZ1TUMs6xljuBUkiVbca3GuM8fJ9fhJs58nBAf
cbnF1fjTzZDUpzcyZ34ad4p+LZVPpczgbQDjHdWTsbvvMtKcCPT32a+Ts5J57XcF
8z+vqfxeV32ubE2Po72tK3Zdg+ruY6hg28uXQ2UNjyBDof9MS24nNVC2Zy0Tkptz
ATITTjShgfr2ZVe0RRQnOn1iBPs7272T8D7VG4MyIxf/AjgdYSgCs1CVLoSoMi+F
ToZLw2jO4uWyYLf6KAj7yBKbdf0Z2cfq3X64WOioxLsZIjZAFACGCbcrc8ia/WMR
GfPrnHqwB0e6hdL8M7KslPCUFryJq/sjvj/0sy5RDVfZWr04I5164REu+dsIKMXf
4zusxtv8iRx3hxgyLaPd8QN9j5n6xTdkMzPDlSnlhM49tSjjWOad+EfHWgJ0HKSq
KcFH3srBw9idmocme4uzmyQvZ2+PbuVOJ0nxvwpkJT+lshkYspcTC0ThxJRF4JkX
nCz+SQlGwqmvZe2cMiuR09KeyujZ0aeoaAV2QBxBF2WgHs5smmCUNBqETI0iXMNI
gBPphPcfWZRRag==
=sEr9
-----END PGP SIGNATURE-----
--=-=-=--

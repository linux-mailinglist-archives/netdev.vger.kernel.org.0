Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40257595720
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiHPJwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiHPJwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:52:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB4F130
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:51:06 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660639865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YS42GgQ9CRQW3NOc9B9Xfj8VAlwmzytP15BC0/OWf78=;
        b=e535klWKAXqT50p5w0j9Fhc0iSNPeqW0FeBw5ekiDRts53V6c2VbA6aUh/zdyPfeoz23K3
        e5V3Tj9bN2Nz60qrNuqPtb51vqamvKVeCSyllgTlnmTgXE8d09WORMS3j1P18tmven6TBW
        Dhv2ghmo5gh1en89FsldsC7EE9E/z/oFszZypuFS2s1RReYlDqKnCgVR++Vu/n0JCN4xq4
        6lfLD+gD9VAGuzeRg1Z+tPlNTQE5o4r7Byy6TlaysKOFsGKz3NjaVcO0DM6sxDjtH3AdYa
        SYDMj/6WDZ9Bsz4r4S42xm7SJTWI8ARioUUJ956PpQpkUGgJVxGafiU7E+XFOg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660639865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YS42GgQ9CRQW3NOc9B9Xfj8VAlwmzytP15BC0/OWf78=;
        b=wTuns6Sdbf8knNpvSTWkw0bIi+1wssHl43PY3DJc7ycPIHImBVNfP14FT9HrsOOrEDnBpI
        FTzU63ik7bbh93Aw==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <87k079hzry.fsf@intel.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf> <87v8qti3u2.fsf@intel.com>
 <20220815222639.346wachaaq5zjwue@skbuf> <87k079hzry.fsf@intel.com>
Date:   Tue, 16 Aug 2022 10:51:03 +0200
Message-ID: <87edxgr2q0.fsf@kurt>
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

Hi Vinicius,

On Mon Aug 15 2022, Vinicius Costa Gomes wrote:
> I think your question is more "why there's that workqueue on igc?"/"why
> don't you retrieve the TX timestamp 'inline' with the interrupt?", if I
> got that right, then, I don't have a good reason, apart from the feeling
> that reading all those (5-6?) registers may take too long for a
> interrupt handler. And it's something that's being done the same for
> most (all?) Intel drivers.

We do have one optimization for igb which attempts to read the Tx
timestamp directly from the ISR. If that's not ready *only* then we
schedule the worker. I do assume igb and igc have the same logic for
retrieving the timestamps here.

The problem with workqueues is that under heavy system load, it might be
deferred and timestamps will be lost. I guess that workqueue was added
because of something like this: 1f6e8178d685 ("igb: Prevent dropped Tx
timestamps via work items and interrupts.").

>
> I have a TODO to experiment with removing the workqueue, and retrieving
> the TX timestamp in the same context as the interrupt handler, but other
> things always come up.

Let me know if you have interest in that igb patch.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmL7WncTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgt83EACmNS6huf22NsiWN5Fk1VBI8wv4+jKm
zF3edlHo+2x40hs5ApKTEFDGqmMJnXFmUia29+aFPBmJDAokcoQ3jq8a58UAsIdB
LwsqiBuA9f7zOpIZZKlQYIlvshXd1NZP+WxFkriaqQNZ8utmacFC8XZ4fnsD4s/S
pH5Uo9gEnV8E8khYvjIvBnBP+XHdONhdQbVdi5SrfSdCej77gn4A46/EzGcTfyQY
FDRbIp1ntn02G/0hMsweMURVFMcuO2BebWXWlXgxzywimw7tLHBL4QW0kHT1+Hb3
GJtD2kpjodNEAwz0fsYdcP8HCOpglB4Ft0ah3DcpU/cH2YPJkI8d61JwD3CotAqz
3i3H8Ua401RvBLEXVvkAtZuwqmLhu24TbLHs0H/BolbLltR6oOSXZPV8oM4udCyS
WB1ZJW3wzc3Py5dqlIaqpJWhgGjgnsRZQO2b23Z6J6KsDI9nufsvoBeV8bnfC1eS
xApt5V8zo5ISU19WCm8zK4JTMctfFiQHCVzcwR7X/718FiGfa5p76TfqnxYeu9wB
8lsYY/isJHnfuscaO/2xwQ572bQtQPGFtFcwBRLOG7jAGPxBHpajiyelcqQqHwyz
gQFAYKfP9XaGrYMKF0W7w4paVXFmB39IoSAPXbLsu/7J8Kw+wmThE10AoN+KWevI
FALWBBkQ/tJung==
=XPhz
-----END PGP SIGNATURE-----
--=-=-=--

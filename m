Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953A86E5983
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjDRGiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDRGiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:38:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE63138;
        Mon, 17 Apr 2023 23:38:18 -0700 (PDT)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681799896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kfz+D7TM/wHowDOMCAkr1nIxmgPwDwdseJ81VbVMqLU=;
        b=Qja9sjb3hQzLpzYJq2J0Wa+VA84Fie+HUHIAafEimKkSsDTfhfEbA7YKRlIlznBiL7a6A5
        d/0TMIyv7/xxuquJngOnG98QmXOv96gKkv/RIzNbwv5o1ucLLub1LkvX8fgioRLwEqFXWW
        KpxTnnvR06hWG101r/yrIABPF9BZGEh+nDZDjxqZ7BmJ7pDpIxnNJVj/CF4n6fUOBRI2cV
        oPQ5A+cAOkmLLa+gPrUuUPq51uXlvUiy74/S715js6GfMmGO+1hhTkEBNtVn6QGqCsKe6e
        fgyZyVUJA9FCefuEfwA6Ncriwo9Wghm3/9o99YGb5O8711TYZiOklXz1xCPkGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681799896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kfz+D7TM/wHowDOMCAkr1nIxmgPwDwdseJ81VbVMqLU=;
        b=XO/be0eJ+3EB/ipq+vqyJvwMnot+gGdBOHn8XVymJOPJnAODYiA68QW6/cQQ6xIhZExCLY
        lhsiR3kNp8ZF9cAQ==
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Brouer, Jesper" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8r?= =?utf-8?Q?gensen?= 
        <toke@redhat.com>
Cc:     "Brouer, Jesper" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.lau@kernel.org" <martin.lau@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>,
        "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH bpf-next V1 5/5] selftests/bpf: xdp_hw_metadata track
 more timestamps
In-Reply-To: <PH0PR11MB5830D771AA05F28675173A42D89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
 <168174344813.593471.4026230439937368990.stgit@firesoul>
 <87leiqsexd.fsf@kurt>
 <PH0PR11MB5830D771AA05F28675173A42D89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
Date:   Tue, 18 Apr 2023 08:38:14 +0200
Message-ID: <87pm81hezt.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Apr 18 2023, Song, Yoong Siang wrote:
> Tested-by: Song Yoong Siang <yoong.siang.song@intel.com>
>
> I tested this patchset by using I226-LM (rev 04) NIC on Tiger Lake Platform.
> I use testptp selftest tool to make sure PHC is almost same as system clock.

OK, your test result looks sane.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmQ+OtYeHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEMGT0fKqRnOC6bsQAJRVKF/pZAkeaqAc
Zrovwe3r4Hk/cQsHhBEwbl7oKLKqXEHRBDeGrIZj80NpkQoAuWfEVLlppqw4KwMH
Ac3FIejTKnrpXJTGm99SwL7pzMu+N98l4MHmPWDTbTUCtz17lDv3BHqTBlZUMEXH
HKWgB5GsFLXfkKVtSfLXDVEx2SQ90RgLXi3GKvBc5X0Iitfm459wP7Mogg69wgty
R17bYgsJtWo2qCjnHGawo5QVhFjHV5Rc6l87Im2fJedStx9Ge+UXD+xqzAc8i1Jk
iEwFQfLIziyXlBViF5GrxOhG6PfQLdt+8v/ABoO+CXpmvOFZ+1Qyu8alAmkmR5ld
wG/V6rZiCMbOViE69nSK6dpxOE0PXa8b7Wc0HRM+dmjbDPK2M+xnQgoJBmPcONeO
drIOvkDg/LMQGXQhfvr7jL/RefOQFImpTwDc/0XFIUMzFcTIbi7y8j/ZBTLMncWP
Lv/wJMxxnfqXBN2kjvE/AGSB6MfZ5rRNEwpiT/fv/QEJ98QnrZOGthHhCtDamwEL
YXFd/jAbmctteSQNTaa9UnRyRR/eP+JNUJNiDUybs4rsNfI+DSch2c3yRFE105lO
krcz2Bn4cDoDNOAt/qBgJYYZXUeT2keCtRRAhR3abjdpGqdTsc+WFUHQB1lyeXXj
St1S+5DrUeqMgTowGML8JYqRtqE7
=Vlmm
-----END PGP SIGNATURE-----
--=-=-=--

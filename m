Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F93260996
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgIHEbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:31:25 -0400
Received: from sonic311-10.consmr.mail.ne1.yahoo.com ([66.163.188.240]:34929
        "EHLO sonic311-10.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgIHEbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:31:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599539483; bh=aQBm+9Bca4ejs9ftzYnk89bfX4ekoPZ6NeQWeQKD++E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=QinnxJB4BywnQIIxfw8iovOshpEJppl9gVRAfWQW1r2ENHoYU4cdBCzsluWTYsc4jAqfCOR3zPy0qYGuunUGBKP0JVRO7fSHL8F7TYUo19LyqF19LCqsRNAA8zON0xhg0UNsBq+7EliZwLRNVcYDAV6CR/Xo+ErlRV3CJoZMKnpHAhs8eWYsNflUKd71TYDD3xFAJKA6CNY7sQ53qoH2hq7fDTtVREdv2SMpHizJX6kdkYbXwBp1L6CrtPT1ve3GHTG35iW3XHhRnd7jMGy9pbF73EVTl1gJbUHyawPi3DUx1f+2N4TBwt0ka3r4enzTxXvbosiuyZbWtgV389o6Uw==
X-YMail-OSG: UR3fK6cVM1moNqU5MIaQW.u0CAzKEqMe2O4rUd_vEIf_l93U4dxRLmzMZTLSzGI
 lqyDQpYzpLr6oEW97avX8YXhjqRtQtL6P1ZP4o9P7okS6K6vtc6..F4JJwUiwRyiXmBy_lnVun1g
 gJh11Qf9m8aXES5YtfhNtKGK3VD48D8H2ESo3AFZ0XOd73bhm1_0euemVIXDfTV43An2YzAgYmEb
 fKWvM63590tJiDM3uc1t48nJ_y0HfOmFx5yxzVMYhZRFYj3sIE1hhISrtUTOYryaT1D5M5Bz.OBB
 Irj8UtvY2.L.5ry0ADcJpJ0bqsgSWvkxwe_oFbTUDphglESgW9uNuXrJogWzB2svzUX42IUxolG2
 AdwEXrn6MvB31XNjOa5rLNDGDL9jT0drnhF9H0UNy6dPgT4aavveJJnlN8indojbaH7ImLxWwmd5
 uZcuhQGn4bnkU7OQ0MEIJk7lRRkTfiAwZ0s7iTYToxD1K8yZoEUhmMa0zYB4kVjjxjvWPA2YqKcY
 5T7OSTPpj6kVX1rW3yYbLb78cCsMXWIC_8n67apwyeHusAVWYV2Ud5.EsdOomfpsErwzLdgEOKE6
 LtlvXuvakMGomZfLs.zUASbwUkjzox_s4aXBb_yznEr7RtbOT5n6xFugrMqXj6UaNaf7ym5rxMHf
 zmU4NwZUdclMCEFEuQf1N8bEcMEyPRh0pUnj_KtyMS1A4DDN5eS.j_CGH8bEbCxtugAPv5VgHwAw
 .qYGN8aBBH2h0b.tCcXJn8dAZ4Slq97AA_r_nkfJu._rkrvKSbbMBxko_41iCaZBpn6bdKbyBxo9
 ZA_hW98q2_i9E4ktPfOABKu6b8HdJV.zVpPIhzfWTUY4MLx9CUzQCezsenQ7Z_U2IJsJRkjsyFFz
 qEo7nNFUH4DsYdPSsBEdwsz0GOAU.e_rKbqZ1WSXcA7wgEK4NLPObMs7hgYYWownZQCZhc2ezFY7
 dMQ4mBVB80HXhAggStkGtwj2eNabIgGFC3bbbW8i8lNPvsbj0n6F1i4FhzGIWZktCA_3hR4vwNvh
 .KD2ajETLvah1ikFt3r.6OquY0WjV8Qd9Bb8qG4X3yrhEgKviPMb3K6f_kCjDsTl79mRbGgSj93E
 dutP3TJ7cqPczy2HOU.u3DhRzFOnfaneZ.dMyG4o0TRGOiXQS5KHNpU0d_dVf3TT1nAj5S4rWiVg
 hcZ2HnTbEsHrOn31GQlwzF8prLhsriyfINWVVTQsJQILISPEe50o0_afVWsC6eyEdEW0VkeKxnRZ
 WybZLJxLJSUbFA3nZ8GaaeY9BjtXQVhitBKTpg7BLIKwtGvTCy14zG2S0KIoG0GV.w4Tf_Yv4LYA
 PszhBNDskuFdEg2_82yjmdg4fpdHJEJxewonqKgZclsIaxQ0PpQ1pTJuufJJ_RsTaKs15DeGAcmI
 og8WBx.8jlTdfW2RNV3PCJGAY5oiJOK8YHZum3qZOhT7gQ5y7Qp3cz_yZC1oJ9dgNbNsViT4vs12
 HvfA9eQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Tue, 8 Sep 2020 04:31:23 +0000
Date:   Tue, 8 Sep 2020 04:29:23 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau15@blikxy.online>
Reply-To: maurhinck5@gmail.com
Message-ID: <1642723452.4216975.1599539363042@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1642723452.4216975.1599539363042.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck5@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.

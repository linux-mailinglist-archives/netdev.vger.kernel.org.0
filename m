Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF6450FFD9
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351338AbiDZOCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351318AbiDZOCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:02:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A1E18EA02;
        Tue, 26 Apr 2022 06:59:00 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650981538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2iZVgTNBSgaeoRbSzUYC9JbtTRd+xjYUfhrrkl8rhw=;
        b=O/ZgmagFIttM/Oj0vNa1VQ1CCLIjqaWKHzuEny15FQuDDOgW4b70p7rZhsXEgtnUckXWjj
        1KpDVu0jLM9629gMOkygcFVSUx7kHR8N7E6hDovfHzOEoM3s2Odvw3IWqzWqGfZwwQrkvY
        8DjK/TgMO+BU0xTgVOvackORvTWWqMI3EnR0noqUk/5QVe5e1F9iDrpaeHdqSm1vOxhJJS
        r7jFdfosahjEQ6yxFlUCDo9VhRAWQjFGCU9SGHu/GblBeGktcw8zVO5XqsIPPAv7NQAg0Y
        7iYVCAwXWTREshV82/JcKcVdu2VXlirSA6ZZz6cBq/Fv3mvxY2tj5WT5z6AyuQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650981538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2iZVgTNBSgaeoRbSzUYC9JbtTRd+xjYUfhrrkl8rhw=;
        b=CsPZZMnCYu/3XbqW8wNsn2dnOrwdU7n6otYY7wFkbPKv68VZIvA/28JBS+SbXOUVBmzHtU
        CJvZ18kAtTHeS6Ag==
To:     Tan Tee Min <tee.min.tan@linux.intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Ong@vger.kernel.org, Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: disable Split Header (SPH) for
 Intel platforms
In-Reply-To: <20220426074531.4115683-1-tee.min.tan@linux.intel.com>
References: <20220426074531.4115683-1-tee.min.tan@linux.intel.com>
Date:   Tue, 26 Apr 2022 15:58:56 +0200
Message-ID: <8735i0ndy7.fsf@kurt>
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

Hi,

On Tue Apr 26 2022, Tan Tee Min wrote:
> Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
> of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
> This SPH limitation will cause ping failure when the packets size exceed
> the MTU size. For example, the issue happens once the basic ping packet
> size is larger than the configured MTU size and the data is lost inside
> the fragmented packet, replaced by zeros/corrupted values, and leads to
> ping fail.
>
> So, disable the Split Header for Intel platforms.

Does this issue only apply on Intel platforms?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmJn+qATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgmn6D/9qeUHNLrQQtVKYURUbC/oNztnlmc3Z
hwrp1SHvXu96xuyNmylbZEo2zADbG258zdU8ZD3NEBdHFRA4aL6f2B239dSyry1n
xDi1COlTs/ve7G08MZalCchNpyrgPw3JR2PP4bSWIeqbP4C13C7dZEtsPjJs8tGH
DxelFGu0xyfDxYpkS93ebV+cMvmwyhHDHHX3mbjP6Yj7V+g8XCS7ds22k1VLP5F0
CURBIhbl+f0XqFDc51M6wnUbmfD9nSGSuximRG1Exog1E/wrfadUOObHFFaQLBWr
EcJdw0NEi/XnyK0G4xiP8hr1lfQmclpHD8aEMW9EprErePDqJQL596GkI3R4Ku5G
IqkAieR62prU/Yopidw5M8EtH7FusL0zPsDXWp8jylqDUruN4ltbD1X6Cr4l9dKp
xtXDFL73nj8/AYFKrTlrYc8isMnTxumkR6yu+N9jTgWLkAY17IJ0Bm80xKafqjAe
xivpxueX2+/ZjnP4kYR1FzVC7CQTx81h1Cxjj9YFGWDTLlQ29vVvtV7a09zyGUOc
qBlAYfPUHa0AQIEeDCQAJVvif005cnP87maoYPkU45oeL3GBS7Uykd/0Hfr/wpFw
dZbLJnewfK848KvNsajR7omzWE8T34ApYJRIYIuJtfDuBBZhB/y/CgNgp1wi3LdL
D7+1mOI7VgmBoQ==
=YG8s
-----END PGP SIGNATURE-----
--=-=-=--

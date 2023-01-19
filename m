Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB1674241
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjASTIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjASTHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:07:02 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F98658F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:06:08 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JJ3T2e2326441
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 19:03:31 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JJ3Lv73901116
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 20:03:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674155003; bh=Wfm6bDhjBOCJiVSYWMYcyD42C/fm4t0Apau7rsOpOUM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=VB4FLeN2gYJVHDzMQDpUfcaTX1q70HfiQ07172+N/yFbFAXzbHeppqJUZj8JulOSN
         eb+MFLZOY4Kc/bh40HK5ZsMPIUpV0ZH4yhmImdqzQ5HpXzAAVmeat2S01ZNlnfdmkp
         Jh/lHF0Z6BbaU0ffpYe/FbbFnGyvlOw4iyG0L4ts=
Received: (nullmailer pid 501690 invoked by uid 1000);
        Thu, 19 Jan 2023 19:03:20 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is
 powered down on configuration
Organization: m
References: <20230119171248.3882021-1-bjorn@mork.no>
        <20230119171248.3882021-2-bjorn@mork.no>
        <Y8l7Oz9gpslb3IwH@shell.armlinux.org.uk>
Date:   Thu, 19 Jan 2023 20:03:20 +0100
In-Reply-To: <Y8l7Oz9gpslb3IwH@shell.armlinux.org.uk> (Russell King's message
        of "Thu, 19 Jan 2023 17:17:47 +0000")
Message-ID: <87zgaeuz2f.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> Doing this unconditionally means that the link will drop - even when
> we aren't doing any reconfiguration (except changing the advertisement).
> That's why I made it conditional in the version of the patch I sent
> (which failed due to the unknown bits 3 and 0.)

Right.  Sorry for missing that crucial point.  Will fix.


Bj=C3=B8rn

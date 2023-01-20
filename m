Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F305C6754F8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjATMtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjATMtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:49:06 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051097AF2F
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:48:55 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30KCmFWm2379412
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 12:48:17 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30KCm92P4064118
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 13:48:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674218890; bh=uxEIoYUDUtV0y+NYQ4FqDADcXTUki0rcUmnQd3BbzWM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=k2uwH9VYCY2uxEgmDY/nT3XFZtJ/c77961E1eiJ7Iq4sfWtKJhTsj8TzF6Uk0pqo6
         7gnY0XeR0n8aTdqgstGIWjMuPeNRelesK19rYD6HQfv4pCKAeeq6r2aiCCGWPw+UTk
         mIViVyMBEzlGgryisoKt0oMDMwM/C72MBrTCKhG0=
Received: (nullmailer pid 538239 invoked by uid 1000);
        Fri, 20 Jan 2023 12:48:09 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH v2 net 3/3] mtk_sgmii: enable PCS polling to allow SFP work
Organization: m
References: <20230120104947.4048820-1-bjorn@mork.no>
        <20230120104947.4048820-4-bjorn@mork.no>
        <Y8qJJ7XWd9tAO+op@shell.armlinux.org.uk>
Date:   Fri, 20 Jan 2023 13:48:09 +0100
In-Reply-To: <Y8qJJ7XWd9tAO+op@shell.armlinux.org.uk> (Russell King's message
        of "Fri, 20 Jan 2023 12:29:27 +0000")
Message-ID: <87tu0ltlrq.fsf@miraculix.mork.no>
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
> On Fri, Jan 20, 2023 at 11:49:47AM +0100, Bj=C3=B8rn Mork wrote:
>> From: Alexander Couzens <lynxis@fe80.eu>
>>=20
>> Currently there is no IRQ handling (even the SGMII supports it).
>> Enable polling to support SFP ports.
>>=20
>> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
>> Signed-off-bu: Bj=C3=B8rn Mork <bjorn@mork.no>
>
> Typo in this attributation.

Impressive!  Thanks.

I tend to forget the -s when doing anything but "git commit" (and this
came from "git am").  And then I try to fix it manually.  Forgetting
that I'm unable to type a three-letter word with less than four errors.

A bit surprised checkpatch didn't catch it.  I guess it's happy with one
SoB, and silently accepting all unknown tags.

>> ---
>>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 1 +
>>  1 file changed, 1 insertion(+)
>>=20
>> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/eth=
ernet/mediatek/mtk_sgmii.c
>> index c4261069b521..24ea541bf7d7 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
>> @@ -187,6 +187,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct devi=
ce_node *r, u32 ana_rgc3)
>>  			return PTR_ERR(ss->pcs[i].regmap);
>>=20=20
>>  		ss->pcs[i].pcs.ops =3D &mtk_pcs_ops;
>> +		ss->pcs[i].pcs.poll =3D 1;
>
> As "poll" is a bool, we prefer true/false rather than 1/0. Using
> 1/0 will probably cause someone to submit a patch changing this, so
> it's probably best to fix this up at submission time.

Yes. Will fix.


Bj=C3=B8rn

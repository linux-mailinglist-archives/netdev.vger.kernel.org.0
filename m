Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C9758D4B8
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbiHIHhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 03:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbiHIHhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 03:37:03 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD1B20F60
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 00:37:00 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 1CE6E7F46C;
        Tue,  9 Aug 2022 09:36:56 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0703434064;
        Tue,  9 Aug 2022 09:36:56 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3EDB3405A;
        Tue,  9 Aug 2022 09:36:55 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Tue,  9 Aug 2022 09:36:55 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id B275E7F46C;
        Tue,  9 Aug 2022 09:36:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660030615; bh=7yJ6IVYVLaNCDNqrW/hsBvDqBYC7JP/mDUiChoOwEnw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=zPGFt0P2Z631uopVIw5+Oe9HUOuqbR1ZztXzqgBn/HB0k3aXRVOJKUku49Pf+aU3c
         WsWnDKoWBqUuHSaMq2rTpWmJYQzipJz4EjymJGMHds2gNEIxqQC7NLFqR5EBGdldGo
         7lIPVKs9UiVNP1FhZGtrdiCzckeHye4ehkSZO/jIA9qniTMg5xrULVon0b6t3nQyQM
         NoVNQ2f2rzoGqxASEu114g+go06QR4iqsqqE/dTFR9oDw1NQ/kRRhyl0KYoo2+wAkT
         tnM6/Cd4xBZhAij/oJw7odYRJdGsReOK21BN9Axgz9VZEkffAHIotXGVBZtOT8zkcW
         G+W+UTTeUWNcw==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.9; Tue, 9 Aug 2022 09:36:55 +0200
Received: from atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7]) by
 atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7%11]) with mapi id
 15.01.2507.009; Tue, 9 Aug 2022 09:36:55 +0200
From:   =?iso-8859-2?Q?Cs=F3k=E1s_Bence?= <Csokas.Bence@prolan.hu>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] fec: Allow changing the PPS channel
Thread-Topic: [PATCH] fec: Allow changing the PPS channel
Thread-Index: AQHYqykV8NCDZGrvf0GRT4CMfxBJF62k6dsAgAFD/SM=
Date:   Tue, 9 Aug 2022 07:36:55 +0000
Message-ID: <da7f75cc331744fd8890ffd0f580f220@prolan.hu>
References: <20220808131556.163207-1-csokas.bence@prolan.hu>,<YvEZvCmS9lSoyhDQ@hoboy.vegasvil.org>
In-Reply-To: <YvEZvCmS9lSoyhDQ@hoboy.vegasvil.org>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.7.28]
x-esetresult: clean, is OK
x-esetid: 37303A29A91EF456617664
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

>On Mon, Aug 08, 2022 at 03:15:57PM +0200, Cs=F3k=E1s Bence wrote:
>> +static ssize_t pps_ch_store(struct kobject *kobj, struct kobj_attribute=
 *attr, const char *buf, size_t count)
>> +{
>> +=A0=A0=A0=A0 struct device *dev =3D container_of(kobj, struct device, k=
obj);
>> +=A0=A0=A0=A0 struct net_device *ndev =3D to_net_dev(dev);
>> +=A0=A0=A0=A0 struct fec_enet_private *fep =3D netdev_priv(ndev);
>> +=A0=A0=A0=A0 int enable =3D fep->pps_enable;
>> +=A0=A0=A0=A0 struct ptp_clock_request ptp_rq =3D { .type =3D PTP_CLK_RE=
Q_PPS };
>> +
>> +=A0=A0=A0=A0 if (enable)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fep->ptp_caps.enable(&fep->ptp_cap=
s, &ptp_rq, 0);
>> +
>> +=A0=A0=A0=A0 kstrtoint(buf, 0, &fep->pps_channel);
>> +
>> +=A0=A0=A0=A0 if (enable)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fep->ptp_caps.enable(&fep->ptp_cap=
s, &ptp_rq, 1);
>
> NAK.
>
> Don't use a private, custom sysfs knob.=A0 The core PTP layer provides
> an API for that already.

Does it? I seem to have missed it. Can you point me at some docs?
Also, does it have support for setting pulse mode (i.e. high, low, toggle)?

> Thanks,
> Richard

Thanks,
Bence

>
>> +
>> +=A0=A0=A0=A0 return count;
>> +}=

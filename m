Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC95E3CC1C2
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 10:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhGQIMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 04:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbhGQIMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 04:12:53 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F64C06175F;
        Sat, 17 Jul 2021 01:09:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id go30so18909638ejc.8;
        Sat, 17 Jul 2021 01:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=in-reply-to:references:thread-topic:user-agent:mime-version
         :content-transfer-encoding:subject:from:date:to:cc:message-id;
        bh=0PC1GdkYY+PBBRzD0FwMonDpEhuRkLmD9anK7ZjygqU=;
        b=gMBzf9tXlsjrEBxfrcD9XGMe3rpOz+RdQbsCd7Vl+yQc1oiG1DA88QG67VZa8MebWH
         /BBnoZDbofYQi5+5gyJWL06FIo+LbaTPNFL13kDbsMhgQhq3LNJaMDaRyDpjECBHN2jx
         WSOdfXacfbKl3T2/actz+uBstLtYl7Zufj0iVtCgaiRNJg8wNnA90ngx8ACX0yisoLAc
         TaIvKhK0iROT+noiDiMOczjTof0n94hloeV6Vrx7DqziuGpSJa8gP+Ovzs1JtH4arxg1
         cfBacZL2JR2uCOPngFVip9sZe1ahDtlJ5hYjfbCGXPBL3/Gj2ariCTPKKI/eKatXxGbY
         6AsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:in-reply-to:references:thread-topic:user-agent
         :mime-version:content-transfer-encoding:subject:from:date:to:cc
         :message-id;
        bh=0PC1GdkYY+PBBRzD0FwMonDpEhuRkLmD9anK7ZjygqU=;
        b=JwApjrRU1Bju2AZaBmdMzisihWyYpwGr4jAhr8ZXP0Xj0Ysc1gikRAhb+cO5odMCfI
         smEKIyRw1O82LhJsxqrMBDfFos5T96Vp5l6KAIBL+DzTqN+U0j02+NY3NKP55qwvQOFk
         hL/2eQGJ+/BFwMO9uYmaZ3UWIzvRautARuydmPDcOl9n/WxTo/1XdUHHm3XPNqYSnwaA
         Dgq1fXQvgGSDBi5f+RTcrHe0KM9ayoDkqNw7/NAU4LvdQQGJgjKVWlgKlA90YK/eP97B
         DWuJrOK3iM/Co/UycarnbN6sJ7OhGXz3VkJXlUU886lK8VY6SeQFlcz0TeTqg3YbN8KH
         BSeQ==
X-Gm-Message-State: AOAM533sD76jNFrFAHDQWFAmc4I0lJI6VoZWg3Y24XXAYMB1okbw4V1R
        jCMjYUofXN4OH65xQmmbGio=
X-Google-Smtp-Source: ABdhPJyQ5DJmgnZam4idrp0qUQ23XWMuygNlkWlalSG8Ws590Mlu86hZM5HcMzfwcjR5G7mwWhonKA==
X-Received: by 2002:a17:906:4f1a:: with SMTP id t26mr16578489eju.84.1626509395094;
        Sat, 17 Jul 2021 01:09:55 -0700 (PDT)
Received: from [192.168.1.158] (83-87-52-217.cable.dynamic.v4.ziggo.nl. [83.87.52.217])
        by smtp.gmail.com with ESMTPSA id m15sm4678223edp.73.2021.07.17.01.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 01:09:54 -0700 (PDT)
In-Reply-To: <20210716210655.i5hxcwau5tdq4zhb@skbuf>
References: <20210716153641.4678-1-ericwouds@gmail.com> <20210716210655.i5hxcwau5tdq4zhb@skbuf>
X-Referenced-Uid: 5673
Thread-Topic: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
User-Agent: Android
X-Is-Generated-Message-Id: true
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Local-Message-Id: <eda300a2-4e36-4d0c-8ea8-eae5e6d62bea@gmail.com>
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
From:   Eric Woudstra <ericwouds@gmail.com>
Date:   Sat, 17 Jul 2021 10:09:53 +0200
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Message-ID: <eda300a2-4e36-4d0c-8ea8-eae5e6d62bea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You are right now there is a problem with vlan unaware bridge=2E

We need =
to change the line to:

if (vid > 1) reg[1] |=3D ATA2_IVL;

I have just tes=
ted this with a vlan unaware bridge and also with vlan bridge option disabl=
ed in the kernel=2E Only after applying the if statement it works for vlan =
unaware bridges/kernel=2E

On Jul 16, 2021, 11:06 PM, at 11:06 PM, Vladimir=
 Oltean <olteanv@gmail=2Ecom> wrote:
>On Fri, Jul 16, 2021 at 05:36:39PM +0=
200, ericwouds@gmail=2Ecom wrote:
>> From: Eric Woudstra <ericwouds@gmail=
=2Ecom>
>>
>> According to reference guides mt7530 (mt7620) and mt7531:
>>
=
>> NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to
>> read/=
write the address table=2E When IVL is set, MAC[47:0] and
>CVID[11:0]
>> wi=
ll be used to read/write the address table=2E
>>
>> Since the function only=
 fills in CVID and no FID, we need to set the
>> IVL bit=2E The existing co=
de does not set it=2E
>>
>> This is a fix for the issue I dropped here earl=
ier:
>>
>>
>http://lists=2Einfradead=2Eorg/pipermail/linux-mediatek/2021-Ju=
ne/025697=2Ehtml
>>
>> With this patch, it is now possible to delete the 's=
elf' fdb entry
>> manually=2E However, wifi roaming still has the same issu=
e, the entry
>> does not get deleted automatically=2E Wifi roaming also nee=
ds a fix
>> somewhere else to function correctly in combination with vlan=
=2E
>>
>> Signed-off-by: Eric Woudstra <ericwouds@gmail=2Ecom>
>> ---
>>  d=
rivers/net/dsa/mt7530=2Ec | 1 +
>>  drivers/net/dsa/mt7530=2Eh | 1 +
>>  2 =
files changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/dsa/mt7530=2E=
c b/drivers/net/dsa/mt7530=2Ec
>> index 93136f7e6=2E=2E9e4df35f9 100644
>> =
--- a/drivers/net/dsa/mt7530=2Ec
>> +++ b/drivers/net/dsa/mt7530=2Ec
>> @@ =
-366,6 +366,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16
>vid,
>>  	=
int i;
>>
>>  	reg[1] |=3D vid & CVID_MASK;
>> +	reg[1] |=3D ATA2_IVL;
>>  =
	reg[2] |=3D (aging & AGE_TIMER_MASK) << AGE_TIMER;
>>  	reg[2] |=3D (port_=
mask & PORT_MAP_MASK) << PORT_MAP;
>>  	/* STATIC_ENT indicate that entry i=
s static wouldn't
>> diff --git a/drivers/net/dsa/mt7530=2Eh b/drivers/net/=
dsa/mt7530=2Eh
>> index 334d610a5=2E=2Eb19b389ff 100644
>> --- a/drivers/ne=
t/dsa/mt7530=2Eh
>> +++ b/drivers/net/dsa/mt7530=2Eh
>> @@ -79,6 +79,7 @@ e=
num mt753x_bpdu_port_fw {
>>  #define  STATIC_EMP			0
>>  #define  STATIC_E=
NT			3
>>  #define MT7530_ATA2			0x78
>> +#define  ATA2_IVL			BIT(15)
>>
>>=
  /* Register for address table write data */
>>  #define MT7530_ATWD			0x7=
c
>> --
>> 2=2E25=2E1
>>
>
>Can VLAN-unaware FDB entries still be manipulat=
ed successfully after
>this patch, since it changes 'fid 0' to be interpret=
ed as 'vid 0'?
>
>What is your problem with roaming exactly? Have you tried=
 to disable
>hardware address learning on the CPU port and set
>ds->assiste=
d_learning_on_cpu_port =3D true for mt7530?
>
>Please note that since kerne=
l v5=2E14, raw 'self' entries can no longer
>be
>managed directly using 'br=
idge fdb', you need to use 'master static'
>and
>go through the bridge:
>ht=
tps://www=2Ekernel=2Eorg/doc/html/latest/networking/dsa/configuration=2Ehtm=
l#forwarding-database-fdb-management
>You will need to update your 'bridgef=
dbd' program, if it proves to be
>at
>all necessary to achieve what you wan=
t=2E


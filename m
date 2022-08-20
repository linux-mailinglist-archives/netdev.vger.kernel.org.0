Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3687459AE59
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346558AbiHTNEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 09:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347582AbiHTNEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 09:04:07 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B4696FEE;
        Sat, 20 Aug 2022 06:02:04 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id s11so5075610qtx.6;
        Sat, 20 Aug 2022 06:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=U3FkfNBRlbG7WiI0nCbkRkLkJmeq6xcxmavYn3SgZSg=;
        b=n7Bky+sui0sBMKGkPpZWsaIh5ZWxwkC60/33jYL8+pBjouShQGmS7Ub23Un8JJ+zr0
         Z0t+/4wzEd/H1cRcSZL9QFvuvEiJKpUusAa4rb31+eX0oEfFvXygQU8mb9/IG5akNnah
         bwn9CqsX+PykQz0dnvkobcqyqQfk77elfP9/g9lEE+an+VCh8mWyE0xkOlmHUvAOtjfX
         QV6SlS7F9UmxzSCaTPbl0MzVrFPK/AVsxRGPlEARpWRMWPO66Jf+canB+WibfFDHeVM4
         09mqhj2FWHfeT8hvQER2m0LcOcHqT6NQydO9Ru3dMepetz3ZB13G5c4xLjqHD9JwGMeU
         dSTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=U3FkfNBRlbG7WiI0nCbkRkLkJmeq6xcxmavYn3SgZSg=;
        b=NkVZJDR98UImgtO2JTAp9h9iclCM8LjeypdMjhDFTXdxDECO8XQRy6pDReiFT5A1ez
         XP4rFfHXNylRK7Z4xe6JBuN35C1zHdiOJDIma2ilkal3Yr0Rne/K2o89p5cVp4yebT4e
         XGbGLdRmj8Wsw43hB+IrS/bSB2kBhGn4b1sVHIEHglYgdA6g8HzI2M0wTbUUkaYC3K/C
         /EKvx0bAj4IgL8YtIPTTp3fS0PBIprbKDNFkt5r/sMLrSvLgpgHdi+rWJzfXm7XjNrLw
         zN25l9Q9oPTmRDJh7X45mDLeTV8ke4cGbyE+uMRKMDiUWbGqf59FcuIklwi5P7HDeDnl
         YwkA==
X-Gm-Message-State: ACgBeo1RCqQn8xBsGreRntyEedl7n0pZGJW5oAGy6+FSV1Z7ZKYt1CXk
        S2Colz/D/4P5FpuEjBEKuy8Y/Do5n0Y=
X-Google-Smtp-Source: AA6agR5uitQKT0YMuHYpHwb5gsKUNsVxNdClZ3dLEfvLyzw8zs1ydPPDA6RGdSAMrqqRx1TOaUPO/g==
X-Received: by 2002:a05:622a:86:b0:342:f620:dc7a with SMTP id o6-20020a05622a008600b00342f620dc7amr9914928qtw.594.1661000522304;
        Sat, 20 Aug 2022 06:02:02 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id hg17-20020a05622a611100b0034359fc348fsm4857700qtb.73.2022.08.20.06.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Aug 2022 06:02:01 -0700 (PDT)
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
 <20220809214207.bd4o7yzloi4npzf7@pali>
 <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
 <20220809224535.ymzzt6a4v756liwj@pali> <20220820091618.vdrisqa6twvl23vj@pali>
From:   Sean Anderson <seanga2@gmail.com>
Message-ID: <dc72ac66-e5a8-524f-6881-f8ecf984361a@gmail.com>
Date:   Sat, 20 Aug 2022 09:02:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20220820091618.vdrisqa6twvl23vj@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/22 5:16 AM, Pali Roh=C3=A1r wrote:
> On Wednesday 10 August 2022 00:45:35 Pali Roh=C3=A1r wrote:
>> On Tuesday 09 August 2022 18:41:25 Sean Anderson wrote:
>>> On 8/9/22 5:42 PM, Pali Roh=C3=A1r wrote:
>>>> On Tuesday 09 August 2022 17:36:52 Sean Anderson wrote:
>>>>> On 8/9/22 5:31 PM, Pali Roh=C3=A1r wrote:
>>>>>> On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
>>>>>>> On 8/8/22 5:45 PM, Michal Such=C3=A1nek wrote:
>>>>>>>> On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrot=
e:
>>>>>>>>> On Mon, 8 Aug 2022 23:09:45 +0200
>>>>>>>>> Michal Such=C3=A1nek <msuchanek@suse.de> wrote:
>>>>>>>>>
>>>>>>>>>> On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:=

>>>>>>>>>>> Hi Tim,
>>>>>>>>>>>
>>>>>>>>>>> On 8/8/22 3:18 PM, Tim Harvey wrote:
>>>>>>>>>>>> Greetings,
>>>>>>>>>>>>
>>>>>>>>>>>> I'm trying to understand if there is any implication of 'eth=
ernet<n>'
>>>>>>>>>>>> aliases in Linux such as:
>>>>>>>>>>>>          aliases {
>>>>>>>>>>>>                  ethernet0 =3D &eqos;
>>>>>>>>>>>>                  ethernet1 =3D &fec;
>>>>>>>>>>>>                  ethernet2 =3D &lan1;
>>>>>>>>>>>>                  ethernet3 =3D &lan2;
>>>>>>>>>>>>                  ethernet4 =3D &lan3;
>>>>>>>>>>>>                  ethernet5 =3D &lan4;
>>>>>>>>>>>>                  ethernet6 =3D &lan5;
>>>>>>>>>>>>          };
>>>>>>>>>>>>
>>>>>>>>>>>> I know U-Boot boards that use device-tree will use these ali=
ases to
>>>>>>>>>>>> name the devices in U-Boot such that the device with alias '=
ethernet0'
>>>>>>>>>>>> becomes eth0 and alias 'ethernet1' becomes eth1 but for Linu=
x it
>>>>>>>>>>>> appears that the naming of network devices that are embedded=
 (ie SoC)
>>>>>>>>>>>> vs enumerated (ie pci/usb) are always based on device regist=
ration
>>>>>>>>>>>> order which for static drivers depends on Makefile linking o=
rder and
>>>>>>>>>>>> has nothing to do with device-tree.
>>>>>>>>>>>>
>>>>>>>>>>>> Is there currently any way to control network device naming =
in Linux
>>>>>>>>>>>> other than udev?
>>>>>>>>>>>
>>>>>>>>>>> You can also use systemd-networkd et al. (but that is the sam=
e kind of mechanism)
>>>>>>>>>>>   =20
>>>>>>>>>>>> Does Linux use the ethernet<n> aliases for anything at all?
>>>>>>>>>>>
>>>>>>>>>>> No :l
>>>>>>>>>>
>>>>>>>>>> Maybe it's a great opportunity for porting biosdevname to DT b=
ased
>>>>>>>>>> platforms ;-)
>>>>>>>>>
>>>>>>>>> Sorry, biosdevname was wrong way to do things.
>>>>>>>>> Did you look at the internals, it was dumpster diving as root i=
nto BIOS.
>>>>>>>>
>>>>>>>> When it's BIOS what defines the names then you have to read them=
 from
>>>>>>>> the BIOS. Recently it was updated to use some sysfs file or what=
ver.
>>>>>>>> It's not like you would use any of that code with DT, anyway.
>>>>>>>>
>>>>>>>>> Systemd-networkd does things in much more supportable manner us=
ing existing
>>>>>>>>> sysfs API's.
>>>>>>>>
>>>>>>>> Which is a dumpster of systemd code, no thanks.
>>>>>>>>
>>>>>>>> I want my device naming independent of the init system, especial=
ly if
>>>>>>>> it's systemd.
>>>>>>>
>>>>>>> Well, there's always nameif...
>>>>>>>
>>>>>>> That said, I have made [1] for people using systemd-networkd.
>>>>>>>
>>>>>>> --Sean
>>>>>>>
>>>>>>> [1] https://github.com/systemd/systemd/pull/24265
>>>>>>
>>>>>> Hello!
>>>>>>
>>>>>> In some cases "label" DT property can be used also as interface na=
me.
>>>>>> For example this property is already used by DSA kernel driver.
>>>>>>
>>>>>> I created very simple script which renames all interfaces in syste=
m to
>>>>>> their "label" DT property (if there is any defined).
>>>>>>
>>>>>> #!/bin/sh
>>>>>> for iface in `ls /sys/class/net/`; do
>>>>>> 	for of_node in of_node device/of_node; do
>>>>>> 		if test -e /sys/class/net/$iface/$of_node/; then
>>>>>> 			label=3D`cat /sys/class/net/$iface/$of_node/label 2>/dev/null`
>>>>>> 			if test -n "$label" && test "$label" !=3D "$iface"; then
>>>>>> 				echo "Renaming net interface $iface to $label..."
>>>>>> 				up=3D$((`cat /sys/class/net/$iface/flags 2>/dev/null || echo 1=
` & 0x1))
>>>>>> 				if test "$up" !=3D "0"; then
>>>>>> 					ip link set dev $iface down
>>>>>> 				fi
>>>>>> 				ip link set dev $iface name "$label" && iface=3D$label
>>>>>> 				if test "$up" !=3D "0"; then
>>>>>> 					ip link set dev $iface up
>>>>>> 				fi
>>>>>> 			fi
>>>>>> 			break
>>>>>> 		fi
>>>>>> 	done
>>>>>> done
>>>>>>
>>>>>> Maybe it would be better first to use "label" and then use etherne=
t alias?
>>>>>>
>>>>>
>>>>> It looks like there is already precedent for using ID_NET_LABEL_ONB=
OARD for
>>>>> this purpose (on SMBios boards). It should be a fairly simple exten=
sion to
>>>>> add that as well. However, I didn't find any uses of this in Linux =
or U-Boot
>>>>> (although I did find plenty of ethernet LEDs). Do you have an examp=
le you
>>>>> could point me to?
>>>>>
>>>>> --Sean
>>>>
>>>> In linux:
>>>> $ git grep '"label"' net/dsa/dsa2.c
>>>> net/dsa/dsa2.c: const char *name =3D of_get_property(dn, "label", NU=
LL);
>>>>
>>>
>>> Hm, if Linux is using the label, then do we need to rename things in =
userspace?
>>
>> It uses it _only_ for DSA drivers. For all other drivers (e.g. USB or
>> PCIe based network adapters) it does not use label.
>=20
> Hello Sean! I would like to ask, are you going to use/implement "label"=

> support (so it would work also for non-DSA drivers) in userspace, in
> similar way how you did aliases? https://github.com/systemd/systemd/pul=
l/24265
>=20

Hi Pali,

No, I have no plans to do that.

--Sean


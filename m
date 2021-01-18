Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9831B2FA508
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390787AbhARPoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:44:14 -0500
Received: from mail-eopbgr70102.outbound.protection.outlook.com ([40.107.7.102]:45221
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393532AbhARPlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:41:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yv2lkog4Yes2dX58ev/F6vLwkVCZCfqlNuJl7T7AvxaAFcj2q3u0UIi4Y74sKmON0q8BiNE96TykRK/ETagjGaZugip76vytnC02TYzwzoySCTccu6UQv+78js/RN1ja2A+/S+ODjgthdfE0KLpllVm+oV3yqymCgWjCe9p1Eb7Z18Y+XtVuhKWcnLE757/0l3K+7ZhwqTblIInMXihNvwtJ8RmUvFaVEzk/KZey+GUV1AN+4zcm7a5ZZiXxfvMjQ1UxqJi3hf/Q7KNtTwzXiGJcjyqDAxojNCDgFBvhjdrGZD91TIGmovRQ3g4mwlC6mnE7h7Y4K45DbnRHm87lCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBKYolTSgMFWuDRVmUi97k7Of3Vb4YwqBeR6t00uO1o=;
 b=dFlfc9cF3c9nkobUoFywAWXk41G2dCSq7Vrd0WH2k9m3FRTC7/EyNDlg6lXgvIEbm4mJzvwN8Uf+RL5KvuJYZdK7DLWrFRoyoYnauIXTraHBun4yavWfNgeOjAeBu4G8GUt6uJ8Gs9oqm8ZyPqZFv06anIjIaOKYxiAxy4IH39tTgHV4X7V9HoSGyBw5b+XZkv/bJm43tFBq4FezOXX0LhfwSOjKOpvaKKvdIe41/pjCog06FIJTzUe48ho0O+5ob29/Q9Qzs8r5VfrgWFmzQ2tZyA1uRgN/pPmSbcrgau3G6EwQlp8PjPXdzV8yKGCdjGtMy2g+GcFM+qcbJpJHMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBKYolTSgMFWuDRVmUi97k7Of3Vb4YwqBeR6t00uO1o=;
 b=R3tNvHOLUpCyhM8HAY9m2rTui1ps2Z+jRz/0GMfljShXKZiVg4SkPR10Xi2/UeL0bXBLo0t2T+m82zFN79pUb1Cl7ivtgxzETPf94SvlKDj7hZ3MVa5WxKOobI+wtDz98FkKr9BfhjAx4YbsnN5gQV1F79R63q4w6PSPKQvfu3A=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3492.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:158::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Mon, 18 Jan
 2021 15:41:06 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 15:41:06 +0000
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning for
 DSA and CPU ports)
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
 <87h7nhlksr.fsf@waldekranz.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <af05538b-7b64-e115-6960-0df8e503dde3@prevas.dk>
Date:   Mon, 18 Jan 2021 16:41:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <87h7nhlksr.fsf@waldekranz.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR04CA0003.eurprd04.prod.outlook.com
 (2603:10a6:20b:92::16) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR04CA0003.eurprd04.prod.outlook.com (2603:10a6:20b:92::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 15:41:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18aa417b-805e-498c-ee6e-08d8bbc777f7
X-MS-TrafficTypeDiagnostic: AM0PR10MB3492:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3492153656BBBDF51F8FF5D993A40@AM0PR10MB3492.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mtqkMarGCDMgdNblzdFmkAnKn4uYqEQn0b6MDErlTv6T7SbxK2VhO4mJ9WwQ61YU8MSjAr2LtncuVaQoYLGhba1a+P+4k9je28D2M4AH6OZ85kz8W90hHHjGYyeLgVPjIwacgVgVeN1rti+vHLS/JqAV4FqUk4JLs0ISdoiIGizC7ReRJA4Vw42gJ7rGZ8I+UivTOXT47d/7D+FNfoLDcV5o65aMEDrW8qx4fPo+mebsF2E+C1D0IZbpUFjTgG2sfqN77fW/AntcSyhebOXoZ+oS4B9sp7Gc1u/Gt1CdnbYQWfwhe+H3Pjt8FaDG1P7vF3YIEf7AdxbQWfbw0y/FCPsyRXGauYDJb4FGf8cJzCBurtSIUsxvEE5yrZfmJfHukrjsBz+AZjiI+UpJUfe2y6bWzH9YdGr+nOpNkcMEPJLHSUWdE5tJvIRrh4Rzgkzt1GNv8TCZDDQbQTKvrdkshTslxaEzWdvpHShhRQm3cl0dl2eY/YkCqI3glUSygbOT4vffwdkzAVqZrBwJlvg8Q1tncWDn89fTdKyq3tTplUpFFi4UFzpTgAeAKrewL+FtnakWj8RaODpkA8HIoRmfBse0n2H74JGyOL8EF74Wyi3mImQLtBZp4xWOxH/vkppF0iKIDgi309l2tcFQ3H+pHD+rGeA0wdcmjVFGGXrsiJbm7hkdmtCMK9QdzyqZUub
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(186003)(4326008)(83380400001)(6486002)(478600001)(53546011)(54906003)(52116002)(16526019)(110136005)(5660300002)(86362001)(316002)(966005)(2616005)(16576012)(26005)(956004)(8676002)(8976002)(8936002)(36756003)(2906002)(66476007)(66556008)(31696002)(66946007)(44832011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?XbQeLX+qDsV/QvDbMd3nmg3FI+meRAa6aetyMEi9UbYuR41IRbqG/gCW?=
 =?Windows-1252?Q?4yNiHl2QWMhLXAzO7OIF7bUgoGZC64BXTXFZm49XLuibosXHV1+YAB+9?=
 =?Windows-1252?Q?I8BdAC1w2F+pVdtV8brRWOUgLO/M7mBMBHa74Q9N2sF/oXL9dBxR3ZCz?=
 =?Windows-1252?Q?xwxDGtSlAI92xvXlnjwc7rClWbs6ktj0PQPNZ9uPHQEQVHuUoonRWG1O?=
 =?Windows-1252?Q?dGJpdedhwCQoKyFFko25DvlhDrwvt+Q/rjNZGAYsTtY/8/gs+vH5AGgh?=
 =?Windows-1252?Q?XFsjIUYHk+lJy7wXPeiGXexnVWAsbEuaZubFFzaG/CgwKNzc8JrIwnRL?=
 =?Windows-1252?Q?vbMP5BSIPqS239eOyjlNo2di0i8qWMCX31Rl0xpUcTWwHYacNzLIQ4cL?=
 =?Windows-1252?Q?jcMIxSdRz6zRq4GHP8KrteIhNQ2jOZ6uTqbATE7mNY44VsPB4IueCmHv?=
 =?Windows-1252?Q?HGcKK2kTGHQQ0F59RwkCBRNkg/kQ9g0TGhk22FjKSfxo0nvkUIgMTWIv?=
 =?Windows-1252?Q?J5R5hxQpteKTpqjGlAYtCvlPavF4NnkKgoO+5/CMp3C181fNHh36F6Tq?=
 =?Windows-1252?Q?70KuZKQcegewsUNUZLL7Z4fVeugVyAh+r9Bio07Ha9rYELrBUVkX9ef/?=
 =?Windows-1252?Q?SXD/y4U7hNe4SspMBFU+sWgRWPSo0D7cRj7sEBum/QZFFtGuNyiHiyei?=
 =?Windows-1252?Q?3xha6S5DIA1QBiTZOsNfNLvJnJBEZ/2S2bXiRTgQ3ReMlMFXon8iTGAM?=
 =?Windows-1252?Q?GS58ycipmMZ7O7RSzRnrBfvxWK8kk0ArN4p41EmfDiQTukoslgvoYT6o?=
 =?Windows-1252?Q?k2/DBCfocL6j66DDvIppaDk20F+33qKPN6klquy5zFMoW38EvGVlfovr?=
 =?Windows-1252?Q?E4iFlehj3w8t16XD2/seiXeJmNVYiBizdsI0RpPtVyzIzXGgXFf9lRn9?=
 =?Windows-1252?Q?leJq7uP/TLrGkHqHTli01nIm4X4641ga/mcVpO9JkCRQ1kUTLNr0xmgy?=
 =?Windows-1252?Q?t79Vzp4fywiaSrCxrJ36jTbHruuBg7FtzA9oqhDno+wBO2L57EjeoTmD?=
 =?Windows-1252?Q?6prm9hc3a2Fjyu3Q?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 18aa417b-805e-498c-ee6e-08d8bbc777f7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 15:41:06.3565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGad0VLPX06Oyt0SbfPEgSDm0a4YOqsJl+eSYp4LllRZdyMc1tdh5itMKQtlUBqdwh6/V11MglhuZkvZroUWPANoBPgO1FSe2UeGrz9PjN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2021 02.42, Tobias Waldekranz wrote:
> On Thu, Jan 14, 2021 at 14:49, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
>> Hi
>>
>> I've noticed something rather odd with my mv88e6250, which led me to the
>> commit in the subject.
>>
>> First, the MAC address of the master device never seems to get learned
>> (at least according to "mv88e6xxx_dump --atu"), so all packets destined
>> for the machine gets flooded out all ports 

[snip]

>> the master device's address doesn't get learned (nor does some garbage
>> address appear in the ATU), and the unicast packets are still forwarded
>> out all ports. So I must be missing something else.
> 
> The thing you are missing is that all packets from the CPU are sent with
> FROM_CPU tags. SA learning is not performed on these as it intended for
> control traffic.

Ah, yes, I do remember stumbling on the tagger using FROM_CPU and
wondering about that at some point. And I didn't recall the somewhat
subtle detail of those being treated as MGMT and thus not participating
in SA learning.

> Ideally, bulk traffic would be sent with a FORWARD tag. But there is
> currently no way for the DSA tagger to discriminate the bulk data from
> control traffic. And changing that is no small task.

Indeed.

> In the mean time we could extend Vladimir's (added to CC) work on
> assisted CPU port learning to include the local bridge addresses. You
> pushed me to take a first stab at this :) Please have a look at this
> series:
> 
> https://lore.kernel.org/netdev/20210116012515.3152-1-tobias@waldekranz.com/

I'll try these out, thanks. FWIW, in an earlier BSP there were some
horrible hacks to go behind the kernel's back and add the CPU's address
as a static entry in the switch, which is why I haven't seen this
before. And this was done for much the same reason as we will have to it
now (it implemented ERPS, another ring redundancy protocol).

>> Finally, I'm wondering how the tagging could get in the way of learning
>> the right address, given that the tag is inserted after the DA and SA.
> 
> Yes, but the CPU port is configured in DSA mode, so the switch will use
> the tag command (FROM_CPU) to determine if learning should be done or
> not.

Right, but that comment was directed at commit 4c7ea3c0791e; even if SA
learning did happen, bytes 6-11 of the frame are the same with or
without the tag added, so I don't understand how _corrupted_ addresses
could get learned.

>> What I'm _really_ trying to do is to get my mv88e6250 to participate in
>> an MRP ring, which AFAICT will require that the master device's MAC gets
>> added as a static entry in the ATU: Otherwise, when the ring goes from
>> open to closed, I've seen the switch wrongly learn the node's own mac
>> address as being in the direction of one of the normal ports, which
>> obviously breaks all traffic.
> 
> Well the static entry for the bridge MAC should be installed with the
> aforementioned series applied. So that should not be an issue.

Yes, so there are several good reasons for adding that address
statically to the hardware's database.

> My guess is that MRP will still not work though, as you will probably
> need the ability to trap certain groups to the CPU (management
> entries). I.e. some MRP PDUs must be allowed to ingress on blocked
> ports, no?

Indeed, and I'm currently just using a not-for-mainline patch that
hardcodes the two multicast addresses in the ATU.

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1911,6 +1911,24 @@ static int mv88e6xxx_broadcast_setup(struct
mv88e6xxx_chip *chip, u16 vid)
                err = mv88e6xxx_port_add_broadcast(chip, port, vid);
                if (err)
                        return err;
+
+               if (port != dsa_upstream_port(chip->ds, port))
+                       continue;
+               if (IS_ENABLED(CONFIG_BRIDGE_MRP)) {
+                       static const u8 mrp_dmac[][ETH_ALEN] = {
+                               { 0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 },
+                               { 0x1, 0x15, 0x4e, 0x0, 0x0, 0x3 },
+                       };
+                       const u8 state =
MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT;
+                       int i;
+
+                       for (i = 0; i < ARRAY_SIZE(mrp_dmac); ++i) {
+                               err = mv88e6xxx_port_db_load_purge(chip,
port,
+
mrp_dmac[i], vid, state);
+                               if (err)
+                                       return err;
+                       }
+               }
        }

        return 0;

because yes, one needs to prevent those frames from being flooded out
all ports automatically.

I suppose the real solution is having userspace do some "bridge mdb add"
yoga, but since no code currently uses
MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT, I don't think there's any
way to actually achieve this. And I have no idea how to represent the
requirement that "frames with this multicast DA are only to be directed
at the CPU" in a hardware-agnostic way.

Rasmus

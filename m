Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15593A5968
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhFMPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 11:38:55 -0400
Received: from mout02.posteo.de ([185.67.36.66]:58079 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231844AbhFMPiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 11:38:54 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id C27BE24010F
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 17:36:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1623598610; bh=0+6/B9KVWJUU4lpEcAE/Ygv0rdimmwaH5lku6QLB6rA=;
        h=To:Cc:From:Autocrypt:Subject:Date:From;
        b=e4nXU1pya9bK6v/vtmxceOBqNcATdbjmrJagLhmSgB7Zn6bp0m1k9hd4EKMEv7IiD
         eGFDUU5mptSEyJaPXp4pykFGptUC8JeENk/rN/315foRnNRBKb8853KIscsWmVVhnx
         Np3ymZWB9VdIw1earvZotdT5Hy2x4u4QdkCDQoBSMs3HBpAEiIk5Ugb+C6tFLG/4LZ
         68OScaHoms8q79XFqjT+w7MJBHoR7+ONOckvyYeThlbg/P+EgwGzZeawUsNcN7tO1c
         oww1P2huc1oS8aU0kTEKitcFkdVrZoEjBfJFvHoZPNMYfzwQTr2dOcQ1MAeKYUxpie
         DPFkHxEW/fvPg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4G2zG452MRz6tmX;
        Sun, 13 Jun 2021 17:36:44 +0200 (CEST)
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
 <f9d008bc-2416-8032-0005-35d7c6d87fc1@hartkopp.net>
 <34cc6b6a-6eb0-f3ce-1864-9057b80fab9e@posteo.de>
 <trinity-0d8be729-1e3c-452c-8171-962963abed0d-1623591348277@3c-app-gmx-bap71>
From:   Patrick Menschel <menschel.p@posteo.de>
Autocrypt: addr=menschel.p@posteo.de; prefer-encrypt=mutual; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUlOQkZ3RG1RZ0JFQUMr
 elBRRy9KTHQyWUpiNTRERFBKd0Jtd25EUTh4dUZQcEFjRjNYSVVuZkFOTGs0OUpoClhWczFR
 TnVHZk1VLytmY3RPWGd0SmF6Q3doc3NGdlUvWStPc1Nmd3FTN1ROOXhIWE1DZmtnK1gxRHhI
 ZGtqcmoKL1pUYkxHd1FUQlE2SVpVeW9BTEVSQ2RHZFBETFVqWERSS0poSTdvV3RqYlVFWUVr
 ZE9RYnY2eDhLVWd1bGtHUgpYYWxka1hJZ0R0VWZLaUE0VGhBVXpncVJuZ09DV2ZITis4TnBo
 Q2pGVlFnclRSakxCc3pkZTFnTmJkZ2kvdWxiClcyTngvS1Jqa0F1TTdFUVJvVUJ2QUJWb2FX
 R3ZYenIzUmphUFhrSk5wNHdFbm1IcVoxZlVteWMvSGZRNnVjWnkKRW5QZnlEWExtWTJQUU5P
 N2ZCemZLMTJVRTdWZHh0OTBDNURPSkRBc25kNHYreloxNHJObEpmTHNwaDZkVlNIbApsS2t2
 NE1BTndNaGxRT3Bta1pLMHhVU0Q2R0M1OHRiV0RSbEg4b3UrWUhDYlh2OHJCTXphR0phWDVB
 S25lNTJTCmZEUCtiQVVTdWVQdDhrRG5TaU1ZNk9iUEdObWhqcW1JN1RmNkU1NDdqRXUzcmxr
 aVI3Rno2cktVVzA5VlBlcnAKUnVya3orSTFtTDZ5ZTlZdGFDZ3MwbFR4b3VuYnA5emROVE04
 djZFOGJsMWNoSnRoYWs1bkEvRktnbmRtVHdhUQpNclFTRFEyNmxMcUw0MXRPZzhlVXFhTzJI
 TXVPRGNaaVVIMGVNWHlQZjhsbXhMcy9sbUVZU3hGUXFMWlBjWW9pClA0SGxVcDNSMkxIa0hO
 WDg1WDBKUldwRkkwLzNKMTFiWEpjLzc1MzVKODExdE9aRDkyRHlkK20zS3dBUkFRQUIKdENk
 UVlYUnlhV05ySUUxbGJuTmphR1ZzSUR4dFpXNXpZMmhsYkM1d1FIQnZjM1JsYnk1a1pUNkpB
 bFFFRXdFSwpBRDRXSVFUcFZLQkNXcGNoUW9QQURFY3g1bTR3ejYrNFRnVUNYQU9aQ0FJYkl3
 VUpDV1lCZ0FVTENRZ0hBZ1lWCkNna0lDd0lFRmdJREFRSWVBUUlYZ0FBS0NSQXg1bTR3ejYr
 NFRnQTJELzBTQW92U0xuK1pTcGUzK0d4UUhKMzYKWmJ1TWs0REVSa0RKMnIveStvc254WUd2
 TmNtU3N5Q1pBaVZjTTlFM0kxUXVtdDZvWHpoditJUDJNd09MZTlQMwpvUmhJQ1JyQ2RwWmY1
 YjdDb0lOc3lENUJwNGFsSUs5UFpHUDdXTjRHeGE3OVpNYkRhNVBNWGVQZ2psckFNVGNOCjRv
 c2Q5NVB4eFNkV1dheTB2TUh0VWYwRGJkaDFRNUs1U3lkREpxdG56dFBkNzBzUG9wOHBRSWhE
 NExGUWdpcFgKL3VRdkEvWnZpN2c5T3N4YThCNnRDTG41VG5LT2lNYktCVUFya1FHTDFnbDQ4
 NFJtKzRlR011YVZrVjVBb3VYMApOaGQvTVU3eEMxS2dGcWZwYTMzZ0ZRdUxTSTU2aStuRkt6
 dzNIdiszeHBJOXJjaHFXQjNnSWNVQ2lQZmFxcU1vCnI4RVNKODF0NWlvckQrRlpQb1RyMUEz
 aGZTMTNuMGxWUytsZUd3dlNucjRRZ0gvcjZ5eGw4RERIaUdFMUFXblAKaTNaWFNKWnkxRUJW
 TWJXTXFBNzFwczZDS2ZnbmpmSHVvVmNsTElXd3cxT2gwYXlER1hMZUFic1VPTGtGOXAxMwo1
 MWxRS0lJWUZpcXVwL09qa0pKMlgxaTdITjlqV2xRVnR0SER3QlhZOWNYWDRHUzk3cnNwSVhj
 S2hHRytFSVB0CjFEaFdBdDR1ZDdqcDIrSDRmTXlKZGlVK0wrYTVXNjlTODZpOURTMjBUdXd2
 K3JRemNQWTQ3MkVxZmo0elhWWmsKNUNzZ2kxVDZzQ1lnZDd5TGpHMnFYblZsSTJqQ1JyT0RW
 dGJiY25jSi9peEhPQ1h2TmlvRzZPREhBM3ZtNlZxaQpEelBmYTBFaWZveWMxbDRvSUZvQ2c3
 a0NEUVJjQTVrSUFSQUEwdUlXUGNrRlpzb0ZVZG1Sd29vMW95YzhmSyttCll6TmhTc1l0UTlI
 ZDMvQmlWeUxwUERQK0F6eks4U2JvWXVGcTJOaGRJaTIyeFRTZ2pyRFZMOU10YTdNbDB6cHgK
 QnJSTitySm5LRFl3bThJeUl6eUpCRmhXU1l3YnVPSXVqbnB6U1IvVGVDT1VvelRadFhnQmRU
 YzZrUG5kV1BWTgpDWU9hZVFXdDI1Qnc3ZGNVbllUQ1FWYm9EN0RFVWFEVkVqM1BKM2U0aGli
 TEp1UnEvK1dQY3kxQ3g2UFNucTJ6CkdQN1pVNWh6NjF2ZGovbVJJa2QxS2UzUTZmWUwzSVRN
 T1l1WGF6VUVEZ3l3TlN0bVkwRmZUT05GWEtGTXdSNm8KcUtuSGlTN2tINytxQWFodUpkdVFB
 MW9SU2xUTWRFb3F2WHEySlVJTm1NaGdYL0ZQN3ZpZEFxcTdnVjRXWElxcAptckliVHBiNVpz
 U0N6dUJBd3lkOTYxM1lmYWpZVGlUYkJGRzQ1Mld4TnlJeTFUdVpWMmIxZlhPbGdLRjNvbmUx
 CnhwbURqbTFlZVhSdjRnV0d0Vks5cXlEaUtYWnlmQ0YyL2o5d08xaTNnUHZqYmFvU1dhT2hH
 T2V6dlNFQzB4RjgKWU9TMitGSmxVclVyVm54UXZsZkdyWFYxbUpRTHpvcFJ5N0VndjNlRDI0
 NUx5YjhjUHpOUmppelRqV2RYN0g0MwpuNTlXMkdWTkFLTkNyV1pkOGNjZEdJK1RodmwzUUh1
 YWQ3NEY5cGdDUUNZWXM5dG92YVZldFR1WlI2Y3JMaG10CmxmK1V4ME5SV29PV2ZTR0w5anBt
 dkR3aGlwWCszMUlvb1FiOTZ1a2UzOFBZMUVOMjJ6QlBxZ25jVVVrUkxQQncKbEhYbnpFVit6
 U1p4QXpFQUVRRUFBWWtDUEFRWUFRb0FKaFloQk9sVW9FSmFseUZDZzhBTVJ6SG1iakRQcjdo
 TwpCUUpjQTVrSUFoc01CUWtKWmdHQUFBb0pFREhtYmpEUHI3aE9Db0lQLzNTanBFdTl4Wkpj
 TlZvU0s5MTA0enB6CmtnS2FUVmcrR0tZSEFJa1NZL3U2NU1zVmFTWk14bWVDSzdtTiswNU1w
 RUZCYW9uMG5sVTlRK0ZMRDFkRDBsenYKTVBkOEZOcEx4VEMxVDQwbXBVN0ZCV1hlVjZWRHoz
 STY5VkFBdjRWVDM4ZVZhYXBOS1lmVGdwcFRYVEVNYVdoTApVYUpGaU1HaFNYaGkrR01GV2Ji
 NVNFOGJJRTZ0WUpONWlYZUFNVFE4NjhYVGtHS0VHTjk3bEU2S09odmpWV0kxCkhiUVIzZ0tV
 ck1uVmlhbGp0YnV4bGNvS2YrblRvNG85OUEyTkprRCswaFozclJZTWhacFR1MitkcCt2Rm9p
 aEQKdVNFTCtoblZhNFRMd2pYd2gzNzNweU9XMFhra2E5YWpNTEFoMUFtMmRBa0pLSDhzMVlJ
 UUlpL2Q3bEkyYXQ1awpIcWtIa2p0YzE1ZkgrQUU5Q0VSM3RCSVNoYU9Fb0hXTXc0WEs5NS9n
 MWVnMVB1cmJmN3RwRnltcklxU3ppQjlvCjJBWituSHVDQ001ZC9pQXh5MmJOcndqNDhPM2Z5
 WXd1a0pManUyNlJKbzRMNStjNEJoTU1Ray9nVWROdldHK2YKNUxreVhvbHNMY0p0SktLdStD
 V1pFK1hxc2RGWHd2d2xDRVNSQ012cGZyQmNtY1hrT0g3S1JKVy9pUjFXVjVRZApjR3ZDcDl0
 a08vaEhSb2t0dzBibUl1MlFhZkovajZLTGJqZWV4cTc0TWUyb0U5YmkxY3B2azYvSElDV0JQ
 dHVYCnNqd2o1Q2M3UlZOMjJLekdZT0RKVGtxU0d4RjV1NVlkTHVNVG5CVGNweEphR2h3MzNq
 QjgwY3o3enFwQXBpREIKZFFnR2psVlNQT3ZidU04aXBPZDYKPW1nREMKLS0tLS1FTkQgUEdQ
 IFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=
Subject: Re: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
Message-ID: <a44df2a0-a403-40ba-3312-c6eb53ddf291@posteo.de>
Date:   Sun, 13 Jun 2021 15:36:43 +0000
MIME-Version: 1.0
In-Reply-To: <trinity-0d8be729-1e3c-452c-8171-962963abed0d-1623591348277@3c-app-gmx-bap71>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 13.06.21 um 15:35 schrieb Norbert Slusarek:
>> Hi,
>>
>> 1.
>> Are you sure this leak really happens on 64-bit and not on 32-bit instead?
>>
>> I remember I got the problems with bcm msg head on the 32bit raspberry
>> pi because I missed the alignment by accident.
>>
>> When I calculate the size of msg head on a Ryzen 1800X with Python
>> 3.9.5, I get:
>>
>> struct.calcsize("IIIllllII"),struct.calcsize("IIIllllII0q")
>> (56, 56)
>>
>> First Value is raw, the second value is the alignment hack with the zero
>> length quad word "0q".
>>
>> On the 32bit raspberry pi, same op results in the gap.
>>
>> struct.calcsize("IIIllllII"),struct.calcsize("IIIllllII0q")
>> (36, 40)
> 
> Hey Patrick,
> 
> having reproduced this leak I could only observe the issue on 64-bit systems.
> I've just tested it on a 32-bit OS running on a raspberry pi and I couldn't observe
> any leak. The offset difference on 32-bit between count and ival1 is 4.
> On 64-bit systems, it's 8:
> 
> (gdb) ptype struct bcm_msg_head
> type = struct bcm_msg_head {
>     __u32 opcode;
>     __u32 flags;
>     __u32 count;
>     struct bcm_timeval ival1;
>     struct bcm_timeval ival2;
>     canid_t can_id;
>     __u32 nframes;
>     struct can_frame frames[0];
> }
> (gdb) p/x &((struct bcm_msg_head *)0x0)->count
> $1 = 0x8
> (gdb) p/x &((struct bcm_msg_head *)0x0)->ival1
> $2 = 0x10
> (gdb) p sizeof(((struct bcm_msg_head *)0x0)->count)
> $3 = 4
> 

Ouch,

I should not skip lines while reading.
We're talking about different gaps as it seems. I didn't realize the gap
in front of ival1 before.

There is also a gap in between nframes and frames[0].
That one is caused by align(8) of data in struct can_frame.
It propagates upwards into that gap on 32bit arch.
You can find it if you actually fill frames[] with a frame.

I found it while concatenating bcm_msg_head and a can frame into a
python bytearray which was too short for the raspberry pi as I forgot
the alignment.

I came up with a format string "IIIllllII0q" for bcm_msg_head.

Kind Regards,
Patrick

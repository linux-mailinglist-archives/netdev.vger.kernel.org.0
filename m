Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562243773AA
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhEHSiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:38:01 -0400
Received: from mout01.posteo.de ([185.67.36.65]:40293 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhEHSiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 14:38:00 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 71BE2240026
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 20:36:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1620499017; bh=woizo10EuEdtSwiBJ6mE/8V/AV91s8H60UJNgduiDQI=;
        h=To:Cc:From:Autocrypt:Subject:Date:From;
        b=r9ANrwTug7PXzO6lKGH8lDc3JHF+dSIoK5U33tDrocfbqTMej8qY1lrINvdO+nSAN
         tkI9pVh49O2LZ3oMqC5MWMEJsQmv+IjGUtW6J6YCgCW4w4gWONCxnhMLH5B9C7dElP
         Oh37fqcpZoXrzTxwABep47AwZ7u9sAT6U2+EBvsHrY7slHX+yUdX+0NvgXowTjRnDH
         l76dUk/jH0hE0Ccw1f4ln2p588HsgL7vgOvsUXA4nJpB5SRU1Yyqkq1xk0EsLH1BIt
         CXrEy8H4+TvG2Pnp14bulA+vuk0zluVREt3U1rNQs6Q4YN+PoC/tIuM0zKzEQeGDKy
         uj0TLBAmtoIPw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Fcwyc32j2z9rxG;
        Sat,  8 May 2021 20:36:56 +0200 (CEST)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Drew Fustini <drew@beagleboard.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Will C <will@macchina.cc>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
 <20210407080118.1916040-7-mkl@pengutronix.de>
 <CAPgEAj6N9d=s1a-P_P0mBe1aV2tQBQ4m6shvbPcPvX7W1NNzJw@mail.gmail.com>
 <a46b95e3-4238-a930-6de3-360f86beaf52@pengutronix.de>
 <20210507072521.3y652xz2kmibjo7d@pengutronix.de>
 <c0048a2a-2a32-00b5-f995-f30453aaeedb@posteo.de>
 <20210507082536.jgmaoyusp3papmlw@pengutronix.de>
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
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Message-ID: <7cb69acc-ee56-900b-0320-a893f687d850@posteo.de>
Date:   Sat,  8 May 2021 18:36:56 +0000
MIME-Version: 1.0
In-Reply-To: <20210507082536.jgmaoyusp3papmlw@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 07.05.21 um 10:25 schrieb Marc Kleine-Budde:
> On 07.05.2021 08:21:57, Patrick Menschel wrote:
>>>>> Would it be possible for you to pull these patches into a v5.10 branch
>>>>> in your linux-rpi repo [1]?
>>>>
>>>> Here you are:
>>>>
>>>> https://github.com/marckleinebudde/linux-rpi/tree/v5.10-rpi/backport-performance-improvements
>>>>
>>>> I've included the UINC performance enhancements, too. The branch is compiled
>>>> tested only, though. I'll send a pull request to the rpi kernel after I've
>>>> testing feedback from you.
>>>
>>> Drew, Patrick, have you tested this branch? If so I'll send a pull
>>> request to the raspi kernel.
>>>
> 
>> not yet. Thanks for reminding me. I'll start a native build on a pi0w asap.
>>
>> Is there any test application or stress test that I should run?
> 
> No, not any particular, do your normal (stress) testing.
> 
Following up on this.

Build and test finished on a pi0w.

### Test conditions ###

Since I lacked a true stress test, I wrote one for regular tox with
pytest collection.

https://gitlab.com/Menschel/socketcan/-/blob/master/tests/test_socketcan.py#L872

It uses mcp0 and mcp1 which are directly connected.
No CAN FD, just 500k with regular frames, random id and random data.

I basically mimic cangen but enhanced with a queue that handles to the
rx thread what should be compared next.

### Extract from dmesg shows no CRC Errors ###

[   30.930608] CAN device driver interface
[   30.967349] spi_master spi0: will run message pump with realtime priority
[   31.054202] mcp251xfd spi0.1 can0: MCP2518FD rev0.0 (-RX_INT
-MAB_NO_WARN +CRC_REG +CRC_RX +CRC_TX +ECC -HD c:40.00MHz m:20.00MHz
r:17.00MHz e:16.66MHz) successfully initialized.
[   31.076906] mcp251xfd spi0.0 can1: MCP2518FD rev0.0 (-RX_INT
-MAB_NO_WARN +CRC_REG +CRC_RX +CRC_TX +ECC -HD c:40.00MHz m:20.00MHz
r:17.00MHz e:16.66MHz) successfully initialized.
[   31.298969] mcp251xfd spi0.0 mcp0: renamed from can1
[   31.339864] mcp251xfd spi0.1 mcp1: renamed from can0
[   33.471889] IPv6: ADDRCONF(NETDEV_CHANGE): mcp0: link becomes ready
[   34.482260] IPv6: ADDRCONF(NETDEV_CHANGE): mcp1: link becomes ready
[  215.218979] can: controller area network core
[  215.219146] NET: Registered protocol family 29
[  215.261599] can: raw protocol
[  218.745376] can: isotp protocol
[  220.931150] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  220.931274] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  220.931395] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  220.931518] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  220.931643] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  220.931768] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  220.931893] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  222.099822] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  222.099901] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  222.100022] NOHZ tick-stop error: Non-RCU local softirq work is
pending, handler #08!!!
[  222.330438] can: broadcast manager protocol

That softirq error has something to do with IsoTp. I was not able to
trace it back but I have it on multiple boards: pi0w, pi3b, pi3b+.


### Performance ###

## v5.10-rpi/backport-performance-improvements ##

I get about 20000 frames in 2 minutes.

2021-05-08 19:00:36 [    INFO] 20336 frames in 0:02:00
(test_socketcan.py:890)

2021-05-08 19:49:34 [    INFO] 20001 frames in 0:02:00
(test_socketcan.py:890)


## regular v5.10 ##

2021-05-08 20:19:55 [    INFO] 20000 frames in 0:02:00
(test_socketcan.py:890)

2021-05-08 20:22:40 [    INFO] 19995 frames in 0:02:00
(test_socketcan.py:890)

2021-05-08 20:25:22 [    INFO] 19931 frames in 0:02:00
(test_socketcan.py:890)


The numbers are slightly better but I count that as tolerance. I also
found that there are cross effects. If I run the same test on vcan0
before, the frame count goes down to 13000 instead.

I also have to admit, that I didn't get any crc errors with regular
v5.10 during that tests.

Do I have to change my test?

I can still update that pi3b+ that runs my micro-hil at work. That was
the one that occasionally had CRC errors.

Best Regards,
Patrick




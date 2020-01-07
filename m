Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DF6132D08
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgAGRaL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jan 2020 12:30:11 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:38075 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgAGRaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:30:10 -0500
Received: from [192.168.1.176] ([37.4.249.154]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MqJuP-1jTDmD2EAV-00nTer; Tue, 07 Jan 2020 18:30:02 +0100
Subject: Re: [RPI 3B+ / TSO / lan78xx ]
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        RENARD Pierre-Francois <pfrenard@gmail.com>,
        nsaenzjulienne@suse.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <5267da21-8f12-2750-c0c5-4ed31b03833b@gmail.com>
 <78b94ba2-9a87-78bb-8916-e6ef5a0668ae@gmail.com>
 <863777f2-3a7b-0736-d0a4-d9966bea3f96@gmail.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Openpgp: preference=signencrypt
Autocrypt: addr=stefan.wahren@i2se.com; keydata=
 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 AQ==
Message-ID: <f7e1f498-d90b-1685-dc02-4c24273957a7@i2se.com>
Date:   Tue, 7 Jan 2020 18:30:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <863777f2-3a7b-0736-d0a4-d9966bea3f96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Provags-ID: V03:K1:NP238M/sIC7ImzJ4Yk8d0oC7DYq5fYSzCxzV1DykE363RMWuFM0
 J9yyJRXfOyxs3HI14tPeI5nG95uNKRbLLD9kV1pbXcqXOthzuhk2E2EkTbiEVvWXcG2xILs
 NUrABIq0DzBKH7edBCA6u2KQOFDpW9By4wAH61UHHSXdsGvzLqThmEfhb6darH/1sM+Pgr7
 6/L1C+vcetUxcEg1w8KTw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vm6/ZvQlDQQ=:FLjGkNXlazz31py+qhEAKr
 koIOsF21nek0XF/7dME/RSmxAAeLVdg9zO50vw/AuyOaNgxws3Z3bCbr7Sljjmn8HrdiZEvd9
 MuICD8InHAE79M9b973djay7+r3V64+Rf5LFiMUfMHbcYuwDnE0/y/8F5MU4tKb/QGvHCixAq
 uftuWEoh9MLNMA7BHKo9fSURHFBE0otOmSu5rXGtIFwsRVZ8Piwvw71YViD+y67CTUr9XhMpW
 1tnUmlCRG69S9uXOSOuULO7tlpCgLKd3q3LgOia4FzdTmG1JFzeADaX/vhdhZ//U4UWkdpbOO
 rFxUfQg5jnWxwIQ6nD3we9kjIri0z5y4A55bVHC+2VpvkN5fQtrt28inzZeNqjbsKNIuuayYs
 QYjpb+m2EsduWZgIGkUwBL2XeRMOB27tIbME065jvMjcLtsgKJlTywM12PyylsdwabvJfkod4
 rZpEAntkGYfDIlRMsXmDkot6N9h0PcvDo5w1u9pxmp5JofpWrxWKW0LkCb47oET0zifAlKqBa
 PQgBrG+CLD+5vEu122KmPE2BSc8JmD1CEF2Bd7FhjpoidqP1Cz7UkNU6WjBFStsuhZKjzxIDo
 h4/I1FU2PejKksokiE9jtyWjuimZ3xGYZitGRsB9azcid5oMtvdWyZgyvUe+Z4OaV5DslqIBw
 OZk4Y3Hzs25L6voDvzpJQM5hQeY/aAhNDJcHJ/jD/I5PXufeL550W2UgWEFjnr4DwQj8k6oYe
 gkkjkW00H0qKYZaYV01UbG+fgW6SHY/o3Q/Qs0RRpgy5TpS37J3LuwlWxUQfCPoL8QribyjT8
 li8vucLaN2wDB3/iq9tySyxWVthF9aVUnHAWr98eHI3gh3U9aMrPWeHM+vsOW+Gu3nnyH9Avi
 tnbWu+kZQ3j/xLUspwpSHMoqYYS4pt3K4TOt4xfcA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Am 07.01.20 um 18:04 schrieb Eric Dumazet:
>
> On 1/7/20 5:32 AM, RENARD Pierre-Francois wrote:
>> Hello all
>>
>> I am facing an issue related to Raspberry PI 3B+ and onboard ethernet card.
>>
>> When doing a huge transfer (more than 1GB) in a row, transfer hanges and failed after a few minutes.
>>
>>
>> I have two ways to reproduce this issue
>>
>>
>> using NFS (v3 or v4)
>>
>>     dd if=/dev/zero of=/NFSPATH/file bs=4M count=1000 status=progress
>>
>>
>>     we can see that at some point dd hangs and becomes non interrutible (no way to ctrl-c it or kill it)
>>
>>     after afew minutes, dd dies and a bunch of NFS server not responding / NFS server is OK are seens into the journal
>>
>>
>> Using SCP
>>
>>     dd if=/dev/zero of=/tmp/file bs=4M count=1000
>>
>>     scp /tmp/file user@server:/directory
>>
>>
>>     scp hangs after 1GB and after a few minutes scp is failing with message "client_loop: send disconnect: Broken pipe lostconnection"
>>
>>
>>
>>
>> It appears, this is a known bug relatted to TCP Segmentation Offload & Selective Acknowledge.
>>
>> disabling this TSO (ethtool -K eth0 tso off & ethtool -K eth0 gso off) solves the issue.
>>
>> A patch has been created to disable the feature by default by the raspberry team and is by default applied wihtin raspbian.
>>
>> comment from the patch :
>>
>> /* TSO seems to be having some issue with Selective Acknowledge (SACK) that
>>  * results in lost data never being retransmitted.
>>  * Disable it by default now, but adds a module parameter to enable it for
>>  * debug purposes (the full cause is not currently understood).
>>  */
>>
>>
>> For reference you can find
>>
>> a link to the issue I created yesterday : https://github.com/raspberrypi/linux/issues/3395
>>
>> links to raspberry dev team : https://github.com/raspberrypi/linux/issues/2482 & https://github.com/raspberrypi/linux/issues/2449
>>
>>
>>
>> If you need me to test things, or give you more informations, I ll be pleased to help.
>>
>
> I doubt TSO and SACK have a serious generic bug like that.
>
> Most likely the TSO implementation on the driver/NIC has a bug .

Yes, the issue isn't reproducible with the Raspberry Pi 3B and the same
kernel (without +). The main difference between both boards is the
different ethernet USB chip:

Raspberry Pi 3B: smsc95xx
Raspberry Pi 3B+: lan78xx

>
> Anyway you do not provide a kernel version, I am not sure what you expect from us.

It's Linux 5.4.7 (arm64) as in the provided github link. I asked
Pierre-Francois to report this issue here, so the issue get addressed
properly. Currently this very old bug not fixed in mainline and the
Raspberry Pi vendor tree uses a workaround (disable TSO).

Stefan



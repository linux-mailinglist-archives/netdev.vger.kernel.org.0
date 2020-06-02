Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8731EC3AE
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFBU3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:29:30 -0400
Received: from static-27.netfusion.at ([83.215.238.27]:56434 "EHLO
        mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgFBU3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:29:30 -0400
Received: from [192.168.0.36] (a212-238-163-105.adsl.xs4all.nl [212.238.163.105])
        (Authenticated sender: victor)
        by mail.inliniac.net (Postfix) with ESMTPSA id 02A2810C;
        Tue,  2 Jun 2020 22:31:37 +0200 (CEST)
Subject: Re: [PATCH net-next v2] af-packet: new flag to indicate all csums are
 good
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Mao Wenan <maowenan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>, linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Drozdov <al.drozdov@gmail.com>,
        Tom Herbert <tom@herbertland.com>
References: <20200602080535.1427-1-victor@inliniac.net>
 <CA+FuTSfD2-eF0H=Qu09=JXK6WTiWKNtcqRXqv3TfMfB-=0GiMg@mail.gmail.com>
 <b0a9d785-9d5e-9897-b051-6d9a1e8f914e@inliniac.net>
 <CA+FuTSd07inNysGhx088hq_jybrikSQdxw8HYjmP84foXhnXOA@mail.gmail.com>
 <06479df9-9da4-dbda-5bd1-f6e4d61471d0@inliniac.net>
 <CA+FuTSci29=W89CLweZcW=RTKwEXpUdPjsLGTB95iSNcnpU_Lw@mail.gmail.com>
 <6a3dcce9-4635-28e9-d78e-1c7f1f7874da@inliniac.net>
 <CA+FuTSdmtC4+0cnC2K1gwRLksXgb4hffUpyRbHjjGZbOJOfL0w@mail.gmail.com>
 <21a2224a-65f2-6375-589d-9cadb4fab840@inliniac.net>
 <CA+FuTSdczH+i8+FO+eQ+OT4-bsRAKG+jacPiuRu3jMszpV_2XA@mail.gmail.com>
From:   Victor Julien <victor@inliniac.net>
Autocrypt: addr=victor@inliniac.net; prefer-encrypt=mutual; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUVOQkZBamQvUUJDQURY
 S3FvR0xmclhGTDB5R2k3cHozdjU5dG5TN3hsVTl0NHVSUnd6YThrN3piVW9oTFlJCkFNVkp1
 dFk5Mm9BRDYrOTJtSVNIZDNDZkU0bGZuRlFBNHY1MllXOUUvRHBTaVQzWnFMZ0RHcmdVMHRs
 Qm1OUG8Kd0tJMjZyUnVCejBER3dVZkdocjlud3dTbVRDM213NU80cFlYR0wyd3ludHA0THZ2
 Q1lTdFJDVkZIMEhWL0lDVwozT2d6ejQzNGdtelU2N2xOaXpxMDdmL1R2SWtkd3ZHL1ZGVU5u
 WTZLQXRzUysrRTZZdzl5MEo5SStVYktFUDl4CnkySHl3RFFLRVVqck9FMCtlREtoblRXVGhX
 YnZEZm5CTGZJUGNla3dYbXVPYjVycGFXblE1MTkwNXVETTFzcm8KUGFZK015NEQ3b3N2ZUFN
 di9SbmhuN1VuVlg5M3JUS05RRUhaQUJFQkFBRzBJMVpwWTNSdmNpQktkV3hwWlc0ZwpQSFpw
 WTNSdmNrQnBibXhwYm1saFl5NXVaWFEraVFFN0JCTUJBZ0FsQWhzREJnc0pDQWNEQWdZVkNB
 SUpDZ3NFCkZnSURBUUllQVFJWGdBVUNVQ045WWdJWkFRQUtDUkRCOUpYamttaFd0SlFOQi85
 UVhwOXZCbnlwbm1RaDlHb2cKNE0vR2V6TERWbFJoVnQxL2FnYXByWDFhR09kZ29uRHd4WFR1
 MUs3Wnk5RkcrZysrb3lkRzdaYzFaT3JwSEtjTQp4dWxGams2MUEvODVMLzg1ZktHM0hlTFpX
 M2szR0p1OUhCRnZqNllrbXdmbHdTRk9KWmdkT3k5SGh0b3hTQnVwCmI4WTlKL0Q5MVB5Vi91
 YWdaa21ITjRuQmJldGNkSU9PNXdudWV0VnNrNGJsVjdhVk1kU2JEVXNrbU9Nc0hWTDcKRDN2
 WGFwSG1MbGhWSXZNQjBPTndQQVY5MHV6WUtNRlQ0SWdFbm04VXBFT0hsL0tFNWJyWlAzQkU4
 SXRJajUrZwpJRkNMNTRrdVphMWY5MUlDMzNocUJaNUZQNitNamt3ZmswOVdyQURsVmt4S3NP
 RkgyMHQ2NVVLT2EyeTNLM3pyCnhaYll0Q05XYVdOMGIzSWdTblZzYVdWdUlEeDJhV04wYjNK
 QWRuVjFjbTExZFhJdWIzSm5Qb2tCT0FRVEFRSUEKSWdVQ1VDTjVwZ0liQXdZTENRZ0hBd0lH
 RlFnQ0NRb0xCQllDQXdFQ0hnRUNGNEFBQ2drUXdmU1Y0NUpvVnJSawpxZ2dBa01pODdnZzNT
 K3FkQlVjSjVXd3VLTERPL1M0MTNzR09FaEU0SzU3YXpUVTNOVWNPVnVOZW5mNDB1L3F3Ckt4
 VitEUDJuSzE4Rk9CdDdwcVdyQzRrNThaUWMxTm9SR0VWQjY4elhieVI5L2xIMWNocXB5Mmhv
 enoyL0xhRG4KT0ptUWgvWUorYUhZbVdETGVuK3BtNWc5NzFJTUE5bUdiK3FrMTQ4aFBBMTBn
 b0h0ZHIyNzNPeXpQaldzU0JnVwp4bVU2amhNOE1Ld0tSSkFsTmxoMTVSbFpWNEM5Rmhkdi9V
 b01LZXhpaWltbGZIY1hVR1dtZ2I2RXBnVW5ab2piCklYQlNsYk5FMVZFTk5IcDVaeEhYNUU5
 dmQxV3BiMFV0Zmd2ZCtqaWo5VEtuMHpSSDlFTHFTYmxtUTFTamF4bEsKVnhhUDd1ejRpUHpJ
 NFk0RDVxMHJERHhTVmJRcGEyVjVZbUZ6WlM1cGJ5OXBibXhwYm1saFl5QThhVzVzYVc1cApZ
 V05BYTJWNVltRnpaUzVwYno2SkFTMEVFd0VLQUJjRkFsQWpkL1FDR3dNREN3a0hBeFVLQ0FJ
 ZUFRSVhnQUFLCkNSREI5Slhqa21oV3RKdndCLzlNdDZCWXkzTlZMUU1WQ05YSjRzZm95eUJJ
 Q1p2ODNnN3lpQzVEako2dUxXUE0KVFl2M0ZLRDFWa2tUQ2hWOHNXaDhvMkhHUGduUVk5eisx
 Q1hQM1dSUFdkWG9MNTFha3lPd3pFdEZVRG5JaHBtMApkWFhxQlJ3Qi90WExXN3R0VnkxR3VF
 eExkaDNaaDkwOHZ3SU1xVU51NC83ODB1VTZiRFpLQW9rZmZKekcxbzZMCm45dVF3bEx1WmNH
 MnhnTTZiN0RaN2MvNHZ5ejM1ak9jWUozWkREb25xR3BETTNvZFdnWXp4UHN4a0JVRnlKeFkK
 aDA4MHhzdHR0MFVJMWlmODRyVmdtQXRHblZFQjJ3YklsSktTa3d5ZXI0NGFTQ201WTEyNXNn
 MUtIZFQwMEREQgpWTTRNZ3k0NTJJYUZJVndpNHcwdVdZR09nblQ1MWx2VTY4NmV3VHh2dVFF
 TkJGQWpkL1FCQ0FEVkFoU08wR1YwCkxHdnh0a0hWQ1hzaGdSR2srNmdTSFpRVzc4a3F2V0dM
 OU95UDhzK0ZpUS8vQWFMa1NETzNpSVZTbWVrZVhiZlkKNkcxa2l2aDJLN0NaYlBTMzdDVGVL
 L0p0L2ZFbzY1bTJvcWtMWStDTnZVeElvYVdhMitQY1Z4UXNLem1aZ0hDRApDRVdzN21rK01Z
 UUxNZnluanVoVVorWmlaa2Y1U2ZBY1hQTEQ5emRkTFlSdUJtOTgwRDN1UVJsbXlqRTVOZTJa
 CkRZVEMwU1ZLNDFRMVVDdDFoZFdNOUlWczg2UXEybUU5Y21KWkthUUNRc1ZEMVlMZUdxYTJk
 UVdLYnIyc2EyRHUKd2pCbEhzWk83NFZjTHR2L2lQV1Nad2FxNkdBZTJGZXB0TFhJQWd2Y3lB
 WDlxOHczWDBjdWtsa1RTWFUwbU5ISQpuWHFnRHRBRGtOVnRBQkVCQUFHSkFSOEVHQUVDQUFr
 RkFsQWpkL1FDR3d3QUNna1F3ZlNWNDVKb1ZyU01od2dBCmlicHNMNUtnaEhnK0h2TktocXpV
 b0JGTDMya2xNS1R5Ums0ekhzbzZDNHBKVDNvbjRqOVF2dnJLU2tsaUJ4a1IKM2ZMdVFOVWE5
 YlVYeDNmeUFheVF2ekxnV1FycVc3eTU1Z1dCRUZPQTVQQXdFU1pDdTNYKzNGODZPK2w0N1k0
 dwpOZTRDRDJLYTRLKzlXTHQvR3RlUnBQQU5lVldNUHRRQktqc3BFSFBSeWNidnJGV20xMUJI
 djV2eC9GYVNXN2tICjdkaHFkRHNxMFlJaWYwUkdjUVNySlBBQm00ZHkva1hrcFJQUEFHSGdN
 dVMvejZwY3c0RFVsaTZQVE1aTzNyT0oKbVJQQUlFRUNTVngvRlZERjJXeVREQUlWanBuMENN
 Zjl1dnliVEU4Q25CNEQxcDZLNkgyZ0d0YVRlRlhJUVkraAoxcmNDY0JVNE9zZlQvWFkwZXZO
 aWpnPT0KPWFWT0YKLS0tLS1FTkQgUEdQIFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=
Message-ID: <acf40476-73d7-0620-cde2-2769b87b5b58@inliniac.net>
Date:   Tue, 2 Jun 2020 22:29:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdczH+i8+FO+eQ+OT4-bsRAKG+jacPiuRu3jMszpV_2XA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02-06-2020 22:18, Willem de Bruijn wrote:
> On Tue, Jun 2, 2020 at 4:05 PM Victor Julien <victor@inliniac.net> wrote:
>>
>> On 02-06-2020 21:38, Willem de Bruijn wrote:
>>> On Tue, Jun 2, 2020 at 3:22 PM Victor Julien <victor@inliniac.net> wrote:
>>>>
>>>> On 02-06-2020 21:03, Willem de Bruijn wrote:
>>>>> On Tue, Jun 2, 2020 at 2:31 PM Victor Julien <victor@inliniac.net> wrote:
>>>>>> On 02-06-2020 19:37, Willem de Bruijn wrote:
>>>>>>> On Tue, Jun 2, 2020 at 1:03 PM Victor Julien <victor@inliniac.net> wrote:
>>>>>>>>
>>>>>>>> On 02-06-2020 16:29, Willem de Bruijn wrote:
>>>>>>>>> On Tue, Jun 2, 2020 at 4:05 AM Victor Julien <victor@inliniac.net> wrote:
>>>>>>>>>>
>>>>>>>>>> Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
>>>>>>>>>> that the driver has completely validated the checksums in the packet.
>>>>>>>>>>
>>>>>>>>>> The TP_STATUS_CSUM_UNNECESSARY flag differs from TP_STATUS_CSUM_VALID
>>>>>>>>>> in that the new flag will only be set if all the layers are valid,
>>>>>>>>>> while TP_STATUS_CSUM_VALID is set as well if only the IP layer is valid.
>>>>>>>>>
>>>>>>>>> transport, not ip checksum.
>>>>>>>>
>>>>>>>> Allow me a n00b question: what does transport refer to here? Things like
>>>>>>>> ethernet? It isn't clear to me from the doc.
>>>>>>>
>>>>>>> The TCP/UDP/.. transport protocol checksum.
>>>>>>
>>>>>> Hmm that is what I thought originally, but then it didn't seem to work.
>>>>>> Hence my patch.
>>>>>>
>>>>>> However I just redid my testing. I took the example tpacketv3 program
>>>>>> and added the status flag checks to the 'display()' func:
>>>>>>
>>>>>>                 if (ppd->tp_status & TP_STATUS_CSUM_VALID) {
>>>>>>                         printf("TP_STATUS_CSUM_VALID, ");
>>>>>>                 }
>>>>>>                 if (ppd->tp_status & (1<<8)) {
>>>>>>                         printf("TP_STATUS_CSUM_UNNECESSARY, ");
>>>>>>
>>>>>>                 }
>>>>>>
>>>>>> Then using scapy sent some packets in 2 variants:
>>>>>> - default (good csums)
>>>>>> - deliberately bad csums
>>>>>> (then also added a few things like ip6 over ip)
>>>>>>
>>>>>>
>>>>>> srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(),
>>>>>> iface="enp1s0") // good csums
>>>>>>
>>>>>> srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(chksum=1),
>>>>>> iface="enp1s0") //bad tcp
>>>>>
>>>>> Is this a test between two machines? What is the device driver of the
>>>>> machine receiving and printing the packet? It would be helpful to know
>>>>> whether this uses CHECKSUM_COMPLETE or CHECKSUM_UNNECESSARY.
>>>>
>>>> Yes 2 machines, or actually 2 machines and a VM. The receiving Linux
>>>> sits in a kvm vm with network pass through and uses the virtio driver
>>>> (host uses e1000e). Based on a quick 'git grep CHECKSUM_UNNECESSARY'
>>>> virtio seems to support that.
>>>>
>>>> I've done some more tests. In a pcap replay that I know contains packet
>>>> with bad TCP csums (but good IP csums for those pkts), to a physical
>>>> host running Ubuntu Linux kernel 5.3:
>>>>
>>>> - receiver uses nfp (netronome) driver: TP_STATUS_CSUM_VALID set for
>>>> every packet, including the bad TCP ones
>>>> - receiver uses ixgbe driver: TP_STATUS_CSUM_VALID not set for the bad
>>>> packets.
>>>
>>> Great. Thanks a lot for running all these experiments.
>>>
>>> We might have to drop the TP_STATUS_CSUM_VALID with CHECKSUM_COMPLETE
>>> unless skb->csum_valid.
>>>
>>> For packets with multiple transport layer checksums,
>>> CHECKSUM_UNNECESSARY should mean that all have been verified.
>>>
>>> I believe that in the case of multiple transport headers, csum_valid
>>> similarly ensures all checksums up to csum_start are valid. Will need
>>> to double check.
>>>
>>> If so, there probably is no need for a separate new TP_STATUS.
>>> TP_STATUS_CSUM_VALID is reported only when all checksums are valid.
>>
>> So if I understand you correctly the key may be in the call to
>> `skb_csum_unnecessary`:
>>
>> That reads:
>>
>> static inline int skb_csum_unnecessary(const struct sk_buff *skb)
>> {
>>         return ((skb->ip_summed == CHECKSUM_UNNECESSARY) ||
>>                 skb->csum_valid ||
>>                 (skb->ip_summed == CHECKSUM_PARTIAL &&
>>                  skb_checksum_start_offset(skb) >= 0));
>> }
>>
>> But really only the first 2 conditions are reachable
> 
> .. from this codepath. That function is called in other codepaths as well.
> 
>> , as we already know
>> skb->ip_summed is not CHECKSUM_PARTIAL when we call it.
>>
>> So our unmodified check is:
>>
>>         else if (skb->pkt_type != PACKET_OUTGOING &&
>>                 (skb->ip_summed == CHECKSUM_COMPLETE ||
>>                  skb->ip_summed == CHECKSUM_UNNECESSARY ||
>>                  skb->csum_valid))
>>
>> Should this become something like:
>>
>>         else if (skb->pkt_type != PACKET_OUTGOING &&
>>                 (skb->ip_summed == CHECKSUM_COMPLETE &&
>>                  skb->csum_valid) ||
>>                  skb->ip_summed == CHECKSUM_UNNECESSARY)
>>
>> Is this what you had in mind?
> 
> I don't suggest modifying skb_csum_unnecessary probably. Certainly not
> until I've looked at all other callers of it.

Yeah didn't read it that way. Just wanted to make clear what the actual
check for afpacket is (for my own understanding mostly)

> But in case of packet sockets, yes, adding that csum_valid check is my
> first rough approximation.
> 
> That said, first let's give others more familiar with
> TP_STATUS_CSUM_VALID some time to comment.
> 

Thanks a lot for your comments.

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------


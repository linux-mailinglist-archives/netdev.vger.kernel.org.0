Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE241EC1CF
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFBSbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:31:34 -0400
Received: from static-27.netfusion.at ([83.215.238.27]:56314 "EHLO
        mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBSbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 14:31:33 -0400
Received: from [192.168.0.36] (a212-238-163-105.adsl.xs4all.nl [212.238.163.105])
        (Authenticated sender: victor)
        by mail.inliniac.net (Postfix) with ESMTPSA id 670C010C;
        Tue,  2 Jun 2020 20:33:41 +0200 (CEST)
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
Message-ID: <06479df9-9da4-dbda-5bd1-f6e4d61471d0@inliniac.net>
Date:   Tue, 2 Jun 2020 20:31:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSd07inNysGhx088hq_jybrikSQdxw8HYjmP84foXhnXOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On 02-06-2020 19:37, Willem de Bruijn wrote:
> On Tue, Jun 2, 2020 at 1:03 PM Victor Julien <victor@inliniac.net> wrote:
>>
>> On 02-06-2020 16:29, Willem de Bruijn wrote:
>>> On Tue, Jun 2, 2020 at 4:05 AM Victor Julien <victor@inliniac.net> wrote:
>>>>
>>>> Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
>>>> that the driver has completely validated the checksums in the packet.
>>>>
>>>> The TP_STATUS_CSUM_UNNECESSARY flag differs from TP_STATUS_CSUM_VALID
>>>> in that the new flag will only be set if all the layers are valid,
>>>> while TP_STATUS_CSUM_VALID is set as well if only the IP layer is valid.
>>>
>>> transport, not ip checksum.
>>
>> Allow me a n00b question: what does transport refer to here? Things like
>> ethernet? It isn't clear to me from the doc.
> 
> The TCP/UDP/.. transport protocol checksum.

Hmm that is what I thought originally, but then it didn't seem to work.
Hence my patch.

However I just redid my testing. I took the example tpacketv3 program
and added the status flag checks to the 'display()' func:

                if (ppd->tp_status & TP_STATUS_CSUM_VALID) {
                        printf("TP_STATUS_CSUM_VALID, ");
                }
                if (ppd->tp_status & (1<<8)) {
                        printf("TP_STATUS_CSUM_UNNECESSARY, ");

                }

Then using scapy sent some packets in 2 variants:
- default (good csums)
- deliberately bad csums
(then also added a few things like ip6 over ip)


srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(),
iface="enp1s0") // good csums

srp1(Ether()/IP(src="1.2.3.4", dst="5.6.7.8")/IPv6()/TCP(chksum=1),
iface="enp1s0") //bad tcp

1.2.3.4 -> 5.6.7.8, TP_STATUS_CSUM_VALID, TP_STATUS_CSUM_UNNECESSARY,
rxhash: 0x81ad5744
1.2.3.4 -> 5.6.7.8, rxhash: 0x81ad5744

So this suggests that what you're saying is correct, that it sets
TP_STATUS_CSUM_VALID if the TCP/UDP csum (and IPv4 csum) is valid, and
does not set it when either of them are invalid.

I'll also re-evaluate things in Suricata.


One thing I wonder if what this "at least" from the 682f048bd494 commit
message means:

"Introduce TP_STATUS_CSUM_VALID tp_status flag to tell the
 af_packet user that at least the transport header checksum
 has been already validated."

For TCP/UDP there wouldn't be a higher layer with csums, right? And
based on my testing it seems lower levels (at least IP) is also
included. Or would that perhaps refer to something like VXLAN or Geneve
over UDP? That the csums of packets on top of those layers aren't
(necessarily) considered?

Thanks,
Victor


>> (happy to follow up with a patch to clarify the doc when I understand
>> things better)
>>
>>> But as I understand it drivers set CHECKSUM_COMPLETE if they fill in
>>> skb->csum over the full length of the packet. This does not
>>> necessarily imply that any of the checksum fields in the packet are
>>> valid yet (see also skb->csum_valid). Protocol code later compares
>>> checksum fields against this using __skb_checksum_validate_complete and friends.
>>>
>>> But packet sockets may be called before any of this, however. So I wonder
>>> how valid the checksum really is right now when setting TP_STATUS_CSUM_VALID.
>>> I assume it's correct, but don't fully understand where the validation
>>> has taken place..
>>
>> I guess I'm more confused now about what TP_STATUS_CSUM_VALID actually
>> means. It sounds almost like the opposite of TP_STATUS_CSUMNOTREADY, but
>> I'm not sure I understand what the value would be.
>>
>> It would be great if someone could help clear this up. Everything I
>> thought I knew/understood so far has been proven wrong, so I'm not too
>> confident about my patch anymore...
> 
> Agreed that we should clear this up.
> 
>>> Similar to commit 682f048bd494 ("af_packet: pass checksum validation
>>> status to the user"), please update tpacket_rcv and packet_rcv.
>>
>> Ah yes, good catch. Will add it there as well.
>>
>>> Note also that net-next is currently closed.
>>
>> Should I hold off on sending a v3 until it reopens?
> 
> Yep, thanks. You can always check
> http://vger.kernel.org/~davem/net-next.html when unsure.
> 


-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A1F290D79
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgJPVws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730013AbgJPVwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 17:52:46 -0400
X-Greylist: delayed 347 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Oct 2020 14:52:46 PDT
Received: from rhcavspool01.kulnet.kuleuven.be (rhcavspool01.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB14C0613D4
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 14:52:46 -0700 (PDT)
Received: from rhcavuit01.kulnet.kuleuven.be (rhcavuit01.kulnet.kuleuven.be [134.58.240.129])
        by rhcavspool01.kulnet.kuleuven.be (Postfix) with ESMTP id 738746402
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 23:47:02 +0200 (CEST)
X-KULeuven-Envelope-From: mathy.vanhoef@kuleuven.be
X-Spam-Status: not spam, SpamAssassin (not cached, score=-52.019, required 5,
        autolearn=disabled, ALL_TRUSTED -1.00, LOCAL_SMTPS -50.00,
        NICE_REPLY_A -1.02)
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 1A68E120334.A0937
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-smtps-2.cc.kuleuven.be (icts-p-smtps-2e.kulnet.kuleuven.be [134.58.240.34])
        by rhcavuit01.kulnet.kuleuven.be (Postfix) with ESMTP id 1A68E120334
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 23:46:55 +0200 (CEST)
Received: from [192.168.1.16] (unknown [31.215.199.82])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by icts-p-smtps-2.cc.kuleuven.be (Postfix) with ESMTPSA id 3755E200A1;
        Fri, 16 Oct 2020 23:46:53 +0200 (CEST)
Subject: Re: [Regression 5.9][Bisected 1df2bdba528b] Wifi GTK rekeying fails:
 Sending of EAPol packages broken
To:     Thomas Deutschmann <whissi@gentoo.org>
Cc:     johannes@sipsolutions.net,
        "davem@davemloft.net" <davem@davemloft.net>, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        denkenz@gmail.com
References: <4a7f92dc-13bb-697f-1730-ac288e74b730@gentoo.org>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Autocrypt: addr=Mathy.Vanhoef@kuleuven.be; keydata=
 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
Message-ID: <caf58be6-2461-2168-1ae5-c6512ea542aa@kuleuven.be>
Date:   Sat, 17 Oct 2020 01:46:51 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4a7f92dc-13bb-697f-1730-ac288e74b730@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Thomas,

That's surprising regression, I'll try to reproduce it next week.

- Mathy

On 10/15/20 5:44 AM, Thomas Deutschmann wrote:
> Hi,
> 
> after upgrading to linux-5.9.0 I noticed that my wifi got disassociated
> every 10 minutes when access point triggered rekeying for GTK.
> 
> This happened with iwd but not with wpa_supplicant. iwd was logging
> 
>> wlan0: disassociated from aa:bb:cc:dd:ap:01 (Reason:
>> 2=PREV_AUTH_NOT_VALID)
>> wlan0: authenticate with aa:bb:cc:dd:ap:01
>> wlan0: send auth to aa:bb:cc:dd:ap:01 (try 1/3)
>> wlan0: authenticated
>> wlan0: associate with aa:bb:cc:dd:ap:01 (try 1/3)
>> wlan0: RX AssocResp from aa:bb:cc:dd:ap:01 (capab=0x1511 status=0 aid=1)
>> wlan0: associated
> 
> With the help of iwd developers (many thanks!) we noticed that EAPoL
> packets didn't reach access point. As workaround, using the legacy way
> to send EAPoL packets by setting
> 
>> [General]
>> ControlPortOverNL80211=False
> 
> in iwd's main.conf, worked. So it became clear that this is a kernel
> problem.
> 
> I now finished bisecting the kernel and
> 1df2bdba528b5a7a30f1b107b6924aa79af5e00e [1] is the first bad commit:
> 
>> commit 1df2bdba528b5a7a30f1b107b6924aa79af5e00e
>> Author: Mathy Vanhoef
>> Date:   Thu Jul 23 14:01:48 2020 +0400
>>
>>     mac80211: never drop injected frames even if normally not allowed
>>
>>     In ieee80211_tx_dequeue there is a check to see if the dequeued frame
>>     is allowed in the current state. Injected frames that are normally
>>     not allowed are being be dropped here. Fix this by checking if a
>>     frame was injected and if so always allowing it.
>>
>>     Signed-off-by: Mathy Vanhoef
>>     Link:
>> https://lore.kernel.org/r/20200723100153.31631-1-Mathy.Vanhoef@kuleuven.be
>>
>>     Signed-off-by: Johannes Berg
>>
>>  net/mac80211/tx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Complete bisect log:
> 
>> git bisect start
>> # good: [665c6ff082e214537beef2e39ec366cddf446d52] Linux 5.8.15
>> git bisect good 665c6ff082e214537beef2e39ec366cddf446d52
>> # bad: [bbf5c979011a099af5dc76498918ed7df445635b] Linux 5.9
>> git bisect bad bbf5c979011a099af5dc76498918ed7df445635b
>> # good: [bcf876870b95592b52519ed4aafcf9d95999bc9c] Linux 5.8
>> git bisect good bcf876870b95592b52519ed4aafcf9d95999bc9c
>> # bad: [47ec5303d73ea344e84f46660fff693c57641386] Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
>> git bisect bad 47ec5303d73ea344e84f46660fff693c57641386
>> # good: [8f7be6291529011a58856bf178f52ed5751c68ac] Merge tag
>> 'mmc-v5.9' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc
>> git bisect good 8f7be6291529011a58856bf178f52ed5751c68ac
>> # bad: [76769c38b45d94f5492ff9be363ac7007fd8e58b] Merge tag
>> 'mlx5-updates-2020-08-03' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
>> git bisect bad 76769c38b45d94f5492ff9be363ac7007fd8e58b
>> # good: [94d9f78f4d64b967273a676167bd34ddad2f978c] docs: networking:
>> timestamping: add section for stacked PHC devices
>> git bisect good 94d9f78f4d64b967273a676167bd34ddad2f978c
>> # good: [5ee30564c85c94b7dc78aa6cce09e9712b2ad70d] ice: update
>> reporting of autoneg capabilities
>> git bisect good 5ee30564c85c94b7dc78aa6cce09e9712b2ad70d
>> # good: [bd69058f50d5ffa659423bcfa6fe6280ce9c760a] net: ll_temac: Use
>> devm_platform_ioremap_resource_byname()
>> git bisect good bd69058f50d5ffa659423bcfa6fe6280ce9c760a
>> # skip: [7dbc63f0a5402293e887e89a7974c5e48405565d] ice: Misc minor fixes
>> git bisect skip 7dbc63f0a5402293e887e89a7974c5e48405565d
>> # good: [1303a51c24100b3b1915d6f9072fe5ae5bb4c5f6] cfg80211/mac80211:
>> add connected to auth server to station info
>> git bisect good 1303a51c24100b3b1915d6f9072fe5ae5bb4c5f6
>> # skip: [f34f55557ac9a4dfbfbf36c70585d1648ab5cd90] ice: Allow 2 queue
>> pairs per VF on SR-IOV initialization
>> git bisect skip f34f55557ac9a4dfbfbf36c70585d1648ab5cd90
>> # bad: [cc5d229a122106733a85c279d89d7703f21e4d4f] fsl/fman: check
>> dereferencing null pointer
>> git bisect bad cc5d229a122106733a85c279d89d7703f21e4d4f
>> # good: [6fc8c827dd4fa615965c4eac9bbfd465f6eb8fb4] tcp: syncookies:
>> create mptcp request socket for ACK cookies with MPTCP option
>> git bisect good 6fc8c827dd4fa615965c4eac9bbfd465f6eb8fb4
>> # bad: [b90a1269184a3ff374562d243419ad2fa9d3b1aa] Merge branch
>> 'net-openvswitch-masks-cache-enhancements'
>> git bisect bad b90a1269184a3ff374562d243419ad2fa9d3b1aa
>> # skip: [829eb208e80d6db95c0201cb8fa00c2f9ad87faf] rtnetlink: add
>> support for protodown reason
>> git bisect skip 829eb208e80d6db95c0201cb8fa00c2f9ad87faf
>> # bad: [0e8642cf369a37b718c15effa6ffd52c00fd7d15] tcp: fix build fong
>> CONFIG_MPTCP=n
>> git bisect bad 0e8642cf369a37b718c15effa6ffd52c00fd7d15
>> # skip: [48040793fa6003d211f021c6ad273477bcd90d91] tcp: add earliest
>> departure time to SCM_TIMESTAMPING_OPT_STATS
>> git bisect skip 48040793fa6003d211f021c6ad273477bcd90d91
>> # good: [bc5cbd73eb493944b8665dc517f684c40eb18a4a] iavf: use generic
>> power management
>> git bisect good bc5cbd73eb493944b8665dc517f684c40eb18a4a
>> # skip: [8f3f330da28ede9d106cd9d5c5ccd6a3e7e9b50b] tun: add missing
>> rcu annotation in tun_set_ebpf()
>> git bisect skip 8f3f330da28ede9d106cd9d5c5ccd6a3e7e9b50b
>> # skip: [9466a1ccebbe54ac57fb8a89c2b4b854826546a8] mptcp: enable JOIN
>> requests even if cookies are in use
>> git bisect skip 9466a1ccebbe54ac57fb8a89c2b4b854826546a8
>> # good: [09a071f52bbedddef626e71c0fd210838532f347] Documentation:
>> intel: Replace HTTP links with HTTPS ones
>> git bisect good 09a071f52bbedddef626e71c0fd210838532f347
>> # bad: [75e6b594bbaeeb3f8287a2e6eb8811384b8c7195] cfg80211: invert HE
>> BSS color 'disabled' to 'enabled'
>> git bisect bad 75e6b594bbaeeb3f8287a2e6eb8811384b8c7195
>> # bad: [1df2bdba528b5a7a30f1b107b6924aa79af5e00e] mac80211: never drop
>> injected frames even if normally not allowed
>> git bisect bad 1df2bdba528b5a7a30f1b107b6924aa79af5e00e
>> # good: [180ac48ee62f53c26787350a956c5ac371cbe0b7] mac80211: calculate
>> skb hash early when using itxq
>> git bisect good 180ac48ee62f53c26787350a956c5ac371cbe0b7
>> # good: [322cd27c06450b2db2cb6bdc68f3814149baf767] cfg80211/mac80211:
>> avoid bss color setting in non-HE modes
>> git bisect good 322cd27c06450b2db2cb6bdc68f3814149baf767
>> # good: [fd17dba1c860d39f655a3a08387c21e3ceca8c55] cfg80211: Add
>> support to advertize OCV support
>> git bisect good fd17dba1c860d39f655a3a08387c21e3ceca8c55
>> # first bad commit: [1df2bdba528b5a7a30f1b107b6924aa79af5e00e]
>> mac80211: never drop injected frames even if normally not allowed
> 
> 
> See also:
> =========
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1df2bdba528b5a7a30f1b107b6924aa79af5e00e
> 
> 
> 

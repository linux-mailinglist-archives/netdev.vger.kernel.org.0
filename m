Return-Path: <netdev+bounces-7327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1B571FB16
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C4551C20B3C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F2879D4;
	Fri,  2 Jun 2023 07:36:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAEB2F33
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:36:36 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EF1B1B9;
	Fri,  2 Jun 2023 00:36:22 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.116])
	by gateway (Coremail) with SMTP id _____8AxXuv1m3lk1YsDAA--.3320S3;
	Fri, 02 Jun 2023 15:36:21 +0800 (CST)
Received: from [10.20.42.116] (unknown [10.20.42.116])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dx_8vzm3lksIiFAA--.19512S3;
	Fri, 02 Jun 2023 15:36:19 +0800 (CST)
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
To: Liu Peibao <liupeibao@loongson.cn>,
 Vladimir Oltean <vladimir.oltean@nxp.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
 Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
 Claudiu Manoil <claudiu.manoil@nxp.com>, Michael Walle <michael@walle.cc>,
 linux-kernel@vger.kernel.org, Binbin Zhou <zhoubinbin@loongson.cn>,
 Huacai Chen <chenhuacai@loongson.cn>
References: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>
 <ZHjaq+TDW/RFcoxW@bhelgaas> <20230601221532.2rfcda4sg5nl7pzp@skbuf>
 <dc430271-8511-e6e4-041b-ede197e7665d@loongson.cn>
From: Jianmin Lv <lvjianmin@loongson.cn>
Message-ID: <7a7f78ae-7fd8-b68d-691c-609a38ab3161@loongson.cn>
Date: Fri, 2 Jun 2023 15:36:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <dc430271-8511-e6e4-041b-ede197e7665d@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dx_8vzm3lksIiFAA--.19512S3
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3GFWxXF17Cr4UCF13Xr1kXwb_yoW3ArW3pF
	W5ta92kF4DJF4aywnFvw45ury0yrWkJ3sxXrn8J34UC398ur1Sqr4xtr4j9a4Uur4kKw12
	qFWrtryxCF4qyaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
	bakYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
	1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
	x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2
	IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487Mx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1D
	MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
	AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
	cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
	80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIF
	yTuYvjxU7_MaUUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/2 下午3:21, Liu Peibao wrote:
> Hi all,
> 
> It seems that modification for current PCI enumeration framework is
> needed to solve the problem. If the effect of this modification is not
> easy to evaluate, for the requirement of Loongson, it should be OK that
> do the things in Loongson PCI controller driver like discussed
> before[1].
> 
> Br,
> Peibao
> 
> [1] https://lore.kernel.org/all/20221114074346.23008-1-liupeibao@loongson.cn/
> 

Agree. For current pci core code, all functions of the device will be 
skipped if function 0 is not found, even without the patch 6fffbc7ae137 
(e.g. the func 0 is disabled in bios by setting pci header to 
0xffffffff). So it seems that there are two ways for the issue:

1. Adjust the pci scan core code to allow separate function to be 
enumerated, which will affect widely the pci core code.
2. Only Adjust loongson pci controller driver as Peibao said, and any 
function of the device should use platform device in DT if function 0 is 
disabled, which is acceptable for loongson.

Thanks,
Jianmin

> On 6/2/23 6:15 AM, Vladimir Oltean wrote:
>> On Thu, Jun 01, 2023 at 12:51:39PM -0500, Bjorn Helgaas wrote:
>>>>> Doing it in Linux would minimize dependences on the bootloader, so
>>>>> that seems desirable to me. That means Linux needs to enumerate
>>>>> Function 0 so it is visible to a driver or possibly a quirk.
>>>>
>>>> Uhm... no, that wouldn't be enough. Only a straight revert would satisfy
>>>> the workaround that we currently have for NXP ENETC in Linux.
>>>
>>> I guess you mean a revert of 6fffbc7ae137?
>>
>> Yes.
>>
>>> This whole conversation is about whether we can rework 6fffbc7ae137 to
>>> work both for Loongson and for you, so nothing is decided yet.
>>
>> After reading
>> https://lore.kernel.org/linux-pci/20221117020935.32086-1-liupeibao@loongson.cn/
>> and
>> https://lore.kernel.org/linux-pci/20221103090040.836-1-liupeibao@loongson.cn/
>> and seeing the GMAC OF node at arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi,
>> I believe that a solution that would work for both Loongson and NXP would be to:
>>
>> - patch loongson_dwmac_probe() to check for of_device_is_available()
>> - revert commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled
>>    status")
>>
>> I'm not sure what else of what was concretely proposed would work.
>> Anything else is just wishful thinking that the PCI core can start
>> enforcing a central policy, after letting device drivers get to choose
>> how (and whether) to treat the "status" OF property for years on end.
>>
>> As an added benefit, the disabled GMAC would become visible in lspci for
>> the Loongson SoC.
>>
>>> The point is, I assume you agree that it's preferable if we don't have
>>> to depend on a bootloader to clear the memory.
>>
>> I am confused by the message you are transmitting here.
>>
>> With my user hat on, yes, maintaining the effect of commit 3222b5b613db
>> from Linux is preferable.
>>
>> Although Rob will probably not be happy about the way in which that will
>> be achieved. And you haven't proposed ways in which that would remain
>> possible, short of a revert of commit 6fffbc7ae137.
>>
>>> After 6fffbc7ae137, the probe function is not called if the device is
>>> disabled in DT because there's no pci_dev for it at all.
>>
>> Correct, but commit 3222b5b613db pre-dates it by 2 years, and thus, it
>> is broken by Rob's change.
>>
>>>> My problem is that I don't really understand what was the functional
>>>> need for commit 6fffbc7ae137 ("PCI: Honor firmware's device disabled
>>>> status") in the first place, considering that any device driver can
>>>> already fail to probe based on the same condition at its own will.
>>>
>>> In general, PCI drivers shouldn't rely on DT.  If the bus driver (PCI
>>> in this case) calls a driver's probe function, the driver can assume
>>> the device exists.
>>
>> Well, the device exists...
>>
>>> But enetc is not a general-purpose driver, and if DT is the only way
>>> to discover this property, I guess you're stuck doing that.
>>
>> So what Loongson tried to do - break enumeration of the on-chip GMAC
>> PCIe device at the level of the PCIe controller, if the GMAC's pinmuxing
>> doesn't make it available for networking - is encouraged?
>>
>> Do you consider that their patch would have been better in the original
>> form, if instead of the "skip-scan" property, they would have built some
>> smarts into drivers/pci/controller/pci-loongson.c which would intentionally
>> break config space access to gmac@3,0, without requiring OF to specify this?
>>
>> Are you saying that this "present but unusable due to pinmuxing" is an
>> incorrect use of status = "disabled"? What would it constitute correct
>> use of, then?
>>
>> The analogous situation for ENETC would be to patch the "pci-host-ecam-generic"
>> driver to read the SERDES and pinmuxing configuration of the SoC, and to
>> mask/unmask the config access to function 0 based on that. I mean - I could...
>> but is it really a good idea? The principle of separation of concerns
>> tells me no. The fact that the pinmuxing of the device makes it unavailable
>> pertains to the IP-specific logic, it doesn't change whether it's enumerable
>> or accessible on its bus.
>>
>>>>> Is DT the only way to learn the NXP SERDES configuration?  I think it
>>>>> would be much better if there were a way to programmatically learn it,
>>>>> because then you wouldn't have to worry about syncing the DT with the
>>>>> platform configuration, and it would decouple this from the Loongson
>>>>> situation.
>>>>
>>>> Syncing the DT with the platform configuration will always be necessary,
>>>> because for networking we will also need extra information which is
>>>> completely non-discoverable, like a phy-handle or such, and that depends
>>>> on the wiring and static pinmuxing of the SoC. So it is practically
>>>> reasonable to expect that what is usable has status = "okay", and what
>>>> isn't has status = "disabled". Not to mention, there are already device
>>>> trees in circulation which are written that way, and those need to
>>>> continue to work.
>>>
>>> Just because we need DT for non-discoverable info A doesn't mean we
>>> should depend on it for B if B *is* discoverable.
>>
>> But the argument was: we already have device trees with a certain
>> convention, and that is to expect having status = "disabled" for
>> unusable ports. I don't believe that changing that is realistically in
>> scope for fixing this. And if we have device trees with status =
>> "disabled" in circulation which we (I) don't want to break, then we're
>> back to square 1 regarding the probing of disabled devices.
>>
>>> This question of disabling a device via DT but still needing to do
>>> things to the device is ... kind of a sticky wicket.
>>
>> It boils down to whether accessing a disabled device is permitted or
>> not. I opened the devicetree specification and it didn't say anything
>> conclusive. Though it's certainly above my pay grade to say anything
>> with certainty in this area. Apart from "okay" and "disabled", "status"
>> takes other documented values too, like "reserved", "fail" and
>> "fail-sss". Linux treats everything that's not "okay" the same.
>> Krzysztof Kozlowski came with the suggestion for Loongson to replace
>> "skip-scan" with "status", during the review of their v1 patch.
>>
>> In any case, that question will only recur one level lower - in U-Boot,
>> where we make an effort to keep device trees in sync in Linux. Why would
>> U-Boot need to do things to a disabled device? :)
>>
>>> Maybe this should be a different DT property (not "status").  Then PCI
>>> enumeration could work normally and 6fffbc7ae137 wouldn't be in the
>>> way.
>>
>> I'm not quite sure where you're going with this. More concretely?
>>



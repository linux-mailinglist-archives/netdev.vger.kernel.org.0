Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95BE1C2966
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgECC3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:29:22 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:35058 "EHLO johanna1.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbgECC3W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 May 2020 22:29:22 -0400
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgeduhedrjedtgdehgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfupfevtfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffhvfhfkffffgggjggtgfesthekredttdefjeenucfhrhhomhepnfgruhhrihculfgrkhhkuhcuoehlrghurhhirdhjrghkkhhusehpphdrihhnvghtrdhfiheqnecuggftrfgrthhtvghrnhepfeeljedtveffteejhfekveekjeevudeijeeuuefgfefftdeuheetffdtvedugedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdrihhnnecukfhppeekgedrvdegkedrfedtrdduleehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplgduledvrdduieekrddurddufeehngdpihhnvghtpeekgedrvdegkedrfedtrdduleehpdhmrghilhhfrhhomhepoehlrghujhgrkhdqfeesmhgsohigrdhinhgvthdrfhhiqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeohhhkrghllhifvghithdusehgmhgrihhlrdgtohhmqedprhgtphhtthhopeeolhgvohhnsehkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehnihgtpghsfihsugesrhgvrghlthgvkhdrtghomheq
Received: from [192.168.1.135] (84.248.30.195) by johanna1.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E1C39AA507E49F8; Sun, 3 May 2020 05:28:59 +0300
Subject: Re: NET: r8168/r8169 identifying fix
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <8db3cdc1-b63d-9028-e4bd-659e6d213f8f@pp.inet.fi>
 <2f7aeeb2-2a19-da7c-7436-71203a29f9e8@gmail.com>
 <d9781ac2-c7b7-0399-578e-cc43c4629147@pp.inet.fi>
 <04107d6d-d07b-7589-0cef-0d39d86484f3@pp.inet.fi>
 <b9a31f5a-e140-5cd4-d7aa-21a2fa2c27a0@gmail.com>
 <de1bf1a4-8ce3-3352-3ff6-339206fa871e@pp.inet.fi>
 <a940416a-2cc9-c27b-1660-df19273b7478@pp.inet.fi>
 <ae6fe5f1-d7d5-c0ca-a206-48940ee80681@pp.inet.fi>
 <303643ef-91b1-462a-5ecd-6217ca7b325f@pp.inet.fi>
 <db508b70-e5fb-2abf-8012-c168fe7535a7@pp.inet.fi>
 <f3faeea9-13b7-d6ca-7cce-6ec0278d7437@pp.inet.fi>
 <2c9b8110-3be9-28d8-a5e1-729686fe6f12@gmail.com>
 <2359c10c-0f62-c12a-645b-b7f9db315fc4@pp.inet.fi>
 <7deca6c4-90f4-3030-1284-0be33990d0f0@pp.inet.fi>
 <5cdc7f73-b109-2a37-8473-12889506b6a9@pp.inet.fi>
 <d3d950f5-f33f-8bc4-f696-ae68ed936cc0@gmail.com>
 <46c69f39-278c-405f-3557-c21ee2ccd8e5@pp.inet.fi>
 <b2b48c49-2f9f-57fb-ab2f-5eadac3aa403@pp.inet.fi>
Message-ID: <d047c73c-7781-40f7-3f2b-6bdcc307e6f5@pp.inet.fi>
Date:   Sun, 3 May 2020 05:28:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b2b48c49-2f9f-57fb-ab2f-5eadac3aa403@pp.inet.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3.5.2020 4.34, Lauri Jakku wrote:
> Hi,
>
>
> On 3.5.2020 3.11, Lauri Jakku wrote:
>>
>> On 3.5.2020 2.15, Heiner Kallweit wrote:
>>> On 03.05.2020 00:42, Lauri Jakku wrote:
>>>> Hi,
>>>>
>>>>
>>>>
>>>> On 2.5.2020 20.56, Lauri Jakku wrote:
>>>>> Hi,
>>>>>
>>>>> On 1.5.2020 22.12, Lauri Jakku wrote:
>>>>>> Hi,
>>>>>>
>>>>>>
>>>>>> On 19.4.2020 19.00, Heiner Kallweit wrote:
>>>>>>> On 19.04.2020 18:49, Lauri Jakku wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 19.4.2020 18.09, Lauri Jakku wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> On 18.4.2020 21.46, Lauri Jakku wrote:
>>>>>>>>>
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> On 18.4.2020 14.06, Lauri Jakku wrote:
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> On 17.4.2020 10.30, Lauri Jakku wrote:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> On 17.4.2020 9.23, Lauri Jakku wrote:
>>>>>>>>>>>>> On 16.4.2020 23.50, Heiner Kallweit wrote:
>>>>>>>>>>>>>> On 16.04.2020 22:38, Lauri Jakku wrote:
>>>>>>>>>>>>>>> Hi
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 16.4.2020 23.10, Lauri Jakku wrote:
>>>>>>>>>>>>>>>> On 16.4.2020 23.02, Heiner Kallweit wrote:
>>>>>>>>>>>>>>>>> On 16.04.2020 21:58, Lauri Jakku wrote:
>>>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> On 16.4.2020 21.37, Lauri Jakku wrote:
>>>>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> On 16.4.2020 21.26, Heiner Kallweit wrote:
>>>>>>>>>>>>>>>>>>>> On 16.04.2020 13:30, Lauri Jakku wrote:
>>>>>>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> 5.6.3-2-MANJARO: stock manjaro kernel, without 
>>>>>>>>>>>>>>>>>>>>> modifications --> network does not work
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> 5.6.3-2-MANJARO-lja: No attach check, modified 
>>>>>>>>>>>>>>>>>>>>> kernel (r8169 mods only) --> network does not work
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> 5.6.3-2-MANJARO-with-the-r8169-patch: phy patched 
>>>>>>>>>>>>>>>>>>>>> + r8169 mods -> devices show up ok, network works
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> All different initcpio's have realtek.ko in them.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> Thanks for the logs. Based on the logs you're 
>>>>>>>>>>>>>>>>>>>> presumable affected by a known BIOS bug.
>>>>>>>>>>>>>>>>>>>> Check bug tickets 202275 and 207203 at 
>>>>>>>>>>>>>>>>>>>> bugzilla.kernel.org.
>>>>>>>>>>>>>>>>>>>> In the first referenced tickets it's about the same 
>>>>>>>>>>>>>>>>>>>> mainboard (with earlier BIOS version).
>>>>>>>>>>>>>>>>>>>> BIOS on this mainboard seems to not initialize the 
>>>>>>>>>>>>>>>>>>>> network chip / PHY correctly, it reports
>>>>>>>>>>>>>>>>>>>> a random number as PHY ID, resulting in no PHY 
>>>>>>>>>>>>>>>>>>>> driver being found.
>>>>>>>>>>>>>>>>>>>> Enable "Onboard LAN Boot ROM" in the BIOS, and your 
>>>>>>>>>>>>>>>>>>>> problem should be gone.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> OK, I try that, thank you :)
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> It seems that i DO have the ROM's enabled, i'm now 
>>>>>>>>>>>>>>>>>> testing some mutex guard for phy state and try to use 
>>>>>>>>>>>>>>>>>> it as indicator
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> that attach has been done. One thing i've noticed is 
>>>>>>>>>>>>>>>>>> that driver needs to be reloaded to allow traffic 
>>>>>>>>>>>>>>>>>> (ie. ping works etc.)
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> All that shouldn't be needed. Just check with which 
>>>>>>>>>>>>>>>>> PHY ID the PHY comes up.
>>>>>>>>>>>>>>>>> And what do you mean with "it seems"? Is the option 
>>>>>>>>>>>>>>>>> enabled or not?
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I do have ROM's enabled, and it does not help with my 
>>>>>>>>>>>>>>>> issue.
>>>>>>>>>>>>>> Your BIOS is a beta version, downgrading to F7 may help. 
>>>>>>>>>>>>>> Then you have the same
>>>>>>>>>>>>>> mainboard + BIOS as the user who opened bug ticket 202275.
>>>>>>>>>>>>>>
>>>>>>>>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>>> 0000:03:00.0: PHY version: 0xc2077002
>>>>>>>>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>>> 0000:03:00.0: MAC version: 23
>>>>>>>>>>>>>
>>>>>>>>>>>>> ....
>>>>>>>>>>>>>
>>>>>>>>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>>> 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>>>>>>>
>>>>>>>>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>>> 0000:02:00.0: MAC version: 23
>>>>>>>>>>>>>
>>>>>>>>>>>>> .. after module unload & load cycle:
>>>>>>>>>>>>>
>>>>>>>>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>>> 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>>> 0000:02:00.0: MAC version: 23
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> it seem to be the case that the phy_id chances onetime, 
>>>>>>>>>>>>> then stays the same. I'll do few shutdowns and see
>>>>>>>>>>>>>
>>>>>>>>>>>>> is there a pattern at all .. next i'm going to try how it 
>>>>>>>>>>>>> behaves, if i read mac/phy versions twice on MAC version 23.
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> The BIOS downgrade: I'd like to solve this without 
>>>>>>>>>>>>> downgrading BIOS. If I can't, then I'll do systemd-service 
>>>>>>>>>>>>> that
>>>>>>>>>>>>>
>>>>>>>>>>>>> reloads r8169 driver at boot, cause then network is just 
>>>>>>>>>>>>> fine.
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>> What i've gathered samples now, there is three values for 
>>>>>>>>>>>> PHY ID:
>>>>>>>>>>>>
>>>>>>>>>>>> [sillyme@MinistryOfSillyWalk KernelStuff]$ sudo journalctl 
>>>>>>>>>>>> |grep "PHY ver"
>>>>>>>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0xc2077002
>>>>>>>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0xc2077002
>>>>>>>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 09:24:53 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0xc1071002
>>>>>>>>>>>> huhti 17 09:24:53 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0xc1071002
>>>>>>>>>>>> huhti 17 09:27:59 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 09:27:59 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 10:08:42 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0xc1071002
>>>>>>>>>>>> huhti 17 10:08:42 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0xc1071002
>>>>>>>>>>>> huhti 17 10:12:07 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 10:12:07 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 10:20:35 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0xc1071002
>>>>>>>>>>>> huhti 17 10:20:35 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0xc1071002
>>>>>>>>>>>> huhti 17 10:23:46 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>>>>>> huhti 17 10:23:46 MinistryOfSillyWalk kernel: r8169 
>>>>>>>>>>>> 0000:03:00.0: PHY version: 0x1cc912
>>>>>>>>>>>>
>>>>>>>>>>>> I dont know are those hard coded or what, and are they 
>>>>>>>>>>>> device specific how much.
>>>>>>>>>>>>
>>>>>>>>>>>> i haven't coldbooted things up, that may be that something 
>>>>>>>>>>>> to check do they vary how per coldboot.
>>>>>>>>>>>>
>>>>>>>>>>>>>>> I check the ID, and revert all other changes, and check 
>>>>>>>>>>>>>>> how it is working after adding the PHY id to list.
>>>>>>>>>>>>>>>
>>>>>>>>>>> What i've now learned: the patch + script + journald 
>>>>>>>>>>> services -> Results working network, but it is still a 
>>>>>>>>>>> workaround.
>>>>>>>>>>>
>>>>>>>>>> Following patch trusts the MAC version, another thing witch 
>>>>>>>>>> could help is to derive method to do 2dn pass of the probeing:
>>>>>>>>>>
>>>>>>>>>> if specific MAC version is found.
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c 
>>>>>>>>>> b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>> index acd122a88d4a..62b37a1abc24 100644
>>>>>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>> @@ -5172,13 +5172,18 @@ static int r8169_mdio_register(struct 
>>>>>>>>>> rtl8169_private *tp)
>>>>>>>>>>           if (!tp->phydev) {
>>>>>>>>>>                   mdiobus_unregister(new_bus);
>>>>>>>>>>                   return -ENODEV;
>>>>>>>>>> -       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>>>>>>>>> -               /* Most chip versions fail with the genphy 
>>>>>>>>>> driver.
>>>>>>>>>> -                * Therefore ensure that the dedicated PHY 
>>>>>>>>>> driver is loaded.
>>>>>>>>>> -                */
>>>>>>>>>> -               dev_err(&pdev->dev, "Not known MAC version.\n");
>>>>>>>>>> -               mdiobus_unregister(new_bus);
>>>>>>>>>> -               return -EUNATCH;
>>>>>>>>>> +       } else {
>>>>>>>>>> +               dev_info(&pdev->dev, "PHY version: 0x%x\n", 
>>>>>>>>>> tp->phydev->phy_id);
>>>>>>>>>> +               dev_info(&pdev->dev, "MAC version: %d\n", 
>>>>>>>>>> tp->mac_version);
>>>>>>>>>> +
>>>>>>>>>> +               if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>>>>>>>>> +                       /* Most chip versions fail with the 
>>>>>>>>>> genphy driver.
>>>>>>>>>> +                        * Therefore ensure that the 
>>>>>>>>>> dedicated PHY driver is loaded.
>>>>>>>>>> +                        */
>>>>>>>>>> + dev_err(&pdev->dev, "Not known MAC/PHY version.\n", 
>>>>>>>>>> tp->phydev->phy_id);
>>>>>>>>>> + mdiobus_unregister(new_bus);
>>>>>>>>>> +                       return -EUNATCH;
>>>>>>>>>> +               }
>>>>>>>>>>           }
>>>>>>>>>>
>>>>>>>>>>           /* PHY will be woken up in rtl_open() */
>>>>>>>>>>
>>>>>>>>> I just got bleeding edge 5.7.0-1 kernel compiled + firmware's 
>>>>>>>>> updated.. and  now up'n'running. There is one (WARN_ONCE) 
>>>>>>>>> stack trace coming from driver, i think i tinker with it next, 
>>>>>>>>> with above patch the network devices shows up and they can be 
>>>>>>>>> configured.
>>>>>>>>>
>>>>>>>> I tought to ask first, before going to make new probe_type for 
>>>>>>>> errorneus hw (propetype + retry counter) to do re-probe if 
>>>>>>>> requested, N times. Or should the r8169_main.c return deferred 
>>>>>>>> probe on error on some MAC enums ? Which approach is 
>>>>>>>> design-wise sound ?
>>>>>>>>
>>>>>>>> I just tought that the DEFERRED probe may just do the trick i'm 
>>>>>>>> looking ways to implement the re-probeing... hmm. I try the 
>>>>>>>> deferred thing and check would that help.
>>>>>>>>
>>>>>>> Playing with options to work around the issue is of course a 
>>>>>>> great way to
>>>>>>> learn about the kernel. However it's questionable whether a 
>>>>>>> workaround in
>>>>>>> the driver is acceptable for dealing with the broken BIOS of 
>>>>>>> exactly one
>>>>>>>> 10 yrs old board (for which even a userspace workaround exists).
>>>>>> problem recognized: libphy-module get's unloaded for some reason 
>>>>>> before r8169 driver loads -> missing lowlevel functionality -> 
>>>>>> not working driver. This only occurs at 1st load of module.. 
>>>>>> seeking solution.
>>>>>>
>>>>>>
>>>>>> There is [last unloaded: libphy] entries in log BEFORE r8169 is 
>>>>>> probed first time.
>>>>>>
>>>>>>
>>>>>> Any clue what is responsible for unloading to occur ?
>>>>>>
>>>>>>
>>>>> Right now I'm debugging what is the reason, behind that the module 
>>>>> starts to work properly only when
>>>>>
>>>>> unload & reload cycle is done.
>>>>>
>>>>>
>>>>> The libphy is listed as loaded, but the check for low level 
>>>>> read/write function is not set -> r8169 modules rlt_open() fails.
>>>>>
>>>>> See here:
>>>>>
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: ------------[ cut 
>>>>> here ]------------
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: read_page callback 
>>>>> not available, PHY driver not loaded?
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: WARNING: CPU: 3 PID: 
>>>>> 787 at drivers/net/phy/phy-core.c:750 phy_save_page+0xb1/0xe3 [libph
>>>>> y]
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: Modules linked in: 
>>>>> cmac algif_hash algif_skcipher af_alg bnep btusb btrtl btbcm 
>>>>> btintel b
>>>>> luetooth ecdh_generic rfkill ecc uvcvideo videobuf2_vmalloc 
>>>>> videobuf2_memops snd_usb_audio videobuf2_v4l2 videobuf2_common 
>>>>> snd_usbmidi_
>>>>> lib videodev snd_rawmidi snd_seq_device mc input_leds joydev 
>>>>> mousedev squashfs loop amdgpu snd_hda_codec_realtek gpu_sched 
>>>>> i2c_algo_bit
>>>>>   ttm snd_hda_codec_generic drm_kms_helper edac_mce_amd 
>>>>> ledtrig_audio cec rc_core kvm_amd drm ccp snd_hda_codec_hdmi 
>>>>> agpgart rng_core kv
>>>>> m snd_hda_intel syscopyarea sysfillrect ppdev sysimgblt 
>>>>> snd_intel_dspcfg fb_sys_fops snd_hda_codec snd_hda_core snd_hwdep 
>>>>> irqbypass wmi
>>>>> _bmof snd_pcm snd_timer snd evdev pcspkr soundcore parport_pc 
>>>>> parport sp5100_tco mac_hid i2c_piix4 k10temp acpi_cpufreq uinput 
>>>>> crypto_u
>>>>> ser ip_tables x_tables hid_generic usbhid hid ohci_pci virtio_net 
>>>>> net_failover failover firewire_ohci firewire_core crc_itu_t pata_atii
>>>>> xp ehci_pci ehci_hcd sr_mod cdrom ohci_hcd ata_generic pata_acpi 
>>>>> pata_jmicron wmi floppy
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel:  r8169 realtek libphy
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: CPU: 3 PID: 787 
>>>>> Comm: NetworkManager Not tainted 5.7.0-1-raw #12
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: Hardware name: 
>>>>> Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, 
>>>>> BIOS F8l 07/15/2010
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: RIP: 
>>>>> 0010:phy_save_page+0xb1/0xe3 [libphy]
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: Code: c8 82 11 c0 e8 
>>>>> 06 28 ff cc 85 db 74 47 48 8b 85 48 03 00 00 48 83 b8 68 01 00 00 
>>>>> 00 75 10 48 c7 c7 e8 82 11 c0 e8 a9 dd f7 cc <0f> 0b eb 26 48 c7 
>>>>> c7 52 78 11 c0 e8 99 dd f7 cc 0f 0b 48 8b 85 48
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: RSP: 
>>>>> 0018:ffff962c408ef370 EFLAGS: 00010282
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: RAX: 
>>>>> 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>>>>> touko 02 20:40:04 MinistryOfSillyWalk kernel: RDX: 
>>>>> 0000000000000001 RSI: 0000000000000092 RDI: 00000000ffffffff
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: RBP: 
>>>>> ffff8b1af3eb8800 R08: 00000000000004b3 R09: 0000000000000004
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: R10: 
>>>>> 0000000000000000 R11: 0000000000000001 R12: 00000000ffffffa1
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: R13: 
>>>>> 0000000000000002 R14: 0000000000000002 R15: ffff8b1af3eb8800
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: FS: 
>>>>> 00007f07be5d4d80(0000) GS:ffff8b1af7cc0000(0000) 
>>>>> knlGS:0000000000000000
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: CS:  0010 DS: 0000 
>>>>> ES: 0000 CR0: 0000000080050033
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: CR2: 
>>>>> 000055b83aecb008 CR3: 00000002246b0000 CR4: 00000000000006e0
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: Call Trace:
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: 
>>>>> phy_select_page+0x53/0x7a [libphy]
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: 
>>>>> phy_write_paged+0x5c/0xa0 [libphy]
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: 
>>>>> rtl8168d_1_hw_phy_config+0x9d/0x210 [r8169]
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: 
>>>>> rtl8169_init_phy+0x19/0x110 [r8169]
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: rtl_open+0x354/0x4d0 
>>>>> [r8169]
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: __dev_open+0xe0/0x170
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: 
>>>>> __dev_change_flags+0x188/0x1e0
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: 
>>>>> dev_change_flags+0x21/0x60
>>>>> touko 02 20:40:05 MinistryOfSillyWalk kernel: do_setlink+0x78a/0xfd0
>>>>>
>>>>>
>>>>> Something does not setup/register properly at first the way it 
>>>>> should.
>>>>>
>>>>>
>>>> I think i solved it: realtek (the phy driver) was missing device 
>>>> entry for the PHY ID reported by the NIC to match -> read_page and 
>>>> write_page function pointers should now be set. The generic PHY 
>>>> does not fill
>>>>
>>>> the driver's functionality to read or write pages. It happens to be 
>>>> so that the drivers for |RTL8211B Gigabit Ethernet seems to work 
>>>> just fine for my NIC's.
>>> The analysis is wrong. The incorrect PHY ID is not root cause of the
>>> problem, it's caused by a BIOS bug. It's not a valid PHY ID. If you 
>>> want
>>> to do something, then you could try to inject a PHY soft reset before
>>> the MII bus is registered. This should be board-specific, e.g. using
>>> dmi_check_system().
>>
>> Ok, i'll try that approach, thanks for the tip. Hmm, I'll do similar 
>> function mapping what the HW init/config function does determine
>>
>> function to use.
>>
>>
>> I'll get back to you when I got something new developed.
>>
> Oujeah, now it works OK.. the soft reset was all it needed.
>
>
> Here's the patch:
>
> From 06c5deacf3ca9f9258431756a41ff0ba1792f1f7 Mon Sep 17 00:00:00 2001
> From: Lauri Jakku <lja@iki.fi>
> Date: Thu, 16 Apr 2020 00:38:51 +0300
> Subject: [PATCH] NET: r8169 driver identifying improvement.
>
> Trust device MAC enum + r8169d NIC soft reset
> before configuration.
>
> This commit adds enumeration check and allows
> driver to be slow to attach.
>
> Signed-off-by: Lauri Jakku <lja@iki.fi>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c     | 24 +++--
>  .../net/ethernet/realtek/r8169_phy_config.c   | 80 ++++++++++++++++
>  drivers/net/phy/phy-core.c                    | 91 ++++++++++++++++++-
>  3 files changed, 182 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c 
> b/drivers/net/ethernet/realtek/r8169_main.c
> index bf5bf05970a2..a85764f6e448 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -640,7 +640,6 @@ MODULE_AUTHOR("Realtek and the Linux r8169 crew 
> <netdev@vger.kernel.org>");
>  MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
>  module_param_named(debug, debug.msg_enable, int, 0);
>  MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 16=all)");
> -MODULE_SOFTDEP("pre: realtek");
>  MODULE_LICENSE("GPL");
>  MODULE_FIRMWARE(FIRMWARE_8168D_1);
>  MODULE_FIRMWARE(FIRMWARE_8168D_2);
> @@ -5172,13 +5171,18 @@ static int r8169_mdio_register(struct 
> rtl8169_private *tp)
>      if (!tp->phydev) {
>          mdiobus_unregister(new_bus);
>          return -ENODEV;
> -    } else if (!tp->phydev->drv) {
> -        /* Most chip versions fail with the genphy driver.
> -         * Therefore ensure that the dedicated PHY driver is loaded.
> -         */
> -        dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to 
> be added to initramfs?\n");
> -        mdiobus_unregister(new_bus);
> -        return -EUNATCH;
> +    } else {
> +        dev_info(&pdev->dev, "PHY version: 0x%x\n", tp->phydev->phy_id);
> +        dev_info(&pdev->dev, "MAC version: %d\n", tp->mac_version);
> +
> +        if (tp->mac_version == RTL_GIGA_MAC_NONE) {
> +            /* Most chip versions fail with the genphy driver.
> +             * Therefore ensure that the dedicated PHY driver is loaded.
> +             */
> +            dev_err(&pdev->dev, "Not known MAC/PHY version.\n");
> +            mdiobus_unregister(new_bus);
> +            return -EUNATCH;
> +        }
>      }
>
>      /* PHY will be woken up in rtl_open() */
> @@ -5513,6 +5517,9 @@ static int rtl_init_one(struct pci_dev *pdev, 
> const struct pci_device_id *ent)
>             rtl_chip_infos[chipset].name, dev->dev_addr, xid,
>             pci_irq_vector(pdev, 0));
>
> +    dev_info(&pdev->dev, "PHY version: 0x%x\n", tp->phydev->phy_id);
> +    dev_info(&pdev->dev, "MAC version: %d\n", tp->mac_version);
> +
>      if (jumbo_max)
>          netif_info(tp, probe, dev,
>                 "jumbo features [frames: %d bytes, tx checksumming: 
> %s]\n",
> @@ -5532,6 +5539,7 @@ static int rtl_init_one(struct pci_dev *pdev, 
> const struct pci_device_id *ent)
>      return rc;
>  }
>
> +
>  static struct pci_driver rtl8169_pci_driver = {
>      .name        = MODULENAME,
>      .id_table    = rtl8169_pci_tbl,
> diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c 
> b/drivers/net/ethernet/realtek/r8169_phy_config.c
> index b73f7d023e99..73d604c7a8a8 100644
> --- a/drivers/net/ethernet/realtek/r8169_phy_config.c
> +++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
> @@ -1243,6 +1243,84 @@ static void rtl8125_2_hw_phy_config(struct 
> rtl8169_private *tp,
>      rtl8125_config_eee_phy(phydev);
>  }
>
> +
> +static void rtl8168d_hw_phy_pre_config_actions(struct rtl8169_private 
> *tp,
> +                            struct phy_device *phydev)
> +{
> +    /* Reset the PHY before configuration. There is BIOS bug that gives
> +     * random PHY ID when device is not soft resetted first. --lja
> +     */
> +    genphy_soft_reset(phydev);
> +}
> +
> +
> +
> +void r8169_hw_phy_pre_config_actions(struct rtl8169_private *tp, 
> struct phy_device *phydev,
> +                    enum mac_version ver)
> +{
> +    static const rtl_phy_cfg_fct phy_pre_config_actions[] = {
> +        /* PCI devices. */
> +        [RTL_GIGA_MAC_VER_02] = NULL,
> +        [RTL_GIGA_MAC_VER_03] = NULL,
> +        [RTL_GIGA_MAC_VER_04] = NULL,
> +        [RTL_GIGA_MAC_VER_05] = NULL,
> +        [RTL_GIGA_MAC_VER_06] = NULL,
> +        /* PCI-E devices. */
> +        [RTL_GIGA_MAC_VER_07] = NULL,
> +        [RTL_GIGA_MAC_VER_08] = NULL,
> +        [RTL_GIGA_MAC_VER_09] = NULL,
> +        [RTL_GIGA_MAC_VER_10] = NULL,
> +        [RTL_GIGA_MAC_VER_11] = NULL,
> +        [RTL_GIGA_MAC_VER_12] = NULL,
> +        [RTL_GIGA_MAC_VER_13] = NULL,
> +        [RTL_GIGA_MAC_VER_14] = NULL,
> +        [RTL_GIGA_MAC_VER_15] = NULL,
> +        [RTL_GIGA_MAC_VER_16] = NULL,
> +        [RTL_GIGA_MAC_VER_17] = NULL,
> +        [RTL_GIGA_MAC_VER_18] = NULL,
> +        [RTL_GIGA_MAC_VER_19] = NULL,
> +        [RTL_GIGA_MAC_VER_20] = NULL,
> +        [RTL_GIGA_MAC_VER_21] = NULL,
> +        [RTL_GIGA_MAC_VER_22] = NULL,
> +        [RTL_GIGA_MAC_VER_23] = NULL,
> +        [RTL_GIGA_MAC_VER_24] = NULL,
> +        [RTL_GIGA_MAC_VER_25] = rtl8168d_hw_phy_pre_config_actions,
> +        [RTL_GIGA_MAC_VER_26] = rtl8168d_hw_phy_pre_config_actions,
> +        [RTL_GIGA_MAC_VER_27] = rtl8168d_hw_phy_pre_config_actions,
> +        [RTL_GIGA_MAC_VER_28] = rtl8168d_hw_phy_pre_config_actions,
> +        [RTL_GIGA_MAC_VER_29] = NULL,
> +        [RTL_GIGA_MAC_VER_30] = NULL,
> +        [RTL_GIGA_MAC_VER_31] = NULL,
> +        [RTL_GIGA_MAC_VER_32] = NULL,
> +        [RTL_GIGA_MAC_VER_33] = NULL,
> +        [RTL_GIGA_MAC_VER_34] = NULL,
> +        [RTL_GIGA_MAC_VER_35] = NULL,
> +        [RTL_GIGA_MAC_VER_36] = NULL,
> +        [RTL_GIGA_MAC_VER_37] = NULL,
> +        [RTL_GIGA_MAC_VER_38] = NULL,
> +        [RTL_GIGA_MAC_VER_39] = NULL,
> +        [RTL_GIGA_MAC_VER_40] = NULL,
> +        [RTL_GIGA_MAC_VER_41] = NULL,
> +        [RTL_GIGA_MAC_VER_42] = NULL,
> +        [RTL_GIGA_MAC_VER_43] = NULL,
> +        [RTL_GIGA_MAC_VER_44] = NULL,
> +        [RTL_GIGA_MAC_VER_45] = NULL,
> +        [RTL_GIGA_MAC_VER_46] = NULL,
> +        [RTL_GIGA_MAC_VER_47] = NULL,
> +        [RTL_GIGA_MAC_VER_48] = NULL,
> +        [RTL_GIGA_MAC_VER_49] = NULL,
> +        [RTL_GIGA_MAC_VER_50] = NULL,
> +        [RTL_GIGA_MAC_VER_51] = NULL,
> +        [RTL_GIGA_MAC_VER_52] = NULL,
> +        [RTL_GIGA_MAC_VER_60] = NULL,
> +        [RTL_GIGA_MAC_VER_61] = NULL,
> +    };
> +
> +    if (phy_pre_config_actions[ver])
> +        phy_pre_config_actions[ver](tp, phydev);
> +}
> +
> +
>  void r8169_hw_phy_config(struct rtl8169_private *tp, struct 
> phy_device *phydev,
>               enum mac_version ver)
>  {
> @@ -1303,6 +1381,8 @@ void r8169_hw_phy_config(struct rtl8169_private 
> *tp, struct phy_device *phydev,
>          [RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
>          [RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
>      };
> +
> +    r8169_hw_phy_pre_config_actions(tp, phydev);
>
>      if (phy_configs[ver])
>          phy_configs[ver](tp, phydev);
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 66b8c61ca74c..b170185a1ed1 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -151,6 +151,25 @@ static const struct phy_setting settings[] = {
>  };
>  #undef PHY_SETTING
>
> +#ifdef DEBUG
> +#define R8169_ATTACHED_PRINTK \
> +    printk("Phy is attached check %s @ %d: %d\n", \
> +    __FUNC__, __LINE__, is_attached_check);
> +
> +#else
> +#define R8169_ATTACHED_PRINTK
> +#endif
> +
> +#define PHY_NOT_ATTACHED_CHECK \
> +    { \
> +        void *attached_dev_ptr = (phydev) ? phydev->attached_dev : 
> NULL; \
> +        int is_attached_check = (attached_dev_ptr != NULL) && \
> +                                ((phydev) && (phydev->state >= 
> PHY_READY)); \
> +        R8169_ATTACHED_PRINTK \
> +        if (! is_attached_check ) return -EOPNOTSUPP; \
> +    };
> +
> +
>  /**
>   * phy_lookup_setting - lookup a PHY setting
>   * @speed: speed to match
> @@ -457,6 +476,9 @@ int phy_read_mmd(struct phy_device *phydev, int 
> devad, u32 regnum)
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      phy_lock_mdio_bus(phydev);
>      ret = __phy_read_mmd(phydev, devad, regnum);
>      phy_unlock_mdio_bus(phydev);
> @@ -479,6 +501,9 @@ int __phy_write_mmd(struct phy_device *phydev, int 
> devad, u32 regnum, u16 val)
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      if (regnum > (u16)~0 || devad > 32)
>          return -EINVAL;
>
> @@ -518,6 +543,9 @@ int phy_write_mmd(struct phy_device *phydev, int 
> devad, u32 regnum, u16 val)
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      phy_lock_mdio_bus(phydev);
>      ret = __phy_write_mmd(phydev, devad, regnum, val);
>      phy_unlock_mdio_bus(phydev);
> @@ -543,6 +571,10 @@ int phy_modify_changed(struct phy_device *phydev, 
> u32 regnum, u16 mask, u16 set)
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +
>      phy_lock_mdio_bus(phydev);
>      ret = __phy_modify_changed(phydev, regnum, mask, set);
>      phy_unlock_mdio_bus(phydev);
> @@ -587,6 +619,9 @@ int phy_modify(struct phy_device *phydev, u32 
> regnum, u16 mask, u16 set)
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      phy_lock_mdio_bus(phydev);
>      ret = __phy_modify(phydev, regnum, mask, set);
>      phy_unlock_mdio_bus(phydev);
> @@ -613,6 +648,9 @@ int __phy_modify_mmd_changed(struct phy_device 
> *phydev, int devad, u32 regnum,
>  {
>      int new, ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      ret = __phy_read_mmd(phydev, devad, regnum);
>      if (ret < 0)
>          return ret;
> @@ -646,6 +684,10 @@ int phy_modify_mmd_changed(struct phy_device 
> *phydev, int devad, u32 regnum,
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +
>      phy_lock_mdio_bus(phydev);
>      ret = __phy_modify_mmd_changed(phydev, devad, regnum, mask, set);
>      phy_unlock_mdio_bus(phydev);
> @@ -671,6 +713,9 @@ int __phy_modify_mmd(struct phy_device *phydev, 
> int devad, u32 regnum,
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      ret = __phy_modify_mmd_changed(phydev, devad, regnum, mask, set);
>
>      return ret < 0 ? ret : 0;
> @@ -694,6 +739,9 @@ int phy_modify_mmd(struct phy_device *phydev, int 
> devad, u32 regnum,
>  {
>      int ret;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      phy_lock_mdio_bus(phydev);
>      ret = __phy_modify_mmd(phydev, devad, regnum, mask, set);
>      phy_unlock_mdio_bus(phydev);
> @@ -704,7 +752,11 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
>
>  static int __phy_read_page(struct phy_device *phydev)
>  {
> -    if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not 
> available, PHY driver not loaded?\n"))
> +
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +    if (WARN(!phydev->drv->read_page, "read_page callback not 
> available, PHY driver not loaded?\n"))
>          return -EOPNOTSUPP;
>
>      return phydev->drv->read_page(phydev);
> @@ -712,12 +764,16 @@ static int __phy_read_page(struct phy_device 
> *phydev)
>
>  static int __phy_write_page(struct phy_device *phydev, int page)
>  {
> -    if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not 
> available, PHY driver not loaded?\n"))
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +    if (WARN(!phydev->drv->write_page, "write_page callback not 
> available, PHY driver not loaded?\n"))
>          return -EOPNOTSUPP;
>
>      return phydev->drv->write_page(phydev, page);
>  }
>
> +
>  /**
>   * phy_save_page() - take the bus lock and save the current page
>   * @phydev: a pointer to a &struct phy_device
> @@ -728,7 +784,11 @@ static int __phy_write_page(struct phy_device 
> *phydev, int page)
>   */
>  int phy_save_page(struct phy_device *phydev)
>  {
> -    phy_lock_mdio_bus(phydev);
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +
> +    phy_lock_mdio_bus(phydev);
>      return __phy_read_page(phydev);
>  }
>  EXPORT_SYMBOL_GPL(phy_save_page);
> @@ -748,7 +808,10 @@ int phy_select_page(struct phy_device *phydev, 
> int page)
>  {
>      int ret, oldpage;
>
> -    oldpage = ret = phy_save_page(phydev);
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +    oldpage = ret = phy_save_page(phydev);
>      if (ret < 0)
>          return ret;
>
> @@ -782,6 +845,9 @@ int phy_restore_page(struct phy_device *phydev, 
> int oldpage, int ret)
>  {
>      int r;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
>      if (oldpage >= 0) {
>          r = __phy_write_page(phydev, oldpage);
>
> @@ -812,6 +878,9 @@ EXPORT_SYMBOL_GPL(phy_restore_page);
>  int phy_read_paged(struct phy_device *phydev, int page, u32 regnum)
>  {
>      int ret = 0, oldpage;
> +
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
>
>      oldpage = phy_select_page(phydev, page);
>      if (oldpage >= 0)
> @@ -834,6 +903,10 @@ int phy_write_paged(struct phy_device *phydev, 
> int page, u32 regnum, u16 val)
>  {
>      int ret = 0, oldpage;
>
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +
>      oldpage = phy_select_page(phydev, page);
>      if (oldpage >= 0)
>          ret = __phy_write(phydev, regnum, val);
> @@ -856,6 +929,9 @@ int phy_modify_paged_changed(struct phy_device 
> *phydev, int page, u32 regnum,
>                   u16 mask, u16 set)
>  {
>      int ret = 0, oldpage;
> +
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
>
>      oldpage = phy_select_page(phydev, page);
>      if (oldpage >= 0)
> @@ -878,7 +954,12 @@ EXPORT_SYMBOL(phy_modify_paged_changed);
>  int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
>               u16 mask, u16 set)
>  {
> -    int ret = phy_modify_paged_changed(phydev, page, regnum, mask, set);
> +    int ret = -1;
> +
> +    /* If not attached, do nothing. */
> +    PHY_NOT_ATTACHED_CHECK;
> +
> +    ret = phy_modify_paged_changed(phydev, page, regnum, mask, set);
>
>      return ret < 0 ? ret : 0;
>  }

here is the polished patch:

 From 6dd6f2813c543dc728efb8dca796bbbe870bd031 Mon Sep 17 00:00:00 2001
From: Lauri Jakku <lja@iki.fi>
Date: Thu, 16 Apr 2020 00:38:51 +0300
Subject: [PATCH] NET: r8169 driver identifying improvement.

Trust device MAC enum + r8169d NIC soft reset
before configuration.

This commit adds enumeration check and allows
driver to be slow to attach.

Signed-off-by: Lauri Jakku <lja@iki.fi>
---
  drivers/net/ethernet/realtek/r8169_main.c     | 21 +++--
  .../net/ethernet/realtek/r8169_phy_config.c   | 80 +++++++++++++++++++
  2 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c 
b/drivers/net/ethernet/realtek/r8169_main.c
index bf5bf05970a2..6828e755a460 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -640,7 +640,6 @@ MODULE_AUTHOR("Realtek and the Linux r8169 crew 
<netdev@vger.kernel.org>");
  MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
  module_param_named(debug, debug.msg_enable, int, 0);
  MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 16=all)");
-MODULE_SOFTDEP("pre: realtek");
  MODULE_LICENSE("GPL");
  MODULE_FIRMWARE(FIRMWARE_8168D_1);
  MODULE_FIRMWARE(FIRMWARE_8168D_2);
@@ -5172,13 +5171,18 @@ static int r8169_mdio_register(struct 
rtl8169_private *tp)
      if (!tp->phydev) {
          mdiobus_unregister(new_bus);
          return -ENODEV;
-    } else if (!tp->phydev->drv) {
-        /* Most chip versions fail with the genphy driver.
-         * Therefore ensure that the dedicated PHY driver is loaded.
-         */
-        dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to 
be added to initramfs?\n");
-        mdiobus_unregister(new_bus);
-        return -EUNATCH;
+    } else {
+        dev_info(&pdev->dev, "PHY version: 0x%x\n", tp->phydev->phy_id);
+        dev_info(&pdev->dev, "MAC version: %d\n", tp->mac_version);
+
+        if (tp->mac_version == RTL_GIGA_MAC_NONE) {
+            /* Most chip versions fail with the genphy driver.
+             * Therefore ensure that the dedicated PHY driver is loaded.
+             */
+            dev_err(&pdev->dev, "Not known MAC/PHY version.\n");
+            mdiobus_unregister(new_bus);
+            return -EUNATCH;
+        }
      }

      /* PHY will be woken up in rtl_open() */
@@ -5532,6 +5536,7 @@ static int rtl_init_one(struct pci_dev *pdev, 
const struct pci_device_id *ent)
      return rc;
  }

+
  static struct pci_driver rtl8169_pci_driver = {
      .name        = MODULENAME,
      .id_table    = rtl8169_pci_tbl,
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c 
b/drivers/net/ethernet/realtek/r8169_phy_config.c
index b73f7d023e99..f13f68b79a92 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1243,6 +1243,84 @@ static void rtl8125_2_hw_phy_config(struct 
rtl8169_private *tp,
      rtl8125_config_eee_phy(phydev);
  }

+
+static void rtl8168d_hw_phy_pre_config_actions(struct rtl8169_private *tp,
+                            struct phy_device *phydev)
+{
+    /* Reset the PHY before configuration. There is BIOS bug that gives
+     * random PHY ID when device is not soft resetted first. --lja
+     */
+    genphy_soft_reset(phydev);
+}
+
+
+
+void r8169_hw_phy_pre_config_actions(struct rtl8169_private *tp, struct 
phy_device *phydev,
+                    enum mac_version ver)
+{
+    static const rtl_phy_cfg_fct phy_pre_config_actions[] = {
+        /* PCI devices. */
+        [RTL_GIGA_MAC_VER_02] = NULL,
+        [RTL_GIGA_MAC_VER_03] = NULL,
+        [RTL_GIGA_MAC_VER_04] = NULL,
+        [RTL_GIGA_MAC_VER_05] = NULL,
+        [RTL_GIGA_MAC_VER_06] = NULL,
+        /* PCI-E devices. */
+        [RTL_GIGA_MAC_VER_07] = NULL,
+        [RTL_GIGA_MAC_VER_08] = NULL,
+        [RTL_GIGA_MAC_VER_09] = NULL,
+        [RTL_GIGA_MAC_VER_10] = NULL,
+        [RTL_GIGA_MAC_VER_11] = NULL,
+        [RTL_GIGA_MAC_VER_12] = NULL,
+        [RTL_GIGA_MAC_VER_13] = NULL,
+        [RTL_GIGA_MAC_VER_14] = NULL,
+        [RTL_GIGA_MAC_VER_15] = NULL,
+        [RTL_GIGA_MAC_VER_16] = NULL,
+        [RTL_GIGA_MAC_VER_17] = NULL,
+        [RTL_GIGA_MAC_VER_18] = NULL,
+        [RTL_GIGA_MAC_VER_19] = NULL,
+        [RTL_GIGA_MAC_VER_20] = NULL,
+        [RTL_GIGA_MAC_VER_21] = NULL,
+        [RTL_GIGA_MAC_VER_22] = NULL,
+        [RTL_GIGA_MAC_VER_23] = NULL,
+        [RTL_GIGA_MAC_VER_24] = NULL,
+        [RTL_GIGA_MAC_VER_25] = rtl8168d_hw_phy_pre_config_actions,
+        [RTL_GIGA_MAC_VER_26] = rtl8168d_hw_phy_pre_config_actions,
+        [RTL_GIGA_MAC_VER_27] = rtl8168d_hw_phy_pre_config_actions,
+        [RTL_GIGA_MAC_VER_28] = rtl8168d_hw_phy_pre_config_actions,
+        [RTL_GIGA_MAC_VER_29] = NULL,
+        [RTL_GIGA_MAC_VER_30] = NULL,
+        [RTL_GIGA_MAC_VER_31] = NULL,
+        [RTL_GIGA_MAC_VER_32] = NULL,
+        [RTL_GIGA_MAC_VER_33] = NULL,
+        [RTL_GIGA_MAC_VER_34] = NULL,
+        [RTL_GIGA_MAC_VER_35] = NULL,
+        [RTL_GIGA_MAC_VER_36] = NULL,
+        [RTL_GIGA_MAC_VER_37] = NULL,
+        [RTL_GIGA_MAC_VER_38] = NULL,
+        [RTL_GIGA_MAC_VER_39] = NULL,
+        [RTL_GIGA_MAC_VER_40] = NULL,
+        [RTL_GIGA_MAC_VER_41] = NULL,
+        [RTL_GIGA_MAC_VER_42] = NULL,
+        [RTL_GIGA_MAC_VER_43] = NULL,
+        [RTL_GIGA_MAC_VER_44] = NULL,
+        [RTL_GIGA_MAC_VER_45] = NULL,
+        [RTL_GIGA_MAC_VER_46] = NULL,
+        [RTL_GIGA_MAC_VER_47] = NULL,
+        [RTL_GIGA_MAC_VER_48] = NULL,
+        [RTL_GIGA_MAC_VER_49] = NULL,
+        [RTL_GIGA_MAC_VER_50] = NULL,
+        [RTL_GIGA_MAC_VER_51] = NULL,
+        [RTL_GIGA_MAC_VER_52] = NULL,
+        [RTL_GIGA_MAC_VER_60] = NULL,
+        [RTL_GIGA_MAC_VER_61] = NULL,
+    };
+
+    if (phy_pre_config_actions[ver])
+        phy_pre_config_actions[ver](tp, phydev);
+}
+
+
  void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device 
*phydev,
               enum mac_version ver)
  {
@@ -1304,6 +1382,8 @@ void r8169_hw_phy_config(struct rtl8169_private 
*tp, struct phy_device *phydev,
          [RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
      };

+    r8169_hw_phy_pre_config_actions(tp, phydev, ver);
+
      if (phy_configs[ver])
          phy_configs[ver](tp, phydev);
  }
-- 
2.26.2




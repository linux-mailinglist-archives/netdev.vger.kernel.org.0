Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A539B89F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhFDMCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:02:14 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:46770 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFDMCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 08:02:13 -0400
Received: by mail-wr1-f44.google.com with SMTP id a11so7162193wrt.13;
        Fri, 04 Jun 2021 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LWws1dPTgXqVuB3LKpwxLUmui+8eR3xid3DI3YW0O24=;
        b=ZPweqCe4Wk0/26ZC/KOarQrE2WqoWm0p2HgoGFiYrI/9mQ3Tv1C9PrG6ofIL6sS+gI
         B1ybQdEE2DaNlT93jYOXH4T8IitY5dmilpRe+ptud7Bh7nz/p2zdbcSgJO5XoLm8ZZlz
         rBdEiAzGY3zAJ+fpjHwWF7VNlwRdG3rsev5TnCkbIPULbV2Xh38xQL25nIlBydb/Uybp
         uDbRY9Dw6q+Mng8pD3axK7hE1m14OFY2xoA6S56QJ2HbGM8NVxwnZZpLATQQxc50kvyi
         ecoaAbmSIXWqh0Ad75ARkDHUCKI9ZCzL8yWo8gOrYM3MmkdmC36zyRQaAsyFiLLaP2pb
         +ZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LWws1dPTgXqVuB3LKpwxLUmui+8eR3xid3DI3YW0O24=;
        b=qsPuHPS36lyowSnYV12ro6c9jL9b27QO9VUevG+pJBlQFCtAqMacPTMNupNS71Bqvc
         tFm+zig8L8TVFk0o8E3qbb5VemcaejOGoVfMvbEkNIg52JunpwIjCjjaSTo1G/EgDHU+
         GCDYNtKOaNHALH71L1lEeG+TWpXfVJM9qqBo8yPOgRDasGQHiEXbNZkCIrgAG+3lUtMf
         QKwRyChq0oXxhebMJH+AfOk22mxY0IQoaGOKWXfDZ5MXfOugEoUe9AzmD5LCLxliH5+E
         OS7pWvDUHUsb1sbGHc3rMqCHp1M40SHMUlFor+8y9MPqCIOswm52/V8/E6v4HFnpcI43
         CWPw==
X-Gm-Message-State: AOAM532rXd0sNUHMJNSYhYpy1FVxGRUE0AKJmL5XzPh3pkFwkYjc4vx1
        CtRs2lfx8puAiWz0WBbYhm4Ad0fVRsw=
X-Google-Smtp-Source: ABdhPJzcfzMnf1fzhnD7Bar4TL4IS1QNN6IBKnfN0AVLTaMVN/NyB65JgZzwo7TH1st//9yJmtisRQ==
X-Received: by 2002:adf:c54b:: with SMTP id s11mr3584151wrf.349.1622807951741;
        Fri, 04 Jun 2021 04:59:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:e88b:5ff5:6dda:b362? (p200300ea8f2f0c00e88b5ff56ddab362.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:e88b:5ff5:6dda:b362])
        by smtp.googlemail.com with ESMTPSA id y189sm5653884wmy.25.2021.06.04.04.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 04:59:11 -0700 (PDT)
To:     Koba Ko <koba.ko@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210603025414.226526-1-koba.ko@canonical.com>
 <3d2e7a11-92ad-db06-177b-c6602ef1acd4@gmail.com>
 <CAJB-X+V4vpLoNt2C_i=3mS4UtFnDdro5+hgaFXHWxcvobO=pzg@mail.gmail.com>
 <f969a075-25a1-84ba-daad-b4ed0e7f75f5@gmail.com>
 <CAJB-X+U5VEeSNS4sF0DBxc-p0nxA6QLVVrORHsscZuY37rGJ7w@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] r8169: introduce polling method for link change
Message-ID: <bfc68450-422d-1968-1316-64f7eaa7cbe9@gmail.com>
Date:   Fri, 4 Jun 2021 13:59:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAJB-X+U5VEeSNS4sF0DBxc-p0nxA6QLVVrORHsscZuY37rGJ7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.06.2021 11:08, Koba Ko wrote:
> On Fri, Jun 4, 2021 at 4:23 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 04.06.2021 09:22, Koba Ko wrote:
>>> On Thu, Jun 3, 2021 at 6:00 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> On 03.06.2021 04:54, Koba Ko wrote:
>>>>> For RTL8106E, it's a Fast-ethernet chip.
>>>>> If ASPM is enabled, the link chang interrupt wouldn't be triggered
>>>>> immediately and must wait a very long time to get link change interrupt.
>>>>> Even the link change interrupt isn't triggered, the phy link is already
>>>>> established.
>>>>>
>>>> At first please provide a full dmesg log and output of lspci -vv.
>>>> Do you have the firmware for the NIC loaded? Please provide "ethtool -i <if>"
>>>> output.
>>>
>>> please get the logs from here,
>>> https://bugzilla.kernel.org/show_bug.cgi?id=213165
>>>
>>>> Does the issue affect link-down and/or link-up detection?
>>>> Do you have runtime pm enabled? Then, after 10s of link-down NIC goes to
>>>> D3hot and link-up detection triggers a PME.
>>>
>>> Issue affect link-up.
>>> yes, pm runtime is enabled, but rtl8106e always stays D0 even if the
>>> cable isn't present.
>>>
>> Then runtime pm doesn't seem to be set to "auto". Else 10s after link loss
>> the chip runtime-suspends and is set to D3hot.
> 
> I will check this.
> 
>>
>>>>
>>>>> Introduce a polling method to watch the status of phy link and disable
>>>>> the link change interrupt.
>>>>> Also add a quirk for those realtek devices have the same issue.
>>>>>
>>>> Which are the affected chip versions? Did you check with Realtek?
>>>> Your patch switches to polling for all Fast Ethernet versions,
>>>> and that's not what we want.
>>>
>>> I don't know the exact version, only the chip name 806e(pci device id 0x8165).
>>> ok, Im asking Realtek to help how to identify the chip issue is observed.
>>>
>> At least your Bugzilla report refers to VER_39. PCI device id 0x8136 is shared
>> by all fast ethernet chip versions.
>> Do you know other affected chip versions apart from VER_39 ?
>>
>> In the Bugzilla report you also write the issue occurs with GBit-capable
>> link partners. This sounds more like an aneg problem.
>> The issue doesn't occur with fast ethernet link partners?
> 
> Issue wouldn't be observed when the link-partner has only FE capability.
> 
Weird. I still have no clue how FE vs. GE support at link partner and
ASPM could be related. I could understand that the PHY might have a
problem with a GE link partner and aneg takes more time than usual.
But this would be completely unrelated to a potential issue with
ASPM on the PCIe link.

And it's also not clear how L1_1 can cause an issue if the NIC doesn't
support L1 sub-states. Maybe the root cause isn't with the NIC but
with some other component in the PCIe path (e.g. bridge).

>>
>> Your bug report also includes a patch that disables L1_1 only.
>> Not sure how this is related because the chip version we speak about
>> here doesn't support L1 sub-states.
> 
> I have tried to enable L0s, L1 and don't disable L1 substate,
> but still get the issue that interrupt can't be fired immediately but
> the Link status is up.
> 
>>
>>>>
>>>> My suspicion would be that something is system-dependent. Else I think
>>>> we would have seen such a report before.
>>> On the mainline, the aspm is disable, so you may not observe this.
>>> If you enable ASPM and must wait CHIP go to power-saving mode, then
>>> you can observe the issue.
>>>>
>>
>> So what you're saying is that mainline is fine and your problem is with
>> a downstream kernel with re-enabled ASPM? So there's nothing broken in
>> mainline? In mainline you have the option to re-enable ASPM states
>> individually via sysfs (link subdir at pci device).
> 
> If enable L1_1 on the mainline, the issue could be observed too.
> 
It has a reason that ASPM is disabled per default in mainline. Different
chip versions have different types of issues with ASPM enabled.
However several chip versions work fine with ASPM (also LI sub-states),
therefore users can re-enable ASPM states at own risk.

> Thanks
>>
>>>>> Signed-off-by: Koba Ko <koba.ko@canonical.com>
>>>>> ---
>>>>>  drivers/net/ethernet/realtek/r8169.h      |   2 +
>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 112 ++++++++++++++++++----
>>>>>  2 files changed, 98 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
>>>>> index 2728df46ec41..a8c71adb1b57 100644
>>>>> --- a/drivers/net/ethernet/realtek/r8169.h
>>>>> +++ b/drivers/net/ethernet/realtek/r8169.h
>>>>> @@ -11,6 +11,8 @@
>>>>>  #include <linux/types.h>
>>>>>  #include <linux/phy.h>
>>>>>
>>>>> +#define RTL8169_LINK_TIMEOUT (1 * HZ)
>>>>> +
>>>>>  enum mac_version {
>>>>>       /* support for ancient RTL_GIGA_MAC_VER_01 has been removed */
>>>>>       RTL_GIGA_MAC_VER_02,
>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> index 2c89cde7da1e..70aacc83d641 100644
>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> @@ -178,6 +178,11 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
>>>>>
>>>>>  MODULE_DEVICE_TABLE(pci, rtl8169_pci_tbl);
>>>>>
>>>>> +static const struct pci_device_id rtl8169_linkChg_polling_enabled[] = {
>>>>> +     { PCI_VDEVICE(REALTEK, 0x8136), RTL_CFG_NO_GBIT },
>>>>> +     { 0 }
>>>>> +};
>>>>> +
>>>>
>>>> This doesn't seem to be used.
>>>>
>>>>>  enum rtl_registers {
>>>>>       MAC0            = 0,    /* Ethernet hardware address. */
>>>>>       MAC4            = 4,
>>>>> @@ -618,6 +623,7 @@ struct rtl8169_private {
>>>>>       u16 cp_cmd;
>>>>>       u32 irq_mask;
>>>>>       struct clk *clk;
>>>>> +     struct timer_list link_timer;
>>>>>
>>>>>       struct {
>>>>>               DECLARE_BITMAP(flags, RTL_FLAG_MAX);
>>>>> @@ -1179,6 +1185,16 @@ static void rtl8168ep_stop_cmac(struct rtl8169_private *tp)
>>>>>       RTL_W8(tp, IBCR0, RTL_R8(tp, IBCR0) & ~0x01);
>>>>>  }
>>>>>
>>>>> +static int rtl_link_chng_polling_quirk(struct rtl8169_private *tp)
>>>>> +{
>>>>> +     struct pci_dev *pdev = tp->pci_dev;
>>>>> +
>>>>> +     if (pdev->vendor == 0x10ec && pdev->device == 0x8136 && !tp->supports_gmii)
>>>>> +             return 1;
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>>  static void rtl8168dp_driver_start(struct rtl8169_private *tp)
>>>>>  {
>>>>>       r8168dp_oob_notify(tp, OOB_CMD_DRIVER_START);
>>>>> @@ -4608,6 +4624,75 @@ static void rtl_task(struct work_struct *work)
>>>>>       rtnl_unlock();
>>>>>  }
>>>>>
>>>>> +static void r8169_phylink_handler(struct net_device *ndev)
>>>>> +{
>>>>> +     struct rtl8169_private *tp = netdev_priv(ndev);
>>>>> +
>>>>> +     if (netif_carrier_ok(ndev)) {
>>>>> +             rtl_link_chg_patch(tp);
>>>>> +             pm_request_resume(&tp->pci_dev->dev);
>>>>> +     } else {
>>>>> +             pm_runtime_idle(&tp->pci_dev->dev);
>>>>> +     }
>>>>> +
>>>>> +     if (net_ratelimit())
>>>>> +             phy_print_status(tp->phydev);
>>>>> +}
>>>>> +
>>>>> +static unsigned int
>>>>> +rtl8169_xmii_link_ok(struct net_device *dev)
>>>>> +{
>>>>> +     struct rtl8169_private *tp = netdev_priv(dev);
>>>>> +     unsigned int retval;
>>>>> +
>>>>> +     retval = (RTL_R8(tp, PHYstatus) & LinkStatus) ? 1 : 0;
>>>>> +
>>>>> +     return retval;
>>>>> +}
>>>>> +
>>>>> +static void
>>>>> +rtl8169_check_link_status(struct net_device *dev)
>>>>> +{
>>>>> +     struct rtl8169_private *tp = netdev_priv(dev);
>>>>> +     int link_status_on;
>>>>> +
>>>>> +     link_status_on = rtl8169_xmii_link_ok(dev);
>>>>> +
>>>>> +     if (netif_carrier_ok(dev) == link_status_on)
>>>>> +             return;
>>>>> +
>>>>> +     phy_mac_interrupt(tp->phydev);
>>>>> +
>>>>> +     r8169_phylink_handler (dev);
>>>>> +}
>>>>> +
>>>>> +static void rtl8169_link_timer(struct timer_list *t)
>>>>> +{
>>>>> +     struct rtl8169_private *tp = from_timer(tp, t, link_timer);
>>>>> +     struct net_device *dev = tp->dev;
>>>>> +     struct timer_list *timer = t;
>>>>> +     unsigned long flags;
>>>>
>>>> flags isn't used and triggers a compiler warning. Did you even
>>>> compile-test your patch?
>>>>
>>>>> +
>>>>> +     rtl8169_check_link_status(dev);
>>>>> +
>>>>> +     if (timer_pending(&tp->link_timer))
>>>>> +             return;
>>>>> +
>>>>> +     mod_timer(timer, jiffies + RTL8169_LINK_TIMEOUT);
>>>>> +}
>>>>> +
>>>>> +static inline void rtl8169_delete_link_timer(struct net_device *dev, struct timer_list *timer)
>>>>> +{
>>>>> +     del_timer_sync(timer);
>>>>> +}
>>>>> +
>>>>> +static inline void rtl8169_request_link_timer(struct net_device *dev)
>>>>> +{
>>>>> +     struct rtl8169_private *tp = netdev_priv(dev);
>>>>> +
>>>>> +     timer_setup(&tp->link_timer, rtl8169_link_timer, TIMER_INIT_FLAGS);
>>>>> +}
>>>>> +
>>>>>  static int rtl8169_poll(struct napi_struct *napi, int budget)
>>>>>  {
>>>>>       struct rtl8169_private *tp = container_of(napi, struct rtl8169_private, napi);
>>>>> @@ -4624,21 +4709,6 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
>>>>>       return work_done;
>>>>>  }
>>>>>
>>>>> -static void r8169_phylink_handler(struct net_device *ndev)
>>>>> -{
>>>>> -     struct rtl8169_private *tp = netdev_priv(ndev);
>>>>> -
>>>>> -     if (netif_carrier_ok(ndev)) {
>>>>> -             rtl_link_chg_patch(tp);
>>>>> -             pm_request_resume(&tp->pci_dev->dev);
>>>>> -     } else {
>>>>> -             pm_runtime_idle(&tp->pci_dev->dev);
>>>>> -     }
>>>>> -
>>>>> -     if (net_ratelimit())
>>>>> -             phy_print_status(tp->phydev);
>>>>> -}
>>>>> -
>>>>>  static int r8169_phy_connect(struct rtl8169_private *tp)
>>>>>  {
>>>>>       struct phy_device *phydev = tp->phydev;
>>>>> @@ -4769,6 +4839,10 @@ static int rtl_open(struct net_device *dev)
>>>>>               goto err_free_irq;
>>>>>
>>>>>       rtl8169_up(tp);
>>>>> +
>>>>> +     if (rtl_link_chng_polling_quirk(tp))
>>>>> +             mod_timer(&tp->link_timer, jiffies + RTL8169_LINK_TIMEOUT);
>>>>> +
>>>>>       rtl8169_init_counter_offsets(tp);
>>>>>       netif_start_queue(dev);
>>>>>  out:
>>>>> @@ -4991,7 +5065,10 @@ static const struct net_device_ops rtl_netdev_ops = {
>>>>>
>>>>>  static void rtl_set_irq_mask(struct rtl8169_private *tp)
>>>>>  {
>>>>> -     tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
>>>>> +     tp->irq_mask = RxOK | RxErr | TxOK | TxErr;
>>>>> +
>>>>> +     if (!rtl_link_chng_polling_quirk(tp))
>>>>> +             tp->irq_mask |= LinkChg;
>>>>>
>>>>>       if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
>>>>>               tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
>>>>> @@ -5436,6 +5513,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>       if (pci_dev_run_wake(pdev))
>>>>>               pm_runtime_put_sync(&pdev->dev);
>>>>>
>>>>> +     if (rtl_link_chng_polling_quirk(tp))
>>>>> +             rtl8169_request_link_timer(dev);
>>>>> +
>>>>>       return 0;
>>>>>  }
>>>>>
>>>>>
>>>>
>>>> All this isn't needed. If you want to switch to link status polling,
>>>> why don't you simply let phylib do it? PHY_MAC_INTERRUPT -> PHY_POLL
>>>
>>> Thanks for suggestions, I tried to use PHY_POLL, it could do the same
>>> thing that I did.
>>>
>>>> Your timer-based code most likely would have problems if runtime pm
>>>> is enabled. Then you try to read the link status whilst NIC is in
>>>> D3hot.
>>


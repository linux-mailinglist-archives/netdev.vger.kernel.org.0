Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841D7DB9DE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441466AbfJQWtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:49:24 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35497 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732705AbfJQWtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:49:24 -0400
Received: by mail-ed1-f66.google.com with SMTP id v8so3092445eds.2;
        Thu, 17 Oct 2019 15:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qxuYkWvDR/fCGUTUNTrCXcrEn2fM0mjqFi0ns739uBQ=;
        b=ZbS3ePOOKIGjfgpUCljnLiYSR7zqUwRe0EVRMcsLd2wc0ke5aGptDKucp2S+mTdxtp
         MikZrV913m4OD/Zzo/k/4YToB4fJdbzoUmkznTp/QukfRDIEMmW1UdehIO2oJhnyAn0R
         JYZpwPw2w1wXx3MWtSGbC8CgGSQpFFm+w/JgKCHH6kg5ctKf2Mt5zMWLHxYHwOk2PupT
         vVmhZV4oJsAW8cbmGw3nZ6aspxJKpgqzwUOhIW+IhkpRDyrlZljU8vtLkTtktNII9TSN
         qwk74Mwt+/bBNEmSKxmMmmSJTjqGD7cFxfZdu325gywEn+7I4QpEA0DYZpdYwrXUciMf
         /vJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qxuYkWvDR/fCGUTUNTrCXcrEn2fM0mjqFi0ns739uBQ=;
        b=b1wHQSe3OstMXofWSX2e2HDKyISXPh2qyjcJowmsAdnjAcYT/yenrz9oUxaPrEz2YA
         cNnVXYNss6lvZXQbs2fFksaghKKxt1OIA4CLj1BZpAkFT2YQgpu8lLtyBSkAdB1XTdp4
         amMXYT36ekZbdwP6wEp+Tcc1lUK0YcOzPduTcOezIgc2Z6V/rSalsRJO//eqEvFU+1CF
         ceRFSNMQtfh0Ks1lPFDHdXv9Qor+nJihbZnkNRRMiyJ6V6xk77gMHryuM+sTVMQ57sKj
         EKjeInYRsiYE3kLo711ZSrw7fmjZJG6H9OdrUXj8xsxy0xRAUtBXy96knyFRBWTN2Gtl
         sKsw==
X-Gm-Message-State: APjAAAV2d6PaLnweK86bcBgbSvqvhC/vpD5IalJYnQYSnKdo3LexFLFT
        7apCAMUyb+c1EgxEqGWwZyY8Rcx9NnBsuk6bHYU=
X-Google-Smtp-Source: APXvYqyvKEBiQUg8sFQgwIIZT50npPsOssNhlEPJpyEvSemy65LF44qK81E8yXFYKQxFG7rLvbUbzOF8m+ss2m2I4rM=
X-Received: by 2002:aa7:c6d0:: with SMTP id b16mr6565058eds.108.1571352560075;
 Thu, 17 Oct 2019 15:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191015224953.24199-1-f.fainelli@gmail.com> <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com> <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
In-Reply-To: <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 18 Oct 2019 01:49:09 +0300
Message-ID: <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII connections
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Russell King <rmk+kernel@armlinux.org.uk>, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 at 01:22, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 10/17/2019 3:06 PM, Vladimir Oltean wrote:
> >> +static int phy_rgmii_debug_rcv(struct sk_buff *skb, struct net_device
> >> *dev,
> >> +                   struct packet_type *pt, struct net_device *unused)
> >> +{
> >> +    struct phy_rgmii_debug_priv *priv = pt->af_packet_priv;
> >> +    u32 fcs;
> >> +
> >> +    /* If we receive something, the Ethernet header was valid and so was
> >> +     * the Ethernet type, so to re-calculate the FCS we need to undo
> >> what
> >> +     * eth_type_trans() just did.
> >> +     */
> >> +    if (!__skb_push(skb, ETH_HLEN))
> >> +        return 0;
> >
> > Why would this return NULL?
> I don't think it can, good point.
>
> >
> >> +
> >> +    fcs = phy_rgmii_probe_skb_fcs(skb);
> >> +    if (skb->len != priv->skb->len || fcs != priv->fcs) {
> >
> > I feel like this logic is broken. How do you know that this skb is that
> > skb? Everybody else can still enqueue to the netdev, right?
>
> That is true, so I could be defeated by someone sending an Ethernet
> Frame with a 0xdada ethernet type through, e.g.: raw sockets, good point.
>

Well, that's the tricky part. You're sending a frame out, with no
guarantee you'll get the same frame back in. So I'm not sure that any
identifiers put inside the frame will survive.
How do the tests pan out for you? Do you actually get to trigger this
check? As I mentioned, my NIC drops the frames with bad FCS.

> >
> > Actually if I'm right about the FCS errors resulting in drops below,
> > then any news here is good news, no need to even compare the FCS of two
> > frames which you don't know whether they're in fact one and the same.
>
> FCS is a bit overstated here, although it actually is what the HW would
> generate/verify but the point was really that if you have a RGMII issue
> you may very well end-up with two packets instead of one, because of the
> clock/data misalignment.
>
> >
> >> +        print_hex_dump(KERN_INFO, "RX probe skb: ",
> >> +                   DUMP_PREFIX_OFFSET, 16, 1, skb->data, 32,
> >> +                   false);
> >> +        netdev_warn(dev, "Calculated FCS: 0x%08x expected: 0x%08x\n",
> >> +                fcs, priv->fcs);
> >> +    } else {
> >> +        priv->rcv_ok = 1;
> >> +    }
> >> +
> >> +    complete(&priv->compl);
> >> +
> >> +    return 0;
> >> +}
> >> +
> >> +static int phy_rgmii_trigger_config(struct phy_device *phydev,
> >> +                    phy_interface_t interface)
> >> +{
> >> +    int ret = 0;
> >> +
> >> +    /* Configure the interface mode to be tested */
> >> +    phydev->interface = interface;
> >> +
> >> +    /* Forcibly run the fixups and config_init() */
> >> +    ret = phy_init_hw(phydev);
> >> +    if (ret) {
> >> +        phydev_err(phydev, "phy_init_hw failed: %d\n", ret);
> >> +        return ret;
> >> +    }
> >> +
> >> +    /* Some PHY drivers configure RGMII delays in their config_aneg()
> >> +     * callback, so make sure we run through those as well.
> >> +     */
> >> +    ret = phy_start_aneg(phydev);
> >> +    if (ret) {
> >> +        phydev_err(phydev, "phy_start_aneg failed: %d\n", ret);
> >> +        return ret;
> >> +    }
> >> +
> >> +    /* Put back in loopback mode since phy_init_hw() may have issued
> >> +     * a software reset.
> >> +     */
> >> +    ret = phy_loopback(phydev, true);
> >> +    if (ret)
> >> +        phydev_err(phydev, "phy_loopback failed: %d\n", ret);
> >> +
> >> +    return ret;
> >> +}
> >> +
> >> +static void phy_rgmii_probe_xmit_work(struct work_struct *work)
> >> +{
> >> +    struct phy_rgmii_debug_priv *priv;
> >> +
> >> +    priv = container_of(work, struct phy_rgmii_debug_priv, work);
> >> +
> >> +    dev_queue_xmit(priv->skb);
> >
> > Oops, you just lost ownership of priv->skb here. Anything happening
> > further is in a race with the netdev driver. You need to hold a
> > reference to it with skb_get().
>
> Doh, yes, thanks!
>
> >
> >> +}
> >> +
> >> +static int phy_rgmii_prepare_probe(struct phy_rgmii_debug_priv *priv)
> >> +{
> >> +    struct phy_device *phydev = priv->phydev;
> >> +    struct net_device *ndev = phydev->attached_dev;
> >> +    struct sk_buff *skb;
> >> +    int ret;
> >> +
> >> +    skb = netdev_alloc_skb(ndev, ndev->mtu);
> >> +    if (!skb)
> >> +        return -ENOMEM;
> >> +
> >> +    priv->skb = skb;
> >
> > Could you assign priv->skb at the end, not here? This way you won't risk
> > leaking a freed pointer into priv->skb if eth_header below fails.
>
> Makes sense.
>
> >
> >> +    skb->dev = ndev;
> >> +    skb_put(skb, ndev->mtu);
> >> +    memset(skb->data, 0xaa, skb->len);
> >> +
> >
> > I think you need to do something like this before skb_put:
> >
> > +       skb->protocol = htons(ETH_P_EDSA);
> > +       skb_reset_network_header(skb);
> > +       skb_reset_transport_header(skb);
> >
> > Otherwise I get a lot of these errors on a bridged net device:
> >
> > [  142.919783] protocol 0000 is buggy, dev swp2
> > [  142.924436] protocol 0000 is buggy, dev eth2
> >
> >> +    /* Build the header */
> >> +    ret = eth_header(skb, ndev, ETH_P_EDSA, ndev->dev_addr,
> >> +             NULL, ndev->mtu);
> >
> > A switch net device will complain about having SMAC == DMAC and drop the
> > frame. Don't you want to send broadcast frames here?
>
> Yes, that makes sense, if you do not have broadcast in your network
> filter, your network adapter is not great use.
>
> >
> >> +    if (ret != ETH_HLEN) {
> >> +        kfree_skb(skb);
> >> +        return -EINVAL;
> >> +    }
> >> +
> >> +    priv->fcs = phy_rgmii_probe_skb_fcs(skb);
> >> +
> >
> > I'm far from a checksumming expert, but if the FCS was invalid, wouldn't
> > the RX MAC just drop the frame?
>
> Depends if the user has requested NETIF_F_RXALL, this was just a
> convenient way to produce a strong enough checksum to compare against,
> the HW will have to insert it and strip it back on its way back to itself.
>

So I guess in absence of this netdev feature, the expected default
behavior is to not receive anything back in case there's any frame
corruption. Which makes the FCS check on RX incorrect as of now.

> >
> >> +    return 0;
> >> +}
> >> +
> >> +static int phy_rgmii_probe_interface(struct phy_rgmii_debug_priv *priv,
> >> +                     phy_interface_t iface)
> >> +{
> >> +    struct phy_device *phydev = priv->phydev;
> >> +    struct net_device *ndev = phydev->attached_dev;
> >> +    unsigned long timeout;
> >> +    int ret;
> >> +
> >> +    ret = phy_rgmii_trigger_config(phydev, iface);
> >> +    if (ret) {
> >> +        netdev_err(ndev, "%s rejected by driver(s)\n",
> >> +               phy_modes(iface));
> >> +        return ret;
> >> +    }
> >> +
> >> +    netdev_info(ndev, "Trying \"%s\" PHY interface\n",
> >> phy_modes(iface));
> >> +
> >> +    /* Prepare probe frames now */
> >> +    ret = phy_rgmii_prepare_probe(priv);
> >> +    if (ret)
> >> +        return ret;
> >> +
> >> +    priv->rcv_ok = 0;
> >> +    reinit_completion(&priv->compl);
> >> +
> >> +    cancel_work_sync(&priv->work);
> >> +    schedule_work(&priv->work);
> >> +
> >> +    timeout = wait_for_completion_timeout(&priv->compl,
> >> +                          msecs_to_jiffies(3000));
> >> +    if (!timeout) {
> >> +        netdev_err(ndev, "transmit timeout!\n");
> >> +        ret = -ETIMEDOUT;
> >> +        goto out;
> >> +    }
> >> +
> >> +    ret = priv->rcv_ok == 1 ? 0 : -EINVAL;
> >> +out:
> >> +    phy_loopback(phydev, false);
> >> +    dev_consume_skb_any(priv->skb);
> >
> > Don't consume the skb if the xmit has timed out. The driver will have
> > already freed it in that case, leading to:
> >
> > [  145.994328] sja1105 spi0.1 swp2: transmit timeout!
> > [  145.999259] ------------[ cut here ]------------
> > [  146.003901] WARNING: CPU: 0 PID: 163 at lib/refcount.c:190
> > refcount_sub_and_test_checked+0xb8/0xc0
> > [  146.013029] refcount_t: underflow; use-after-free.
> >
> > That means, in practice, moving the kfree_skb call to phy_rgmii_debug_rcv.
> >
> >> +    return ret;
> >> +}
> >> +
> >> +static struct packet_type phy_rgmii_probes_type __read_mostly = {
> >> +    .type    = cpu_to_be16(ETH_P_EDSA),
> >> +    .func    = phy_rgmii_debug_rcv,
> >> +};
> >> +
> >> +static int phy_rgmii_can_debug(struct phy_device *phydev)
> >> +{
> >> +    struct net_device *ndev = phydev->attached_dev;
> >> +
> >> +    if (!ndev) {
> >> +        netdev_err(ndev, "No network device attached\n");
> >> +        return -EOPNOTSUPP;
> >> +    }
> >> +
> >> +    if (!phy_interface_is_rgmii(phydev)) {
> >> +        netdev_info(ndev, "Not RGMII configured, nothing to do\n");
> >> +        return 0;
> >> +    }
> >> +
> >> +    if (!phydev->is_gigabit_capable) {
> >> +        netdev_err(ndev, "not relevant in non-Gigabit mode\n");
> >> +        return -EOPNOTSUPP;
> >> +    }
> >> +
> >> +    if (phy_driver_is_genphy(phydev) ||
> >> phy_driver_is_genphy_10g(phydev)) {
> >> +        netdev_err(ndev, "only relevant with non-generic drivers\n");
> >> +        return -EOPNOTSUPP;
> >> +    }
> >> +    return 1;
> >> +}
> >> +
> >> +int phy_rgmii_debug_probe(struct phy_device *phydev)
> >> +{
> >> +    struct net_device *ndev = phydev->attached_dev;
> >> +    unsigned char operstate = ndev->operstate;
> >> +    phy_interface_t rgmii_modes[4] = {
> >> +        PHY_INTERFACE_MODE_RGMII,
> >> +        PHY_INTERFACE_MODE_RGMII_ID,
> >> +        PHY_INTERFACE_MODE_RGMII_RXID,
> >> +        PHY_INTERFACE_MODE_RGMII_TXID
> >> +    };
> >> +    struct phy_rgmii_debug_priv *priv;
> >> +    unsigned int i, count;
> >> +    int ret;
> >> +
> >> +    ret = phy_rgmii_can_debug(phydev);
> >> +    if (ret <= 0)
> >> +        return ret;
> >> +
> >> +    priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> >> +    if (!priv)
> >> +        return -ENOMEM;
> >> +
> >> +    if (phy_rgmii_probes_type.af_packet_priv)
> >> +        return -EBUSY;
> >> +
> >> +    phy_rgmii_probes_type.af_packet_priv = priv;
> >> +    priv->phydev = phydev;
> >> +    INIT_WORK(&priv->work, phy_rgmii_probe_xmit_work);
> >> +    init_completion(&priv->compl);
> >> +
> >> +    /* We are now testing this network device */
> >> +    ndev->operstate = IF_OPER_TESTING;
> >> +
> >
> > Shouldn't you put the netdev in promisc mode somewhere?
>
> If we send with a broadcast MAC SA (which is a good suggestion) and our
> own MAC DA, then no.
>

Yes, but remember, nobody guarantees that a frame with DMAC
ff:ff:ff:ff:ff:ff on egress will still have it on its way back. Again,
this all depends on how you plan to manage the rx-all ethtool feature.

> [snip]
>
> >>
> >
> > Despite the above, I couldn't actually get this running successfully. At
> > the end of the test I always get "-bash: echo: write error: Connection
> > timed out".
> > It's a fun toy, but I don't really think it's very useful in catching
> > any bug.
>
> Looks like it just did, with itself :)
>
> > It's basically a glorified ping test, and brainless ping tests are
> > precisely the reason why people get this wrong most of the time. You
> > can't have a generic software tool identify for you a configuration
> > problem that depends entirely upon a private hardware implementation of
> > a specification that is vague.
> >
> > I mean in theory, the arithmetic is simple enough for a MAC-to-PHY
> > connection. These 2 equalities always need to hold true:
> >
> > MAC TX delay + PCB TX delay + PHY TX delay == 1
> > MAC RX delay + PCB RX delay + PHY RX delay == 1
> >
> > meaning that delays in each direction need to be applied at most once.
> >
> > For a PHY-to-MAC connection, there is this unwritten Linux rule that the
> > PHY should apply the requested delays in both directions. This already
> > contradicts common sense, as it is not uncommon, from a hardware point
> > of view, for each device to add the delays in its own TX direction (so
> > the MAC would add the TX delays and the PHY would add the RX delays).
> > That is not possible to specify with Linux. But let's go with the flow.
> > So the PHY adds all specified delays, and one can assume that the
> > unspecified delays up to rgmii-id were added by the PCB. This small
> > kernel thread would basically probe for PCB delays, in this case,
> > assuming that the MAC driver and the PHY driver are both compliant.
> >
> > Let's say there is more than one phy-mode that works. Andrew said to
> > raise a red flag in that case, because the PHY driver is surely not
> > doing the right thing with the delays. But:
> > - Maybe it is, but the equalities above aren't completely set in stone.
> > Maybe the inserted propagation delays aren't high enough that two of
> > them would break the link again.
> > - Which of the multiple phy-mode configurations that work is the right
> > one? A tool that can't tell me that is pointless, IMO. My PHY works due
> > to pin strapping, but the driver is buggy. Do I care? No, as long as it
> > works, and as long as it will continue to work after somebody fixes the
> > driver. How do I know what delay mode is right? Well, of course, if it
> > works with the configuration out of pin strapping, then obviously I
> > should put the pin strapping settings in the DT. End of story. Can this
> > kernel thread tell me that? No....
> >
> > And then, there's the RGMII fixed-link. The rules are cloudy for that
> > one, because now there's potentially 2 phy-modes that operate on the
> > same link. To complicate matters even further, your patch does not
> > consider the fixed-link (no PHY) case, and there is no generic interface
> > to even add selftests for that in the future. You would need to unbind
> > the MAC driver, mangle the DT bindings, then bind it back again...
> >
> > I guess I'm just concerned about the chaos that a tool returning false
> > positives would create for people who don't really follow what's going
> > on ("look, but the tool said this!").
>
> And maybe I should have marked this RFC, the commit subject is clear
> that this not fool proof, it cannot be, for all the reasons you
> outlined. The thing is that I have spent many hours of my life (like
> you, like Andrew) helping people troubleshoot why RGMII does not work,
> if we have a good litmus test we can submit, that gets us half-way there.
>
> I am completely fine dropping this if you believe this is going to cause
> more harm than good.

Not saying that. Perhaps with the right wording at the end of the
selftest, it can at least point out what can be wrong and what can't
be wrong, as well as rehash what needs to be checked with the
schematics.

> --
> Florian

Thanks,
-Vladimir

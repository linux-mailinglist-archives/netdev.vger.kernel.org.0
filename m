Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027324663E4
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357977AbhLBMrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:47:07 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:51417 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241674AbhLBMrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:47:06 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 05013580276;
        Thu,  2 Dec 2021 07:43:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 02 Dec 2021 07:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=g/cXjPseJ2T+s/+am5TJBsPaAhTuqO7Vc6DGkpATu
        L4=; b=i3tD2Yp2s6s7XZJV9jPGcS0UVbzet/Ywo8fVbTCWapWBB8R+uYGkTAZSC
        6gHIl2PPGoK7GwWquQhV2lHZD/DvUGzh8attGZj4/bNfJmdEMP1htjDUiIGIsxtm
        MM1NCzrMuCSI1B1JP3cpH8n1RhCtgyuc48AJOquATldpGflVbvjPI6Qz/4jH98Gx
        9icm64ICrb2p/tAAy55CTS5egk/kctzuk1L/J3aEPGjdS/ruoIthNeR3XPOZSER+
        G7EvPD/Snb5SLUhFxWnPW8NJYq3sqFSxjZ5OqAVQPJcujOQHh/hU3haQGg7tFZwl
        8qa7AzbcNjROGOSFeSG5HGlwrfpzQ==
X-ME-Sender: <xms:f7-oYSLqLu3-Cyn-PmA0d8o8pAC8YZRAfi393c5X8SefYYToqTDZzA>
    <xme:f7-oYaJYor7iQDUN9seYGSB3TdhbbEHUZZzHvKQkO1LrxcKknKXaY1jmFu8e_QTLC
    EhtIJfSoQS0O9Q>
X-ME-Received: <xmr:f7-oYSuheS_56eP9JrNTWVJ5g8Vdxl2Ng8tm3cAjBMmDDyxRAyYTCiZ4I0hW2OvKwCaEsT7jc9VfGTwJicKnrysZy_jvnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieehgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeefheethffhhfdvueevkeffffefjeejffefuedtfedvgfettdetkedtgfejtdeh
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:f7-oYXatHaAfRTZLAhBjHcnwMFLDBhdm8G1zNxqlWa-b25V5uG66Nw>
    <xmx:f7-oYZajhk9weNmodRNIYQ8JiUj27eVmfXZ7aMpDTfccFiAclqEVow>
    <xmx:f7-oYTAHezZ1SPOsYo8z_ANJeM4gYegrZQ7nupt7enq6LRQuaj0eQA>
    <xmx:f7-oYfBFoUusJsnziPTzLi8abSOxSmqS0E0Hwj_obTWGJZpIJhEb4g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Dec 2021 07:43:42 -0500 (EST)
Date:   Thu, 2 Dec 2021 14:43:39 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        arkadiusz.kubalewski@intel.com, richardcochran@gmail.com,
        abyagowi@fb.com, anthony.l.nguyen@intel.com, davem@davemloft.net,
        kuba@kernel.org, linux-kselftest@vger.kernel.org, mkubecek@suse.cz,
        saeed@kernel.org, michael.chan@broadcom.com, petrm@nvidia.com
Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Message-ID: <Yai/e5jz3NZAg0pm@shredder>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211201180208.640179-3-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 07:02:06PM +0100, Maciej Machnikowski wrote:
> +RCLK_GET
> +========
> +
> +Get status of an output pin for PHY recovered frequency clock.
> +
> +Request contents:
> +
> +  ======================================  ======  ==========================
> +  ``ETHTOOL_A_RCLK_HEADER``               nested  request header
> +  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
> +  ======================================  ======  ==========================
> +
> +Kernel response contents:
> +
> +  ======================================  ======  ==========================
> +  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
> +  ``ETHTOOL_A_RCLK_PIN_FLAGS``            u32     state of a pin
> +  ``ETHTOOL_A_RCLK_RANGE_MIN_PIN``        u32     min index of RCLK pins
> +  ``ETHTOOL_A_RCLK_RANGE_MAX_PIN``        u32     max index of RCLK pins
> +  ======================================  ======  ==========================
> +
> +Supported device can have mulitple reference recover clock pins available

s/mulitple/multiple/

> +to be used as source of frequency for a DPLL.
> +Once a pin on given port is enabled. The PHY recovered frequency is being
> +fed onto that pin, and can be used by DPLL to synchonize with its signal.

s/synchonize/synchronize/

Please run a spell checker on documentation

> +Pins don't have to start with index equal 0 - device can also have different
> +external sources pins.
> +
> +The ``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is optional parameter. If present in
> +the RCLK_GET request, the ``ETHTOOL_A_RCLK_PIN_ENABLED`` is provided in a

The `ETHTOOL_A_RCLK_PIN_ENABLED` attribute is no where to be found in
this submission

> +response, it contatins state of the pin pointed by the index. Values are:

s/contatins/contains/

> +
> +.. kernel-doc:: include/uapi/linux/ethtool.h
> +    :identifiers: ethtool_rclk_pin_state

This structure is also no where to be found

> +
> +If ``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is not present in the RCLK_GET request,
> +the range of available pins is returned:
> +``ETHTOOL_A_RCLK_RANGE_MIN_PIN`` is lowest possible index of a pin available
> +for recovering frequency from PHY.
> +``ETHTOOL_A_RCLK_RANGE_MAX_PIN`` is highest possible index of a pin available
> +for recovering frequency from PHY.
> +
> +RCLK_SET
> +==========
> +
> +Set status of an output pin for PHY recovered frequency clock.
> +
> +Request contents:
> +
> +  ======================================  ======  ========================
> +  ``ETHTOOL_A_RCLK_HEADER``               nested  request header
> +  ``ETHTOOL_A_RCLK_OUT_PIN_IDX``          u32     index of a pin
> +  ``ETHTOOL_A_RCLK_PIN_FLAGS``            u32      requested state
> +  ======================================  ======  ========================
> +
> +``ETHTOOL_A_RCLK_OUT_PIN_IDX`` is a index of a pin for which the change of
> +state is requested. Values of ``ETHTOOL_A_RCLK_PIN_ENABLED`` are:
> +
> +.. kernel-doc:: include/uapi/linux/ethtool.h
> +    :identifiers: ethtool_rclk_pin_state

Same.

Looking at the diagram from the previous submission [1]:

      ┌──────────┬──────────┐
      │ RX       │ TX       │
  1   │ ports    │ ports    │ 1
  ───►├─────┐    │          ├─────►
  2   │     │    │          │ 2
  ───►├───┐ │    │          ├─────►
  3   │   │ │    │          │ 3
  ───►├─┐ │ │    │          ├─────►
      │ ▼ ▼ ▼    │          │
      │ ──────   │          │
      │ \____/   │          │
      └──┼──┼────┴──────────┘
        1│ 2│        ▲
 RCLK out│  │        │ TX CLK in
         ▼  ▼        │
       ┌─────────────┴───┐
       │                 │
       │       SEC       │
       │                 │
       └─────────────────┘

Given a netdev (1, 2 or 3 in the diagram), the RCLK_SET message allows
me to redirect the frequency recovered from this netdev to the EEC via
either pin 1, pin 2 or both.

Given a netdev, the RCLK_GET message allows me to query the range of
pins (RCLK out 1-2 in the diagram) through which the frequency can be
fed into the EEC.

Questions:

1. The query for all the above netdevs will return the same range of
pins. How does user space know that these are the same pins? That is,
how does user space know that RCLK_SET message to redirect the frequency
recovered from netdev 1 to pin 1 will be overridden by the same message
but for netdev 2?

2. How does user space know the mapping between a netdev and an EEC?
That is, how does user space know that RCLK_SET message for netdev 1
will cause the Tx frequency of netdev 2 to change according to the
frequency recovered from netdev 1?

3. If user space sends two RCLK_SET messages to redirect the frequency
recovered from netdev 1 to RCLK out 1 and from netdev 2 to RCLK out 2,
how does it know which recovered frequency is actually used an input to
the EEC?

4. Why these pins are represented as attributes of a netdev and not as
attributes of the EEC? That is, why are they represented as output pins
of the PHY as opposed to input pins of the EEC?

5. What is the problem with the following model?

- The EEC is a separate object with following attributes:
  * State: Invalid / Freerun / Locked / etc
  * Sources: Netdev / external / etc
  * Potentially more

- Notifications are emitted to user space when the state of the EEC
  changes. Drivers will either poll the state from the device or get
  interrupts

- The mapping from netdev to EEC is queried via ethtool

[1] https://lore.kernel.org/netdev/20211110114448.2792314-1-maciej.machnikowski@intel.com/

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4093F742D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhHYLPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:15:23 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:44647 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231697AbhHYLPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 07:15:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C72A4580BF5;
        Wed, 25 Aug 2021 07:14:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Aug 2021 07:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0X/yRV
        3deJN7huXxfDYwyXkyViG++lamHPQUYqYnshg=; b=rJ6MbtCXKRUQFJfnnNNahG
        7KUOEpdDY1DcBmohEkCa0dXsb1mgY/G870Tk9uLyHWOO72Xo93U/ZI/fxjsLkxU+
        EYgZDYp8IiIX3t/enD2yuGjuN8voajpVIhOAydCC+zO/esJprZ5TjXcp5iPEK3Zr
        T46TxErUgj41wZJW1fqsexm13ANwesEGy2qpSHH5s1LwB+fQdtgZy3u3cTUcKXos
        hrPv0dgqEo/W3CMZpAqpq8xOsDB0SZHg6QPC8fK0pxvIoVkBsNhes/4wf4wOZcnN
        R46/AdlQ5Bitdz1GKMJkGGoIoRROEeDVNqrjahFMxpyanow8sojH3pbMTHPoqJ+A
        ==
X-ME-Sender: <xms:GCYmYQ5oxFZVgRQu_aw7z8qPPEpnei9xMStMIe_FdwPue2C6waQ4gw>
    <xme:GCYmYR7--r-jOmcuvzzMpyqnfxZol8jZO2y4h4jxmCTcIFNFU8ab8ncuAIXcsNY8l
    UhZ43SYn4ntGLI>
X-ME-Received: <xmr:GCYmYfd-NX1D2K7u6Vvm5gzebHUDTCoygAD1uCEym4MujMplnsdmOr-hR_Y9bRVraD9MNG5ABVYD1Z-z5C_YrWkvDJjSHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtledgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GCYmYVJlcOI9KADfmew6mj92RS1tZhoeOjGZQ3EYumcyhCXi4bTwsg>
    <xmx:GCYmYUKUviQCahsuFOfmNbMzNS7XTH0sKFHd2FuOLR0PzA52QNIyUg>
    <xmx:GCYmYWwIF0gcReUEGPRbC0YupzS038EvG-j_GraRuX7Lf4ldp6B_YA>
    <xmx:GiYmYT8TLpW9w9GwEV3uWZxswTWhqMBZ-9kALMcBagkHSpzOk5-x8Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Aug 2021 07:14:32 -0400 (EDT)
Date:   Wed, 25 Aug 2021 14:14:28 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <YSYmFEDWJIu6eDvR@shredder>
References: <20210824130344.1828076-1-idosch@idosch.org>
 <20210824130344.1828076-2-idosch@idosch.org>
 <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 04:12:31PM -0700, Jakub Kicinski wrote:
> On Tue, 24 Aug 2021 16:03:39 +0300 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> > 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> > modules parameters and retrieve their status.
> 
> Lgtm! A few "take it or leave it" nit picks below.

Thanks and thanks a lot for the reviews!

> 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> > +The optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute encodes the
> > +transceiver module power mode policy enforced by the host. The default policy
> > +is driver-dependent and can be queried using this attribute.
> 
> Should we make a recommendation for those who don't have to worry about
> legacy behavior? 

Yes

> Like:
> 
>   The default policy is driver-dependent (but "auto" is the recommended
>   and generally assumed to be used for drivers no implementing this API).

I think "generally assumed to be used for drivers no implementing this
API" is problematic given that it is most likely the exact opposite of
what actually happens. I imagine most vendors supporting these modules
just went with "high" policy instead of implementing "auto" policy in
firmware.

So I suggest:

"The default policy is driver-dependent, but "auto" is the recommended
default and it should be implemented by new drivers and drivers where
conformance to a legacy behavior is not critical."

> 
> IMHO the "and can be queried using this attribute" part can be skipped.

OK

> 
> > +/**
> > + * struct ethtool_module_power_mode_params - module power mode parameters
> > + * @policy: The power mode policy enforced by the host for the plug-in module.
> > + * @mode: The operational power mode of the plug-in module. Should be filled by
> > + * device drivers on get operations.
> 
> Indent continuation lines by one tab.

Oops, I see that I did do that for other kdoc comments. Will fix.

> 
> > + * @mode_valid: Indicates the validity of the @mode field. Should be set by
> > + * device drivers on get operations when a module is plugged-in.
> 
> Should we make a firm decision on whether we want to use these kind of
> valid bits or choose invalid defaults? As you may guess my preference
> is the latter since that's what I usually do, that way drivers don't
> have to write two fields.
> 
> Actually I think this may be the first "valid" in ethtool, I thought we
> already had one but I don't see it now..

I was thinking about this as well, but I wasn't sure if it's valid to
adjust uAPI values in order to make in-kernel APIs simpler. I did see it
in some other places, but wasn't sure if it's a pattern that should be
copied.

Do you mean something like this?

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 7d453f0e993b..d61049091538 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -732,7 +732,7 @@ enum ethtool_module_power_mode_policy {
  * @ETHTOOL_MODULE_POWER_MODE_HIGH: Module is in high power mode.
  */
 enum ethtool_module_power_mode {
-       ETHTOOL_MODULE_POWER_MODE_LOW,
+       ETHTOOL_MODULE_POWER_MODE_LOW = 1,
        ETHTOOL_MODULE_POWER_MODE_HIGH,
 };

I prefer this over memsetting a struct to 0xff.

If the above is fine, I can make the following patch:

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c258b3f30a2e..d304df39ee5c 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -41,6 +41,11 @@ In the message structure descriptions below, if an attribute name is suffixed
 with "+", parent nest can contain multiple attributes of the same type. This
 implements an array of entries.
 
+Attributes that need to be filled-in by device drivers and that are dumped to
+user space based on whether they are valid or not should not use zero as a
+valid value. For example, ``ETHTOOL_A_MODULE_POWER_MODE``. This avoids the need
+to explicitly signal the validity of the attribute in the device driver API.
+
 
 Request header
 ==============

> 
> > +struct ethtool_module_power_mode_params {
> > +	enum ethtool_module_power_mode_policy policy;
> > +	enum ethtool_module_power_mode mode;
> > +	u8 mode_valid:1;
> > +};

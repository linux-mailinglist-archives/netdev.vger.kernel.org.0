Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84402CCC9D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgLCC2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgLCC2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 21:28:22 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EE3C061A4D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 18:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=59BB2xRVKDX8VI8ZgVcs1Z987PTAHPeh2oHIvKsiklg=; b=VOqCb+wsWD0aswDN2tKdjRXtNk
        C/6eb5NNQbHMNlEHCjCCTubkoIf5MBEwrk8Ef3OMP02gSpJhjAtInxvzsza53rIs8iE/ggTA+NnbD
        Fn/zHwzezPL2vxNJ9Xk0Dg57U4c3fm824/2mjN26idn7OSDW0AYhgcU1D3XYYLJhnrHbOnqXS00U2
        5TUUnI5OUOdqpg9mKYU/lrrHGH1ERXfCyw813aEbkq2EWn2iiJTvQXrtBTRlL1HnEAewf86iZMlA2
        nbpQHUdQ7nFaOk/skBWsieaxia9NJOlQ/5QiSLPpciSsFT5nsIx7LY2t48zkGtLFuQn804aeOEdGV
        /BLPNfTQ==;
Received: from [2601:1c0:6280:3f0::1494]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkeLC-0000nG-H0; Thu, 03 Dec 2020 02:27:30 +0000
Subject: Re: [PATCH net-next v3] devlink: Add devlink port documentation
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     jacob.e.keller@intel.com, Jiri Pirko <jiri@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
 <20201202135337.937538-1-parav@nvidia.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <13de3998-1e0f-9a53-4b75-53fd1e74ecee@infradead.org>
Date:   Wed, 2 Dec 2020 18:27:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201202135337.937538-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 12/2/20 5:53 AM, Parav Pandit wrote:
> Added documentation for devlink port and port function related commands.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Changelog:
> v2->v3:
>  - rephased many lines

     rephrased

>  - first paragraph now describe devlink port
>  - instead of saying PCI device/function, using PCI function every
>    where
>  - changed 'physical link layer' to 'link layer'
>  - made devlink port type description more clear
>  - made devlink port flavour description more clear
>  - moved devlink port type table after port flavour
>  - added description for the example diagram
>  - describe CPU port that its linked to DSA
>  - made devlink port description for eswitch port more clear
> v1->v2:
>  - Removed duplicate table entries for DEVLINK_PORT_FLAVOUR_VIRTUAL.
>  - replaced 'consist of' to 'consisting'
>  - changed 'can be' to 'can be of'
> ---
>  .../networking/devlink/devlink-port.rst       | 111 ++++++++++++++++++
>  Documentation/networking/devlink/index.rst    |   1 +
>  2 files changed, 112 insertions(+)
>  create mode 100644 Documentation/networking/devlink/devlink-port.rst
> 
> diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
> new file mode 100644
> index 000000000000..8407bbe9ce88
> --- /dev/null
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -0,0 +1,111 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +Devlink Port
> +============
> +
> +``devlink-port`` is a port that exist on the device. A devlink port can

                                   exists

> +be of one among many flavours. A devlink port flavour along with port
> +attributes describe what a port represents.
> +
> +A device driver who intents to publish a devlink port, sets the

                   that intends                         ^no comma

> +devlink port attributes and registers the devlink port.
> +
> +Devlink port flavours are described below.
> +
> +.. list-table:: List of devlink port flavours
> +   :widths: 33 90
> +
> +   * - Flavour
> +     - Description
> +   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
> +     - Any kind of physical networking port. This can be a eswitch physical

                                                            an

> +       port or any other physical port on the device.
> +   * - ``DEVLINK_PORT_FLAVOUR_DSA``
> +     - This indicates a DSA interconnect port.
> +   * - ``DEVLINK_PORT_FLAVOUR_CPU``
> +     - This indicates a CPU port applicable only to DSA.
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
> +     - This indicates an eswitch port representing a networking port of
> +       PCI physical function (PF).
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
> +     - This indicates an eswitch port representing a networking port of
> +       PCI virtual function (VF).
> +   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
> +     - This indicates a virtual port for the virtual PCI device such as PCI VF.
> +
> +A devlink port types are described below.

  The devlink port types

> +
> +.. list-table:: List of devlink port types
> +   :widths: 23 90
> +
> +   * - Type
> +     - Description
> +   * - ``DEVLINK_PORT_TYPE_ETH``
> +     - Driver should set this port type when a link layer of the port is Ethernet.
> +   * - ``DEVLINK_PORT_TYPE_IB``
> +     - Driver should set this port type when a link layer of the port is InfiniBand.
> +   * - ``DEVLINK_PORT_TYPE_AUTO``
> +     - This type is indicated by the user when user prefers to set the port type
> +       to be automatically detected by the device driver.
> +
> +A controller consist of one or more PCI functions. Such PCI function can have one

                consists

> +or more networking ports. A networking port of such PCI function is represented
> +by the eswitch devlink port. A devlink instance holds ports of two types of
> +controllers.
> +
> +(1) controller discovered on same system where eswitch resides:
> +This is the case where PCI PF/VF of a controller and devlink eswitch
> +instance both are located on a single system.
> +
> +(2) controller located on external host system.
> +This is the case where a controller is located in one system and its
> +devlink eswitch ports are located in a different system. Such controller
> +is called external controller.
> +
> +An example view of two controller systems::
> +
> +In this example a controller which contains the eswitch is local controller
> +with controller number = 0. The second is a external controller having
> +controller number = 1. Eswitch devlink instance has representor devlink
> +ports for the PCI functions of both the controllers.

I find that sentence confusing but I don't know how to fix it.

> +
> +                 ---------------------------------------------------------
> +                 |                                                       |
> +                 |           --------- ---------         ------- ------- |
> +    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +    | pci rc  |=== | pf0 |______/________/       | pf1 |___/_______/     |
> +    | connect |  | -------                       -------                 |
> +    -----------  |     | controller_num=1 (no eswitch)                   |
> +                 ------|--------------------------------------------------
> +                 (internal wire)
> +                       |
> +                 ---------------------------------------------------------
> +                 | devlink eswitch ports and reps                        |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 |                                                       |
> +                 |                                                       |
> +                 |           --------- ---------         ------- ------- |
> +                 |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +                 | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +                 | | pf0 |______/________/       | pf1 |___/_______/     |
> +                 | -------                       -------                 |
> +                 |                                                       |
> +                 |  local controller_num=0 (eswitch)                     |
> +                 ---------------------------------------------------------
> +
> +Port function configuration
> +===========================
> +
> +When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
> +``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the networking port of a
> +PCI function. A user can configure the port function attributes before
> +enumerating the function. For example user may set the hardware address of
> +the function represented by the devlink port function.

thanks.
-- 
~Randy


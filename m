Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D425A668C6B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjAMGUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbjAMGTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:19:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A00160D1;
        Thu, 12 Jan 2023 22:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0FE8ECE1FD0;
        Fri, 13 Jan 2023 06:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2A6C433EF;
        Fri, 13 Jan 2023 06:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673590718;
        bh=wEWDjWNp9HFA9trnITWiDujwpu+PYv8VBDs0iEs8fKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s4lca7SYzgmB7X8BuvQifCXHQU8caIg0muaQPNrePzqJnrURktGBRve08Z+9lwFuF
         f9U+2Eh77R1ZuC/4EbMpRou497ecuMLxlEIzDxQ2f/54CDiN3ocukVORldYqv42stb
         q2s3/5flzZ64aRCssNtknitwJNgHyBcEG5/UMmQIHN4EQs4s4GIsR0bIvHes8V03Wj
         r7nwzIT6lcYUUZpk20+0NXxFFWx8DSBSsmrsEcMQvq3ZpCyS951n5OzsxXTNJnHdnv
         Z4JzrM41cH2Z1duzJMrU6QuRc9nOb1Ur71tLeO/1Xs0NymJMmxam44tjT3zfRzGO2U
         FEsG+K79RoGQQ==
Date:   Thu, 12 Jan 2023 22:18:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 03/12] docs: ethtool-netlink: document
 interface for MAC Merge layer
Message-ID: <20230112221836.0b1e6021@kernel.org>
In-Reply-To: <20230111161706.1465242-4-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
        <20230111161706.1465242-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 18:16:57 +0200 Vladimir Oltean wrote:
> Show details about the structures passed back and forth related to MAC
> Merge layer configuration, state and statistics. The rendered htmldocs
> will be much more verbose due to the kerneldoc references.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: patch is new
> 
>  Documentation/networking/ethtool-netlink.rst | 103 +++++++++++++++++++
>  Documentation/networking/statistics.rst      |   1 +
>  2 files changed, 104 insertions(+)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index f10f8eb44255..490c2280ce4f 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -223,6 +223,8 @@ Userspace to kernel:
>    ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
>    ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
>    ``ETHTOOL_MSG_RSS_GET``               get RSS settings
> +  ``ETHTOOL_MSG_MM_GET``                get MAC merge layer state
> +  ``ETHTOOL_MSG_MM_SET``                set MAC merge layer parameters
>    ===================================== =================================
>  
>  Kernel to userspace:
> @@ -265,6 +267,7 @@ Kernel to userspace:
>    ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
>    ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
>    ``ETHTOOL_MSG_RSS_GET_REPLY``            RSS settings
> +  ``ETHTOOL_MSG_MM_GET_REPLY``             MAC merge layer status
>    ======================================== =================================
>  
>  ``GET`` requests are sent by userspace applications to retrieve device
> @@ -1716,6 +1719,104 @@ being used. Current supported options are toeplitz, xor or crc32.
>  ETHTOOL_A_RSS_INDIR attribute returns RSS indrection table where each byte
>  indicates queue number.
>  
> +MM_GET
> +======
> +
> +Retrieve 802.3 MAC Merge parameters.
> +
> +Request contents:
> +
> +  ====================================  ======  ==========================
> +  ``ETHTOOL_A_MM_HEADER``               nested  request header
> +  ====================================  ======  ==========================
> +
> +Kernel response contents:
> +
> +  ================================  ======  ===================================
> +  ``ETHTOOL_A_MM_HEADER``           Nested  request header
> +
> +  ``ETHTOOL_A_MM_SUPPORTED``        Bool    set if device supports the MM layer

I'm guessing the empty lines are to improve readability?
(They are not required for the table to render correctly.)

Why did you capitalize the types, tho?

> +  ``ETHTOOL_A_MM_PMAC_ENABLED``     Bool    set if RX of preemptible and SMD-V
> +                                            frames is enabled

s/is/are/ ?

> +  ``ETHTOOL_A_MM_TX_ENABLED``       Bool    set if TX of preemptible frames is
> +                                            administratively enabled (might be
> +                                            inactive if verification failed)
> +
> +  ``ETHTOOL_A_MM_TX_ACTIVE``        Bool    set if TX of preemptible frames is
> +                                            operationally enabled
> +
> +  ``ETHTOOL_A_MM_ADD_FRAG_SIZE``    U32     minimum size of transmitted
> +                                            non-final fragments, in octets
> +
> +  ``ETHTOOL_A_MM_VERIFY_ENABLED``   Bool    set if TX of SMD-V frames is
> +                                            administratively enabled (TX will
> +                                            not take place when port is not up)

The sentence in the brackets seems obvious, is there some special 
MM meaning to "port is not up"? You're not talking about the link
being up?

> +  ``ETHTOOL_A_MM_VERIFY_STATUS``    U8      state of the Verify function

Only places you say "Verify function" rather than just "verification",
not sure that's on purpose.

> +  ``ETHTOOL_A_MM_VERIFY_TIME``      U32     delay between verification attempts
> +
> +  ``ETHTOOL_A_MM_MAX_VERIFY_TIME``  U32     maximum interval supported by

s/interval/verification interval/ ?

> +                                            device
> +
> +  ``ETHTOOL_A_MM_STATS``            Nested  IEEE 802.3-2018 subclause 30.14.1
> +                                            oMACMergeEntity statistics counters
> +

The empty line between last entry and delimiter can go

> +  ================================  ======  ===================================
> +
> +If ``ETHTOOL_A_MM_SUPPORTED`` is reported as false, the other netlink
> +attributes will be absent.

Why not return -EOPNOTSUPP?
You do so in case driver does not have the op:

+	if (!ops->get_mm)
+		return -EOPNOTSUPP;


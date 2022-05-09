Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58435207FA
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiEIWuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiEIWuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:50:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7655F6E8CF;
        Mon,  9 May 2022 15:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66BDBCE1B7F;
        Mon,  9 May 2022 22:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F2C385B3;
        Mon,  9 May 2022 22:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652136365;
        bh=kUsp5ywapvjh+TIviLfPYdjLx8988YN+fB39xNMI1Hk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uz2QlAxx3fLtTv+bya49kC8Eyu85O0tp7SNOppx3x1ZCgUqya39mLXLjHuMQTmFOT
         TFijgu0XUzs94vlLJ7K0fMLiAw4GecyQ4N83nQzZwS4LJNSW6Ci7D88yvimWgO7DKa
         QvZ9ejOgGfS2N6OSnSwRbDRWtDyOiP7SHR98x2OhSKcnVzgQ2unv4h0CiADObiyo+o
         JLH7OkFSQb3UEEda+Cv8r3+6ESFQS1cIy3gAPQW26b7aKBMvlDtio/LA+sutQF05DO
         YNAeOKuVg/U6FVngVsfXr/PNcRQllg64X5YRlh9zKz/PggoljrjiwMA3CMxuqQrG76
         z+UTXDvApWvXQ==
Date:   Mon, 9 May 2022 15:46:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, jdenham@redhat.com, sbrivio@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, pabeni@redhat.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        shshaikh@marvell.com, manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v6 2/2] net: vxlan: Add extack support to
 vxlan_fdb_delete
Message-ID: <20220509154603.4a7b4243@kernel.org>
In-Reply-To: <ac4b6c650b6519cc56baa32ef20415460a5aa8ee.1651762830.git.eng.alaamohamedsoliman.am@gmail.com>
References: <cover.1651762829.git.eng.alaamohamedsoliman.am@gmail.com>
        <ac4b6c650b6519cc56baa32ef20415460a5aa8ee.1651762830.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 May 2022 17:09:58 +0200 Alaa Mohamed wrote:
> +			NL_SET_ERR_MSG(extack,
> +						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");

This continuation line still does not align with the opening bracket.
Look here if your email client makes it hard to see:

https://lore.kernel.org/all/ac4b6c650b6519cc56baa32ef20415460a5aa8ee.1651762830.git.eng.alaamohamedsoliman.am@gmail.com/

Same story in patch 1:

>  static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
>  			       struct net_device *dev,
> -			       const unsigned char *addr, u16 vid)
> +			       const unsigned char *addr, u16 vid,
> +				   struct netlink_ext_ack *extack)

and here:

>  static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>  			    struct net_device *dev,
> -			    const unsigned char *addr, u16 vid)
> +			    const unsigned char *addr, u16 vid,
> +				struct netlink_ext_ack *extack)

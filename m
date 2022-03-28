Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DD34EA3EF
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 02:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiC2AA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 20:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiC2AA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 20:00:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871E91621BE;
        Mon, 28 Mar 2022 16:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C2E9B812A5;
        Mon, 28 Mar 2022 23:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600B8C340F0;
        Mon, 28 Mar 2022 23:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648511921;
        bh=0JHLA9Az/gFd6bxzHMkYosq2dj4ONzVc2VUDBGf1fvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=puOeuIZFKSf+WhR6KFY36ycQK0llkBintfMJ2WZRa6vwpTFmZAMPQNzaatHt98Ebs
         ymdqLtYaAiZXH5fz5s8pJhorC1W3kVEs/xxkNvSMOU7GpwA/0zER/lklN4cbWuUwPK
         w81iiLjsl8oh6aohuoh0rH/C793oxhl9wPWYQdGdTw4V2OnjciJR2biiDoyhcNYOm5
         9AtAeslNkQzDKFgoMvUZnf6Pk/TL6qJaqw2nv1BnDgDK3pWdmqWKRe5ePn/OQ3n/8U
         RZWfHcQgG2KJQo6yq1N48Of4RGMe/Kwqv2uRAK0GkAhGA9/a9vP3VkjU++NELEdqeE
         ycljmGeKCYnlg==
Date:   Mon, 28 Mar 2022 16:58:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com, andrew@lunn.ch, davem@davemloft.net,
        pabeni@redhat.com, robh+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH v6 net 0/4] Fix broken link on Xilinx's AXI Ethernet in
 SGMII mode
Message-ID: <20220328165839.70f964dc@kernel.org>
In-Reply-To: <20220328123238.2569322-1-andy.chiu@sifive.com>
References: <20220328123238.2569322-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Mar 2022 20:32:34 +0800 Andy Chiu wrote:
> The Ethernet driver use phy-handle to reference the PCS/PMA PHY. This
> could be a problem if one wants to configure an external PHY via phylink,
> since it use the same phandle to get the PHY. To fix this, introduce a
> dedicated pcs-handle to point to the PCS/PMA PHY and deprecate the use
> of pointing it with phy-handle. A similar use case of pcs-handle can be
> seen on dpaa2 as well.
> 
> --- patch v5 ---
>  - Re-applying the v4 patch on the net tree.
>  - Describes the pcs-handle DT binding at ethernet-controller level.
> --- patch v6 ---
>  - Remove "preferrably" to clearify usage of pcs_handle.

This set not longer applies, please rebase on latest net/master.

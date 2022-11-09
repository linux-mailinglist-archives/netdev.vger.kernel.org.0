Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2145A622120
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiKIBDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiKIBDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:03:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA4B58016;
        Tue,  8 Nov 2022 17:03:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA78D617FF;
        Wed,  9 Nov 2022 01:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1233C433D6;
        Wed,  9 Nov 2022 01:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667955781;
        bh=AKGrBhvkorqm/2TEcJUFOKbZe1Y1MF1i/gGlH8Y2quU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K1BVFiw3c4elu5Wxs9Ey1ivJO5ncGEQGN22oqnPXZaigjFVnUy+sUhCvgbcaJgXFx
         4RVfL/IvVR7JJae/Va0IHcIENiCmkULoRi9yyZuLpYWBPF/IyaNwVQuBs4cpIiBivE
         1FSBZpmhy4pzZ75ROfdsyuIwm6AOquyninmLUQpdsTalUQ1Mrr2/oQ9NfTjBe/WvZr
         znAUXE4GRFDTVMvQJdEkrWQ3Oc0+Fe1py3bYWf1IoGFeBp4PSDtXh8Ix2XEfLez89h
         q35cBmGC5DF17CPx0Hc00hds+00/1dd+keKJSxrlZo3dTTKWqFO9fSRY1+k1NMVIy3
         ByhvPkUfNP/Uw==
Date:   Tue, 8 Nov 2022 17:02:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, pabeni@redhat.com, edumazet@google.com,
        greentime.hu@sifive.com
Subject: Re: [PATCH v3 net-next 0/3] net: axienet: Use a DT property to
 configure frequency of the MDIO bus
Message-ID: <20221108170259.2e95c6c0@kernel.org>
In-Reply-To: <20221104060305.1025215-1-andy.chiu@sifive.com>
References: <20221104060305.1025215-1-andy.chiu@sifive.com>
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

On Fri,  4 Nov 2022 14:03:02 +0800 Andy Chiu wrote:
> Some FPGA platforms have to set frequency of the MDIO bus lower than 2.5
> MHz. Thus, we use a DT property, which is "clock-frequency", to work
> with it at boot time. The default 2.5 MHz would be set if the property
> is not pressent. Also, factor out mdio enable/disable functions due to
> the api change since 253761a0e61b7.

FWIW this patch set was set to Changes Requested in the patchwork
but I don't recall what the reason was. If you're not aware of anyone
requesting changes either - could you just repost to the list again,
the same exact code?

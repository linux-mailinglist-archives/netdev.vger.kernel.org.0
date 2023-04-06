Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5F56D8C2A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjDFAyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjDFAyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:54:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4D365B6;
        Wed,  5 Apr 2023 17:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33C763570;
        Thu,  6 Apr 2023 00:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B8C433D2;
        Thu,  6 Apr 2023 00:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680742487;
        bh=g+UND0j5inL0XUXLwORjYYJtQ3AtOdrCes6rxYidbmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RODaCHga84tnTcZijWbd/HBNGDpLyU9Qz4IntbKeutfFvIpqk7Wn6F9spD2RqCNaC
         GliJnPO6rrnSZ96HN983VH3cyrwUaJC9dS5VII2obtwPIpO3rJsD+99cJ2qDFUK6K7
         c4TyYSVKWdNGOCHotvmGbc2eBW01gZvqJ63BsNYtcm4eCG6bvg4CMmjj6TmnU4dLXs
         JTDgWWMR7vk9OlJ5PIMY6yW+jp5OPxOPvtJh03rgHTNk9x9GNdfc4gjYzu84fBo5ri
         NlOLaEv1CIt2bCYw7DuJ0OdH2slucXjn7SHNtDfXdITFKu3fmXdrviviIVeQysDJ/D
         f4LgkrP4GgmrA==
Date:   Wed, 5 Apr 2023 17:54:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: dsa: brcm,sf2: Drop unneeded
 "#address-cells/#size-cells"
Message-ID: <20230405175445.3e7639e1@kernel.org>
In-Reply-To: <20230404204152.635400-1-robh@kernel.org>
References: <20230404204152.635400-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Apr 2023 15:41:52 -0500 Rob Herring wrote:
> There's no need for "#address-cells/#size-cells" in the brcm,sf2 node as
> no immediate child nodes have an address. What was probably intended was
> to put them in the 'ports' node, but that's not necessary as that is
> covered by ethernet-switch.yaml via dsa.yaml.

There was an application fuzz on this one, FWIW. 
Hope I'm not messing up...

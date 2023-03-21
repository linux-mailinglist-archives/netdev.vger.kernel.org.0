Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280A46C293D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCUEoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCUEoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:44:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBC430181;
        Mon, 20 Mar 2023 21:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C45306195D;
        Tue, 21 Mar 2023 04:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAAEC433D2;
        Tue, 21 Mar 2023 04:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679373838;
        bh=2s4jY8/zJcEM72Oy6GTSv34oh2hGJUAKFp8HfH4OOZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HzGSCHWrSKytehdFqo0TzC0qNk1vSMtVNv9tb0WkdoWdbzigl7Yn7Mle23nE18FE1
         yFyD8z+Fgy45V9qx6wC1L2VzmOhnvTzPHJLLQA+srNArtMxtUXbe7g83uwIZ1zaAyr
         tc3tUi+wolZUgLWia2et61DnX3PWIyGuUfMu7moE7CROqFe6z0Mhim2UTGN1f6mogx
         EP/9gKTruA9lwYh1Kskv68B619fXygjROx8izkuY81m96oihpPxDncfVYFnn6xZ9Gp
         OanjG/3ViUdqsCMCeAguokh5kjxaeLq83urjGmCUji8y8EBeP/YlpTwJ1BF3VPsucr
         ToKPWiVpj5wFw==
Date:   Mon, 20 Mar 2023 21:43:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] mtk: wed: move cpuboot, ilm and dlm in
 dedicated dts nodes
Message-ID: <20230320214356.27c62f9f@kernel.org>
In-Reply-To: <cover.1679330630.git.lorenzo@kernel.org>
References: <cover.1679330630.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 17:57:54 +0100 Lorenzo Bianconi wrote:
>  arch/arm64/boot/dts/mediatek/mt7986a.dtsi     | 69 +++++++-------

Do you know if this can go via our tree, or via arm/MediaTek ?

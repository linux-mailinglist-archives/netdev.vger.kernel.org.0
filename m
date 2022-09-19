Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D515BCD70
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiISNnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiISNnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:43:13 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8F211C22;
        Mon, 19 Sep 2022 06:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VocfEw++MFgUsPr0v6ZBZJ3FMCFmFfXe2mplGtWPu2M=; b=OUcgTWX8iTWv1z2PC1W/G8Y0IU
        VnnVpDlIU5YvD0Wk/RI8jScos5OainyAIVDjdjbSECXSAIFn9eMUqeHIIAhNDc2INKOuy27IMii/y
        iC0EOnkKV+9CZPsNOHob5h0GbZdC7lTxZzXeJr8SGb/c23czk0bLhQ5P9njD0UHQuAeqa5RrIjcru
        lWNRMopGKRmZTxdEP91vTSeGLn9ffA88/AcbxaW/L8U5DCa9t20JrBub7vsYTPPATBF28j2Xhrpes
        c2heHaBJW3qg8eCZdbMzjJ33X3Dr+w1uMAHLQyEcRkZM2sgkdl/bua382CyRdl/L4woJeBjzMKMbJ
        rEvGPGvw==;
Received: from [92.206.252.27] (helo=javelin)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oaGuR-0018Y4-GQ; Mon, 19 Sep 2022 13:34:03 +0000
Date:   Mon, 19 Sep 2022 15:34:01 +0200
From:   Alexander 'lynxis' Couzens <lynxis@fe80.eu>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/5] net: mediatek: sgmii:
 mtk_pcs_setup_mode_an: don't rely on register defaults
Message-ID: <20220919153402.65baf42b@javelin>
In-Reply-To: <YyhSnqacAE4ajRdy@shell.armlinux.org.uk>
References: <20220919083713.730512-1-lynxis@fe80.eu>
        <20220919083713.730512-4-lynxis@fe80.eu>
        <YyhSnqacAE4ajRdy@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Sep 2022 12:29:34 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> I'm not sure if I've asked this before, but why does SGMII_AN_RESTART
> need to be set here? It could do with a comment in the code.

It's not my bit :). I've not added it. But why not (re)start autoneg
when powering up the phy?

Should it done elsewhere?

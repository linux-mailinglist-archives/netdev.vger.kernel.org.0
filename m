Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30703E04CC
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbhHDPt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:49:57 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43648 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239442AbhHDPtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:49:55 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 174FnRuh010232;
        Wed, 4 Aug 2021 10:49:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628092167;
        bh=uGCZbtqEYmK5kLgwupBcfUZCsog7QexvO2Uxics2r+k=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=lRDZ119Vp5RfkrAPbJiFD7zbm8ynrlWp6+fMlaaaryaQxnuKSZdG+TBxRQNow/CLB
         jvaela/0MA9K+THEyyCqD8+oTFtzWweX8VhEpE8zeUrIskz2RgkNDfiHmXfrFlDgbw
         KINebrXHFvtbY0rXXbxMACqHSowwM4rhtcj2HSFM=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 174FnR6m121600
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Aug 2021 10:49:27 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 4 Aug
 2021 10:49:27 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 4 Aug 2021 10:49:26 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 174FnRsq039974;
        Wed, 4 Aug 2021 10:49:27 -0500
Date:   Wed, 4 Aug 2021 10:49:27 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Aswath Govindraju <a-govindraju@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] dt-bindings: net: can: Document power-domains property
Message-ID: <20210804154927.w5jtppcc6n6qh7mf@never>
References: <20210802091822.16407-1-a-govindraju@ti.com>
 <20210804072341.l4flosh7rkvma22o@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210804072341.l4flosh7rkvma22o@pengutronix.de>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09:23-20210804, Marc Kleine-Budde wrote:
> On 02.08.2021 14:48:22, Aswath Govindraju wrote:
> > Document power-domains property for adding the Power domain provider.
> > 
> > Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> 
> Applied to linux-can-next/testing.
> 
> BTW: TI's dkim is broken:
> 
> |   ✗ [PATCH v2] dt-bindings: net: can: Document power-domains property
> |     + Link: https://lore.kernel.org/r/20210802091822.16407-1-a-govindraju@ti.com
> |     + Acked-by: Rob Herring <robh@kernel.org>
> |     + Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> |   ---
> |   ✗ BADSIG: DKIM/ti.com
> 

I have taken this up with TI's IT operations folks, Thanks for the headsup.

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D

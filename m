Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1DE4C4287
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiBYKjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239694AbiBYKjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:39:33 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7408A1CABC2;
        Fri, 25 Feb 2022 02:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+Xn6FzCuUazJGXD67KTYniSd2lGAAlj38VcC1aa/bc0=; b=Ro+pJpQZ9JcDZevJIMLxTuad/H
        Sseks3nrleSAy9xs9huspJ4b/Va+W2jw5nIxBRBQJK5CniSMzg4xetI5pqiAmXHKZsDFbgZg8TraO
        jsVL4wsp73Yvo10CQSSyCZuq9xU9EeQkzUDkf3LntOrH8yygtcWk4wDMBbwkklrgtbAM=;
Received: from p200300daa7204f00f847964d075b2b3d.dip0.t-ipconnect.de ([2003:da:a720:4f00:f847:964d:75b:2b3d] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nNXzs-00088g-S6; Fri, 25 Feb 2022 11:38:48 +0100
Message-ID: <18408826-3af1-a80a-181d-25f46b4920fb@nbd.name>
Date:   Fri, 25 Feb 2022 11:38:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 02/11] arm64: dts: mediatek: mt7622: add support for
 coherent DMA
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220225101811.72103-1-nbd@nbd.name>
 <20220225101811.72103-3-nbd@nbd.name>
In-Reply-To: <20220225101811.72103-3-nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.22 11:18, Felix Fietkau wrote:
> It improves performance by eliminating the need for a cache flush on rx and tx
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
Sorry, I accidentally left out the dt-bindings patches. They will be 
included in v2.

- Felix

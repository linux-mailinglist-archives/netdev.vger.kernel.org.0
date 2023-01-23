Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578806782BD
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjAWRQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjAWRQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:16:19 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A892D16C;
        Mon, 23 Jan 2023 09:15:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674494115; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=J3D1nRrqdR7VVwC5VJmPGIPhaqzeQ88fG+fHjhgJ08DTQOkJ5kPybexGXU+z9Qlt2zbvVOHwBt8VCeRW4w0COuV1F6md071d4jDcSAmKrliC+K84BW99J0VVXhrKyjLDxbVLCRbaGArizAyTeujbh0WyD20pwCoLvHhA73G76xU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674494115; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yuwGd2YcEpwDjBwVwPYpdZ9lUV0N6XEYhlBFGQbYKjE=; 
        b=ku2tD7MGOtAokjrpTZbxysioFn5Fg3xbdkwZENf0GyY+8WE7UzFc/4+fa9zBAAKok88w3IdEN56HpSvrtXDniVTY221qLRxwJPpJyIAmYSmP1JTdH0Ak0D0EwkP+AxIveTFYT9wwvxZ86Gl2kyc1apgyo5fgyRcYaLbvi8h+8FU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674494115;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=yuwGd2YcEpwDjBwVwPYpdZ9lUV0N6XEYhlBFGQbYKjE=;
        b=GWxHpKSp20cf4rv7cdRwL5dJ0rSfaQlFCKuq4GLWLSlU+3H1w7XkTxQQ+e8GKDH2
        hKzBIR9gdOh3YTDCXLwzo2uxigYuBmpkNKxf6QsTmXDoaZKgrwJ2nuXwcAALChUQYoq
        QpxXnuzoxyRdZ/adN7W3dXsQqX9uGgRqPdjemnrA=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1674494111566648.0127878046771; Mon, 23 Jan 2023 09:15:11 -0800 (PST)
Message-ID: <6d44b799-1843-e233-39ea-ff62d2d64065@arinc9.com>
Date:   Mon, 23 Jan 2023 20:15:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: dsa: mt7530: fix tristate and help description
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com
References: <20230123170853.400977-1-arinc.unal@arinc9.com>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230123170853.400977-1-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just to make sure, the limit for a line is 80 columns for kconfig too, 
is that right? A tab character is 8 columns.

Arınç

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA06A84D7
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCBPD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCBPD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:03:58 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD0B410AD;
        Thu,  2 Mar 2023 07:03:56 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 3611A1272;
        Thu,  2 Mar 2023 16:03:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1677769435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFh65Q0meHUvCZajlWBLFgBfm/4mtsOaSmn9QAS8Lrw=;
        b=vncLLb3smtpBMIEMMSwOgNGHoDkn2UreOPYUqHEzaVUlOg9Bg9jQd/OfOqFowPlNahyt/s
        tpgWcuwDyBsB7uo17QBgvJBnKUrWqntNyM8Fz/JYwDbU8pl/wDkQVmB/Ab2eSzwLLVV+21
        lnELqlv8K8FkM2CESNfhIxBcl11+j4TlzmEbSSN0FecEyORYIXkLVIEN7Vt9qPCow12Cx/
        8p0FW+XkuFu8ud6iROFEv50yb4zE4fYuyiaEqzdPu50oEWb2eZpnChEZLi8viRVYbWdUg5
        pOla+QzhedRpMum/dCiEVfG5w9HIeIP4wzYwlJzbxMf1OF8Hx0DurW/DTB1MAA==
MIME-Version: 1.0
Date:   Thu, 02 Mar 2023 16:03:55 +0100
From:   Michael Walle <michael@walle.cc>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     tharvey@gateworks.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, hauke@hauke-m.de, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, martin.blumenstingl@googlemail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
In-Reply-To: <adb55f7dc3b4be01317cf7766e389874@dev.tdt.de>
References: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <20230222160425.4040683-1-michael@walle.cc>
 <8aa26f417c99761cdf1b6b7082fdec14@dev.tdt.de>
 <df9a0b6e59d27d5898a9021915ca333a@walle.cc>
 <adb55f7dc3b4be01317cf7766e389874@dev.tdt.de>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <36b05e6b246b200a7f26fb09892dc9f8@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

> In my tests I always set the skew values in register 0x17 first and
> then triggered a restart of the ANEG via register 0x0. This then led to
> the new values being adopted.

Right. I missed that. And I can confirm this is working perfectly 
although
mentioned otherwise in the datasheet. The answer FAE anser is still
outstanding.

Thank you!
-michael

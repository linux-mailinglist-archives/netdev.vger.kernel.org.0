Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD2612C19
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 18:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJ3R6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 13:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJ3R6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 13:58:16 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 30 Oct 2022 10:58:15 PDT
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39733A479;
        Sun, 30 Oct 2022 10:58:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1667151762; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=LoQgOqNpF8Wwcu6VtLKcO4yYoCvOKAdIVCYF9kaDjStJS7UpaFt6+gdxBlbPtZ3q2AhTueAktG3rTOBOAl/ZlRzWFtKPXQXbP/2Y8hKYsSkJtz5lu8YyAZma6cVn3G3cJ6hUp5vRc+t2RqFvag57ztmd0POErtRJRrdFRJ93how=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1667151762; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9bbvkGLwb/l1l5DfSEEWjM8y6U4gTUldLMgsN2ZwJHI=; 
        b=d/INXma4ZfwxCDKG6YckAw79LjrhUW3sxofmHWm6WUj2S1wj4YE80ny6R3T98/xS8/xpkwpPszBjwrqheeet7UVG7YG7HYg95avPUITQZep7aaPzIaPpyuzsOs9OtpE2KLdLHZMFIZWs+OOVVea2V1oRhivHEJ0pGNSgsX04IFc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1667151762;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9bbvkGLwb/l1l5DfSEEWjM8y6U4gTUldLMgsN2ZwJHI=;
        b=BgJlSSBIjCMuklesP4o7xxtQBHELhJLioMpT0uZ/6IziR5QiJ3g7DtK6SY/DK/z8
        +XNGl1kZovw21Rwa8t4UsBugjGTAzdqGXKLVuUrB1AANgJkKufZi/Fu9qcgAUKdyBQp
        Zegg27gAXPxIotcEcuusabwUk1eWrnEosEjSdv3Q=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1667151759719557.7288943473982; Sun, 30 Oct 2022 10:42:39 -0700 (PDT)
Message-ID: <a75564ec-3a9a-1bd6-3f4f-aae28ac933ad@arinc9.com>
Date:   Sun, 30 Oct 2022 20:42:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v1 net-next 4/7] dt-bindings: net: dsa: mediatek,mt7530:
 remove unnecessary dsa-port reference
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-5-colin.foster@in-advantage.com>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20221025050355.3979380-5-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.10.2022 08:03, Colin Foster wrote:
> dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
> the binding isn't necessary. Remove this unnecessary reference.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Thanks.
Arınç

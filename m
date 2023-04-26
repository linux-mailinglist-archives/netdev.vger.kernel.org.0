Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3E86EF83E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241370AbjDZQRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241410AbjDZQRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:17:31 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AB772BB;
        Wed, 26 Apr 2023 09:17:30 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1prhpE-0005lh-2Q;
        Wed, 26 Apr 2023 18:17:00 +0200
Date:   Wed, 26 Apr 2023 17:15:12 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 04/24] net: dsa: mt7530: properly support
 MT7531AE and MT7531BE
Message-ID: <ZElOEAsoNXUlYL1g@makrotopia.org>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
 <20230425082933.84654-5-arinc.unal@arinc9.com>
 <ZEfsCit0XX8zqUIJ@makrotopia.org>
 <ce681fac-5f00-f0fc-b2cf-89907c50ee7c@arinc9.com>
 <ZEkiIQZsspBlDyEn@makrotopia.org>
 <20230426143944.s5vmhloepa3yodrj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230426143944.s5vmhloepa3yodrj@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 05:39:44PM +0300, Vladimir Oltean wrote:
> On Wed, Apr 26, 2023 at 02:07:45PM +0100, Daniel Golle wrote:
> > On Wed, Apr 26, 2023 at 11:12:09AM +0300, Arınç ÜNAL wrote:
> > > On 25.04.2023 18:04, Daniel Golle wrote:
> > > > On Tue, Apr 25, 2023 at 11:29:13AM +0300, arinc9.unal@gmail.com wrote:
> > > > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > > > 
> > > > > Introduce the p5_sgmii pointer to store the information for whether port 5
> > > > > has got SGMII or not.
> > > > 
> > > > The p5_sgmii your are introducing to struct mt7530_priv is a boolean
> > > > variable, and not a pointer.
> > > 
> > > I must've meant to say field.
> > 
> > Being just a single boolean variable also 'field' would not be the right
> > word here. We use 'field' as in 'bitfield', ie. usually disguised integer
> > types in which each bit has an assigned meaning.
> 
> "field" is a perfectly legal name for a member of a C structure.
> https://en.wikipedia.org/wiki/Struct_(C_programming_language)
> Not to be confused with bitfield.

Right, thank you for pointing that out.
Must have slipped off my mind that all this is inside a struct, of
course...


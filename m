Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0145A5049
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 17:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiH2PiW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Aug 2022 11:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2PiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 11:38:21 -0400
Received: from x61w.mirbsd.org (xdsl-85-197-1-163.nc.de [85.197.1.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C7D8275A
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 08:38:20 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 4953C2910F; Mon, 29 Aug 2022 17:38:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 41827290F0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:38:19 +0200 (CEST)
Date:   Mon, 29 Aug 2022 17:38:19 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: Re: inter-qdisc communication?
In-Reply-To: <95259a4e-5911-6b7b-65c1-ca33312c23ec@tarent.de>
Message-ID: <e6509d55-ea5e-ee51-692f-2fe75ba28a21@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de> <20220826170632.4c975f21@kernel.org> <95259a4e-5911-6b7b-65c1-ca33312c23ec@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Aug 2022, Thorsten Glaser wrote:

> All references to ifb seem to cargo-cult the following filter…
> 
> 	protocol ip u32 match u32 0 0 flowid 1:1
> 	 action mirred egress redirect dev ifb0

> I require any and all traffic of all protocols to be redirected.
> Not just IPv4, and not just traffic that matches anything. Can I
> do that with the filter, and will this “trick” get me the effect
> I want to have?

https://wiki.gentoo.org/wiki/Traffic_shaping#Traffic_Shaping_Script
has “protocol all” but there is still a filter required? Looking at
net/sched/cls_u32.c this is _quite_ an amount of code involved; is
there really no pass-all? Maybe it’s time to write one…

bye,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************

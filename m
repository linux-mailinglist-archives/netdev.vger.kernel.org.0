Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EFA5A503E
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 17:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiH2PdR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Aug 2022 11:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiH2PdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 11:33:16 -0400
Received: from x61w.mirbsd.org (xdsl-85-197-1-163.nc.de [85.197.1.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181C17E001
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 08:33:13 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id B25D92910F; Mon, 29 Aug 2022 17:33:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id AA1ED28FDF
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:33:12 +0200 (CEST)
Date:   Mon, 29 Aug 2022 17:33:12 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: tc-stab(8) dead link and question
Message-ID: <b41de7e-2c73-a3c6-c2fc-d72d783cee42@tarent.de>
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

Hi again,

from reading around in more documentation, I found “stab” mentioned
and that it refers to tc-stab(8).

First, the [1] link is dead; the Wayback Machine has as last version:
http://web.archive.org/web/20150606220856/http://ace-host.stuart.id.au/russell/files/tc/tc-atm/

Second… this might be something I’d need to take into account when
doing bandwidth limiting. How do I use the adjusted sizes?

Currently, I’m shaping by taking skb->len and multiplying with the
amount of ns per byte that can be calculated from the configured rate.
This (on ethernet, which I’m testing on; in prod it is possibly used
on WLAN instead but not always) already takes the Ethernet header into
account, but not the trailer apparently, but it would obviously need
per-packet overhead for DSL links, so I’m wondering which variables
I need to query, and how, for this.

Thanks,
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

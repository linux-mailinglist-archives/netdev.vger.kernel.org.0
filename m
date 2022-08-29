Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DB85A5594
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiH2UcY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Aug 2022 16:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiH2UcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 16:32:23 -0400
Received: from x61w.mirbsd.org (xdsl-85-197-1-163.nc.de [85.197.1.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DAD83F1C
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 13:32:21 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 8924624668; Mon, 29 Aug 2022 22:32:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id E29A724667
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 22:32:18 +0200 (CEST)
Date:   Mon, 29 Aug 2022 22:32:18 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: continuous REPL mode for tc(8)
Message-ID: <33c27582-9b59-60f9-3323-c661b9524c51@tarent.de>
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

Hi,

perhaps, if not inter-qdisc communication, can I at least have
a mode for tc to run in a loop, so I lose the fork+exec overhead
when calling tc change a *lot* of times?

How difficult to implement is that?

Could I, maybe, even just call main() multiple times, or does
that leak?

Thanks in advance,
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

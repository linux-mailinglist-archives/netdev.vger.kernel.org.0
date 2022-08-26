Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1449C5A3024
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344729AbiHZTnU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Aug 2022 15:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiHZTnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:43:18 -0400
X-Greylist: delayed 507 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Aug 2022 12:43:17 PDT
Received: from x61w.mirbsd.org (xdsl-89-0-70-246.nc.de [89.0.70.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3B9D5710
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 12:43:16 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 9A32724551; Fri, 26 Aug 2022 21:34:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 92F622454E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 21:34:47 +0200 (CEST)
Date:   Fri, 26 Aug 2022 21:34:47 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: inter-qdisc communication?
Message-ID: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: Yes, score=6.2 required=5.0 tests=BAYES_50,KHOP_HELO_FCRDNS,
        RCVD_IN_PBL,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  3.3 RCVD_IN_PBL RBL: Received via a relay in Spamhaus PBL
        *      [89.0.70.246 listed in zen.spamhaus.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.7 SPF_SOFTFAIL SPF: sender does not match SPF record (softfail)
        *  1.0 RDNS_DYNAMIC Delivered to internal network by host with
        *      dynamic-looking rDNS
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.4 KHOP_HELO_FCRDNS Relay HELO differs from its IP's reverse DNS
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

is it possible for qdiscs to communicate with each other?

For example, if I have a normal egress qdisc and an ingress
qdisc, how could I “share” configuration values so that e.g.
a “tc change” can affect both in one run?

Use case: we have a normal egress qdisc that does a lot of
things. Now we add artificial latency, and we need to do that
on ingress as well, for symmetry, obviously, so I’ll write a
small qdisc that does just that for ingress. But we’re already
firing a “tc change” to the egress qdisc every few ms or so,
and I don’t want to double that overhead.

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

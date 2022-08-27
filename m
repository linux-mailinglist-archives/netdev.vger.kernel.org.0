Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A35A33A4
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiH0CAK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Aug 2022 22:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345225AbiH0CAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:00:08 -0400
Received: from x61w.mirbsd.org (xdsl-89-0-70-246.nc.de [89.0.70.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1F6EE1B
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 19:00:05 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id B96E529265; Sat, 27 Aug 2022 04:00:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id B185F28D7A;
        Sat, 27 Aug 2022 04:00:02 +0200 (CEST)
Date:   Sat, 27 Aug 2022 04:00:02 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Dave Taht <dave.taht@gmail.com>
cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: inter-qdisc communication?
In-Reply-To: <CAA93jw66wYTAWQoAcEU-1=GxKe61U9_j__zMkooyODrLO=wnFQ@mail.gmail.com>
Message-ID: <21f823b-aa56-95fc-6da7-85aeddba705c@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de> <20220826170632.4c975f21@kernel.org> <49bb3aa4-a6d0-7f38-19eb-37f270443e7e@tarent.de> <20220826180641.1e856c1d@kernel.org> <CAA93jw66wYTAWQoAcEU-1=GxKe61U9_j__zMkooyODrLO=wnFQ@mail.gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=3.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RCVD_IN_PBL,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022, Dave Taht wrote:

> This has some useful info on using netem properly, inc latency
> https://www.bufferbloat.net/projects/codel/wiki/Best_practices_for_benchmarking_Codel_and_FQ_Codel/

It mostly has that netem cannot be used together with other qdiscs,
and my colleague found that out, the hard way, as well. So I need to
implement that part myself as well. I have an idea for egress, but
nothing past that yet.

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

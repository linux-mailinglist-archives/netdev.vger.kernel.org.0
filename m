Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A045A3334
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbiH0ApK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Aug 2022 20:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiH0ApJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:45:09 -0400
Received: from x61w.mirbsd.org (xdsl-89-0-70-246.nc.de [89.0.70.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE46310578
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 17:45:05 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id E342829185; Sat, 27 Aug 2022 02:45:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id DC9FA2915A;
        Sat, 27 Aug 2022 02:45:02 +0200 (CEST)
Date:   Sat, 27 Aug 2022 02:45:02 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org
Subject: Re: inter-qdisc communication?
In-Reply-To: <20220826170632.4c975f21@kernel.org>
Message-ID: <49bb3aa4-a6d0-7f38-19eb-37f270443e7e@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de> <20220826170632.4c975f21@kernel.org>
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

On Fri, 26 Aug 2022, Jakub Kicinski wrote:

> How do you add latency on ingress? 🤔 
> The ingress qdisc is just a stub to hook classifiers/actions. 

Oh, damn. Then, I guess, I’ll have to do that on egress on
the other interface, which makes it at least symmetric for
passing traffic but catch not the set of traffic it should.
Especially not the traffic terminating locally. Meh.

The question remains the same, just the use case magically
mutated under me.

(Maybe if there were documentation like an intro to qdisc
writing like I asked for already, I’d have known that.)

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

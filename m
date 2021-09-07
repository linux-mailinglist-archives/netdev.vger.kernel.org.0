Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3369A402EFD
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhIGTd5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Sep 2021 15:33:57 -0400
Received: from lixid.tarent.de ([193.107.123.118]:41415 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231941AbhIGTdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 15:33:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 3C987140C63;
        Tue,  7 Sep 2021 21:32:47 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 4SC8CvqGdfGB; Tue,  7 Sep 2021 21:32:41 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id AA4841400EE;
        Tue,  7 Sep 2021 21:32:41 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 4C65352238E; Tue,  7 Sep 2021 21:32:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id 498C05203C0;
        Tue,  7 Sep 2021 21:32:41 +0200 (CEST)
Date:   Tue, 7 Sep 2021 21:32:41 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     Wen Liang <liangwen12year@gmail.com>, netdev@vger.kernel.org,
        dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 1/2] tc: u32: add support for json output
In-Reply-To: <20210907122914.34b5b1a1@hermes.local>
Message-ID: <f9752b7-476-5ae6-6ab4-717e1c8553bb@tarent.de>
References: <cover.1630978600.git.liangwen12year@gmail.com>        <5c4108ba5d3c30a0366ad79b49e1097bd9cc96e1.1630978600.git.liangwen12year@gmail.com> <20210907122914.34b5b1a1@hermes.local>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Sep 2021, Stephen Hemminger wrote:

> Space is not valid in JSON tag.

They are valid. Any strings are valid.

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
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************

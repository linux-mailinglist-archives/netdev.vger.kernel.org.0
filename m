Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1894396FB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 22:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbfFGUoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 16:44:24 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:50176 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbfFGUoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 16:44:24 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.92)
        (envelope-from <mh+netdev@zugschlus.de>)
        id 1hZLin-0000Vd-Fc; Fri, 07 Jun 2019 22:44:21 +0200
Date:   Fri, 7 Jun 2019 22:44:21 +0200
From:   Marc Haber <mh+netdev@zugschlus.de>
To:     Yussuf Khalil <dev@pp3345.net>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: Re: iwl_mvm_add_new_dqa_stream_wk BUG in lib/list_debug.c:56
Message-ID: <20190607204421.GK31088@torres.zugschlus.de>
References: <20190530081257.GA26133@torres.zugschlus.de>
 <20190602134842.GC3249@torres.zugschlus.de>
 <29401822-d7e9-430b-d284-706bf68acb8a@pp3345.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29401822-d7e9-430b-d284-706bf68acb8a@pp3345.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 10:20:56PM +0200, Yussuf Khalil wrote:
> CC'ing iwlwifi maintainers to get some attention for this issue.
> 
> I am experiencing the very same bug on a ThinkPad T480s running 5.1.6 with
> Fedora 30. A friend is seeing it on his X1 Carbon 6th Gen, too. Both have an
> "Intel Corporation Wireless 8265 / 8275" card according to lspci.

I have an older 04:00.0 Network controller [0280]: Intel Corporation
Wireless 8260 [8086:24f3] (rev 3a) on a Thinkpad X260.

> Notably, in all cases I've observed it occurred right after roaming from one
> AP to another (though I can't guarantee this isn't a coincidence).

I also have multiple Access Points broadcasting the same SSID in my
house, and yes, I experience those issues often when I move from one
part of the hose to another. I have, however, also experienced it in a
hotel when I was using the mobile hotspot offered by my mobile, so that
was clearly not a roaming situation.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

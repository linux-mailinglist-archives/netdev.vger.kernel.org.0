Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600973236F
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFBNsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 09:48:45 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:36180 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfFBNso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 09:48:44 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.92)
        (envelope-from <mh+netdev@zugschlus.de>)
        id 1hXQqo-0000vP-R8; Sun, 02 Jun 2019 15:48:42 +0200
Date:   Sun, 2 Jun 2019 15:48:42 +0200
From:   Marc Haber <mh+netdev@zugschlus.de>
To:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: iwl_mvm_add_new_dqa_stream_wk BUG in lib/list_debug.c:56
Message-ID: <20190602134842.GC3249@torres.zugschlus.de>
References: <20190530081257.GA26133@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190530081257.GA26133@torres.zugschlus.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:12:57AM +0200, Marc Haber wrote:
> on my primary notebook, a Lenovo X260, with an Intel Wireless 8260
> (8086:24f3), running Debian unstable, I have started to see network
> hangs since upgrading to kernel 5.1. In this situation, I cannot
> restart Network-Manager (the call just hangs), I can log out of X, but
> the system does not cleanly shut down and I need to Magic SysRq myself
> out of the running system. This happens about once every two days.

The issue is also present in 5.1.5 and 5.1.6.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

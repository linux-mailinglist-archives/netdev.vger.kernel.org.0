Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30B028F8C8
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388964AbgJOSkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:40:46 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36272 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgJOSkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 14:40:45 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2020 14:40:44 EDT
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 8CBB48679B; Thu, 15 Oct 2020 20:33:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1602786833;
        bh=dV0+kWgIRHjFHhxjma5VS4fwV/bqAmm2JmcpyYQHK90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p5/cKbKVaK1KcqSaIR+mbp40xg+ZVM+ARTbEzmtyf+FsWORoLFdd+I7z7/gQoRC8q
         x3wTkT+Rv9QDAS9jUAQKvHP4RXGauB+zDCnT17lfAjh4hgJrsbA5ozeozDKDhTPtL9
         mKa+hjuaL2M81xlp8zMt/065Fkf8gdXuYj6VNL8g=
Date:   Thu, 15 Oct 2020 11:33:53 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: perf measure for stalled cycles per instruction on newer Intel
 processors
Message-ID: <20201015183352.o4zmciukdrdvvdj4@two.firstfloor.org>
References: <CAJ3xEMiOtDe5OeC8oT2NyVu5BEmH_eLgAAH4voLqejWgsvG4xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiOtDe5OeC8oT2NyVu5BEmH_eLgAAH4voLqejWgsvG4xQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 05:53:40PM +0300, Or Gerlitz wrote:
> Hi,
> 
> Earlier Intel processors (e.g E5-2650) support the more of classical
> two stall events (for backend and frontend [1]) and then perf shows
> the nice measure of stalled cycles per instruction - e.g here where we
> have IPC of 0.91 and CSPI (see [2]) of 0.68:

Don't use it. It's misleading on a out-of-order CPU because you don't
know if it's actually limiting anything.

If you want useful bottleneck data use --topdown.

-Andi

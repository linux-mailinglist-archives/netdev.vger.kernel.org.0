Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDE126648
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfLSQAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:00:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:52706 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfLSQAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:00:05 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihyDR-0001RQ-Vz; Thu, 19 Dec 2019 16:59:54 +0100
Date:   Thu, 19 Dec 2019 16:59:53 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf v2 0/4] Fix concurrency issues between XSK wakeup and
 control path using RCU
Message-ID: <20191219155953.GD4198@linux-9.fritz.box>
References: <20191217162023.16011-1-maximmi@mellanox.com>
 <cfe64691-7a0f-5b8a-d511-ebe742cec3c0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfe64691-7a0f-5b8a-d511-ebe742cec3c0@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 06:33:14PM +0100, Björn Töpel wrote:
> On 2019-12-17 17:20, Maxim Mikityanskiy wrote:
> > This series addresses the issue described in the commit message of the
> > first patch: lack of synchronization between XSK wakeup and destroying
> > the resources used by XSK wakeup. The idea is similar to
> > napi_synchronize. The series contains fixes for the drivers that
> > implement XSK. I haven't tested the changes to Intel's drivers, so,
> > Intel guys, please review them.
> 
> Max, thanks a lot for compiling the series on your vacation!

Applied, thanks!

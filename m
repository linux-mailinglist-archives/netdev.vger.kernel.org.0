Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701A0104E4F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUIst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:48:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:33918 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUIst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:48:49 -0500
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXi8t-0002G7-4F; Thu, 21 Nov 2019 09:48:47 +0100
Date:   Thu, 21 Nov 2019 09:48:46 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH bpf-next] tools: bpftool: fix warning on ignored return
 value for 'read'
Message-ID: <20191121084846.GA31576@pc-11.home>
References: <20191119111706.22440-1-quentin.monnet@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119111706.22440-1-quentin.monnet@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25639/Wed Nov 20 11:02:53 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 11:17:06AM +0000, Quentin Monnet wrote:
> When building bpftool, a warning was introduced by commit a94364603610
> ("bpftool: Allow to read btf as raw data"), because the return value
> from a call to 'read()' is ignored. Let's address it.
> 
> Cc: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks!

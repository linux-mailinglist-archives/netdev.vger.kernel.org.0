Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F82ABF338
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfIZMnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:43:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:56860 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfIZMnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 08:43:35 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDT7J-0002X9-00; Thu, 26 Sep 2019 14:43:29 +0200
Date:   Thu, 26 Sep 2019 14:43:28 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf] libbpf: teach btf_dumper to emit stand-alone
 anonymous enum definitions
Message-ID: <20190926124328.GA6563@pc-63.home>
References: <20190925203745.3173184-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925203745.3173184-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25584/Thu Sep 26 10:24:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 01:37:45PM -0700, Andrii Nakryiko wrote:
> BTF-to-C converter previously skipped anonymous enums in an assumption
> that those are embedded in struct's field definitions. This is not
> always the case and a lot of kernel constants are defined as part of
> anonymous enums. This change fixes the logic by eagerly marking all
> types as either referenced by any other type or not. This is enough to
> distinguish two classes of anonymous enums and emit previously omitted
> enum definitions.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!

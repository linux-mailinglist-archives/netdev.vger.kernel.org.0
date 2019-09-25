Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E85BE64F
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbfIYU1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:27:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:34036 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732671AbfIYU1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:27:50 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDDt5-0001xG-Kz; Wed, 25 Sep 2019 22:27:47 +0200
Date:   Wed, 25 Sep 2019 22:27:47 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf] libbpf: fix false uninitialized variable warning
Message-ID: <20190925202747.GC9500@pc-63.home>
References: <20190925183038.2755521-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925183038.2755521-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25583/Wed Sep 25 10:27:51 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 11:30:38AM -0700, Andrii Nakryiko wrote:
> Some compilers emit warning for potential uninitialized next_id usage.
> The code is correct, but control flow is too complicated for some
> compilers to figure this out. Re-initialize next_id to satisfy
> compiler.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!

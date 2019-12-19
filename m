Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85153126570
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLSPKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:10:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:41862 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfLSPKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:10:36 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihxRi-0005Zt-N2; Thu, 19 Dec 2019 16:10:34 +0100
Date:   Thu, 19 Dec 2019 16:10:34 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: Add missing newline in opts validation
 macro
Message-ID: <20191219151034.GA4198@linux-9.fritz.box>
References: <20191219120714.928380-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191219120714.928380-1-toke@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 01:07:14PM +0100, Toke Høiland-Jørgensen wrote:
> The error log output in the opts validation macro was missing a newline.
> 
> Fixes: 2ce8450ef5a3 ("libbpf: add bpf_object__open_{file, mem} w/ extensible opts")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!

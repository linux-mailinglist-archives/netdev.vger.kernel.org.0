Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21551B9695
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 07:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgD0Ffs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 01:35:48 -0400
Received: from verein.lst.de ([213.95.11.211]:45443 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgD0Ffs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 01:35:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 009A668CEE; Mon, 27 Apr 2020 07:35:45 +0200 (CEST)
Date:   Mon, 27 Apr 2020 07:35:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pass kernel pointers to the sysctl ->proc_handler method v3
Message-ID: <20200427053545.GB15905@lst.de>
References: <20200424064338.538313-1-hch@lst.de> <20200426155100.bcbqnrilk45ugzva@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426155100.bcbqnrilk45ugzva@ast-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 08:51:00AM -0700, Alexei Starovoitov wrote:
> The set looks good to me.
> Should I take it via bpf-next tree ?

The first patch is a little unrelated and I think taking it via the
bpf tree sounds fine.   Al volunteered the vfs tree for the actual
sysctl changes, which looks more suitable.

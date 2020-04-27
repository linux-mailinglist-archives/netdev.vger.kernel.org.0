Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948631B9698
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 07:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgD0FgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 01:36:19 -0400
Received: from verein.lst.de ([213.95.11.211]:45448 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgD0FgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 01:36:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AF26768CEE; Mon, 27 Apr 2020 07:36:16 +0200 (CEST)
Date:   Mon, 27 Apr 2020 07:36:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pass kernel pointers to the sysctl ->proc_handler method v3
Message-ID: <20200427053616.GC15905@lst.de>
References: <20200424064338.538313-1-hch@lst.de> <20200426155958.GS23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426155958.GS23230@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 04:59:58PM +0100, Al Viro wrote:
> OK, I can live with that; further work can live on top of that, anyway.
> How are we going to handle that?  I can put it into never-rebased branch
> in vfs.git (#work.sysctl), so that people could pull that.
> 
> FWIW, I'm putting together more uaccess stuff (will probably hit -next
> tonight or tomorrow); this would fit well there...

Sounds good to me.  The first patch isn't really needed for the series
and could go in through the bpf tree.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98ECE1AD7ED
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 09:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgDQHsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 03:48:13 -0400
Received: from verein.lst.de ([213.95.11.211]:56236 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbgDQHsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 03:48:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E8D2E68BEB; Fri, 17 Apr 2020 09:48:07 +0200 (CEST)
Date:   Fri, 17 Apr 2020 09:48:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/6] firmware_loader: remove unused exports
Message-ID: <20200417074807.GA19954@lst.de>
References: <20200417064146.1086644-1-hch@lst.de> <20200417064146.1086644-3-hch@lst.de> <20200417074330.GB23015@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417074330.GB23015@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 09:43:30AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Apr 17, 2020 at 08:41:42AM +0200, Christoph Hellwig wrote:
> > Neither fw_fallback_config nor firmware_config_table are used by modules.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/base/firmware_loader/fallback_table.c | 2 --
> >  1 file changed, 2 deletions(-)
> 
> I have no objection to this patch, and can take it in my tree, but I
> don't see how it fits in with your larger patch series...

firmware_config_table is a sysctl table, and I looked for users but
didn't find them.  But yes, it isn't really related and you can take
it separately.

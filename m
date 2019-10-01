Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACA8C441E
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfJAXHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:07:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:48928 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfJAXHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:07:06 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFREW-0001KP-JW; Wed, 02 Oct 2019 01:07:04 +0200
Date:   Wed, 2 Oct 2019 01:07:04 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next] libbpf: bump current version to v0.0.6
Message-ID: <20191001230704.GD10044@pc-63.home>
References: <20190930222503.519782-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930222503.519782-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25589/Tue Oct  1 10:30:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 03:25:03PM -0700, Andrii Nakryiko wrote:
> New release cycle started, let's bump to v0.0.6 proactively.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!

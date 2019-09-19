Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFEAB7980
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732121AbfISMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:33:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:60406 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbfISMdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:33:16 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iAvcY-0000NK-BU; Thu, 19 Sep 2019 14:33:14 +0200
Date:   Thu, 19 Sep 2019 14:33:14 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf] xsk: relax UMEM headroom alignment
Message-ID: <20190919123314.GB5504@pc-63.home>
References: <20190918075739.19451-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190918075739.19451-1-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25577/Thu Sep 19 10:20:13 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 09:57:39AM +0200, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> This patch removes the 64B alignment of the UMEM headroom. There is
> really no reason for it, and having a headroom less than 64B should be
> valid.
> 
> Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Applied, thanks!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30858BE669
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393145AbfIYUac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:30:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:34770 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393128AbfIYUaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:30:30 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDDvg-00025t-Km; Wed, 25 Sep 2019 22:30:28 +0200
Date:   Wed, 25 Sep 2019 22:30:28 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf] selftests/bpf: delete unused variables in test_sysctl
Message-ID: <20190925203028.GD9500@pc-63.home>
References: <20190925183614.2775293-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925183614.2775293-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25583/Wed Sep 25 10:27:51 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 11:36:14AM -0700, Andrii Nakryiko wrote:
> Remove no longer used variables and avoid compiler warnings.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!

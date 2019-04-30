Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A3DFED1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfD3R1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 13:27:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbfD3R1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 13:27:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3BA23ACC4;
        Tue, 30 Apr 2019 17:27:07 +0000 (UTC)
Date:   Tue, 30 Apr 2019 19:27:01 +0200
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     mrostecki@opensuse.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf, libbpf: Add .so files to gitignore
Message-ID: <20190430172701.jegv3tmcvo3ytdri@workstation>
References: <20190430162501.13256-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430162501.13256-1-mrostecki@opensuse.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I forgot to add "bpf-next" to the subject prefix, sorry!

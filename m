Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EDB3AD483
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 23:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhFRVoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 17:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234615AbhFRVoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 17:44:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3686121D;
        Fri, 18 Jun 2021 21:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624052510;
        bh=tRXqw30J35AbDfbBfYc98TsOMc5DEf0x24g3SIImSPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B4umn21QmkhEmVUXhRyOfZX7zAYzp6ED+kiDMywq0Tn2sQnKrERJUsahnBl4Ct/+c
         RgqCKyCUN0qot95DQga/LSbzqwJwtewHhIB5638G9yoM2tT91IFqZQsE7ngNQhz+i2
         shbi5vBnyPyOZemwUr8V25FrVIRwQtdHEgb1aNxCyiUNq3s3gvzf491b+T/j3xkw2+
         Lh7ZTOjdLXGw6z0WD7mKiuN8zdN2ASaNUOF5x/zdC9V0N9kVc/bmKnKrZSpgtlyOJ0
         96h/musBsY8sSbsd3P1EGXQqcHvd6bTeoptMSRjLUbbMrj81JX4z5w3McEirL/wQ50
         c7Vuv/Fp441Cg==
Date:   Fri, 18 Jun 2021 14:41:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/tls: don't change cipher type in
 bidirectional test
Message-ID: <20210618144149.35192fcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210618204532.257773-1-seth.forshee@canonical.com>
References: <20210618204532.257773-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 15:45:32 -0500 Seth Forshee wrote:
> The bidirectional test attempts to change the cipher to
> TLS_CIPHER_AES_GCM_128. The test fixture setup will have already set
> the cipher to be tested, and if it was different than the one set by
> the bidir test setsockopt() will fail on account of having different
> ciphers for rx and tx, causing the test to fail.

It's setting it up in the opposite direction, TLS is uni-directional.
I've posted this earlier:

https://patchwork.kernel.org/project/netdevbpf/patch/20210618202504.1435179-2-kuba@kernel.org/

Sorry for not CCing you.

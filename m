Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0EB2A3654
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgKBWNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:13:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKBWM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:12:59 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE85E22258;
        Mon,  2 Nov 2020 22:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604355179;
        bh=OjQWsjZGnoZnJAETOTGCXdF4ff8Ym0bxZMlSVc4Nveg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cl/xZsZ1DDlIK3NhlTQfRGhVprC5UUs5SD7Z6L3tPtaYleZciEx75IrXqlZ4wKFuF
         xnGVTG7+NIcfK7c3hjIiSNfqxkc2HpMqRH0guJthqqQ31bhQer5SdFP+R+eEAU1MFL
         fREiuNoa0hVRyKPWZiqtpkXsQe9WMpYfTaAzcvqA=
Date:   Mon, 2 Nov 2020 14:12:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Subject: Re: [PATCH net-next 10/15] net/smc: Introduce SMCR get link command
Message-ID: <20201102141258.68ffad28@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102193409.70901-11-kgraul@linux.ibm.com>
References: <20201102193409.70901-1-kgraul@linux.ibm.com>
        <20201102193409.70901-11-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 20:34:04 +0100 Karsten Graul wrote:
> +	__u8 netdev[IFNAMSIZ];		/* ethernet device name */

In file included from <command-line>:32:
./usr/include/linux/smc_diag.h:135:14: error: =E2=80=98IFNAMSIZ=E2=80=99 un=
declared here (not in a function)
  135 |  __u8 netdev[IFNAMSIZ];  /* ethernet device name */
      |              ^~~~~~~~
make[3]: *** [usr/include/linux/smc_diag.hdrtest] Error 1
make[2]: *** [usr/include] Error 2
make[1]: *** [usr] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: *** wait: No child processes.  Stop.
make: *** [__sub-make] Error 2
In file included from <command-line>:32:
./usr/include/linux/smc_diag.h:135:14: error: =E2=80=98IFNAMSIZ=E2=80=99 un=
declared here (not in a function)
  135 |  __u8 netdev[IFNAMSIZ];  /* ethernet device name */
      |              ^~~~~~~~

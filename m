Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08F53DC684
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhGaPGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233192AbhGaPGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 11:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AC3360F56;
        Sat, 31 Jul 2021 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627743998;
        bh=gNiUnBuL1HVpIZ4jlTDGVnQzIgG2kgIj8YDNE+2XDPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PTeRPxaPfZ5pNrWI8dcUTUYhCQOEmGlRyAjSupCD2nMeHbJehwiRWk23zZAahzLSw
         7J9vX7FhFU9yboX5YCyawKg8zyNXNjhv9DhX5dznCKtt/tKxJJIoXeVn+WrzHJzuJP
         5YSxLjQRqhyEzVgIOvbvf2h2hvAFSwjiu04nS7pUUE2fkGOYSLM/wXiroYfpFGEtOf
         PhJHK06BO13vrAObJAWOdHPik975QAMpPo1NzYSID+Wk3UbGEZmQkdZsvKaIcxes+O
         GtegquQ2VnoXytsbeKLPVIUYt6Ex54CeR2SBXz/oNC/9XQsYRcMdZzoE82s0NsxqvH
         XmtbxWOswq4AQ==
Date:   Sat, 31 Jul 2021 08:06:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <davem@davemloft.net>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH net-next] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210731080637.231d89e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210730201354.1237659-1-jonathan.lemon@gmail.com>
References: <20210730201354.1237659-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 13:13:54 -0700 Jonathan Lemon wrote:
> The OpenCompute timecard driver has additional functionality besides
> a clock.  Make the following resources available:
>=20
>  - The external timestamp channels (ts0/ts1)
>  - devlink support for flashing and health reporting
>  - GPS and MAC serial ports
>  - board serial number (obtained from i2c device)
>=20
> Also add watchdog functionality for when GNSS goes into holdover.

drivers/ptp/ptp_ocp.c: In function =E2=80=98ptp_ocp_init=E2=80=99:
drivers/ptp/ptp_ocp.c:1600:6: warning: variable =E2=80=98err=E2=80=99 set b=
ut not used [-Wunused-but-set-variable]
1600 |  int err;
     |      ^~~
drivers/ptp/ptp_ocp.c:1153:69: warning: Using plain integer as NULL pointer
drivers/ptp/ptp_ocp.c:1506:27: warning: Using plain integer as NULL pointer
drivers/ptp/ptp_ocp.c:1587:31: warning: Using plain integer as NULL pointer
drivers/ptp/ptp_ocp.c:881:29: warning: dereference of noderef expression
drivers/ptp/ptp_ocp.c:1399:29: warning: dereference of noderef expression
